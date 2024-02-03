class Variations {
  final List<String> size;
  final List<String> color;

  Variations({required this.size, required this.color});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'size': size,
      'color': color,
    };
  }

  factory Variations.fromMap(Map<String, dynamic> map) {
    return Variations(
      size: List<String>.from(map['size']),
      color: List<String>.from(map['color']),
    );
  }
}
