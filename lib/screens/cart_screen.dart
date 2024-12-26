import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../constants/styles.dart';
import '../routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Cart',
          style: AppStyles.headingStyle.copyWith(
            fontSize: 24,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.itemCount > 0) {
                return IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppStyles.errorColor,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppStyles.errorColor,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Clear Cart',
                              style: AppStyles.headingStyle,
                            ),
                          ],
                        ),
                        content: const Text(
                          'Are you sure you want to clear your cart? This action cannot be undone.',
                          style: AppStyles.bodyStyle,
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: AppStyles.bodyStyle.copyWith(
                                color: AppStyles.subtitleColor,
                              ),
                            ),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.errorColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              cart.clear();
                              Navigator.of(ctx).pop();
                            },
                            child: Text(
                              'Clear Cart',
                              style: AppStyles.bodyStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppStyles.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: AppStyles.primaryColor,
                    ),
                  ).animate().scale(),
                  const SizedBox(height: 24),
                  Text(
                    'Your cart is empty',
                    style: AppStyles.headingStyle.copyWith(
                      fontSize: 20,
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 8),
                  Text(
                    'Add some books to start reading!',
                    style: AppStyles.bodyStyle.copyWith(
                      color: AppStyles.subtitleColor,
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: AppStyles.primaryButtonStyle,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('Browse Books'),
                  ).animate().scale(),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) {
                    final cartItem = cart.items.values.toList()[i];
                    final book = cartItem.book;
                    return Dismissible(
                      key: ValueKey(book.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppStyles.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.delete_outline,
                          color: AppStyles.errorColor,
                        ),
                      ),
                      onDismissed: (_) {
                        cart.removeItem(book.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppStyles.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  book.imageAssetPath,
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: AppStyles.headingStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      book.author,
                                      style: AppStyles.bodyStyle.copyWith(
                                        color: AppStyles.subtitleColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${(book.price * cartItem.quantity).toStringAsFixed(2)}',
                                          style: AppStyles.headingStyle.copyWith(
                                            color: AppStyles.primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        if (book.isDiscounted) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppStyles.successColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Save \$${((book.originalPrice - book.price) * cartItem.quantity).toStringAsFixed(2)}',
                                              style: AppStyles.bodyStyle.copyWith(
                                                color: AppStyles.successColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppStyles.backgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildQuantityButton(
                                            icon: Icons.remove,
                                            onPressed: () => cart.decrementQuantity(book.id),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            child: Text(
                                              '${cartItem.quantity}',
                                              style: AppStyles.headingStyle.copyWith(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          _buildQuantityButton(
                                            icon: Icons.add,
                                            onPressed: () => cart.incrementQuantity(book.id),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn().slideX();
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppStyles.surfaceColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
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
                          'Total Items',
                          style: AppStyles.bodyStyle.copyWith(
                            fontSize: 14,
                            color: AppStyles.subtitleColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppStyles.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${cart.totalQuantity}',
                            style: AppStyles.headingStyle.copyWith(
                              fontSize: 16,
                              color: AppStyles.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: AppStyles.bodyStyle.copyWith(
                            fontSize: 14,
                            color: AppStyles.subtitleColor,
                          ),
                        ),
                        Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: AppStyles.headingStyle.copyWith(
                            fontSize: 24,
                            color: AppStyles.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    if (cart.savings > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppStyles.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.savings_outlined,
                              color: AppStyles.successColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'You save \$${cart.savings.toStringAsFixed(2)}',
                              style: AppStyles.bodyStyle.copyWith(
                                color: AppStyles.successColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: AppStyles.primaryButtonStyle.copyWith(
                        minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 56),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.paymentMethod,
                          arguments: {
                            'totalAmount': cart.totalAmount,
                            'items': cart.items.values.toList(),
                          },
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: AppStyles.primaryColor,
          ),
        ),
      ),
    );
  }
}
