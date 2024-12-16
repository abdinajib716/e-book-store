import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.itemCount > 0) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          'Clear Cart',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        content: Text(
                          'Are you sure you want to clear your cart?',
                          style: GoogleFonts.poppins(),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(),
                            ),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                          TextButton(
                            child: Text(
                              'Clear',
                              style: GoogleFonts.poppins(color: Colors.red),
                            ),
                            onPressed: () {
                              cart.clear();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Continue Shopping',
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) {
                    final cartItem = cart.items.values.toList()[i];
                    final book = cartItem.book;
                    return Dismissible(
                      key: ValueKey(book.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        cart.removeItem(book.id);
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.asset(
                            book.imageAssetPath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            book.title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '\$${(book.price * cartItem.quantity).toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  cart.decrementQuantity(book.id);
                                },
                              ),
                              Text(
                                '${cartItem.quantity}',
                                style: GoogleFonts.poppins(),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cart.incrementQuantity(book.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Items:',
                          style: GoogleFonts.poppins(),
                        ),
                        Text(
                          '${cart.totalQuantity}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount:',
                          style: GoogleFonts.poppins(),
                        ),
                        Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    if (cart.savings > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'You save: \$${cart.savings.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // TODO: Implement checkout
                      },
                      child: Text(
                        'Proceed to Checkout',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
