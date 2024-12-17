import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../constants/styles.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: AppStyles.headingStyle,
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
                        title: const Text(
                          'Clear Cart',
                          style: AppStyles.headingStyle,
                        ),
                        content: const Text(
                          'Are you sure you want to clear your cart?',
                          style: AppStyles.bodyStyle,
                        ),
                        actions: [
                          TextButton(
                            child: const Text(
                              'Cancel',
                              style: AppStyles.bodyStyle,
                            ),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                          TextButton(
                            child: Text(
                              'Clear',
                              style: AppStyles.bodyStyle
                                  .copyWith(color: AppStyles.errorColor),
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
                    style:
                        AppStyles.subheadingStyle.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Continue Shopping',
                      style: AppStyles.bodyStyle
                          .copyWith(color: Theme.of(context).primaryColor),
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
                        color: AppStyles.errorColor,
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
                            style: AppStyles.headingStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${(book.price * cartItem.quantity).toStringAsFixed(2)}',
                                style: AppStyles.bodyStyle.copyWith(
                                  color: AppStyles.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (book.isDiscounted)
                                Text(
                                  'You save: \$${((book.originalPrice - book.price) * cartItem.quantity).toStringAsFixed(2)}',
                                  style: AppStyles.bodyStyle.copyWith(
                                    color: AppStyles.successColor,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
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
                                style: AppStyles.bodyStyle,
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
                          style: AppStyles.bodyStyle.copyWith(
                            fontSize: 14,
                            color: AppStyles.subtitleColor,
                          ),
                        ),
                        Text(
                          '${cart.totalQuantity}',
                          style: AppStyles.headingStyle.copyWith(
                            fontSize: 16,
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
                          style: AppStyles.bodyStyle.copyWith(
                            fontSize: 14,
                            color: AppStyles.subtitleColor,
                          ),
                        ),
                        Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: AppStyles.headingStyle.copyWith(
                            fontSize: 18,
                            color: AppStyles.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    if (cart.savings > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'You save: \$${cart.savings.toStringAsFixed(2)}',
                        style: AppStyles.bodyStyle.copyWith(
                          color: AppStyles.successColor,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: AppStyles.primaryButtonStyle.copyWith(
                        minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 48),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implement checkout
                      },
                      child: Text(
                        'Proceed to Checkout',
                        style: AppStyles.bodyStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
