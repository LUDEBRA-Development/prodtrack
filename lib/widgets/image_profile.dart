import 'package:flutter/material.dart';
import 'package:prodtrack/models/Supplier.dart';
import 'package:prodtrack/widgets/avatar.dart';

Widget imageProfile(Supplier supplier) {
  return Image.network(
      supplier.urlProfilePhoto.toString(),
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        }
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return avatar(supplier.urlProfilePhoto.toString());
      },
    );
}