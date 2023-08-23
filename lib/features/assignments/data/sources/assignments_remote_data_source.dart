import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/shared_prefs.dart';
import '../../../../core/sources/base_remote_data_source.dart';
import '../../../../core/utils/assignments_utils.dart';
import '../models/assignments_data_holder_model.dart';
import '../models/customer_data_holder_model.dart';

abstract class AssignmentsRemoteDataSource {
  Future<AssignmentsDataHolderModel> getAssignments({String? withRelation});

  Future<CustomerDataHolderModel> getCustomerBy({required int addressId});

  Future<SingleAssignmentDataHolderModel> getDetailedAssignment({
    required int assignmentId,
  });

  Future<SingleAssignmentDataHolderModel> putAssignmentState({
    required int assignmentId,
    required InAppAssignmentState stateToBeSet,
  });
}

class AssignmentsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AssignmentsRemoteDataSource {
  final http.Client _client;

  AssignmentsRemoteDataSourceImpl({
    required http.Client client,
    required SharedPrefs sharedPrefs,
    required PackageInfo packageInfo,
  })  : _client = client,
        super(
          sharedPrefs: sharedPrefs,
          packageInfo: packageInfo,
        );

  @override
  Future<AssignmentsDataHolderModel> getAssignments({
    String? withRelation,
  }) async {
    final withParameter = withRelation != null ? '?with[]=$withRelation' : '';
    final response = await _client.get(
      Uri.parse('$baseUrl/assignments$withParameter'),
      headers: getHeaders(),
    );

    return AssignmentsDataHolderModel.fromJson(handleResponse(response));
  }

  @override
  Future<CustomerDataHolderModel> getCustomerBy(
      {required int addressId}) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/customers/addresses/$addressId'),
      headers: getHeaders(),
    );

    return CustomerDataHolderModel.fromJson(handleResponse(response));
  }

  @override
  Future<SingleAssignmentDataHolderModel> getDetailedAssignment({
    required int assignmentId,
  }) async {
    const String parameters = '''
    with[]=customer_address&
    with[]=employees&
    with[]=tools&
    with[]=vehicles&
    with[]=documentations&
    with[]=documentations.upload&
    with[]=documents&
    with[]=articles
    ''';
    final response = await _client.get(
      Uri.parse('$baseUrl/assignments/$assignmentId?$parameters'),
      headers: getHeaders(),
    );

    return SingleAssignmentDataHolderModel.fromJson(handleResponse(response));
  }

  @override
  Future<SingleAssignmentDataHolderModel> putAssignmentState({
    required int assignmentId,
    required InAppAssignmentState stateToBeSet,
  }) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/assignments/$assignmentId'),
      headers: getHeaders(),
      body: json.encode({
        'state': stateToBeSet.originalAssignmentState.originalValue,
      }),
    );

    return SingleAssignmentDataHolderModel.fromJson(handleResponse(response));
  }
}
