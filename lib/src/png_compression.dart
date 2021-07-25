/// The PNG compression level
enum PngCompression {
  defaultCompression,
  bestCompression,
  bestSpeed,
  noCompression
}

extension PngCompressionExtension on PngCompression {
  /// The level of PNG compression
  int get level {
    switch (this) {
      case PngCompression.bestCompression:
        return 9;
      case PngCompression.defaultCompression:
        return 6;
      case PngCompression.bestSpeed:
        return 1;
      case PngCompression.noCompression:
        return 0;
    }
  }
}
