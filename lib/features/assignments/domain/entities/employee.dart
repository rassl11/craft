import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int id;
  final int pictureId; //picture_id
  final int groupId; //group_id
  final String firstName; //first_name
  final String lastName; //last_name
  final String email;
  final String number;
  final String color;
  final EmployeePicture? picture;

  const Employee({
    required this.id,
    required this.pictureId,
    required this.groupId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.number,
    required this.color,
    required this.picture,
  });

  @override
  List<Object?> get props => [
        id,
        pictureId,
        groupId,
        firstName,
        lastName,
        email,
        number,
        color,
        picture,
      ];
}

class EmployeePicture extends Equatable {
  final int id;
  final String thumbUrl; //thumb_url

  const EmployeePicture({
    required this.id,
    required this.thumbUrl,
  });

  @override
  List<Object?> get props => [id, thumbUrl];
}
