import 'package:flutter_test/flutter_test.dart';
import 'package:curacard/core/utils/adherence_calculator.dart';

void main() {
  group('AdherenceCalculator Unit Tests', () {
    test('calculateScore should return 100.0 when intake list is empty', () {
      final score = AdherenceCalculator.calculateScore([]);
      expect(score, equals(100.0));
    });

    test('calculateScore should return 50.0 when 2 of 4 medications are taken', () {
      final statuses = [
        IntakeStatus.taken,
        IntakeStatus.taken,
        IntakeStatus.pending,
        IntakeStatus.pending,
      ];
      final score = AdherenceCalculator.calculateScore(statuses);
      expect(score, equals(50.0));
    });

    test('calculateScore should return 100.0 when all medications are taken', () {
      final statuses = [
        IntakeStatus.taken,
        IntakeStatus.taken,
        IntakeStatus.taken,
      ];
      final score = AdherenceCalculator.calculateScore(statuses);
      expect(score, equals(100.0));
    });

    test('calculateScore should return 0.0 when no medications are taken', () {
      final statuses = [
        IntakeStatus.pending,
        IntakeStatus.skipped,
      ];
      final score = AdherenceCalculator.calculateScore(statuses);
      expect(score, equals(0.0));
    });

    test('formatPercentage should format double to rounded string', () {
      expect(AdherenceCalculator.formatPercentage(66.666), equals('67%'));
      expect(AdherenceCalculator.formatPercentage(100.0), equals('100%'));
      expect(AdherenceCalculator.formatPercentage(0.0), equals('0%'));
    });

    test('getFeedbackLabel should return appropriate feedback string', () {
      expect(AdherenceCalculator.getFeedbackLabel(95.0), equals('Excellent Adherence'));
      expect(AdherenceCalculator.getFeedbackLabel(75.0), equals('Good Adherence'));
      expect(AdherenceCalculator.getFeedbackLabel(55.0), equals('Needs Attention'));
      expect(AdherenceCalculator.getFeedbackLabel(30.0), equals('Critical: Missed Doses'));
    });
  });
}
