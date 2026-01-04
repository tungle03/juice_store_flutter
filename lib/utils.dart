String formatPrice(int value) {
  // format kiểu 45000 -> 45.000 đ
  final s = value.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final reverseIndex = s.length - i;
    buf.write(s[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buf.write('.');
    }
  }
  return '${buf.toString()} đ';
}
