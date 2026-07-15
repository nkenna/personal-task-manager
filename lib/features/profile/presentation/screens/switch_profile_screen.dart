import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ptm/core/navigation/app_router.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/profile/domain/usecases/set_active_profile.dart';
import 'package:ptm/features/profile/presentation/providers/profile_providers.dart';

class SwitchProfileScreen extends ConsumerWidget {
  const SwitchProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeProfileProvider).value;
    final profiles = ref.watch(profilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Switch Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: profiles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (list) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...list.map(
              (profile) => _ProfileTile(
                profile: profile,
                isActive: active?.id == profile.id,
                onTap: () async {
                  if (active?.id == profile.id) return;
                  await ref
                      .read(setActiveProfileProvider)
                      .call(SetActiveProfileParams(profile.id));
                  ref.invalidate(activeProfileProvider);
                  ref.invalidate(profilesProvider);
                  if (context.mounted) {
                    ref.read(appRouterDelegateProvider).back();
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: Text(
                'Add new profile',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  
                ),
              ),
              onTap: () =>
                  ref.read(appRouterDelegateProvider).showCreateProfile(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.profile,
    required this.isActive,
    required this.onTap,
  });

  final Profile profile;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(profile.name),
      subtitle: Text(profile.email),
      trailing: isActive
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined),
      onTap: onTap,
    );
  }
}
