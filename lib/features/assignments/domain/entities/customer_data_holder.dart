import 'package:equatable/equatable.dart';

class CustomerDataHolder extends Equatable {
  final CustomerAddress data;

  const CustomerDataHolder({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

class CustomerAddress extends Equatable {
  final int id;
  final int customerId; //customer_id
  final String? lat;
  final String? lng;
  final String? name;
  final String? fullAddress; //full_address
  final String street;
  final String? streetAddon; //street_addon
  final String zip;
  final String city;
  final String? province;
  final String country;
  final String? phone;
  final String? mobile;
  final String? mail;

  const CustomerAddress({
    required this.id,
    required this.customerId,
    required this.lat,
    required this.lng,
    required this.name,
    required this.fullAddress,
    required this.street,
    required this.streetAddon,
    required this.zip,
    required this.city,
    required this.province,
    required this.country,
    required this.phone,
    required this.mobile,
    required this.mail,
  });

  @override
  List<Object?> get props => [
        id,
        customerId,
        lat,
        lng,
        name,
        fullAddress,
        street,
        streetAddon,
        zip,
        city,
        province,
        country,
        phone,
        mobile,
        mail,
      ];
}
