import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signature_state.dart';

class SignatureCubit extends Cubit<SignatureCubitState> {
  SignatureCubit() : super(Initial());

  void startDrawing() {
    emit(DrawingStarted());
  }

  void stopDrawing() {
    emit(DrawingStopped());
  }

  void clear() {
    emit(Initial());
  }
}
