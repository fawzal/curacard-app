import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curacard/core/theme/app_theme.dart';
import 'package:curacard/core/utils/adherence_calculator.dart';
import 'package:curacard/data/models/medication_model.dart';
import 'package:curacard/data/models/intake_item_model.dart';
import 'package:curacard/presentation/widgets/medication_card.dart';

void main() {
  final baseMed1 = MedicationModel(
    id: 'med-1',
    name: 'Amlodipine Besylate',
    dosage: '5 mg - 1 Pill',
    scheduledTimes: ['08:00 AM'],
  );

  final baseMed2 = MedicationModel(
    id: 'med-2',
    name: 'Salbutamol Inhaler',
    dosage: '2 Puffs',
    scheduledTimes: ['12:00 PM'],
  );

  final pendingItem = IntakeItemModel(
    medication: baseMed1,
    scheduledTime: '08:00 AM',
    status: IntakeStatus.pending,
  );

  final takenItem = IntakeItemModel(
    medication: baseMed2,
    scheduledTime: '12:00 PM',
    status: IntakeStatus.taken,
  );

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: child),
    );
  }

  group('MedicationCard Widget Tests', () {
    testWidgets('renders pending medication with Minum pill button', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        MedicationCard(
          item: pendingItem,
          onToggleStatus: () {},
        ),
      ));

      expect(find.text('Amlodipine Besylate'), findsOneWidget);
      expect(find.textContaining('08:00 AM'), findsOneWidget);
      expect(find.text('Minum'), findsOneWidget);
    });

    testWidgets('renders taken medication with Diminum pill badge', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        MedicationCard(
          item: takenItem,
          onToggleStatus: () {},
        ),
      ));

      expect(find.text('Salbutamol Inhaler'), findsOneWidget);
      expect(find.text('Diminum'), findsOneWidget);
    });

    testWidgets('triggers onToggleStatus when status pill button is tapped', (tester) async {
      bool toggleTriggered = false;

      await tester.pumpWidget(buildTestableWidget(
        MedicationCard(
          item: pendingItem,
          onToggleStatus: () => toggleTriggered = true,
        ),
      ));

      await tester.tap(find.text('Minum'));
      await tester.pumpAndSettle();

      expect(toggleTriggered, isTrue);
    });
  });
}
