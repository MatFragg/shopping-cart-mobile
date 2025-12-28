import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/product.dart';

class ProductFormData {
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String? imageUrl;
  final bool active;
  final bool available;

  ProductFormData({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    this.imageUrl,
    required this.active,
    required this.available,
  });
}

class ProductForm extends StatefulWidget {
  final Product? initialProduct;
  final Function(ProductFormData) onSubmit;

  const ProductForm({
    super.key,
    this.initialProduct,
    required this.onSubmit,
  });

  @override
  State<ProductForm> createState() => ProductFormState();
}

class ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  late bool _active;
  late bool _available;

  @override
  void initState() {
    super.initState();
    if (widget.initialProduct != null) {
      _nameController.text = widget.initialProduct!.name;
      _descriptionController.text = widget.initialProduct!.description;
      _priceController.text = widget.initialProduct!.price.toString();
      _stockController.text = widget.initialProduct!.stock.toString();
      _categoryController.text = widget.initialProduct!.category;
      _imageUrlController.text = widget.initialProduct!.imageUrl ?? '';
      _active = widget.initialProduct!.active;
      _available = widget.initialProduct!.available;

    } else {
      _active = true;
      _available = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  ProductFormData getFormData() {
    return ProductFormData(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      category: _categoryController.text.trim(),
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
      active: _active,
      available: _available,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final formData = ProductFormData(
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      stock: int.tryParse(_stockController.text) ?? 0,
      category: _categoryController.text.trim(),
      imageUrl: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      active: _active,
      available: _available,
    );

    widget.onSubmit(formData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del producto',
              prefixIcon: Icon(Icons.shopping_bag),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El nombre es requerido';
              }
              if (value.trim().length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La descripción es requerida';
              }
              if (value.trim().length < 10) {
                return 'La descripción debe tener al menos 10 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Precio',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El precio es requerido';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Ingrese un precio válido mayor a 0';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _stockController,
            decoration: const InputDecoration(
              labelText: 'Stock',
              prefixIcon: Icon(Icons.inventory),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El stock es requerido';
              }
              final stock = int.tryParse(value);
              if (stock == null || stock < 0) {
                return 'Ingrese un stock válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Categoría',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La categoría es requerida';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'URL de imagen (opcional)',
              prefixIcon: Icon(Icons.image),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final uri = Uri.tryParse(value);
                if (uri == null || !uri.hasScheme) {
                  return 'Ingrese una URL válida';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Activo'),
            value: _active,
            onChanged: (value) => setState(() => _active = value),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Disponible'),
            value: _available,
            onChanged: (value) => setState(() => _available = value),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              widget.initialProduct == null
                  ? 'Crear Producto'
                  : 'Actualizar Producto',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
