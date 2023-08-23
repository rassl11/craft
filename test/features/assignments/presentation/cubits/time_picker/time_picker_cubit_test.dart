import 'package:bloc_test/bloc_test.dart';
import 'package:share/core/utils/date_utils.dart';
import 'package:share/features/assignments/presentation/cubits/time_picker/time_picker_cubit.dart';

void main() {
  final Map<TimeRecordType, TimePickerTime?> timeRecords = {
    TimeRecordType.timeSpent: const TimePickerTime(
      duration: Duration(minutes: 2),
      humanReadableTime: '0h 2m',
    ),
    TimeRecordType.breakTime: null,
    TimeRecordType.drivingTime: null,
  };

  blocTest<TimePickerCubit, TimePickerState>(
    'should emit state with a new record',
    act: (cubit) => cubit.updateTimeRecord(
      TimeRecordType.timeSpent,
      const Duration(minutes: 2),
      '0h 2m',
    ),
    build: TimePickerCubit.new,
    expect: () => <TimePickerState>[
      TimePickerState(timeRecords: timeRecords),
    ],
  );

  blocTest<TimePickerCubit, TimePickerState>(
    'should emit state with attachment if updateAttachment() was called',
    act: (cubit) => cubit.updateAttachment('attachment'),
    build: TimePickerCubit.new,
    expect: () => <TimePickerState>[
      const TimePickerState(attachment: 'attachment'),
    ],
  );
}
