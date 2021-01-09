class Point {
  final String id;
  final String code;
  final double x;
  final double y;
  final int updatedAt;
  final int createdAt;

  Point({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.x,
    this.y,
    this.code,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json["id"],
      code: json["code"],
      x: json["x"] as double,
      y: json["y"] as double,
      createdAt: json["created_at"] as int,
      updatedAt: json["updated_at"] as int,
    );
  }

  Map<String, dynamic> pointToJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    if (id != null) map["id"] = id;

    map["code"] = code;
    map["x"] = x;
    map["y"] = y;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;

    return map;
  }
}
