import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  
  const UserImage({super.key, required this.onPickedImage});
  final void Function(File? pickImage) onPickedImage;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  XFile? imageFile = null;
  void selectImg() async {
    XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 150, imageQuality: 50);
    if (file == null) {
      return null;
    }
    setState(() {
      imageFile = file;
    });
    widget.onPickedImage(File(imageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              imageFile != null ? FileImage(File(imageFile!.path)) : null,
          child: imageFile == null
              ? const Icon(
                  Icons.account_circle_rounded,
                  size: 40,
                )
              : null,
        ),
        TextButton.icon(
          onPressed: selectImg,
          icon: Icon(Icons.image),
          label: Text('Profile Image'),
        )
      ],
    );
  }
}
