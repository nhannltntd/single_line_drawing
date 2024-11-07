class Edge {
  final int startIndex;
  final int endIndex;

  Edge(this.startIndex, this.endIndex);

  Edge reversed() => Edge(endIndex, startIndex);

  String getKey() {
    int minIndex = startIndex < endIndex ? startIndex : endIndex;
    int maxIndex = startIndex > endIndex ? startIndex : endIndex;
    return '${minIndex}_$maxIndex';
  }

  @override
  bool operator ==(Object other) {
    if (other is Edge) {
      return (startIndex == other.startIndex && endIndex == other.endIndex) ||
          (startIndex == other.endIndex && endIndex == other.startIndex);
    }
    return false;
  }

  @override
  int get hashCode => startIndex.hashCode ^ endIndex.hashCode;
}
