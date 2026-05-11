import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/memory/memory_manager.dart';
import 'core/edge_db/db_service.dart';
import 'core/encryption/encryption_service.dart';
import 'core/theme/verve_theme.dart';
import 'features/viewport/morphing_viewport.dart';

// Provide global services through Riverpod
final dbServiceProvider = Provider<EdgeDbService>((ref) => EdgeDbService());
final encryptionServiceProvider = Provider<EncryptionService>((ref) => EncryptionService());

final memoryManagerProvider = Provider<MemoryManager>((ref) {
  return MemoryManager(ref.read(dbServiceProvider), ref.read(encryptionServiceProvider));
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create a container so we can initialize services before runApp
  final container = ProviderContainer();

  final memoryManager = container.read(memoryManagerProvider);
  await memoryManager.initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const VerveApp(),
    ),
  );
}

class VerveApp extends StatelessWidget {
  const VerveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verve',
      theme: VerveTheme.darkTheme,
      home: const Scaffold(
        body: MorphingViewport(),
      ),
    );
  }
}
