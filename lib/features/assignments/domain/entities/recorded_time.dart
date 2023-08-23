import 'package:equatable/equatable.dart';

class RecordedTime extends Equatable {
  final int workingTime;
  final int breakTime;
  final int drivingTime;

  const RecordedTime({
    this.workingTime = 0,
    this.breakTime = 0,
    this.drivingTime = 0,
  });

  bool get isNotEmpty => workingTime != 0;

  @override
  List<Object?> get props => [
        workingTime,
        breakTime,
        drivingTime,
      ];
}
