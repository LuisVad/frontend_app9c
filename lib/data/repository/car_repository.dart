import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car_model.dart';

class CarRepository {
  final String apiUrl = 'https://23vjrzc0zj.execute-api.us-east-1.amazonaws.com/Prod/vehiculos';

  Future<void> createCar(CarModel car) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': car.id, // Incluye el id en el JSON, si es necesario
        'dueño': car.owner,
        'marca': car.mark,
        'modelo': car.model,
        'autonomia': car.autonomy,
        'velocidadMaxima': car.topSpeed,
        'caballosDeFuerza': car.horsePower,
      }),
    );

    if (response.statusCode != 201) { // 201 Created es el código de éxito para creación
      throw Exception('Failed to create car: ${response.body}');
    }
  }

  Future<void> updateCar(CarModel car) async {
    if (car.id == null) {
      throw Exception('Car id is required for update');
    }
    final response = await http.put(
      Uri.parse('$apiUrl/${car.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'dueño': car.owner,
        'marca': car.mark,
        'modelo': car.model,
        'autonomia': car.autonomy,
        'velocidadMaxima': car.topSpeed,
        'caballosDeFuerza': car.horsePower,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update car: ${response.body}');
    }
  }

  Future<void> deleteCar(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete car: ${response.body}');
    }
  }

  Future<List<CarModel>> getAllCars() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((carData) => CarModel.fromJson(carData)).toList();
    } else {
      throw Exception('Failed to load cars: ${response.body}');
    }
  }
}
