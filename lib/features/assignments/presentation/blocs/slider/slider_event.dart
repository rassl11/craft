part of 'slider_bloc.dart';

abstract class SliderEvent extends Equatable {
  const SliderEvent();
}

class SliderSegmentChanged extends SliderEvent {
  final ActiveSegment activeSegment;

  const SliderSegmentChanged({required this.activeSegment});

  @override
  List<Object?> get props => [activeSegment];
}
