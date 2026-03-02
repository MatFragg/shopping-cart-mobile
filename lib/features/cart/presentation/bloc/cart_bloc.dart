import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/features/cart/domain/entities/cart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_item_to_cart.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/get_active_cart.dart';
import '../../domain/usecases/remove_cart_item.dart';
import '../../domain/usecases/update_cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetActiveCart getActiveCart;
  final AddItemToCart addItemToCart;
  final UpdateCartItem updateCartItem;
  final RemoveCartItem removeCartItem;
  final ClearCart clearCart;

  CartBloc({
    required this.getActiveCart,
    required this.addItemToCart,
    required this.updateCartItem,
    required this.removeCartItem,
    required this.clearCart,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemQuantity>(_onUpdateQuantity);
    on<RemoveFromCart>(_onRemoveItem);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onLoadCart(
      LoadCart event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoading());

    final result = await getActiveCart(NoParams());

    result.fold(
          (failure) => emit(CartError(_mapFailureToMessage(failure))),
          (cart) {
        if (cart.isEmpty) {
          emit(CartEmpty());
        } else {
          emit(CartLoaded(cart));
        }
      },
    );
  }

  Future<void> _onAddToCart(
      AddToCartEvent event,
      Emitter<CartState> emit,
      ) async {
    emit(CartLoading());

    final result = await addItemToCart(
      AddItemParams(
        productId: event.productId,
        quantity: event.quantity,
      ),
    );

    result.fold(
          (failure) => emit(CartError(_mapFailureToMessage(failure))),
          (cart) => emit(CartOperationSuccess(
        message: 'Item added to cart',
        cart: cart,
      )),
    );
  }

  Future<void> _onUpdateQuantity(
      UpdateCartItemQuantity event,
      Emitter<CartState> emit,
      ) async {
    final currentState = state;

    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      final result = await updateCartItem(
        UpdateCartItemParams(
          productId: event.productId,
          quantity: event.quantity,
        ),
      );

      result.fold(
            (failure) {
          emit(currentState.copyWith(isUpdating: false));

          if (failure is InsufficientStockFailure) {
            emit(CartStockError(
              message: failure.message,
              availableStock: failure.availableStock,
              currentCart: currentState.cart,
            ));
            emit(currentState);
          } else {
            emit(CartError(_mapFailureToMessage(failure)));
          }
        },
            (cart) {
          if (cart.isEmpty) {
            emit(CartEmpty());
          } else {
            emit(CartLoaded(cart, isUpdating: false));
          }
        },
      );
    }
  }

  Future<void> _onRemoveItem(
      RemoveFromCart event,
      Emitter<CartState> emit,
      ) async {
    final currentState = state;
    emit(CartLoading());

    final result = await removeCartItem(
      RemoveCartItemParams(productId: event.productId),
    );

    result.fold(
          (failure) {
        if (currentState is CartLoaded) {
          emit(currentState);
        }
        emit(CartError(_mapFailureToMessage(failure)));
      },
          (_) async {
        final cartResult = await getActiveCart(NoParams());
        cartResult.fold(
              (failure) => emit(CartError(_mapFailureToMessage(failure))),
              (cart) {
            if (cart.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(CartOperationSuccess(
                message: 'Item removed from cart',
                cart: cart,
              ));
            }
          },
        );
      },
    );
  }

  Future<void> _onClearCart(
      ClearCartEvent event,
      Emitter<CartState> emit,
      ) async {
    final currentState = state;
    emit(CartLoading());

    final result = await clearCart(NoParams());

    result.fold(
          (failure) {
        if (currentState is CartLoaded) {
          emit(currentState);
        }
        emit(CartError(_mapFailureToMessage(failure)));
      },
          (_) => emit(CartEmpty()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server error. Please try again.';
      case NetworkFailure _:
        return 'No internet connection.';
      case AuthenticationFailure _:
        return (failure as AuthenticationFailure).message;
      case InsufficientStockFailure _:
        final stockFailure = failure as InsufficientStockFailure;
        return 'Insufficient stock. Available: ${stockFailure.availableStock}';
      default:
        return 'An error occurred.';
    }
  }
}