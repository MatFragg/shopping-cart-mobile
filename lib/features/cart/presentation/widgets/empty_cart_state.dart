// TODO: Similar al EmptyProductsState
Center(
child: Column(
children: [
Icon(Icons.shopping_cart_outlined, size: 120, color: Colors.grey),
Text('Your cart is empty'),
ElevatedButton(
onPressed: () => Navigator.pushNamed(context, '/browse-products'),
child: Text('Browse Products'),
),
],
),
)