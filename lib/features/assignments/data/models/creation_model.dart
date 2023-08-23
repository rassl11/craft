import '../../domain/entities/creation.dart';

class CreationModel extends Creation {
  const CreationModel({required CauserModel causer}) : super(causer: causer);

  factory CreationModel.fromJson(Map<String, dynamic> json) {
    return CreationModel(
      causer: CauserModel.fromJson(json['causer'] as Map<String, dynamic>),
    );
  }
}

class CauserModel extends Causer {
  const CauserModel({
    required int id,
    required String firstName,
    required String lastName,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
        );

  factory CauserModel.fromJson(Map<String, dynamic> json) {
    return CauserModel(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
    );
  }
}
