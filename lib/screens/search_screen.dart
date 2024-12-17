import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/styles.dart';
import '../models/book.dart';
import '../services/search_service.dart';
import '../widgets/book_card.dart';
import '../widgets/book_card_skeleton.dart';
import '../widgets/cart_badge.dart';
import '../utils/debouncer.dart';

class SearchScreen extends StatefulWidget {
  final List<Book>? initialBooks;

  const SearchScreen({super.key, this.initialBooks});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer();
  List<Book> _searchResults = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isInitialState = true;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.text = '';
      setState(() => _isInitialState = true);
    });
    _searchResults = widget.initialBooks ?? [];
    _hasSearched = widget.initialBooks != null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = widget.initialBooks ?? [];
        _hasSearched = widget.initialBooks != null;
      });
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = '';
        _isInitialState = false;
      });
    }

    try {
      final searchTerms = query.toLowerCase().split(' ');
      
      setState(() {
        _searchResults = (widget.initialBooks ?? []).where((book) {
          final title = book.title.toLowerCase();
          final author = book.author.toLowerCase();
          final description = book.description.toLowerCase();
          
          return searchTerms.every((term) =>
            title.contains(term) ||
            author.contains(term) ||
            description.contains(term)
          );
        }).toList();
        _hasSearched = true;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to search books. Please try again.';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage),
            backgroundColor: AppStyles.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search books...',
                hintStyle: AppStyles.bodyStyle.copyWith(color: AppStyles.subtitleColor),
                border: InputBorder.none,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _performSearch(_searchController.text.trim()),
                    ),
                  ],
                ),
              ),
              style: AppStyles.bodyStyle,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {}); // Update UI for clear button visibility
                _debouncer.run(() => _performSearch(value));
              },
              onSubmitted: _performSearch,
            ),
          ),
          CartBadge(
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isInitialState) {
      return _buildInitialState();
    }

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSearchResults();
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Start typing to search books',
            style: AppStyles.bodyStyle.copyWith(
              color: AppStyles.subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6, // Show 6 skeleton items
      itemBuilder: (context, index) => const BookCardSkeleton(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppStyles.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: AppStyles.bodyStyle.copyWith(
              color: AppStyles.errorColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _performSearch(_searchController.text),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No books found for "${_searchController.text}"',
            style: AppStyles.bodyStyle.copyWith(
              color: AppStyles.subtitleColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final book = _searchResults[index];
        return BookCard(book: book);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }
}
