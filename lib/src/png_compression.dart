const int DEFAULT_COMPRESSION = 6;
const int BEST_COMPRESSION = 9;
const int BEST_SPEED = 1;
const int NO_COMPRESSION = 0;

enum PngCompression {
  defaultCompression,
  bestCompression,
  bestSpeed,
  noCompression
}

extension PngCompressionExtension on PngCompression {
  int get level {
    switch (this) {
      case PngCompression.defaultCompression:
        return DEFAULT_COMPRESSION;
      case PngCompression.bestCompression:
        return BEST_COMPRESSION;
      case PngCompression.bestSpeed:
        return BEST_SPEED;
      case PngCompression.noCompression:
        return NO_COMPRESSION;
    }
  }
}
