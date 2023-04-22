import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<String> uploadImageToFirebase(String directory, File image) async {
  // Generate a unique ID for the image file
  final imageName = DateTime.now().millisecondsSinceEpoch.toString();

  // Get the reference to the Firebase Storage directory where the image will be uploaded
  final storageRef = FirebaseStorage.instance.ref(directory);

  // Create a reference to the image file
  final imageRef = storageRef.child(imageName);

  // Upload the image to Firebase Storage
  await imageRef.putFile(image);

  // Get the download URL of the image
  final imageUrl = await imageRef.getDownloadURL();

  // Return the download URL of the image
  return imageUrl;
}