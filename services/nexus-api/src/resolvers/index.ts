import { calculatePoF } from '../services/pofEngine';
import { resolveHub } from '../services/router';

export const resolvers = {
  Query: {
    health: () => 'OK',
    verifyInventory: async (_: any, args: { hubId: string, skus: string[] }) => {

      let targetHub = args.hubId;

      try {
         // P3-T14: Enforce single-hub
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

      const lowestPoF = Math.min(...items.map(item => item.probabilityOfFulfillment));

      return {
        isFulfillable: lowestPoF > 0.0,
        hubId: targetHub,
        overallPoF: lowestPoF,
        items,
        errors: []
      };
    }
  }
};
