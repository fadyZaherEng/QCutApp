import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/logic/b_profile_controller.dart';

class CustomEditNewServiceBottomSheet extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String servicePrice;
  final String serviceTime;
  final String? serviceImagePath;
  final Function(bool success)? onServiceUpdated;

  const CustomEditNewServiceBottomSheet({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceTime,
    this.serviceImagePath,
    this.onServiceUpdated,
  });

  @override
  State<CustomEditNewServiceBottomSheet> createState() =>
      _CustomEditNewServiceBottomSheetState();
}

class _CustomEditNewServiceBottomSheetState
    extends State<CustomEditNewServiceBottomSheet> {
  late TextEditingController serviceNameController;
  late TextEditingController servicePriceController;
  late TextEditingController serviceTimeController;
  File? _selectedImage;
  late final BProfileController _profileController;
  bool _isSubmitting = false;
  bool _isUploadingImage = false;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    serviceNameController = TextEditingController(text: widget.serviceName);
    servicePriceController = TextEditingController(text: widget.servicePrice);
    serviceTimeController = TextEditingController(text: widget.serviceTime);
    _uploadedImageUrl = widget.serviceImagePath;

    // Register the controller if it doesn't exist yet
    if (!Get.isRegistered<BProfileController>()) {
      _profileController = Get.put(BProfileController());
    } else {
      _profileController = Get.find<BProfileController>();
    }
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    servicePriceController.dispose();
    serviceTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () async {
                  final XFile? file =
                      await picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  final XFile? file =
                      await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _uploadedImageUrl =
            null; // Reset uploaded URL when new image is selected
      });

      // Upload the selected image
      await _uploadSelectedImage();
    }
  }

  // New method to upload selected image
  Future<void> _uploadSelectedImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      _uploadedImageUrl =
          await _profileController.uploadServiceImage(_selectedImage!);

      if (_uploadedImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to upload image. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error uploading image: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _updateService() async {
    if (serviceNameController.text.isEmpty ||
        servicePriceController.text.isEmpty ||
        serviceTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if image is selected but not uploaded yet
    if (_selectedImage != null && _uploadedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please wait for image upload to complete"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _profileController.updateBarberService(
        serviceId: widget.serviceId,
        serviceName: serviceNameController.text,
        servicePrice: servicePriceController.text,
        serviceTime: serviceTimeController.text,
        imageUrl: _uploadedImageUrl, // Pass the uploaded image URL
      );

      if (response['success'] == true) {
        // Explicitly fetch services to ensure data is up to date
        await _profileController.fetchBarberServices();

        // Force a rebuild of any widgets that depend on barberServices
        _profileController.update(['barber_services']);

        // Force the entire app to rebuild - this ensures even non-GetX widgets update
        Get.forceAppUpdate();

        // Notify any parent widgets through the callback
        if (mounted) {
          // Delay the pop slightly to allow state to propagate
          await Future.delayed(const Duration(milliseconds: 100));

          Navigator.pop(context);
          if (widget.onServiceUpdated != null) {
            widget.onServiceUpdated!(true);
          }

          // Show a success message after navigation
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(
              content: Text("Service updated successfully"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? "Failed to update service"),
              backgroundColor: Colors.red,
            ),
          );
          // Still call onServiceUpdated with false to indicate failure
          if (widget.onServiceUpdated != null) {
            widget.onServiceUpdated!(false);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating service: $e"),
            backgroundColor: Colors.red,
          ),
        );
        if (widget.onServiceUpdated != null) {
          widget.onServiceUpdated!(false);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Text(
              "Edit Service",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC49A58),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Edit Service photo",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            /// Image Picker with upload status
            _isUploadingImage
                ? const Center(
                    child: SpinKitDoubleBounce(
                      color: ColorsData.primary,
                    ),
                  )
                : Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!,
                                  width: 120, height: 120, fit: BoxFit.cover)
                              : (_uploadedImageUrl != null)
                                  ? Image.network(_uploadedImageUrl!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, e, s) => Container(
                                            width: 120,
                                            height: 120,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: Colors.grey),
                                          ))
                                  : Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image,
                                          size: 50, color: Colors.grey),
                                    ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add,
                                size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      if (_uploadedImageUrl != null && _selectedImage != null)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
            const SizedBox(height: 16),

            /// Service Name Input
            _buildTextField(serviceNameController, "Change Service Name"),
            const SizedBox(height: 12),

            /// Service Price Input
            _buildTextField(servicePriceController, "Change Service Price",
                keyboardType: TextInputType.number),
            const SizedBox(height: 12),

            /// Service Time Input
            _buildTextField(
                serviceTimeController, "Change Average time (minutes)",
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),

            /// Confirm Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC49A58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: (_isSubmitting || _isUploadingImage)
                    ? null
                    : _updateService,
                child: (_isSubmitting || _isUploadingImage)
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Confirm",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Custom TextField
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      style: Styles.textStyleS14W400(color: ColorsData.dark),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: ColorsData.dark),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Show Bottom Sheet Function
void showCustomEditNewServiceBottomSheet(
  BuildContext context, {
  required String serviceId,
  required String serviceName,
  required String servicePrice,
  required String serviceTime,
  String? serviceImagePath,
  Function(bool success)? onServiceUpdated,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CustomEditNewServiceBottomSheet(
      serviceId: serviceId,
      serviceName: serviceName,
      servicePrice: servicePrice,
      serviceTime: serviceTime,
      serviceImagePath: serviceImagePath,
      onServiceUpdated: onServiceUpdated,
    ),
  );
}
