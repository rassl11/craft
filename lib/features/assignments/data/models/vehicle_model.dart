import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required int id,
    required String manufacturer,
    required String model,
    required String registrationNumber,
    required String licensePlate,
    required String icon,
  }) : super(
          id: id,
          manufacturer: manufacturer,
          model: model,
          registrationNumber: registrationNumber,
          licensePlate: licensePlate,
          icon: icon,
        );

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int? ?? 0,
      manufacturer: json['manufacturer'] as String? ?? '',
      model: json['model'] as String? ?? '',
      registrationNumber: json['registration_number'] as String? ?? '',
      licensePlate: json['license_plate'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}
