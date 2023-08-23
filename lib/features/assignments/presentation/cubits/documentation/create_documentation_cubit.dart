import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/utils/date_utils.dart';
import '../../../../../core/utils/failure_helper.dart';
import '../../../domain/usecases/documentation/create_time_documentation.dart';
import '../time_picker/time_picker_cubit.dart';

part 'create_documentation_state.dart';

class CreateDocumentationCubit extends Cubit<CreateDocumentationState> {
  final CreateTimeDocumentation _createTimeDocumentation;

  CreateDocumentationCubit({
    required CreateTimeDocumentation createTimeDocumentation,
  })  : _createTimeDocumentation = createTimeDocumentation,
        super(const CreateDocumentationState());

  Future<void> createDocumentation({
    required int assignmentId,
    required Map<TimeRecordType, TimePickerTime?> timeRecords,
    required String title,
    required String attachment,
  }) async {
    if (_isNoFilledFields(timeRecords)) {
      emit(state.copyWith(noFilledFields: true));
      return;
    }

    emit(state.copyWith(blocStatus: Status.loading));

    final recordedWorkingTime = timeRecords[TimeRecordType.timeSpent];
    final recordedBreakTime = timeRecords[TimeRecordType.breakTime];
    final recordedDrivingTime = timeRecords[TimeRecordType.drivingTime];
    final result = await _createTimeDocumentation(
      CreateTimeDocumentationParams(
        assignmentId: assignmentId,
        workingTime: recordedWorkingTime?.duration.inMinutes ?? 0,
        breakTime: recordedBreakTime?.duration.inMinutes ?? 0,
        drivingTime: recordedDrivingTime?.duration.inMinutes ?? 0,
        description: attachment,
        title: title,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          blocStatus: Status.error,
          errorMsg: mapFailureToMessage(failure),
        ),
      ),
      (data) => emit(
        state.copyWith(
          blocStatus: Status.loaded,
        ),
      ),
    );
  }

  void resetFieldsErrors() {
    emit(state.copyWith(noFilledFields: false));
  }

  bool _isNoFilledFields(
    Map<TimeRecordType, TimePickerTime?> timeRecords,
  ) {
    bool noFilledFields = true;
    timeRecords.forEach((key, value) {
      if (value != null && value.duration.inMinutes > 0) {
        noFilledFields = false;
        return;
      }
    });
    return noFilledFields;
  }
}
