// dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/features/authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import 'package:shopping_cart/features/authentication/presentation/bloc/auth_state.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: Text('Not authenticated'));
          }

          final user = state.user;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDrawerHeader(context, user),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const Divider(),
                    _buildSectionHeader('MARKETPLACE'),
                    ListTile(
                      leading: const Icon(Icons.inventory),
                      title: const Text('My Products'),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: const Text('Browse Products'),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Divider(),
                    _buildSectionHeader('ORDERS'),
                    ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('My Purchases'),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: const Text('My Sales'),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, dynamic user) {
    final initials = "${user.firstName[0]}${user.lastName[0]}".toUpperCase();

    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withAlpha(180),
          ],
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      accountName: Text(
        "${user.firstName} ${user.lastName}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      accountEmail: Text(user.email),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final originalContext = context;

    final dialogHostContext = Navigator.of(context).context;

    showDialog(
      context: dialogHostContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(originalContext).pop();
              dialogContext.read<AuthBloc>().add(LogoutRequested());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
