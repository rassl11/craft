import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final int id;
  final String manufacturer;
  final String model;
  final String registrationNumber; //registration_number
  final String licensePlate; //license_plate
  final String icon;

  const Vehicle({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.registrationNumber,
    required this.licensePlate,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        manufacturer,
        model,
        registrationNumber,
        licensePlate,
        icon,
      ];
}
