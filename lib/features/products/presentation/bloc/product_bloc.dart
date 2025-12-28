import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/features/authentication/data/datasources/token_data_source.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_my_products.dart';
import '../../domain/usecases/get_products_by_category.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/update_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProducts getAllProducts;
  final GetMyProducts getMyProducts;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final SearchProducts searchProducts;
  final GetProductsByCategory getProductsByCategory;
  final TokenDataSource tokenDataSource;

  ProductBloc({
    required this.getAllProducts,
    required this.getMyProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.searchProducts,
    required this.getProductsByCategory,
    required this.tokenDataSource,
  }) : super(ProductInitial()) {
    on<LoadAllProducts>(_onLoadAllProducts);
    on<LoadMyProducts>(_onLoadMyProducts);
    on<CreateProductEvent>(_onCreateProduct);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadAllProducts(
      LoadAllProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    final token = event.token ?? await tokenDataSource.getToken();
    if (token == null || token.isEmpty) {
      emit(const ProductError('No authentication token found'));
      return;
    }

    final result = await getAllProducts(GetAllProductsParams(token));

    result.fold(
          (failure) {
        emit(ProductError(_mapFailureToMessage(failure)));
      },
          (products) {
        if (products.isEmpty) {
          emit(const ProductEmpty('No products available'));
        } else {
          emit(ProductsLoaded(products: products));
        }
      },
    );
  }

  Future<void> _onLoadMyProducts(
      LoadMyProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    final token = event.token ?? await tokenDataSource.getToken();

    if (token == null || token.isEmpty) {
      emit(const ProductError('No authentication token found'));
      return;
    }

    final result = await getMyProducts(GetMyProductsParams(token));

    result.fold(
          (failure) {
        emit(ProductError(_mapFailureToMessage(failure)));
      },
          (products) {
        if (products.isEmpty) {
          emit(const ProductEmpty('No tienes productos aún'));
        } else {
          emit(ProductsLoaded(products: products));
        }
      },
    );
  }

  Future<void> _onCreateProduct(
      CreateProductEvent event,
      Emitter<ProductState> emit,
      ) async {
    if (event.name.trim().isEmpty) {
      emit(const ProductError('El nombre del producto es requerido'));
      return;
    }

    if (event.description.trim().isEmpty) {
      emit(const ProductError('La descripción es requerida'));
      return;
    }

    if (event.price <= 0) {
      emit(const ProductError('El precio debe ser mayor a 0'));
      return;
    }

    if (event.stock < 0) {
      emit(const ProductError('El stock no puede ser negativo'));
      return;
    }

    if (event.category.trim().isEmpty) {
      emit(const ProductError('La categoría es requerida'));
      return;
    }

    emit(ProductLoading());

    final token = await tokenDataSource.getToken();
    if (token == null || token.isEmpty) {
      emit(const ProductError('No authentication token found'));
      return;
    }

    final result = await createProduct(
      CreateProductParams(
        token,
        name: event.name,
        description: event.description,
        price: event.price,
        stock: event.stock,
        category: event.category,
        imageUrl: event.imageUrl,
        active: event.active,
        available: event.available,
      ),
    );

    result.fold(
          (failure) => emit(ProductError(_mapFailureToMessage(failure))),
          (product) => emit(const ProductOperationSuccess('Producto creado exitosamente')),
    );
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event,
      Emitter<ProductState> emit,
      ) async {
    // Validación de campos con null-safe operators
    if (event.name?.trim().isEmpty ?? true) {
      emit(const ProductError('El nombre del producto es requerido'));
      return;
    }

    if (event.description?.trim().isEmpty ?? true) {
      emit(const ProductError('La descripción es requerida'));
      return;
    }

    if ((event.price ?? 0) <= 0) {
      emit(const ProductError('El precio debe ser mayor a 0'));
      return;
    }

    if ((event.stock ?? -1) < 0) {
      emit(const ProductError('El stock no puede ser negativo'));
      return;
    }

    if (event.category?.trim().isEmpty ?? true) {
      emit(const ProductError('La categoría es requerida'));
      return;
    }

    emit(ProductLoading());

    final token = await tokenDataSource.getToken();
    if (token == null || token.isEmpty) {
      emit(const ProductError('No authentication token found'));
      return;
    }

    final result = await updateProduct(
      UpdateProductParams(
        token,
        event.productId,
        name: event.name,
        description: event.description,
        price: event.price,
        stock: event.stock,
        category: event.category,
        imageUrl: event.imageUrl,
        active: event.active,
        available: event.available,

      ),
    );

    result.fold(
          (failure) => emit(ProductError(_mapFailureToMessage(failure))),
          (product) => emit(const ProductOperationSuccess('Producto actualizado exitosamente')),
    );
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    final token = await tokenDataSource.getToken();
    if (token == null || token.isEmpty) {
      emit(const ProductError('No authentication token found'));
      return;
    }

    final result = await deleteProduct(
      DeleteProductParams(token, event.productId),
    );

    result.fold(
          (failure) => emit(ProductError(_mapFailureToMessage(failure))),
          (_) => emit(const ProductOperationSuccess('Producto eliminado exitosamente')),
    );
  }

  Future<void> _onSearchProducts(
      SearchProductsEvent event,
      Emitter<ProductState> emit,
      ) async {
    if (event.query.trim().isEmpty) {
      add(const LoadAllProducts());
      return;
    }

    emit(ProductLoading());

    final token = await tokenDataSource.getToken();
    if (token == null || token.isEmpty) {
      emit(const ProductError('No authentication token found'));
      return;
    }

    final result = await searchProducts(
      SearchProductsParams(token, event.query),
    );

    result.fold(
          (failure) => emit(ProductError(_mapFailureToMessage(failure))),
          (products) {
        if (products.isEmpty) {
          emit(ProductEmpty('No se encontraron productos con "${event.query}"'));
        } else {
          emit(ProductsLoaded(products: products));
        }
      },
    );
  }

  Future<void> _onFilterByCategory(
      FilterByCategory event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());

    final token = await tokenDataSource.getToken();
    if (token == null || token.isEmpty) {
      emit(const ProductError('No authentication token found'));
      return;
    }

    final result = await getProductsByCategory(
      GetProductsByCategoryParams(token, event.category),
    );

    result.fold(
          (failure) => emit(ProductError(_mapFailureToMessage(failure))),
          (products) {
        if (products.isEmpty) {
          emit(ProductEmpty('No hay productos en la categoría "${event.category}"'));
        } else {
          emit(ProductsLoaded(products: products));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Error del servidor. Por favor intenta más tarde.';
      case NetworkFailure _:
        return 'Sin conexión a internet.';
      case CacheFailure _:
        return 'No se pudo cargar datos en caché.';
      default:
        return 'Ocurrió un error inesperado.';
    }
  }
}
