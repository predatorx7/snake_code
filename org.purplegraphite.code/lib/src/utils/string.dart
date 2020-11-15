class StringUtils {
  static String toFirstLetterUppercase(String word) {
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }
}
