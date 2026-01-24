import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/measurement_service.dart';
import '../services/recommendation_service.dart';
import '../models/measurement.dart';
import '../models/dress.dart';

final measurementServiceProvider = Provider<MeasurementService>(
  (ref) => MeasurementService(),
);

final recommendationServiceProvider = Provider<RecommendationService>(
  (ref) => RecommendationService(),
);

final measurementStateProvider =
    StateNotifierProvider<MeasurementStateNotifier, MeasurementState>((ref) {
      return MeasurementStateNotifier(ref.read(measurementServiceProvider));
    });

final recommendationProvider =
    FutureProvider.family<List<Dress>, Map<String, dynamic>>((ref, params) {
      final service = ref.read(recommendationServiceProvider);
      return service.getRecommendedDresses(
        params['category'] as DressCategory,
        params['dressType'] as DressType,
        params['measurements'] as MeasurementResult,
      );
    });

class MeasurementStateNotifier extends StateNotifier<MeasurementState> {
  final MeasurementService _measurementService;

  MeasurementStateNotifier(this._measurementService)
    : super(const MeasurementState.initial());

  Future<void> processManualMeasurements(Measurement measurement) async {
    state = const MeasurementState.loading();
    try {
      final result = await _measurementService.processManualMeasurements(
        measurement,
      );
      state = MeasurementState.success(result);
    } catch (e) {
      state = MeasurementState.error(e.toString());
    }
  }

  Future<void> processCameraMeasurements(String imagePath) async {
    state = const MeasurementState.loading();
    try {
      final result = await _measurementService.processCameraMeasurements(
        imagePath,
      );
      state = MeasurementState.success(result);
    } catch (e) {
      state = MeasurementState.error(e.toString());
    }
  }

  void reset() {
    state = const MeasurementState.initial();
  }
}

class MeasurementState {
  final bool isLoading;
  final MeasurementResult? result;
  final String? error;

  // ✅ FIX: initialize ALL final fields (result + error also)
  const MeasurementState._({required this.isLoading, this.result, this.error});

  const MeasurementState.initial()
    : this._(isLoading: false, result: null, error: null);

  const MeasurementState.loading()
    : this._(isLoading: true, result: null, error: null);

  const MeasurementState.success(MeasurementResult result)
    : this._(isLoading: false, result: result, error: null);

  const MeasurementState.error(String error)
    : this._(isLoading: false, result: null, error: error);
}
