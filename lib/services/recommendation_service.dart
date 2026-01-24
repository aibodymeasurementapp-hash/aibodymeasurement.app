import '../models/dress.dart';
import '../models/measurement.dart';
import '../constants/app_constants.dart';

class RecommendationService {
  Future<List<Dress>> getRecommendedDresses(
    DressCategory category,
    DressType dressType,
    MeasurementResult measurements,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock recommendation logic
    final suggestedSize = _calculateSuggestedSize(measurements);
    final categoryString = category.name.toUpperCase();
    final typeString = dressType == DressType.pantShirt ? 'Pant Shirt' : 'Shalwar Qameez';

    return [
      Dress(
        id: 'dress_1',
        title: 'Premium $typeString for $categoryString',
        description: 'High-quality fabric with excellent comfort and fit.',
        price: 2999.99,
        imageUrl: AppImages.dressPlaceholder,
        category: categoryString,
        type: typeString,
        availableSizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
        suggestedSize: suggestedSize,
      ),
      Dress(
        id: 'dress_2',
        title: 'Classic $typeString Collection',
        description: 'Traditional design with modern comfort.',
        price: 2499.99,
        imageUrl: AppImages.shirtPlaceholder,
        category: categoryString,
        type: typeString,
        availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
        suggestedSize: suggestedSize,
      ),
      Dress(
        id: 'dress_3',
        title: 'Designer $typeString',
        description: 'Exclusive designer piece with premium materials.',
        price: 3999.99,
        imageUrl: AppImages.dressPlaceholder,
        category: categoryString,
        type: typeString,
        availableSizes: ['S', 'M', 'L', 'XL'],
        suggestedSize: suggestedSize,
      ),
    ];
  }

  String _calculateSuggestedSize(MeasurementResult measurements) {
    // Mock size calculation based on chest measurement
    if (measurements.chest < 85) return 'S';
    if (measurements.chest < 95) return 'M';
    if (measurements.chest < 105) return 'L';
    return 'XL';
  }
}
