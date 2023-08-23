import 'dart:typed_data';

import 'package:bloc/bloc.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/repositories/authentication_repository.dart';
import '../../../../assignments/domain/usecases/documentation/create_draft_documentation.dart';
import '../../../../assignments/domain/usecases/documentation/delete_documentation.dart';
import 'draft_state.dart';

class DraftCubit extends Cubit<DraftState> {
  final CreateDraftDocumentation createDraftDocumentation;
  final DeleteDocumentation deleteDocumentation;
  final AuthenticationRepository authenticationRepository;

  DraftCubit({
    required this.createDraftDocumentation,
    required this.authenticationRepository,
    required this.deleteDocumentation,
  }) : super(const DraftState());

  Future<void> setTitle(String value) async {
    emit(state.copyWith(
      title: value,
      cubitStatus: Status.initial,
      titleError: state.cubitStatus == Status.error && value.isEmpty,
      draftError: false,
    ));
  }

  void addDraft(Object? draft) {
    final draftBytes = draft as Uint8List? ?? Uint8List(0);
    if (draftBytes.isEmpty) {
      return;
    }

    emit(state.copyWith(
      draft: draftBytes,
      cubitStatus: Status.initial,
      titleError: false,
      draftError: state.cubitStatus == Status.error && draftBytes.isEmpty,
    ));
  }

  Future<void> save({
    required int assignmentId,
  }) async {
    if (state.title.isEmpty || state.draft == null) {
      emit(state.copyWith(
        titleError: state.title.isEmpty,
        draftError: state.draft == null,
      ));
      return;
    }

    emit(state.copyWith(cubitStatus: Status.loading));

    final result = await createDraftDocumentation(
      CreateDraftDocumentationParams(
        assignmentId: assignmentId,
        title: state.title,
        draft: state.draft ?? Uint8List(0),
      ),
    );
    result.fold(
      (failure) {
        if (failure.runtimeType == AuthorizationFailure) {
          authenticationRepository.unauthenticate();
        }
        emit(state.copyWith(cubitStatus: Status.error));
      },
      (success) {
        emit(state.copyWith(isSaving: true));
        Future.delayed(const Duration(seconds: 2), () {
          emit(state.copyWith(
            cubitStatus: Status.loaded,
            isSaving: false,
          ));
        });
      },
    );
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
}
