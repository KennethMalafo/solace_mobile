import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solace_mobile_frontend/weather_and_disaster_forecasting/storage_permission.dart';
import 'package:solace_mobile_frontend/weather_and_disaster_forecasting/image_picker_screen.dart';
import 'package:solace_mobile_frontend/weather_and_disaster_forecasting/saving_user_reports_to_firestore.dart';
import 'package:solace_mobile_frontend/weather_and_disaster_forecasting/cloudinary_upload.dart';

// Get current location method
Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  return await Geolocator.getCurrentPosition();
}

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  ImageUploadScreenState createState() => ImageUploadScreenState();
}

class ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  String _message = '';
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController(text: "+69");
  bool _isPickingImage = false;
  bool _isLoading = false; // Loading state

  // Method to pick an image
  _pickImage() async {
    if (_isPickingImage) return;
    setState(() {
      _isPickingImage = true;
    });

    // Check and request storage permission
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
      setState(() {
        _isPickingImage = false;
      });
      return;
    }

    try {
      if (_image != null) {
        // Guard showDialog with a mounted check
        if (!mounted) return;

        bool? shouldReplace = await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text("Replace Image"),
            content: const Text("Do you want to replace the current image?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text("Replace"),
              ),
            ],
          ),
        );

        if (shouldReplace == null || !shouldReplace) {
          if (mounted) {
            setState(() {
              _isPickingImage = false;
            });
          }
          return;
        }
      }

      File? selectedImage = await pickImage();
      if (selectedImage != null && mounted) {
        setState(() {
          _image = selectedImage;
        });
      }
    } catch (e) {
      // Guard ScaffoldMessenger with a mounted check
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error selecting image')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  // Upload data method with loading indicator
  _uploadData() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image to upload')),
      );
      return;
    }

    if (_message.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    if (_email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email')),
      );
      return;
    }

    if (!_email.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    if (_phoneNumber.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email')),
      );
      return;
    }

    if (_phoneNumber.text.trim().length < 13 ) { // +69 and 10 digits
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid contact number')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      Position position = await getCurrentLocation();
      String imageUrl = await uploadImageToCloudinary(_image!);
      await SavingUserReports().saveDataToFirestore(
        imageUrl,
        position.latitude,
        position.longitude,
        _message,
        _email.text,
        _phoneNumber.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data uploaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error uploading data')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sol",
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                color: Colors.blue[900],
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.07,
                maxHeight: screenHeight * 0.1,
              ),
              child: Image.asset(
                'images/a_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'ce RiverWatch',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue[100],
      body: Stack(
        children: [
          // Background image layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'images/mdrrmo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content layer
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: ListView(
              children: [
                Center(
                  child: Text(
                    'Help Us Respond: Upload Disaster-Related Evidence',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: screenHeight * 0.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      border: Border.all(
                        color: Colors.blue[400]!,
                        width: screenWidth * 0.005,
                      ),
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Center(
                            child: Text(
                              'Tap to select an image',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      _message = text;
                    });
                  },
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Enter your message',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      borderSide: BorderSide(color: Colors.blue[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      borderSide: BorderSide(color: Colors.blue[600]!),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  controller: _email,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      borderSide: BorderSide(color: Colors.blue[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      borderSide: BorderSide(color: Colors.blue[600]!),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  controller: _phoneNumber,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Enter your phone number',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      borderSide: BorderSide(color: Colors.blue[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      borderSide: BorderSide(color: Colors.blue[600]!),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: _isLoading ? null : _uploadData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Upload Data',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Center(
                  child: Text(
                    '*Note: paki upload ang imahe ng disaster related incident sa kung saan man ito nangyare*',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}