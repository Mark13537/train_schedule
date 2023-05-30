class LayoutHelper {
  double width;
  double height;
  double fontSize;
  double titleFontSize;
  double appBarTitleSize;

  static LayoutHelper? _instance;

  factory LayoutHelper({
    double width = 0,
    double height = 0,
    double fontSize = 0,
    double titleFontSize = 0,
    double appBarTitleSize = 0,
  }) {
    _instance = LayoutHelper._internal(
        width, height, fontSize, titleFontSize, appBarTitleSize);
    return _instance!;
  }

  LayoutHelper._internal(this.width, this.height, this.fontSize,
      this.titleFontSize, this.appBarTitleSize);

  static LayoutHelper get instance {
    return _instance!;
  }
}
