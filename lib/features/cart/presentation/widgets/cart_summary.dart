// features/shopping_cart/presentation/widgets/cart_summary.dart

// TODO: Crear widget que muestre:
// - Subtotal
// - Shipping (placeholder: "Calculated at checkout")
// - Total (bold, grande)
//
Container(
padding: EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.grey[100],
border: Border(top: BorderSide(color: Colors.grey[300])),
),
child: Column(
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('Subtotal (${cart.totalQuantity} items)'),
Text(cart.formattedTotal),
],
),
SizedBox(height: 8),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('Shipping'),
Text('Calculated at checkout', style: TextStyle(fontSize: 12)),
],
),
Divider(),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
Text(cart.formattedTotal, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
],
),
],
),
)