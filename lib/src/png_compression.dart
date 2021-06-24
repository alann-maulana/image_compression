const int DEFAULT_COMPRESSION = 6;
const int BEST_COMPRESSION = 9;
const int BEST_SPEED = 1;
const int NO_COMPRESSION = 0;

class PngCompression {
  const PngCompression._(this.level);

  final int level;

  static const PngCompression defaultCompression = PngCompression._(6);
  static const PngCompression bestCompression = PngCompression._(9);
  static const PngCompression bestSpeed = PngCompression._(1);
  static const PngCompression noCompression = PngCompression._(0);
}
