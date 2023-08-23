part of 'scroll_button_bloc.dart';

abstract class ScrollState extends Equatable {
  const ScrollState();
}

class ScrollStateInitial extends ScrollState {
  @override
  List<Object?> get props => [];
}

class ScrollButtonState extends ScrollState {
  final bool isVisible;

  const ScrollButtonState({required this.isVisible});

  @override
  List<Object?> get props => [isVisible];
}

class ScrollUp extends ScrollState {
  @override
  List<Object?> get props => [];
}
