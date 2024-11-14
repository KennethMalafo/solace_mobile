import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> uploadImageToCloudinary(File imageFile) async {
  // Your Cloudinary cloud name
  String cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dw9zrax2h/image/upload';
  String uploadPreset = 'nuas0q21';  // Your unsigned upload preset

  // Read the image file and convert it to base64
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64Image = base64Encode(imageBytes);

  // Send POST request to Cloudinary with image and upload preset
  try {
    var response = await http.post(
      Uri.parse(cloudinaryUrl),
      body: {
        'file': 'data:image/jpeg;base64,$base64Image',
        'upload_preset': uploadPreset,  // Unsigned preset
      },
    );

    // Check if the upload was successful
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String imageUrl = jsonResponse['secure_url'];  // Get the image URL
      return imageUrl;
    } else {
      throw Exception('Failed to upload image');
    }
  } catch (e) {
    throw Exception('Error uploading image: $e');
  }
}
