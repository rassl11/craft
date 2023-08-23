import 'package:equatable/equatable.dart';

class CameraState extends Equatable {
  final List<String> localImages;
  final bool isRearCameraSelected;
  final bool isFlashEnabled;

  const CameraState({
    this.localImages = const [],
    this.isRearCameraSelected = true,
    this.isFlashEnabled = false,
  });

  @override
  List<Object?> get props => [
        localImages,
        isRearCameraSelected,
        isFlashEnabled,
      ];

  CameraState copyWith({
    List<String>? localImages,
    bool? isRearCameraSelected,
    bool? isFlashEnabled,
  }) {
    return CameraState(
      localImages: localImages ?? this.localImages,
      isRearCameraSelected: isRearCameraSelected ?? this.isRearCameraSelected,
      isFlashEnabled: isFlashEnabled ?? this.isFlashEnabled,
    );
  }
}
