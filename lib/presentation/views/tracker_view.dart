import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/adherence_calculator.dart';
import '../providers/medication_provider.dart';
import '../widgets/add_medication_sheet.dart';
import '../widgets/adherence_score_card.dart';
import '../widgets/medication_card.dart';

class TrackerView extends ConsumerStatefulWidget {
  const TrackerView({super.key});

  @override
  ConsumerState<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends ConsumerState<TrackerView> {
  String _selectedFilter = 'Semua';

  void _openAddMedicationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      builder: (_) => const AddMedicationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncMedications = ref.watch(medicationNotifierProvider);
    final adherenceScore = ref.watch(adherenceScoreProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pelacak Obat',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textMain,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Catat kepatuhan minum obat harian',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),

                // + Add Prescription Button (48px Touch Target)
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _openAddMedicationSheet,
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text(
                      'Tambah',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Adherence Score Card
            AdherenceScoreCard(score: adherenceScore),

            const SizedBox(height: 20),

            // Filter Segments (Semua, Tertunda, Selesai)
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Semua', label: Text('Semua')),
                  ButtonSegment(value: 'Tertunda', label: Text('Tertunda')),
                  ButtonSegment(value: 'Selesai', label: Text('Selesai')),
                ],
                selected: {_selectedFilter},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() => _selectedFilter = newSelection.first);
                },
                showSelectedIcon: false,
              ),
            ),

            const SizedBox(height: 16),

            // Medication List
            asyncMedications.when(
              data: (medications) {
                if (medications.isEmpty) {
                  return Card.outlined(
                    margin: const EdgeInsets.only(top: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medication_outlined, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada resep obat',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mulai pantau jadwal konsumsi obat Anda dengan menambahkan resep pertama.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: _openAddMedicationSheet,
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: const Text('Tambah Obat', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredList = medications.where((med) {
                  if (_selectedFilter == 'Tertunda') return med.status == IntakeStatus.pending;
                  if (_selectedFilter == 'Selesai') return med.status == IntakeStatus.taken;
                  return true;
                }).toList();

                if (filteredList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'Tidak ada obat $_selectedFilter untuk hari ini.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return Dismissible(
                      key: Key('${item.medication.id}_${item.scheduledTime}'),
                      direction: DismissDirection.horizontal,
                      background: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Obat?'),
                            content: Text('Apakah Anda yakin ingin menghapus ${item.medication.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        ) ?? false;
                      },
                      onDismissed: (_) {
                        ref.read(medicationNotifierProvider.notifier).deleteMedication(item.medication.id);
                      },
                      child: MedicationCard(
                        item: item,
                        onToggleStatus: () {
                          ref.read(medicationNotifierProvider.notifier).toggleStatus(
                                item.medication.id,
                                item.scheduledTime,
                              );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Card.outlined(
                color: Theme.of(context).colorScheme.errorContainer,
                margin: const EdgeInsets.only(top: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat data obat',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        err.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => ref.refresh(medicationNotifierProvider),
                          child: const Text('Coba Lagi'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

}
