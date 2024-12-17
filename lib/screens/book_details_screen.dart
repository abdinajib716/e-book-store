import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../constants/styles.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'book-${book.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      book.imageAssetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 64),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () {
                  // TODO: Implement share functionality
                  Fluttertoast.showToast(
                    msg: 'Share functionality coming soon!',
                    backgroundColor: Colors.grey[600],
                  );
                },
              ),
              Consumer<WishlistProvider>(
                builder: (context, wishlist, _) {
                  final isInWishlist = wishlist.isInWishlist(book);
                  return IconButton(
                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: isInWishlist ? Colors.red : null,
                    ),
                    onPressed: () {
                      wishlist.toggleWishlist(book);
                      final message = isInWishlist
                          ? '${book.title} removed from wishlist'
                          : '${book.title} added to wishlist';
                      Fluttertoast.showToast(
                        msg: message,
                        backgroundColor: isInWishlist
                            ? AppStyles.errorColor
                            : AppStyles.successColor,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: AppStyles.headingStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.author,
                    style: AppStyles.bodyStyle,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.star_rounded,
                        '${book.rating}',
                      ),
                      const SizedBox(width: 16),
                      _buildInfoChip(
                        Icons.menu_book_rounded,
                        '${book.pages} pages',
                      ),
                      const SizedBox(width: 16),
                      _buildInfoChip(
                        Icons.language_rounded,
                        book.language,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'About this book',
                    style: AppStyles.headingStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    style: AppStyles.bodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${book.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (book.isDiscounted) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$${book.originalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Consumer<CartProvider>(
                  builder: (context, cart, _) {
                    final isInCart = cart.items.containsKey(book.id);
                    return ElevatedButton(
                      onPressed: () {
                        if (!isInCart) {
                          cart.addItem(book);
                          Fluttertoast.showToast(
                            msg: '${book.title} added to cart',
                            backgroundColor: Colors.green,
                          );
                        } else {
                          Navigator.pushNamed(context, '/cart');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isInCart
                            ? AppStyles.successColor
                            : AppStyles.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isInCart ? 'Go to Cart' : 'Add to Cart',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
