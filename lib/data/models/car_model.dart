class CarModel {
  final String? id;
  final String owner;
  final String mark;
  final String model;
  final double autonomy;
  final double topSpeed;
  final double horsePower;

  CarModel({
    this.id,
    required this.owner,
    required this.mark,
    required this.model,
    required this.autonomy,
    required this.topSpeed,
    required this.horsePower,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      owner: json['dueño'],
      mark: json['marca'],
      model: json['modelo'],
      autonomy: json['autonomia'].toDouble(),
      topSpeed: json['velocidadMaxima'].toDouble(),
      horsePower: json['caballosDeFuerza'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dueño': owner,
      'marca': mark,
      'modelo': model,
      'autonomia': autonomy,
      'velocidadMaxima': topSpeed,
      'caballosDeFuerza': horsePower,
    };
  }
}
