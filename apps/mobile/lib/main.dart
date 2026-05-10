import 'package:flutter/material.dart';
import 'features/memory/memory_manager.dart';
import 'core/edge_db/db_service.dart';
import 'core/encryption/encryption_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbService = EdgeDbService();
  final encryptionService = EncryptionService();
  final memoryManager = MemoryManager(dbService, encryptionService);

  await memoryManager.initialize();

  runApp(const VerveApp());
}

class VerveApp extends StatelessWidget {
  const VerveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verve',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF008080), // Aura Teal
          brightness: Brightness.dark,
        ),
      ),
      home: const VoidScreen(),
    );
  }
}

class VoidScreen extends StatelessWidget {
  const VoidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Verve - The Void",
          style: TextStyle(color: Color(0xFF008080), fontSize: 24),
        ),
      ),
    );
  }
}
