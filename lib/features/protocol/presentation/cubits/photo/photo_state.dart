import 'package:equatable/equatable.dart';

import '../../../../../core/blocs/status.dart';

class PhotoState extends Equatable {
  final List<String> photosPath;
  final List<String> hints;
  final int selectedImageIndex;
  final Status cubitStatus;
  final bool hasChanges;

  const PhotoState({
    required this.photosPath,
    required this.hints,
    this.selectedImageIndex = 0,
    this.cubitStatus = Status.initial,
    this.hasChanges = false,
  });

  @override
  List<Object?> get props => [
    photosPath,
    hints,
    selectedImageIndex,
    cubitStatus,
    hasChanges,
  ];

  PhotoState copyWith({
    List<String>? photosPath,
    List<String>? hints,
    int? selectedImageIndex,
    Status? cubitStatus,
    bool? hasChanges,
  }) {
    return PhotoState(
      photosPath: photosPath ?? this.photosPath,
      hints: hints ?? this.hints,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      cubitStatus: cubitStatus ?? this.cubitStatus,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}
