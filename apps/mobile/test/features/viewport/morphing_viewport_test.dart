import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/viewport/morphing_viewport.dart';
import 'package:mobile/core/theme/verve_theme.dart';
import 'package:mobile/features/viewport/widgets/hero_card.dart';
import 'package:mobile/features/viewport/widgets/proposal_card.dart';

void main() {
  testWidgets('MorphingViewport initially displays Void State', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: VerveTheme.darkTheme,
          home: const Scaffold(body: MorphingViewport()),
        ),
      ),
    );

    // Initial state is Void State
    expect(find.text('Verve — The Void'), findsOneWidget);
    expect(find.byKey(const ValueKey('void')), findsOneWidget);
  });

  testWidgets('MorphingViewport transitions to Hero Card state', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: VerveTheme.darkTheme,
          home: const Scaffold(body: MorphingViewport()),
        ),
      ),
    );

    final container = ProviderScope.containerOf(tester.element(find.byType(MorphingViewport)));
    container.read(viewportStateProvider.notifier).setViewportState(ViewportState.heroCard);

    await tester.pumpAndSettle();

    expect(find.byType(HeroCard), findsOneWidget);
    expect(find.byKey(const ValueKey('hero')), findsOneWidget);
  });

  testWidgets('MorphingViewport transitions to Proposal state', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: VerveTheme.darkTheme,
          home: const Scaffold(body: MorphingViewport()),
        ),
      ),
    );

    final container = ProviderScope.containerOf(tester.element(find.byType(MorphingViewport)));
    container.read(viewportStateProvider.notifier).setViewportState(ViewportState.proposal);

    await tester.pumpAndSettle();

    expect(find.byType(ProposalCard), findsOneWidget);
    expect(find.byKey(const ValueKey('proposal')), findsOneWidget);
  });
}
