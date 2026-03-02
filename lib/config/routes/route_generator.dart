import 'package:flutter/material.dart';
import 'package:shopping_cart/features/authentication/presentation/pages/home_page.dart';
import 'package:shopping_cart/features/authentication/presentation/pages/splash_page.dart';
import 'package:shopping_cart/features/cart/presentation/pages/cart_page.dart';
import 'package:shopping_cart/features/products/presentation/pages/browse_products_page.dart';
import 'package:shopping_cart/features/products/presentation/pages/create_product_page.dart';
import 'package:shopping_cart/features/products/presentation/pages/my_products_page.dart';
import 'package:shopping_cart/features/products/presentation/pages/product_detail_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/products/domain/entities/product.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case AppRoutes.browseProducts:
        return MaterialPageRoute(builder: (_) => const BrowseProductsPage());

      case AppRoutes.myProducts:
        return MaterialPageRoute(builder: (_) => const MyProductsPage());

      case AppRoutes.createProduct:
        return MaterialPageRoute(builder: (_) => const CreateProductPage());

      case AppRoutes.editProduct:
        final product = settings.arguments as Product?;
        return MaterialPageRoute(
          builder: (_) => CreateProductPage(product: product),
        );

      case AppRoutes.productDetail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        );

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());



      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
