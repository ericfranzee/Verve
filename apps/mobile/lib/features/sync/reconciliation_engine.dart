import 'offline_queue.dart';

/// P5-T03: Hybrid State Sync Engine (Flutter side)
///
/// Builds the reconciliation engine that merges local Edge state with Cloud state
/// the moment the WebSocket connection is re-established.
class SyncEngine {
  final OfflineQueue _queue;

  SyncEngine(this._queue);

  /// Synchronizes pending local intents with the cloud backend.
  Future<void> syncWithCloud() async {
    try {
      final pendingIntents = await _queue.getPendingIntents();

      if (pendingIntents.isEmpty) {
        print("SyncEngine: No pending intents to sync.");
        return;
      }

      print("SyncEngine: Syncing ${pendingIntents.length} intents with Cloud...");

      for (var intent in pendingIntents) {
        final id = intent['id'] as String;
        final text = intent['text'] as String;

        // Simulate sending intent to Cloud/WebSocket Orchestrator
        final success = await _simulateCloudSync(id, text);

        if (success) {
          await _queue.markIntentSynced(id);
        } else {
          print("SyncEngine: Failed to sync intent $id. Will retry later.");
          // In a real scenario, we might break or continue based on error type
        }
      }

      // Prune after a sync pass to keep DB clean
      await _queue.pruneSyncedIntents();

    } catch (e) {
      print("SyncEngine: Error during sync process: $e");
    }
  }

  /// Simulates a cloud push over WebSocket or REST.
  Future<bool> _simulateCloudSync(String id, String text) async {
    // Artificial delay to simulate network latency
    await Future.delayed(const Duration(milliseconds: 100));

    // Simulate successful sync
    return true;
  }
}
