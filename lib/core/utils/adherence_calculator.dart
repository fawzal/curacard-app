enum IntakeStatus { taken, pending, skipped }

class AdherenceCalculator {
  /// Calculates the adherence score percentage (0.0 to 100.0) from a list of intake statuses.
  /// If total items is 0, defaults to 100.0% adherence.
  static double calculateScore(List<IntakeStatus> statuses) {
    if (statuses.isEmpty) return 100.0;
    
    final takenCount = statuses.where((status) => status == IntakeStatus.taken).length;
    final score = (takenCount / statuses.length) * 100.0;
    return score;
  }

  /// Formats the score to a clean integer percentage string e.g. "85%"
  static String formatPercentage(double score) {
    return '${score.round()}%';
  }

  /// Returns a descriptive feedback string based on the score percentage
  static String getFeedbackLabel(double score) {
    if (score >= 90.0) {
      return 'Kepatuhan Sangat Baik';
    } else if (score >= 70.0) {
      return 'Kepatuhan Baik';
    } else if (score >= 50.0) {
      return 'Perlu Perhatian';
    } else {
      return 'Kritis: Ada Obat Terlewat';
    }
  }
}
