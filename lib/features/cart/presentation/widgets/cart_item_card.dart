// features/shopping_cart/presentation/widgets/cart_item_card.dart

// TODO: Crear widget que muestre:
// - Image del producto (leading)
// - Nombre del producto
// - Precio unitario
// - Quantity selector (+/- buttons)
// - Subtotal
// - Delete icon button
//
// Diseño sugerido:
Card(
child: ListTile(
leading: CircleAvatar(
backgroundImage: item.imageUrl != null
? NetworkImage(item.imageUrl!)
    : AssetImage('assets/placeholder.png'),
),
title: Text(item.productName),
subtitle: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(item.formattedUnitPrice),
Row(
children: [
IconButton(
icon: Icon(Icons.remove_circle_outline),
onPressed: () {
// TODO: Decrease quantity
},
),
Text('${item.quantity}'),
IconButton(
icon: Icon(Icons.add_circle_outline),
onPressed: () {
// TODO: Increase quantity
},
),
],
),
],
),
trailing: Column(
children: [
Text(item.formattedSubtotal, style: bold),
IconButton(
icon: Icon(Icons.delete, color: Colors.red),
onPressed: () {
// TODO: Show confirmation dialog then remove
},
),
],
),
),
)