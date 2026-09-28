import 'package:flutter/material.dart';
import '../../core/utils/adherence_calculator.dart';
import '../../data/models/intake_item_model.dart';

class MedicationCard extends StatelessWidget {
  final IntakeItemModel item;
  final VoidCallback onToggleStatus;

  const MedicationCard({
    super.key,
    required this.item,
    required this.onToggleStatus,
  });

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'inhaler':
        return Icons.air_rounded;
      case 'tablet':
        return Icons.medication_rounded;
      case 'pill':
      default:
        return Icons.medication_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final medication = item.medication;
    final isTaken = item.status == IntakeStatus.taken;

    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isTaken ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3) : Theme.of(context).colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isTaken
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                    : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                _getIconData(medication.iconName),
                color: isTaken ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // Details Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: isTaken ? TextDecoration.lineThrough : null,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.scheduledTime}  •  ${medication.dosage}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // One-tap Action Pill Button
            FilledButton.tonalIcon(
              onPressed: onToggleStatus,
              icon: Icon(
                isTaken ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 18,
              ),
              label: Text(isTaken ? 'Selesai' : 'Minum'),
              style: FilledButton.styleFrom(
                backgroundColor: isTaken 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                foregroundColor: isTaken 
                    ? Theme.of(context).colorScheme.onPrimary 
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
