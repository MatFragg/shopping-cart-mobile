import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_form.dart';

class CreateProductPage extends StatelessWidget {
  final Product? product;

  const CreateProductPage({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final isEditing = product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Producto' : 'Crear Producto'),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context, true);
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: ProductForm(
          initialProduct: product,
          onSubmit: (formData) {
            if (isEditing) {
              context.read<ProductBloc>().add(
                UpdateProductEvent(
                  productId: product!.id,
                  name: formData.name,
                  description: formData.description,
                  price: formData.price,
                  stock: formData.stock,
                  category: formData.category,
                  imageUrl: formData.imageUrl,
                  active: formData.active,
                  available: formData.available,
                ),
              );
            } else {
              context.read<ProductBloc>().add(
                CreateProductEvent(
                  name: formData.name,
                  description: formData.description,
                  price: formData.price,
                  stock: formData.stock,
                  category: formData.category,
                  imageUrl: formData.imageUrl,
                  active: formData.active,
                  available: formData.available,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
