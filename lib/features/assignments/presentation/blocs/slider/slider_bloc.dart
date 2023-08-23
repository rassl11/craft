import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../widgets/craftbox_slider.dart';

part 'slider_event.dart';
part 'slider_state.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  SliderBloc() : super(const SliderState()) {
    on<SliderSegmentChanged>(_onSliderSegmentChanged);
  }

  void _onSliderSegmentChanged(
      SliderSegmentChanged event, Emitter<SliderState> emit) {
    emit(SliderState(activeSegment: event.activeSegment));
  }
}
