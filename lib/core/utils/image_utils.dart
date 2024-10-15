import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;

// ignore: constant_identifier_names
const IOS_BYTES_OFFSET = 28;

/// ImageUtils
class ImageUtils {
  /// Converts a [CameraImage] in YUV420 or BGRA8888 format to [Image] in RGB format
  /// Ref: https://gist.github.com/Alby-o/fe87e35bc21d534c8220aed7df028e03?permalink_comment_id=4574528#gistcomment-4574528
  static image_lib.Image convertCameraImage(CameraImage cameraImage) {
    return switch (cameraImage.format.group) {
      ImageFormatGroup.yuv420 => convertYUV420ToImage(cameraImage),
      ImageFormatGroup.bgra8888 => convertBGRA8888ToImage(cameraImage),
      ImageFormatGroup.jpeg => throw Exception("JPEG not supported"),
      ImageFormatGroup.nv21 => throw Exception("NV21 not supported"),
      ImageFormatGroup.unknown => throw Exception("Unknown Image Format Group"),
    };
  }

  /// Converts a [CameraImage] in BGRA888 format to [Image] in RGB format
  static image_lib.Image convertBGRA8888ToImage(CameraImage cameraImage) {
    final plane = cameraImage.planes[0];

    // Calculate the number of pixels
    int numPixels = cameraImage.width * cameraImage.height;

    // Create a Float32List for the RGB image without the alpha channel
    Float32List floatList = Float32List(numPixels * 3); // 3 channels (RGB)

    // Populate the floatList by ignoring the alpha channel
    for (int i = 0, j = 0; i < plane.bytes.length; i += 4) {
      floatList[j++] = plane.bytes[i] / 255.0; // Red
      floatList[j++] = plane.bytes[i + 1] / 255.0; // Green
      floatList[j++] = plane.bytes[i + 2] / 255.0; // Blue
      // Skip alpha (i + 3)
    }

    // Determine the rowStride for the float32 image
    int floatRowStride = plane.bytesPerRow * 3; // Adjust for float32 bytes

    final img = image_lib.Image.fromBytes(
      width: cameraImage.width,
      height: cameraImage.height,
      bytes: floatList.buffer,
      rowStride: floatRowStride,
      // bytesOffset: IOS_BYTES_OFFSET,
      order: image_lib.ChannelOrder.rgb,
      format: image_lib.Format.float32,
    );
    return image_lib.copyResize(img,
        width: 256, height: 256, interpolation: image_lib.Interpolation.linear);
  }

  /// Converts a [CameraImage] in YUV420 format to [image_lib.Image] in RGB format
  static image_lib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = image_lib.Image(width: imageWidth, height: imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }

    return image;
  }

  // /// Convert a single YUV pixel to RGB
  // static int yuv2rgb(int y, int u, int v) {
  //   // Convert yuv pixel to rgb
  //   var r = (y + v * 1436 / 1024 - 179).round();
  //   var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
  //   var b = (y + u * 1814 / 1024 - 227).round();

  //   // Clipping RGB values to be inside boundaries [ 0 , 255 ]
  //   r = r.clamp(0, 255);
  //   g = g.clamp(0, 255);
  //   b = b.clamp(0, 255);

  //   return 0xff000000 |
  //       ((b << 16) & 0xff0000) |
  //       ((g << 8) & 0xff00) |
  //       (r & 0xff);
  // }

  /// Convert a [Image] to PNG
  static Future<List<int>> convert({required CameraImage image}) async {
    //final responsePort = ReceivePort();

    final encodedImage = Isolate.run(
        () => image_lib.encodePng(ImageUtils.convertCameraImage(image)));
    // isolateUtils.sendMessage(
    //   handler: toPng,
    //   params: {
    //     'image': image,
    //   },
    //   sendPort: isolateUtils.sendPort,
    //   responsePort: responsePort,
    // );

    return await encodedImage;
  }
}
