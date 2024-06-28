int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r"\s+")).length;
  const int speed = 225;

  final readingTime = wordCount / speed;

  return readingTime.ceil();
}
