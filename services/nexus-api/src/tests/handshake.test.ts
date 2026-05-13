import { detect, resolve, RiderStatus } from '../services/chaos/rider_device';

describe('Degraded Bio-Handshake Verification (P4-T14)', () => {
    it('Level 0: Should not trigger chaos if rider is active and pinging recently', () => {
        const status: RiderStatus = {
            riderId: 'rider-123',
            orderId: 'order-999',
            lastPingMinutesAgo: 1,
            isInActiveDelivery: true
        };
        expect(detect(status)).toBe(false);
    });

    it('Level 1-3: Should trigger degraded cascade if rider offline for > 3 mins', () => {
        const status: RiderStatus = {
            riderId: 'rider-123',
            orderId: 'order-999',
            lastPingMinutesAgo: 4,
            isInActiveDelivery: true
        };
        expect(detect(status)).toBe(true);

        const resolution = resolve(status.orderId, status.riderId, status.lastPingMinutesAgo);
        expect(resolution).toContain('Degraded Handshake Initiated');
    });

    it('Level 4: Should dispatch backup rider if offline > 10 mins', () => {
        const status: RiderStatus = {
            riderId: 'rider-123',
            orderId: 'order-999',
            lastPingMinutesAgo: 11,
            isInActiveDelivery: true
        };
        expect(detect(status)).toBe(true);

        const resolution = resolve(status.orderId, status.riderId, status.lastPingMinutesAgo);
        expect(resolution).toContain('Backup Rider Dispatched');
    });
});
