import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:share/features/assignments/data/models/assignments_data_holder_model.dart';
import 'package:share/features/assignments/data/models/creation_model.dart';
import 'package:share/features/assignments/data/models/customer_data_holder_model.dart';
import 'package:share/features/assignments/data/models/document_model.dart';
import 'package:share/features/assignments/data/models/employee_model.dart';
import 'package:share/features/assignments/data/models/project_model.dart';
import 'package:share/features/assignments/data/models/tag_model.dart';
import 'package:share/features/assignments/data/models/tool_model.dart';
import 'package:share/features/assignments/data/models/vehicle_model.dart';
import 'package:share/features/assignments/domain/entities/assignments_data_holder.dart';
import 'package:share/features/assignments/domain/entities/document.dart';

import '../../../../fixtures/fixture_reader.dart';

final assignmentModel = AssignmentModel(
  id: 1249060,
  projectId: 537269,
  customerAddressId: 2449,
  isAllDay: false,
  title: 'Fix the door',
  state: OriginalAssignmentState.unplanned,
  start: null,
  end: null,
  createdAt: DateTime.parse('2023-05-08T15:18:21.000000Z'),
  updatedAt: DateTime.parse('2023-05-18T09:55:31.000000Z'),
  customerAddress: const CustomerAddressModel(
    city: 'Hamburg',
    country: 'DE',
    customerId: 2050,
    fullAddress: 'test, Fuhlsbüttlerstr, 22309 Hamburg',
    id: 2449,
    lat: '53.6097700000',
    lng: '10.0504490000',
    mail: 'info@craftb-oxx.de',
    mobile: '',
    name: 'test',
    phone: '',
    province: 'Hamburg',
    street: 'Fuhlsbüttlerstr',
    streetAddon: '405',
    zip: '22309',
  ),
  tags: [
    TagModel(
        id: 9,
        name: 'JoJo',
        color: '#4169E1',
        icon: 'fa-tag',
        createdAt: DateTime.parse('2020-06-01T08:17:29.000000Z'),
        updatedAt: DateTime.parse('2020-06-18T10:13:28.000000Z')),
  ],
  description: 'instruct: Fix the door',
  internalNote: 'Important hint',
  employees: const [
    EmployeeModel(
      id: 114280,
      pictureId: 0,
      groupId: 2154,
      firstName: 'Denys',
      lastName: 'Denys',
      email: 'ddd@gmail.com',
      number: '',
      color: '#000000',
      picture: null,
    )
  ],
  tools: const [
    ToolModel(
      id: 63,
      manufacturer: 'Testtool',
      model: '1',
      icon: 'fa-wrench',
    )
  ],
  vehicles: const [
    VehicleModel(
      id: 175,
      manufacturer: 'Daewoo',
      model: 'Lanos',
      registrationNumber: 'dddd2f22gg55h55j5j',
      icon: 'fa-truck',
      licensePlate: 'CA0133BA',
    )
  ],
  documents: const [
    DocumentModel(
      id: 4666,
      uploadId: 30124,
      title: 'Animals',
      icon: 'fa-file-pdf',
      picture: PictureModel(
        id: 30124,
        fileSize: 40139374,
        fileOriginalName: 'Illustrated Encyclopedia of Dinosaurs and '
            'Prehistoric Animals.pdf',
        fileName: 'be91308d26a05c2e80e11f78873a55ac.pdf',
        fileMimeType: 'application/pdf',
        fileType: FileType.pdf,
        thumbUrl:
            'https://s3-de-central.profitbricks.com/craftboxx-prod/public/228/documents/4666/be91308d26a05c2e80e11f78873a55ac-thumb.jpg',
        fileUrl:
            'https://s3-de-central.profitbricks.com/craftboxx-prod/public/228/documents/4666/be91308d26a05c2e80e11f78873a55ac.pdf',
        icon: 'fa-file-pdf',
        mediumUrl:
            'https://s3-de-central.profitbricks.com/craftboxx-prod/public/228/documents/4666/be91308d26a05c2e80e11f78873a55ac-medium.jpg',
      ),
    )
  ],
  project: const ProjectModel(
    id: 537269,
    title: 'This is a test project',
  ),
  creation: const CreationModel(
    causer: CauserModel(
      id: 50340,
      firstName: 'Ivan',
      lastName: 'Ivan',
    ),
  ),
  duration: 0,
  timeSpent: 0,
  breakTime: 0,
  drivingTime: 0,
  documentations: const [],
  articles: null,
);

void main() {
  final tAssignmentsDataHolderModel = AssignmentsDataHolderModel(
    data: [
      assignmentModel,
    ],
  );

  test('should be subclass of AssignmentsDataHolder entity', () async {
    // assert
    expect(tAssignmentsDataHolderModel, isA<AssignmentsListHolder>());
  });

  group('fromJson', () {
    test('should return a valid AssignmentsDataHolderModel', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('assignments/assignments.json'))
              as Map<String, dynamic>;
      // act
      final result = AssignmentsDataHolderModel.fromJson(jsonMap);
      // assert
      expect(result, tAssignmentsDataHolderModel);
    });
  });
}
