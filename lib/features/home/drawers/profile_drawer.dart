import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
              radius: 70,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "u/${user.name}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            ListTile(
              title: const Text("My Profile"),
              leading: const Icon(Icons.person),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Icon(
                    MdiIcons.themeLightDark,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(left: 15.4),
                      child: Text("Theme"),
                    ),
                    onTap: () {},
                  ),
                ),
                Switch.adaptive(
                  value: ref.watch(themeNotifierProvider.notifier).mode ==
                      ThemeMode.dark,
                  onChanged: (val) => toggleTheme(ref),
                ),
              ],
            ),
            ListTile(
              title: const Text("Log Out"),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logOut(ref),
            ),
          ],
        ),
      ),
    );
  }
}
