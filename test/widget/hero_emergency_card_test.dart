import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:curacard/core/theme/app_theme.dart';
import 'package:curacard/data/models/emergency_contact_model.dart';
import 'package:curacard/data/models/profile_model.dart';
import 'package:curacard/presentation/widgets/hero_emergency_card.dart';

void main() {
  final testProfile = ProfileModel(
    id: 'test-1',
    fullName: 'Alex Rivera',
    bloodType: 'O+',
    allergies: const ['Penicillin', 'Sulfa'],
    chronicConditions: const ['Asthma'],
    contacts: const [
      EmergencyContactModel(
        id: 'c1',
        name: 'Dr. Sarah Jenkins',
        relation: 'Primary Physician',
        phone: '+1-555-0199',
        isPrimary: true,
      ),
    ],
    isCompleted: true,
    updatedAt: DateTime.now(),
  );

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  group('HeroEmergencyCard Widget Tests', () {
    testWidgets('renders patient details, blood type, and emergency contact', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        HeroEmergencyCard(profile: testProfile),
      ));

      expect(find.text('ID MEDIS DARURAT'), findsOneWidget);
      expect(find.text('Alex Rivera'), findsOneWidget);
      expect(find.text('O+'), findsOneWidget);
      expect(find.textContaining('Penicillin, Sulfa'), findsOneWidget);
      expect(find.text('Hubungi'), findsOneWidget);
      expect(find.text('Edit ID'), findsOneWidget);
    });

    testWidgets('triggers onEditPressed callback when Edit ID is tapped', (tester) async {
      bool editTapped = false;

      await tester.pumpWidget(buildTestableWidget(
        HeroEmergencyCard(
          profile: testProfile,
          onEditPressed: () => editTapped = true,
        ),
      ));

      await tester.tap(find.text('Edit ID'));
      await tester.pumpAndSettle();

      expect(editTapped, isTrue);
    });
  });
}
