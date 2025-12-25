import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/features/authentication/presentation/pages/login_page.dart';
import 'package:shopping_cart/features/authentication/presentation/widgets/activity_item.dart';
import 'package:shopping_cart/features/authentication/presentation/widgets/app_drawer.dart';
import 'package:shopping_cart/features/authentication/presentation/widgets/quick_action_card.dart';
import 'package:shopping_cart/features/authentication/presentation/widgets/section_header.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = (state is AuthAuthenticated) ? state.user : null;

          return Scaffold(
            appBar: AppBar(
              title: const Text("Shopping Cart"),
              actions: [
                _buildBadgeIcon(Icons.notifications_none, "5"),
                _buildBadgeIcon(Icons.shopping_cart_outlined, "3"),
                const SizedBox(width: 8),
              ],
            ),
            drawer: const AppDrawer(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "👋 Welcome back, ${user?.firstName ?? 'User'}!",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SectionHeader(title: "Quick Actions"),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      QuickActionCard(
                        icon: Icons.inventory_2,
                        title: "My Products",
                        backgroundColor: Colors.blue,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        icon: Icons.search,
                        title: "Browse",
                        backgroundColor: Colors.green,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        icon: Icons.receipt_long,
                        title: "My Orders",
                        backgroundColor: Colors.orange,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        icon: Icons.monetization_on,
                        title: "My Sales",
                        backgroundColor: Colors.purple,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SectionHeader(title: "Recent Activity"),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ActivityItem(
                        icon: Icons.shopping_bag,
                        title: "Product X sold",
                        subtitle: "Sold to Carlos M.",
                        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
                      ),
                      ActivityItem(
                        icon: Icons.local_shipping,
                        title: "New order received",
                        subtitle: "Order #12345",
                        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: (user != null)
                ? FloatingActionButton.extended(
              onPressed: () {},
              label: const Text("Add Product"),
              icon: const Icon(Icons.add),
            )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBadgeIcon(IconData icon, String count) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(icon: Icon(icon), onPressed: () {}),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              count,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}