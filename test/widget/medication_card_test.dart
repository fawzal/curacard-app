import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curacard/core/theme/app_theme.dart';
import 'package:curacard/core/utils/adherence_calculator.dart';
import 'package:curacard/data/models/medication_model.dart';
import 'package:curacard/presentation/widgets/medication_card.dart';

void main() {
  final pendingMedication = MedicationModel(
    id: 'med-1',
    name: 'Amlodipine Besylate',
    dosage: '5 mg - 1 Pill',
    scheduledTime: '08:00 AM',
    status: IntakeStatus.pending,
  );

  final takenMedication = MedicationModel(
    id: 'med-2',
    name: 'Salbutamol Inhaler',
    dosage: '2 Puffs',
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
    testWidgets('renders pending medication with Log Intake pill button', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        MedicationCard(
          medication: pendingMedication,
          onToggleStatus: () {},
        ),
      ));

      expect(find.text('Amlodipine Besylate'), findsOneWidget);
      expect(find.textContaining('08:00 AM'), findsOneWidget);
      expect(find.text('Log Intake'), findsOneWidget);
    });

    testWidgets('renders taken medication with Taken pill badge', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        MedicationCard(
          medication: takenMedication,
          onToggleStatus: () {},
        ),
      ));

      expect(find.text('Salbutamol Inhaler'), findsOneWidget);
      expect(find.text('Taken'), findsOneWidget);
    });

    testWidgets('triggers onToggleStatus when status pill button is tapped', (tester) async {
      bool toggleTriggered = false;

      await tester.pumpWidget(buildTestableWidget(
        MedicationCard(
          medication: pendingMedication,
          onToggleStatus: () => toggleTriggered = true,
        ),
      ));

      await tester.tap(find.text('Log Intake'));
      await tester.pumpAndSettle();

      expect(toggleTriggered, isTrue);
    });
  });
}
