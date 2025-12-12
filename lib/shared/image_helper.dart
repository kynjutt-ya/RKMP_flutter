import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  /// Конвертирует XFile в File (для мобильных) или сохраняет bytes (для веб)
  static Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final picker = ImagePicker();
    return await picker.pickImage(source: source);
  }

  /// Получает bytes из XFile
  static Future<Uint8List?> getImageBytes(XFile? file) async {
    if (file == null) return null;
    return await file.readAsBytes();
  }

  /// Создает виджет изображения из File или bytes
  static Widget buildImageWidget({
    String? imageUrl,
    String? imagePath,
    File? imageFile,
    Uint8List? imageBytes,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String placeholderAsset = 'assets/placeholder.png',
  }) {
    // Приоритет: imageUrl > imageBytes > imageFile > imagePath
    if (imageUrl != null && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(
          placeholderAsset,
          width,
          height,
          fit,
        ),
      );
    }

    if (imageBytes != null) {
      return Image.memory(
        imageBytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(
          placeholderAsset,
          width,
          height,
          fit,
        ),
      );
    }

    if (!kIsWeb && imageFile != null && imageFile.existsSync()) {
      return Image.file(
        imageFile,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(
          placeholderAsset,
          width,
          height,
          fit,
        ),
      );
    }

    if (!kIsWeb && imagePath != null) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(
            placeholderAsset,
            width,
            height,
            fit,
          ),
        );
      }
    }

    return _buildPlaceholder(placeholderAsset, width, height, fit);
  }

  static Widget _buildPlaceholder(String asset, double? width, double? height, BoxFit fit) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      ),
    );
  }
}

