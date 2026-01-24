import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';

class RecommendedDressesScreen extends ConsumerWidget {
  const RecommendedDressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ No dependency on missing AppState fields for now
    const categoryText = 'MEN';
    const dressTypeText = 'Pant Shirt';
    const suggestedSize = 'M';

    final items = _mockRecommendedList(
      category: categoryText,
      dressType: dressTypeText,
      size: suggestedSize,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Dresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopInfoCard(
              category: categoryText,
              dressType: dressTypeText,
              suggestedSize: suggestedSize,
            ),
            const SizedBox(height: AppSpacing.paddingMedium),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final d = items[index];
                  return _DressCard(
                    title: d.title,
                    price: d.price,
                    imageUrl: d.imageUrl,
                    sizeChip: d.sizeChip,
                    onTap: () {
                      // ✅ matches router fix: /dress-detail
                      context.pushNamed('dress-detail');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_DressItem> _mockRecommendedList({
    required String category,
    required String dressType,
    required String size,
  }) {
    final images = [
      'https://images.unsplash.com/photo-1520975958225-1b4e2c6b7b46?auto=format&fit=crop&w=900&q=60',
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
      'https://images.unsplash.com/photo-1520975682031-a2c4dbdc16bf?auto=format&fit=crop&w=900&q=60',
      'https://images.unsplash.com/photo-1520975740368-3d8f3a1d2f6a?auto=format&fit=crop&w=900&q=60',
    ];

    return [
      _DressItem(
        id: 'dress_01',
        title: '$category Classic $dressType',
        price: 2499,
        imageUrl: images[0],
        sizeChip: 'Suggested: $size',
      ),
      _DressItem(
        id: 'dress_02',
        title: 'Formal Outfit',
        price: 3299,
        imageUrl: images[1],
        sizeChip: 'Size: $size',
      ),
      _DressItem(
        id: 'dress_03',
        title: 'Casual Wear',
        price: 1999,
        imageUrl: images[2],
        sizeChip: 'Best Fit: $size',
      ),
      _DressItem(
        id: 'dress_04',
        title: 'Premium Collection',
        price: 3899,
        imageUrl: images[3],
        sizeChip: 'Recommended: $size',
      ),
    ];
  }
}

// ---------------- UI ----------------

class _TopInfoCard extends StatelessWidget {
  final String category;
  final String dressType;
  final String suggestedSize;

  const _TopInfoCard({
    required this.category,
    required this.dressType,
    required this.suggestedSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Icon(
                Icons.recommend,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$category • $dressType',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Suggested size: $suggestedSize',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
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

class _DressCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;
  final String sizeChip;
  final VoidCallback onTap;

  const _DressCard({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.sizeChip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      child: Text(
                        sizeChip,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rs $price',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      child: const Text('View'),
                    ),
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

// -------------- local model --------------

class _DressItem {
  final String id;
  final String title;
  final int price;
  final String imageUrl;
  final String sizeChip;

  _DressItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.sizeChip,
  });
}
