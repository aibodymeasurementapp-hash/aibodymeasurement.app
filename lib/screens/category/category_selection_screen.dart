import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../providers/app_state_provider.dart';
import '../../models/dress.dart';

class CategorySelectionScreen extends ConsumerWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Select Category',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingLarge),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            const Text(
              'Choose your category',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              'Select the category that best fits you',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 40),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                children: [
                  _CategoryCard(
                    title: 'MEN',
                    imageUrl: AppImages.menCategory,
                    onTap: () {
                      ref.read(appStateProvider.notifier).setSelectedCategory(DressCategory.men);
                      context.goNamed('dress-type');
                    },
                  ),
                  _CategoryCard(
                    title: 'WOMEN',
                    imageUrl: AppImages.womenCategory,
                    onTap: () {
                      ref.read(appStateProvider.notifier).setSelectedCategory(DressCategory.women);
                      context.goNamed('dress-type');
                    },
                  ),
                  _CategoryCard(
                    title: 'KIDS',
                    imageUrl: AppImages.kidsCategory,
                    onTap: () {
                      ref.read(appStateProvider.notifier).setSelectedCategory(DressCategory.kids);
                      context.goNamed('dress-type');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primaryLight.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Background Image
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 120,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(AppSpacing.radiusLarge),
                    bottomRight: Radius.circular(AppSpacing.radiusLarge),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.border,
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Content
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Select',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
