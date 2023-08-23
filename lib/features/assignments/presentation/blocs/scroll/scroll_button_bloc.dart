import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scroll_button_event.dart';
part 'scroll_button_state.dart';

class ScrollBloc extends Bloc<ScrollViewEvent, ScrollState> {
  ScrollBloc() : super(ScrollStateInitial()) {
    on<ScrollViewEvent>((event, emit) {
      if (event is ViewScrolledForward) {
        emit(const ScrollButtonState(isVisible: true));
      } else if (event is ViewScrolledToStart) {
        emit(const ScrollButtonState(isVisible: false));
      } else if (event is ScrollUpRequested) {
        emit(ScrollUp());
      }
    });
  }
}
