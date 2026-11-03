class BoardPos {
  final int x;
  final int y;
  final int z;

  const BoardPos(this.x, this.y, this.z);

  @override
  bool operator ==(Object other) =>
      other is BoardPos && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() => 'BoardPos($x, $y, $z)';
}

List<BoardPos> turtleLayout() {
  final positions = <BoardPos>[];
  void row(int z, int y, int xStart, int xEnd) {
    for (var x = xStart; x <= xEnd; x += 2) {
      positions.add(BoardPos(x, y, z));
    }
  }

  row(0, 0, 6, 26);
  row(0, 1, 4, 28);
  row(0, 2, 2, 30);
  row(0, 3, 0, 32);
  row(0, 4, 0, 32);
  row(0, 5, 2, 30);
  row(0, 6, 4, 28);
  row(0, 7, 6, 26);

  for (var y = 2; y <= 5; y++) {
    row(1, y, 10, 22);
  }

  row(2, 3, 14, 16);
  row(2, 4, 14, 16);

  return positions;
}
