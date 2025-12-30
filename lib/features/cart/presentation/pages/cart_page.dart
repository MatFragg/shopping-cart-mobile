// features/shopping_cart/presentation/pages/cart_page.dart

// TODO: Crear página con:
// - AppBar con título "Shopping Cart" y badge de cantidad
// - BlocBuilder que muestra diferentes estados:
//   - CartLoading: CircularProgressIndicator
//   - CartEmpty: EmptyCartState widget
//   - CartLoaded: ListView de CartItemCard + CartSummary
//   - CartError: Error message con retry button
// - FloatingActionButton para "Proceed to Checkout"
//
// Estructura sugerida:
Scaffold(
appBar: AppBar(
title: Text('Shopping Cart'),
actions: [
// TODO: Clear cart icon button
],
),
body: BlocConsumer<CartBloc, CartState>(
listener: (context, state) {
if (state is CartOperationSuccess) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text(state.message)),
);
}
},
builder: (context, state) {
if (state is CartLoading) {
return Center(child: CircularProgressIndicator());
}

if (state is CartEmpty) {
return EmptyCartState();
}

if (state is CartLoaded || state is CartOperationSuccess) {
final cart = state is CartLoaded
? state.cart
    : (state as CartOperationSuccess).cart;

return Column(
children: [
Expanded(
child: ListView.builder(
itemCount: cart.items.length,
itemBuilder: (context, index) {
return CartItemCard(item: cart.items[index]);
},
),
),
CartSummary(cart: cart),
],
);
}

if (state is CartError) {
return Center(
child: Column(
children: [
Text(state.message),
ElevatedButton(
onPressed: () => context.read<CartBloc>().add(LoadCart()),
child: Text('Retry'),
),
],
),
);
}

return SizedBox.shrink();
},
),
floatingActionButton: BlocBuilder<CartBloc, CartState>(
builder: (context, state) {
if (state is CartLoaded || state is CartOperationSuccess) {
return FloatingActionButton.extended(
onPressed: () {
// TODO: Navigate to checkout
Navigator.pushNamed(context, '/checkout');
},
label: Text('Checkout'),
icon: Icon(Icons.payment),
);
}
return SizedBox.shrink();
},
),
)