import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/config/routes/app_routes.dart';
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
                        icon: Icons.inventory,
                        title: "My Products",
                        subtitle: "Manage inventory",
                        color: Colors.blue,
                        route: AppRoutes.myProducts,
                      ),
                      QuickActionCard(
                        icon: Icons.shopping_bag,
                        title: "Browse",
                        subtitle: "Explore products",
                        color: Colors.green,
                        route: AppRoutes.browseProducts,
                      ),
                      QuickActionCard(
                        icon: Icons.shopping_cart,
                        title: "Orders",
                        subtitle: "Track purchases",
                        color: Colors.orange,
                        route: AppRoutes.cart,
                      ),
                      QuickActionCard(
                        icon: Icons.attach_money,
                        title: "Sales",
                        subtitle: "View earnings",
                        color: Colors.purple,
                        route: '/sales', // TODO: Implementar
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
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.createProduct),
              icon: const Icon(Icons.add),
              label: const Text("Sell Product"),
            ) : null,
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