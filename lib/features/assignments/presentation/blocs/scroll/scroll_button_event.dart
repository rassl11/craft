part of 'scroll_button_bloc.dart';

abstract class ScrollViewEvent extends Equatable {
  const ScrollViewEvent();
}

class ViewScrolledForward extends ScrollViewEvent {
  @override
  List<Object?> get props => [];
}

class ViewScrolledToStart extends ScrollViewEvent {
  @override
  List<Object?> get props => [];
}

class ScrollUpRequested extends ScrollViewEvent {
  @override
  List<Object?> get props => [];
}
