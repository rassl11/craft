import '../../domain/entities/author.dart';

class AuthorModel extends Author {
  const AuthorModel({
    required int id,
    required String firstName,
    required String lastName,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
        );

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
    );
  }
}
