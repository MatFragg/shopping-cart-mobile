import 'package:equatable/equatable.dart';
import '../../domain/entities/cart.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;
  final bool isUpdating;

  const CartLoaded(this.cart, {this.isUpdating = false});

  @override
  List<Object?> get props => [cart, isUpdating];

  CartLoaded copyWith({Cart? cart, bool? isUpdating}) {
    return CartLoaded(
      cart ?? this.cart,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class CartEmpty extends CartState {
  final String? message;

  const CartEmpty({this.message});

  @override
  List<Object?> get props => [message];
}

class CartOperationSuccess extends CartState {
  final String message;
  final Cart? cart;

  const CartOperationSuccess({
    required this.message,
    this.cart,
  });

  @override
  List<Object?> get props => [message, cart];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartItemRemoved extends CartState {
  final String message;
  final Cart? cart;

  const CartItemRemoved({
    required this.message,
    this.cart,
  });

  @override
  List<Object?> get props => [message, cart];
}

class CartCleared extends CartState {
  final String message;

  const CartCleared({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartStockError extends CartState {
  final String message;
  final int availableStock;
  final Cart currentCart;

  const CartStockError({
    required this.message,
    required this.availableStock,
    required this.currentCart,
  });

  @override
  List<Object?> get props => [message, availableStock, currentCart];
}
