import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/repositories/authentication_repository.dart';
import '../../../../../core/utils/image_converter.dart';
import '../../../../assignments/domain/entities/documentation.dart';
import '../../../../assignments/domain/usecases/documentation/create_image_documentation.dart';
import '../../../../assignments/domain/usecases/documentation/delete_documentation.dart';
import 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final CreateImageDocumentation createImageDocumentation;
  final AuthenticationRepository authenticationRepository;
  final DeleteDocumentation deleteDocumentation;
  final ImageConverter imageConverter;

  PhotoCubit(
    this.createImageDocumentation,
    this.authenticationRepository,
    this.deleteDocumentation,
    this.imageConverter,
  ) : super(PhotoState(
          photosPath: List.empty(),
          hints: List.empty(),
        ));

  void addImages(
    List<String>? images,
    List<String>? hints, {
    required bool hasChanges,
  }) {
    emit(state.copyWith(
      photosPath: images,
      hints: hints,
      hasChanges: hasChanges,
    ));
  }

  void changeCurrentPhotoListIndex(int position) {
    emit(state.copyWith(selectedImageIndex: position));
  }

  void changeHint(String hint) {
    final newHints = List<String>.from(state.hints);
    newHints[state.selectedImageIndex] = hint;
    emit(state.copyWith(
      hints: newHints,
      hasChanges: true,
    ));
  }

  void removeImage() {
    final index = state.selectedImageIndex;
    final newPhotosPath = List<String>.from(state.photosPath);
    final newHints = List<String>.from(state.hints);

    if (index >= 0 && index < newPhotosPath.length) {
      newPhotosPath.removeAt(index);
      newHints.removeAt(index);

      if (index == newPhotosPath.length) {
        final newIndex = index - 1;
        emit(state.copyWith(
          photosPath: newPhotosPath,
          hints: newHints,
          selectedImageIndex: newIndex,
          hasChanges: true,
        ));
      } else {
        emit(state.copyWith(
          photosPath: newPhotosPath,
          hints: newHints,
          hasChanges: true,
        ));
      }
    }
  }

  Future<void> delete({
    required int documentationId,
  }) async {
    final result = await deleteDocumentation(
      DeleteDocumentationParams(
        id: documentationId,
      ),
    );

    emit(state.copyWith(cubitStatus: Status.loading));

    result.fold(
      (failure) {
        if (failure.runtimeType == AuthorizationFailure) {
          authenticationRepository.unauthenticate();
        }
        emit(state.copyWith(cubitStatus: Status.error));
      },
      (success) {
        emit(state.copyWith(cubitStatus: Status.loaded));
      },
    );
  }

  Future<void> uploadImages(int assignmentId) async {
    if (state.cubitStatus == Status.loading) {
      return;
    }

    emit(state.copyWith(cubitStatus: Status.loading));

    final List<Either<Failure, SingleDocumentationHolder>> results = [];

    await Future.forEach(state.photosPath, (String imagePath) async {
      final image = await imageConverter.convertFileToBytes(imagePath);
      if (image.isEmpty) {
        return;
      }
      final title = state.hints[state.photosPath.indexOf(imagePath)];

      final future = await createImageDocumentation(
        CreateImageDocumentationParams(
          assignmentId: assignmentId,
          title: title,
          image: image,
        ),
      );

      results.add(future);
    });

    bool hasFailure = false;
    for (final result in results) {
      result.fold(
        (failure) {
          if (failure.runtimeType == AuthorizationFailure) {
            authenticationRepository.unauthenticate();
          }
          hasFailure = true;
        },
        (_) {},
      );
    }

    if (hasFailure) {
      emit(state.copyWith(cubitStatus: Status.error));
    } else {
      emit(state.copyWith(cubitStatus: Status.loaded));
    }
  }
}
