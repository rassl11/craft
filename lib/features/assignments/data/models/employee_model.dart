import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required int id,
    required int pictureId,
    required int groupId,
    required String firstName,
    required String lastName,
    required String email,
    required String number,
    required String color,
    required EmployeePicture? picture,
  }) : super(
          id: id,
          pictureId: pictureId,
          groupId: groupId,
          firstName: firstName,
          lastName: lastName,
          email: email,
          number: number,
          color: color,
          picture: picture,
        );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as int,
      pictureId: json['picture_id'] as int? ?? 0,
      groupId: json['group_id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      number: json['number'] as String? ?? '',
      color: json['color'] as String? ?? '',
      picture: json['picture'] != null
          ? EmployeePictureModel.fromJson(
              json['picture'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class EmployeePictureModel extends EmployeePicture {
  const EmployeePictureModel({
    required int id,
    required String thumbUrl,
  }) : super(
          id: id,
          thumbUrl: thumbUrl,
        );

  factory EmployeePictureModel.fromJson(Map<String, dynamic> json) {
    return EmployeePictureModel(
      id: json['id'] as int,
      thumbUrl: json['thumb_url'] as String? ?? '',
    );
  }
}
