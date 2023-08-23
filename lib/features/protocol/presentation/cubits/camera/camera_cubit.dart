import 'package:bloc/bloc.dart';
import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraState());

  void addImages(
    Iterable<String> images,
  ) {
    emit(state.copyWith(
        localImages: List.from(state.localImages)..addAll(images)));
  }

  void changeFlashState() {
    emit(state.copyWith(isFlashEnabled: !state.isFlashEnabled));
  }

  void changeCameraState() {
    emit(state.copyWith(isRearCameraSelected: !state.isRearCameraSelected));
  }
}
