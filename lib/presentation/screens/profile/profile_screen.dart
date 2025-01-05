import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../../core/constants/styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text('Coming soon!'),
          ],
        ),
        backgroundColor: AppStyles.primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final wishlist = Provider.of<WishlistProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: screenSize.height * 0.3,
            pinned: true,
            backgroundColor: AppStyles.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppStyles.primaryColor.withOpacity(0.8),
                      AppStyles.primaryColor,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppStyles.primaryColor,
                      ),
                    ).animate().scale(),
                    const SizedBox(height: 16),
                    Text(
                      currentUser?.fullName ?? 'Guest',
                      style: AppStyles.headingStyle.copyWith(
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(),
                    if (currentUser != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        currentUser.email,
                        style: AppStyles.bodyStyle.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ).animate().fadeIn(),
                    ],
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileItem(
                    context,
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    subtitle: 'Update your information',
                    onTap: () => _showComingSoon(context),
                  ),
                  _buildProfileItem(
                    context,
                    icon: Icons.shopping_bag,
                    title: 'My Orders',
                    subtitle: 'Check your order status',
                    onTap: () => _showComingSoon(context),
                  ),
                  _buildProfileItem(
                    context,
                    icon: Icons.favorite,
                    title: 'Wishlist',
                    subtitle: 'Books you saved',
                    trailing: '${wishlist.items.length} books',
                    onTap: () {
                      Navigator.pushNamed(context, '/wishlist');
                    },
                  ),
                  _buildProfileItem(
                    context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage your notifications',
                    onTap: () => _showComingSoon(context),
                  ),
                  _buildProfileItem(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(height: 24),
                  _buildSignOutButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        color: AppStyles.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppStyles.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppStyles.primaryColor,
            ),
          ),
          title: Text(
            title,
            style: AppStyles.subheadingStyle,
          ),
          subtitle: Text(
            subtitle,
            style: AppStyles.bodyStyle.copyWith(
              color: AppStyles.subtitleColor,
            ),
          ),
          trailing: trailing != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppStyles.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    trailing,
                    style: AppStyles.bodyStyle.copyWith(
                      color: AppStyles.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Icon(
                  Icons.arrow_forward_ios,
                  color: AppStyles.primaryColor,
                  size: 16,
                ),
          onTap: onTap,
        ),
      ),
    ).animate().slideX();
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Container(
          width: double.infinity,
          height: 56,
          margin: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton.icon(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    try {
                      await authProvider.logout();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text('Signed out successfully'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/login');
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(e.toString()),
                            ],
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[50],
              foregroundColor: Colors.red,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: authProvider.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.red[300]!,
                      ),
                    ),
                  )
                : const Icon(Icons.logout),
            label: Text(
              'Sign Out',
              style: AppStyles.bodyStyle.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ).animate().fadeIn();
      },
    );
  }
}
