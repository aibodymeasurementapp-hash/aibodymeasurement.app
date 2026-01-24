import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_text_field.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/measurement_provider.dart';
import '../../models/measurement.dart';

class ManualMeasurementScreen extends ConsumerStatefulWidget {
  const ManualMeasurementScreen({super.key});

  @override
  ConsumerState<ManualMeasurementScreen> createState() => _ManualMeasurementScreenState();
}

class _ManualMeasurementScreenState extends ConsumerState<ManualMeasurementScreen> {
  final _additionalInstructionsController = TextEditingController();
  
  final Map<String, double> _measurements = {
    'Shirt Length': 28.0,
    'Waist': 32.0,
    'Chest': 38.0,
    'Shoulder': 17.0,
    'Sleeves Length': 24.0,
    'Hip': 36.0,
    'Inseam': 30.0,
  };

  @override
  void dispose() {
    _additionalInstructionsController.dispose();
    super.dispose();
  }

  void _updateMeasurement(String key, double value) {
    setState(() {
      _measurements[key] = value;
    });
  }

  void _continue() async {
    final measurement = Measurement(
      id: 'measurement_${DateTime.now().millisecondsSinceEpoch}',
      shirtLength: _measurements['Shirt Length']!,
      waist: _measurements['Waist']!,
      chest: _measurements['Chest']!,
      shoulder: _measurements['Shoulder']!,
      sleevesLength: _measurements['Sleeves Length']!,
      hip: _measurements['Hip']!,
      inseam: _measurements['Inseam']!,
      additionalInstructions: _additionalInstructionsController.text,
      createdAt: DateTime.now(),
    );

    ref.read(appStateProvider.notifier).setCurrentMeasurement(measurement);
    await ref.read(measurementStateProvider.notifier).processManualMeasurements(measurement);
  }

  @override
  Widget build(BuildContext context) {
    final measurementState = ref.watch(measurementStateProvider);

    // Navigate to result when processing is complete
    ref.listen(measurementStateProvider, (previous, next) {
      if (next.result != null && !next.isLoading) {
        ref.read(appStateProvider.notifier).setLatestResult(next.result!);
        context.goNamed('result');
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Custom Measurements',
        onBackPressed: () => context.goNamed('dress-type'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Measurements',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'All measurements are in inches',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Measurements
            ..._measurements.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _MeasurementRow(
                  label: entry.key,
                  value: entry.value,
                  onChanged: (value) => _updateMeasurement(entry.key, value),
                ),
              );
            }),
            
            const SizedBox(height: 20),
            
            // Additional Instructions
            AppTextField(
              label: 'Additional Instructions',
              hintText: 'Any special requirements or notes...',
              controller: _additionalInstructionsController,
              maxLines: 4,
            ),
            
            const SizedBox(height: 32),
            
            // Buttons
            PrimaryButton(
              text: 'Continue',
              onPressed: _continue,
              isLoading: measurementState.isLoading,
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => context.goNamed('camera-measurement'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  ),
                ),
                child: const Text(
                  'AI Measurement via Camera',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _MeasurementRow extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _MeasurementRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => onChanged((value - 0.5).clamp(0, 100)),
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppColors.primary,
                ),
                
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                
                IconButton(
                  onPressed: () => onChanged((value + 0.5).clamp(0, 100)),
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
