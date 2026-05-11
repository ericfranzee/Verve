// P3-T05: Paystack integration (primary gateway)

export async function chargePaystack(userId: string, amount: number): Promise<{ success: boolean, transactionId?: string, error?: string }> {
    console.log(`[Paystack] Attempting to charge user ${userId} for ₦${amount}`);

    // Simulating external API call with potential latency
    return new Promise((resolve) => {
        setTimeout(() => {
            // Simulate a failure rate to trigger fallback
            const isSuccess = Math.random() > 0.3;

            if (isSuccess) {
                console.log(`[Paystack] Charge successful`);
                resolve({ success: true, transactionId: `pstk_${Date.now()}` });
            } else {
                console.warn(`[Paystack] Charge failed (timeout or error)`);
                resolve({ success: false, error: 'Payment gateway timeout or decline.' });
            }
        }, 3000); // 3-second simulated latency
    });
}
