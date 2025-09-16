import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/app_bar_with_cart.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBarWithCart(
        title: 'Checkout',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.laptop, size: 30, color: Colors.blueAccent[400]),
                    ),
                  ),
                  title: Text(
                    item.product.name,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Quantity: ${item.quantity}',
                    style: TextStyle(color: Colors.blueGrey[300]),
                  ),
                  trailing: Text(
                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.blueAccent[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.blueGrey),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Payment Form
            const Text(
              'Payment Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Card Number', '1234 5678 9012 3456'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Expiry Date', 'MM/YY'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField('CVV', '123'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField('Cardholder Name', 'John Doe'),
            const SizedBox(height: 30),

            // Complete Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showOrderConfirmation(context, cartProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Complete Order',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey[300]),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.blueGrey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey[700]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueGrey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent[400]!),
        ),
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text(
          'Order Confirmed!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Thank you for your order!\nTotal: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.blueGrey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () {
              cartProvider.clearCart();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}