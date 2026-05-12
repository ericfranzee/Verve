// P3-T07: Payment Cascade Router

import { chargePaystack } from './paystack';
import { chargeFlutterwave } from './flutterwave';
import { chargeWallet } from './wallet';
import { flagPayOnDelivery } from './pod';

export async function executePaymentCascade(userId: string, amount: number): Promise<{ success: boolean, transactionId?: string, method: string }> {
    console.log(`[Cascade Router] Starting payment cascade for user ${userId}, amount ₦${amount}. Total timeout limit: 16s`);

    // Level 1: Paystack (Primary)
    const pstk = await chargePaystack(userId, amount);
    if (pstk.success) {
        return { success: true, transactionId: pstk.transactionId, method: 'Paystack' };
    }

    // Level 2: Flutterwave (Secondary)
    console.log(`[Cascade Router] Escalating to Level 2: Flutterwave`);
    const flw = await chargeFlutterwave(userId, amount);
    if (flw.success) {
        return { success: true, transactionId: flw.transactionId, method: 'Flutterwave' };
    }

    // Level 3: Verve Wallet
    console.log(`[Cascade Router] Escalating to Level 3: Verve Wallet`);
    const wal = await chargeWallet(userId, amount);
    if (wal.success) {
        return { success: true, transactionId: wal.transactionId, method: 'Verve Wallet' };
    }

    // Level 4: Pay-on-Delivery
    console.log(`[Cascade Router] Escalating to Level 4: Pay-on-Delivery`);
    const pod = await flagPayOnDelivery(userId, amount);
    return { success: pod.success, transactionId: pod.transactionId, method: 'Pay-on-Delivery' };
}
