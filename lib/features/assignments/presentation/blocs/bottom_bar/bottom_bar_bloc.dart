import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../widgets/craftbox_bottom_bar.dart';

part 'bottom_bar_event.dart';
part 'bottom_bar_state.dart';

class BottomBarBloc extends Bloc<BottomBarEvent, BottomBarState> {
  BottomBarBloc() : super(const BottomBarState()) {
    on<BottomBarTabChanged>(_onBottomBarTabChanged);
  }

  void _onBottomBarTabChanged(
      BottomBarTabChanged event, Emitter<BottomBarState> emit) {
    emit(BottomBarState(activeTab: event.activeTab));
  }
}
