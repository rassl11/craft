part of 'slider_bloc.dart';

class SliderState extends Equatable {
  final ActiveSegment activeSegment;

  const SliderState({this.activeSegment = ActiveSegment.past});

  @override
  List<Object> get props => [activeSegment];
}
