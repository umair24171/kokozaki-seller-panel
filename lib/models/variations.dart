class Variations {
  final String size;
  final String color;

  Variations({required this.size, required this.color});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'size': size,
      'color': color,
    };
  }

  factory Variations.fromMap(Map<String, dynamic> map) {
    return Variations(
      size: map['size'] ?? '',
      color: map['color'] ?? '',
    );
  }
}
