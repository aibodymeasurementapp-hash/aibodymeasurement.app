import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/measurement_provider.dart';

class CameraMeasurementScreen extends ConsumerStatefulWidget {
  const CameraMeasurementScreen({super.key});

  @override
  ConsumerState<CameraMeasurementScreen> createState() => _CameraMeasurementScreenState();
}

class _CameraMeasurementScreenState extends ConsumerState<CameraMeasurementScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _retake() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _confirm() async {
    if (_selectedImage != null) {
      // Show processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing image...'),
                ],
              ),
            ),
          ),
        ),
      );

      await ref.read(measurementStateProvider.notifier).processCameraMeasurements(_selectedImage!.path);
      
      if (mounted) {
        Navigator.of(context).pop(); // Close processing dialog
      }
    }
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
        title: 'AI Measurement',
        onBackPressed: () => context.goNamed('manual-measurement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingLarge),
        child: Column(
          children: [
            const Text(
              'AI Body Measurement',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'Take or select a full-body photo for AI measurement',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Image Preview Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                ),
                child: _selectedImage == null
                    ? _buildImagePlaceholder()
                    : _buildImagePreview(),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            if (_selectedImage == null) ...[
              PrimaryButton(
                text: 'Open Camera',
                onPressed: _openCamera,
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _selectImage,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                    ),
                  ),
                  child: const Text(
                    'Select from Gallery',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _retake,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                          ),
                        ),
                        child: const Text(
                          'Retake',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: PrimaryButton(
                      text: 'Confirm',
                      onPressed: _confirm,
                      isLoading: measurementState.isLoading,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          size: 64,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 16),
        Text(
          'No image selected',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Take a photo or select from gallery',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge - 2),
          child: Image.file(
            _selectedImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        
        // Mock pose points overlay
        ..._buildMockPosePoints(),
      ],
    );
  }

  List<Widget> _buildMockPosePoints() {
    return [
      // Head
      Positioned(
        top: 50,
        left: 0,
        right: 0,
        child: Center(
          child: _PosePoint(),
        ),
      ),
      
      // Shoulders
      Positioned(
        top: 120,
        left: 80,
        child: _PosePoint(),
      ),
      Positioned(
        top: 120,
        right: 80,
        child: _PosePoint(),
      ),
      
      // Waist
      Positioned(
        top: 220,
        left: 0,
        right: 0,
        child: Center(
          child: _PosePoint(),
        ),
      ),
      
      // Hips
      Positioned(
        top: 280,
        left: 0,
        right: 0,
        child: Center(
          child: _PosePoint(),
        ),
      ),
    ];
  }
}

class _PosePoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
