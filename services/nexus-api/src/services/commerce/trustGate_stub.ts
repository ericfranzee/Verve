/**
 * P5-T15: Trust Level 4 Gate
 *
 * Strict validation enforcing that autonomous (zero-touch) operations
 * require Partner status (Trust Level 4). Demotion from this level is instant.
 */

export enum TrustLevel {
    Stranger = 1,
    Acquaintance = 2,
    Confidant = 3,
    Partner = 4
}

export interface UserContext {
    userId: string;
    trustLevel: TrustLevel;
}

export class TrustGate {
    /**
     * Enforces that the user has attained Partner status.
     * Throws an error if the user is not at Trust Level 4.
     */
    public enforcePartnerStatus(user: UserContext): void {
        if (user.trustLevel !== TrustLevel.Partner) {
            console.warn(`[TrustGate] Blocked zero-touch operation for ${user.userId}. Trust Level is ${user.trustLevel}, requires 4.`);
            throw new Error(`Trust Level 4 (Partner) required for autonomous operations.`);
        }
    }

    /**
     * Checks if a user is eligible for autonomous operations.
     */
    public isEligible(user: UserContext): boolean {
        return user.trustLevel === TrustLevel.Partner;
    }
}
