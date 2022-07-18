String durationToString(Duration duration) {
  return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}
