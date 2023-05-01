import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<String> uploadImageToFirebase(String directory, File image) async {
  // Generate a unique ID for the image file
  final imageName = DateTime.now().millisecondsSinceEpoch.toString();

  // Compress the image to reduce file size
  final compressedImage = await compressImage(image);

  // Get the reference to the Firebase Storage directory where the image will be uploaded
  final storageRef = FirebaseStorage.instance.ref(directory);

  // Create a reference to the image file
  final imageRef = storageRef.child(imageName);

  // Upload the compressed image to Firebase Storage
  await imageRef.putData(compressedImage);

  // Get the download URL of the image
  final imageUrl = await imageRef.getDownloadURL();

  // Return the download URL of the image
  return imageUrl;
}


Future<List<int>> compressImage(File image) async {
  final compressedImage = await FlutterImageCompress.compressWithFile(
    image.path,
    quality: 75,
    minHeight: 1920,
    minWidth: 1080,
  );
  return compressedImage;
}