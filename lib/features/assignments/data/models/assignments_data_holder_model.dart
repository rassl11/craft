import '../../domain/entities/assignments_data_holder.dart';
import '../../domain/entities/customer_data_holder.dart';
import 'article_model.dart';
import 'creation_model.dart';
import 'customer_data_holder_model.dart';
import 'document_model.dart';
import 'documentation_model.dart';
import 'employee_model.dart';
import 'project_model.dart';
import 'tag_model.dart';
import 'tool_model.dart';
import 'vehicle_model.dart';

class AssignmentsDataHolderModel extends AssignmentsListHolder {
  const AssignmentsDataHolderModel({
    required List<AssignmentModel> data,
  }) : super(data: data);

  factory AssignmentsDataHolderModel.fromJson(Map<String, dynamic> json) {
    return AssignmentsDataHolderModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SingleAssignmentDataHolderModel extends SingleAssignmentHolder {
  const SingleAssignmentDataHolderModel({
    required AssignmentModel data,
  }) : super(data: data);

  factory SingleAssignmentDataHolderModel.fromJson(Map<String, dynamic> json) {
    return SingleAssignmentDataHolderModel(
      data: AssignmentModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class AssignmentModel extends Assignment {
  const AssignmentModel({
    required int id,
    required int projectId,
    required int customerAddressId,
    required int duration,
    required int timeSpent,
    required int breakTime,
    required int drivingTime,
    required bool? isAllDay,
    required String title,
    required String description,
    required String internalNote,
    required OriginalAssignmentState state,
    required DateTime? start,
    required DateTime? end,
    required DateTime createdAt,
    required DateTime updatedAt,
    required CustomerAddress? customerAddress,
    required List<TagModel> tags,
    required List<EmployeeModel>? employees,
    required List<ToolModel>? tools,
    required List<VehicleModel>? vehicles,
    required List<DocumentModel>? documents,
    required List<DocumentationModel> documentations,
    required ProjectModel? project,
    required CreationModel? creation,
    required List<ArticleModel>? articles,
  }) : super(
    id: id,
          projectId: projectId,
          customerAddressId: customerAddressId,
          duration: duration,
          timeSpent: timeSpent,
          breakTime: breakTime,
          drivingTime: drivingTime,
          isAllDay: isAllDay,
          title: title,
          description: description,
          internalNote: internalNote,
          state: state,
          start: start,
          end: end,
          createdAt: createdAt,
          updatedAt: updatedAt,
          customerAddress: customerAddress,
          tags: tags,
          employees: employees,
          tools: tools,
          vehicles: vehicles,
          documents: documents,
          documentations: documentations,
          project: project,
          creation: creation,
          articles: articles,
        );

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      customerAddressId: json['customer_address_id'] as int,
      duration: json['duration'] as int? ?? 0,
      timeSpent: json['time_spent'] as int? ?? 0,
      breakTime: json['break_time'] as int? ?? 0,
      drivingTime: json['driving_time'] as int? ?? 0,
      isAllDay: json['all_day'] as bool? ?? false,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      internalNote: json['internal_info'] as String? ?? '',
      state: OriginalAssignmentState.values.firstWhere(
        (state) {
          final stateValue = (json['state'] as String).toLowerCase();
          if (stateValue == 'in_progress') {
            return state == OriginalAssignmentState.inProgress;
          }

          return state.name == stateValue;
        },
      ),
      start: DateTime.tryParse(json['start'] as String? ?? ''),
      end: DateTime.tryParse(json['end'] as String? ?? ''),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      customerAddress: json['customer_address'] != null
          ? CustomerAddressModel.fromJson(
              json['customer_address'] as Map<String, dynamic>,
            )
          : null,
      tags: (json['tags'] as List<dynamic>?)?.map((e) {
        return TagModel.fromJson(e as Map<String, dynamic>);
      }).toList() ?? List.empty(),
      employees: (json['employees'] as List<dynamic>?)?.map((e) {
        return EmployeeModel.fromJson(e as Map<String, dynamic>);
      }).toList(),
      tools: (json['tools'] as List<dynamic>?)?.map((e) {
        return ToolModel.fromJson(e as Map<String, dynamic>);
      }).toList(),
      vehicles: (json['vehicles'] as List<dynamic>?)?.map((e) {
        return VehicleModel.fromJson(e as Map<String, dynamic>);
      }).toList(),
      documents: (json['documents'] as List<dynamic>?)?.map((e) {
        return DocumentModel.fromJson(e as Map<String, dynamic>);
      }).toList(),
      documentations: (json['documentations'] as List<dynamic>?)?.map((e) {
        return DocumentationModel.fromJson(e as Map<String, dynamic>);
      }).toList() ?? List.empty(),
      project: json['project'] != null
          ? ProjectModel.fromJson(json['project'] as Map<String, dynamic>)
          : null,
      creation: json['creation'] != null
          ? CreationModel.fromJson(json['creation'] as Map<String, dynamic>)
          : null,
      articles: (json['articles'] as List<dynamic>?)?.map((e) {
        return ArticleModel.fromJson(e as Map<String, dynamic>);
      }).toList(),
    );
  }
}
