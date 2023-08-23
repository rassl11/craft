import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/date_utils.dart';

part 'time_picker_state.dart';

class TimePickerCubit extends Cubit<TimePickerState> {
  TimePickerCubit() : super(const TimePickerState());

  void updateTimeRecord(
    TimeRecordType type,
    Duration duration,
    String humanReadableTime,
  ) {
    final Map<TimeRecordType, TimePickerTime?> timeRecords = {
      ...state.timeRecords,
    };
    timeRecords[type] = TimePickerTime(
      duration: duration,
      humanReadableTime: humanReadableTime,
    );
    emit(state.copyWith(timeRecords: timeRecords));
  }

  void updateAttachment(String attachment) {
    emit(state.copyWith(attachment: attachment));
  }
}

class TimePickerTime extends Equatable {
  final Duration duration;
  final String humanReadableTime;

  const TimePickerTime({
    required this.duration,
    required this.humanReadableTime,
  });

  @override
  List<Object?> get props => [duration, humanReadableTime];
}
