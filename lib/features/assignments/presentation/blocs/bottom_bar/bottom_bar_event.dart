part of 'bottom_bar_bloc.dart';

abstract class BottomBarEvent extends Equatable {
  const BottomBarEvent();

  @override
  List<Object?> get props => [];
}

class BottomBarTabChanged extends BottomBarEvent {
  final ActiveTab activeTab;

  const BottomBarTabChanged({required this.activeTab});

  @override
  List<Object?> get props => [activeTab];
}
