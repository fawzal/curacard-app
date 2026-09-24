import 'package:flutter/material.dart';
import '../../core/utils/adherence_calculator.dart';

class AdherenceScoreCard extends StatelessWidget {
  final double score;

  const AdherenceScoreCard({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final percentageText = AdherenceCalculator.formatPercentage(score);
    final feedbackLabel = AdherenceCalculator.getFeedbackLabel(score);
    final isHigh = score >= 80.0;
    
    final colorScheme = Theme.of(context).colorScheme;
    final highlightColor = isHigh ? colorScheme.secondary : colorScheme.primary;

    return Card.outlined(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circular Progress Indicator
            SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: score / 100.0,
                    strokeWidth: 5,
                    backgroundColor: colorScheme.surfaceContainerLowest,
                    valueColor: AlwaysStoppedAnimation<Color>(highlightColor),
                  ),
                  Center(
                    child: Text(
                      percentageText,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: highlightColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Label & Score Summary
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Kepatuhan Harian',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: highlightColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          isHigh ? 'TERJAGA' : 'TERTUNDA',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            color: highlightColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    feedbackLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
