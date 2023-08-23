part of 'bottom_bar_bloc.dart';

class BottomBarState extends Equatable {
  final ActiveTab activeTab;

  const BottomBarState({this.activeTab = ActiveTab.assignments});

  @override
  List<Object> get props => [activeTab];
}
