// P3-T08: Verve Wallet (pre-funded NGN balance)
import { getRedisClient } from '../../db/redis';

export async function chargeWallet(userId: string, amount: number): Promise<{ success: boolean, transactionId?: string, error?: string }> {
    console.log(`[Verve Wallet] Checking balance for user ${userId} for ₦${amount}`);

    const redis = getRedisClient();
    if (!redis) {
        return { success: false, error: 'Ledger unavailable.' };
    }

    try {
        const balanceStr = await redis.get(`wallet:${userId}:balance`);
        const balance = balanceStr ? parseFloat(balanceStr) : 0;

        if (balance >= amount) {
            // Deduct balance
            await redis.decrByFloat(`wallet:${userId}:balance`, amount);
            console.log(`[Verve Wallet] Charged successfully. New balance: ₦${balance - amount}`);
            return { success: true, transactionId: `wal_${Date.now()}` };
        } else {
            console.warn(`[Verve Wallet] Insufficient funds`);
            return { success: false, error: 'Insufficient Wallet balance.' };
        }
    } catch (e) {
        return { success: false, error: 'Wallet transaction failed.' };
    }
}
