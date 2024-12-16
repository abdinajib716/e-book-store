import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/book_details_screen.dart';
import '../constants/styles.dart';

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
        decoration: AppStyles.cardDecoration.copyWith(
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailsScreen(book: book),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
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
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 48),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<WishlistProvider>(
                      builder: (context, wishlist, _) {
                        final isInWishlist = wishlist.isInWishlist(book);
                        return Container(
                          decoration: AppStyles.cardDecoration,
                          child: IconButton(
                            icon: Icon(
                              isInWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isInWishlist ? AppStyles.errorColor : AppStyles.successColor,
                              size: 20,
                            ),
                            onPressed: () {
                              wishlist.toggleWishlist(book);
                              final message = isInWishlist
                                  ? '${book.title} removed from wishlist'
                                  : '${book.title} added to wishlist';
                              Fluttertoast.showToast(
                                msg: message,
                                backgroundColor:
                                    isInWishlist ? AppStyles.errorColor : AppStyles.successColor,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.subheadingStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.bodyStyle,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${book.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            if (book.isDiscounted)
                              Text(
                                '\$${book.originalPrice.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        Consumer<CartProvider>(
                          builder: (context, cart, _) {
                            final isInCart = cart.items.containsKey(book.id);
                            return TextButton.icon(
                              icon: Icon(
                                isInCart
                                    ? Icons.shopping_cart
                                    : Icons.add_shopping_cart_outlined,
                                size: 18,
                                color: isInCart
                                    ? AppStyles.successColor
                                    : AppStyles.primaryColor,
                              ),
                              label: Text(
                                isInCart ? 'In Cart' : 'Add',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: isInCart
                                      ? AppStyles.successColor
                                      : AppStyles.primaryColor,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              onPressed: () {
                                if (!isInCart) {
                                  cart.addItem(book);
                                  Fluttertoast.showToast(
                                    msg: '${book.title} added to cart',
                                    backgroundColor: AppStyles.successColor,
                                  );
                                } else {
                                  Navigator.pushNamed(context, '/cart');
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
