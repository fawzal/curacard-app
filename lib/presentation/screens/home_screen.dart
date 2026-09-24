import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../views/contacts_view.dart';
import '../views/pass_id_view.dart';
import '../views/tracker_view.dart';
import '../widgets/ambient_header.dart';
import '../widgets/sos_fab_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTab = 0;

  final List<Widget> _views = const [
    PassIdView(),
    TrackerView(),
    ContactsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AmbientHeader(userInitials: 'AR'),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: _views,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const SosFabButton(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (index) {
          setState(() => _currentTab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.card_membership_rounded),
            label: 'ID Medis',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_liquid_rounded),
            label: 'Pelacak',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts_rounded),
            label: 'Kontak',
          ),
        ],
      ),
    );
  }
}
