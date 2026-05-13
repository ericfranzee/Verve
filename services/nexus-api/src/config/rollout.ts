/**
 * P5-T18: National Rollout Configuration
 *
 * Removes the Phase 3/4 Wuse II geofencing locks and transitions
 * the platform state to scale across Lagos and Abuja.
 */

export const RolloutConfig = {
    // Phased rollout state
    currentPhase: 5,

    // Previously true in Phase 3/4. Disabling to expand mesh network globally.
    isWuseIIGeofenceStrictlyEnforced: false,

    // Active operational cities globally authorized for dispatch and multi-node routing
    activeRegions: [
        {
            city: 'Abuja',
            state: 'FCT',
            activeHubs: ['hub-wuse2', 'hub-maitama', 'hub-garki', 'hub-asokoro']
        },
        {
            city: 'Lagos',
            state: 'Lagos',
            activeHubs: ['hub-lekki', 'hub-ikeja', 'hub-vi', 'hub-yaba']
        }
    ],

    // Mesh threshold: Maximum distance between hubs to allow split routing
    meshSplitThresholdKm: 15.0,

    // Trust level demotion toggle (always true in Phase 5)
    autoDemotionEnabled: true
};
