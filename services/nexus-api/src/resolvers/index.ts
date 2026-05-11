import { calculatePoF } from '../services/pofEngine';
import { resolveHub } from '../services/router';
import { executePaymentCascade } from '../services/payments/cascadeRouter';

export const resolvers = {
  Query: {
    health: () => 'OK',
    verifyInventory: async (_: any, args: { hubId: string, skus: string[] }) => {
      let targetHub = args.hubId;

      try {
         targetHub = resolveHub({}, args.skus);
      } catch (err: any) {
         return {
           isFulfillable: false,
           hubId: args.hubId,
           overallPoF: 0.0,
           items: [],
           errors: [err.message]
         };
      }

      const itemPromises = args.skus.map(sku => calculatePoF(targetHub, sku));
      const items = await Promise.all(itemPromises);

      const lowestPoF = items.length > 0
        ? Math.min(...items.map(item => item.probabilityOfFulfillment))
        : 0.0;

      return {
        isFulfillable: lowestPoF > 0.0,
        hubId: targetHub,
        overallPoF: lowestPoF,
        items,
        errors: []
      };
    }
  },
  Mutation: {
    processPayment: async (_: any, args: { userId: string, amount: number }) => {
      // P3-T07: Trigger cascade router for mutations explicitly
      return await executePaymentCascade(args.userId, args.amount);
    }
  }
};
