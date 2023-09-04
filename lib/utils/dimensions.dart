import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const webScreensize = 600;

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
  ));
}

Future<XFile?> selectImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? myImg = await imagePicker.pickImage(source: source);
  return myImg;
}
