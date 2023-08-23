import '../../domain/entities/customer_data_holder.dart';

class CustomerDataHolderModel extends CustomerDataHolder {
  const CustomerDataHolderModel({
    required CustomerAddressModel data,
  }) : super(data: data);

  factory CustomerDataHolderModel.fromJson(Map<String, dynamic> json) {
    return CustomerDataHolderModel(
      data: CustomerAddressModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': (data as CustomerAddressModel).toJson(),
    };
  }
}

class CustomerAddressModel extends CustomerAddress {
  const CustomerAddressModel({
    required int id,
    required int customerId, //customer_id
    required String? lat,
    required String? lng,
    required String? name,
    required String? fullAddress, //full_address
    required String street,
    required String? streetAddon, //street_addon
    required String zip,
    required String city,
    required String? province,
    required String country,
    required String? phone,
    required String? mobile,
    required String? mail,
  }) : super(
          id: id,
          customerId: customerId,
          lat: lat,
          lng: lng,
          name: name,
          fullAddress: fullAddress,
          street: street,
          streetAddon: streetAddon,
          zip: zip,
          city: city,
          province: province,
          country: country,
          phone: phone,
          mobile: mobile,
          mail: mail,
        );

  factory CustomerAddressModel.fromJson(Map<String, dynamic> json) {
    return CustomerAddressModel(
      id: json['id'] as int,
      customerId: json['customer_id'] as int,
      lat: json['lat'] as String? ?? '',
      lng: json['lng'] as String? ?? '',
      name: json['name'] as String? ?? '',
      fullAddress: json['full_address'] as String? ?? '',
      street: json['street'] as String,
      streetAddon: json['street_addon'] as String? ?? '',
      zip: json['zip'] as String,
      city: json['city'] as String,
      province: json['province'] as String? ?? '',
      country: json['country'] as String,
      phone: json['phone'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      mail: json['mail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'lat': lat,
      'lng': lng,
      'name': name,
      'full_address': fullAddress,
      'street': street,
      'street_addon': streetAddon,
      'zip': zip,
      'city': city,
      'province': province,
      'country': country,
      'phone': phone,
      'mobile': mobile,
      'mail': mail,
    };
  }
}
