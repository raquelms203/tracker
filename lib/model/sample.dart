class Sample {
  final String id;
  final String idPoint;
  final String parameter;
  final int date;
  final int createdAt;
  final int updatedAt;
  final double value;

  Sample(
      {this.createdAt,
      this.date,
      this.id,
      this.idPoint,
      this.parameter,
      this.updatedAt,
      this.value});

  factory Sample.fromJson(Map<String, dynamic> json) {
    return Sample(
        id: json["id"].toString(),
        idPoint: json["id_point"].toString(),
        date: json["date"] as int,
        createdAt: json["created_at"] as int,
        updatedAt: json["updated_at"] as int,
        parameter: json["parameter"],
        value: json["value"] as double);
  }

  Map<String, dynamic> sampleToJson() {
    Map<String, dynamic> map = Map<String, dynamic>();

    if (id != null) map["id"] = id;
    if (idPoint != null) map["id_point"] = idPoint;

    map["date"] = date;
    map["created_at"] = createdAt;
    map["updated_at"] = updatedAt;
    map["parameter"] = parameter;
    map["value"] = value;

    return map;
  }
}
