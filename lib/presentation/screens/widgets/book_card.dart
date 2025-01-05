import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../domain/entities/models/book.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../books/book_details_screen.dart';
import '../../../core/constants/styles.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 200,
          maxHeight: 300,
        ),
        decoration: AppStyles.cardDecoration.copyWith(
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsScreen(book: book),
            ),
          ),
          child: Column(
            children: [
              _buildBookImage(),
              _buildBookDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookImage() {
    return Expanded(
      flex: 2,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Hero(
              tag: 'book-${book.id}',
              child: Image.asset(
                book.imageAssetPath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.book_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          _buildWishlistButton(),
        ],
      ),
    );
  }

  Widget _buildWishlistButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Consumer<WishlistProvider>(
        builder: (context, wishlist, _) {
          final isInWishlist = wishlist.isInWishlist(book);
          return Container(
            decoration: AppStyles.cardDecoration,
            child: IconButton(
              icon: Icon(
                isInWishlist ? Icons.favorite : Icons.favorite_border,
                color: isInWishlist
                    ? AppStyles.errorColor
                    : AppStyles.successColor,
                size: 20,
              ),
              onPressed: () =>
                  _handleWishlistToggle(context, wishlist, isInWishlist),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookDetails(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: AppStyles.subheadingStyle.copyWith(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  style: AppStyles.bodyStyle.copyWith(
                    fontSize: 12,
                    color: AppStyles.subtitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            _buildPriceAndCartSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceAndCartSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${book.price.toStringAsFixed(2)}',
                style: AppStyles.subheadingStyle.copyWith(
                  fontSize: 16,
                  color: AppStyles.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (book.isDiscounted)
                Text(
                  '\$${book.originalPrice.toStringAsFixed(2)}',
                  style: AppStyles.bodyStyle.copyWith(
                    fontSize: 12,
                    color: AppStyles.subtitleColor,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
          _buildCartButton(context),
        ],
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final isInCart = cart.items.containsKey(book.id);
        return TextButton.icon(
          icon: Icon(
            isInCart ? Icons.shopping_cart : Icons.add_shopping_cart_outlined,
            size: 18,
            color: isInCart ? AppStyles.successColor : AppStyles.primaryColor,
          ),
          label: Text(
            isInCart ? 'In Cart' : 'Add',
            style: AppStyles.bodyStyle.copyWith(
              fontSize: 12,
              color: isInCart ? AppStyles.successColor : AppStyles.primaryColor,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          onPressed: () => _handleCartAction(context, cart, isInCart),
        );
      },
    );
  }

  void _handleWishlistToggle(
      BuildContext context, WishlistProvider wishlist, bool isInWishlist) {
    wishlist.toggleWishlist(book);
    final message = isInWishlist
        ? '${book.title} removed from wishlist'
        : '${book.title} added to wishlist';
    _showToast(
        message, isInWishlist ? AppStyles.errorColor : AppStyles.successColor);
  }

  void _handleCartAction(
      BuildContext context, CartProvider cart, bool isInCart) {
    if (!isInCart) {
      cart.addItem(book);
      _showToast('${book.title} added to cart', AppStyles.successColor);
    } else {
      Navigator.pushNamed(context, '/cart');
    }
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
    );
  }
}
