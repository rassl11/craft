part of 'time_picker_cubit.dart';

class TimePickerState extends Equatable {
  final String attachment;
  final Map<TimeRecordType, TimePickerTime?> timeRecords;

  const TimePickerState({
    this.attachment = '',
    this.timeRecords = const {
      TimeRecordType.timeSpent: null,
      TimeRecordType.breakTime: null,
      TimeRecordType.drivingTime: null,
    },
  });

  @override
  List<Object?> get props => [attachment, timeRecords];

  TimePickerState copyWith({
    String? attachment,
    Map<TimeRecordType, TimePickerTime?>? timeRecords,
  }) {
    return TimePickerState(
      attachment: attachment ?? this.attachment,
      timeRecords: timeRecords ?? this.timeRecords,
    );
  }
}
