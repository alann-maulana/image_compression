/// The PNG compression level
enum PngCompression {
  defaultCompression(6),
  bestCompression(9),
  bestSpeed(1),
  noCompression(0);

  const PngCompression(this.level);

  /// The level of PNG compression
  final int level;
}
