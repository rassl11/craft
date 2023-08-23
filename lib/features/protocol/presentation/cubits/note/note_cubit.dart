import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/repositories/authentication_repository.dart';
import '../../../../assignments/domain/usecases/documentation/create_note_documentation.dart';
import '../../../../assignments/domain/usecases/documentation/delete_documentation.dart';
import '../../../../assignments/domain/usecases/documentation/edit_note_documentation.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final CreateNoteDocumentation _createNoteDocumentation;
  final EditNoteDocumentation _editNoteDocumentation;
  final DeleteDocumentation _deleteDocumentation;
  final AuthenticationRepository _authenticationRepository;

  NoteCubit({
    required CreateNoteDocumentation createNoteDocumentation,
    required EditNoteDocumentation editNoteDocumentation,
    required DeleteDocumentation deleteDocumentation,
    required AuthenticationRepository authenticationRepository,
  })  : _createNoteDocumentation = createNoteDocumentation,
        _editNoteDocumentation = editNoteDocumentation,
        _deleteDocumentation = deleteDocumentation,
        _authenticationRepository = authenticationRepository,
        super(const NoteState());

  void setInitialValue({
    required String title,
    required String text,
  }) {
    emit(state.copyWith(
      text: text,
      title: title,
      titleError: title.isEmpty && state.cubitStatus == Status.error,
      textError: text.isEmpty && state.cubitStatus == Status.error,
    ));
  }

  Future<void> save({
    required int assignmentId,
  }) async {
    if (state.title.isEmpty || state.text.isEmpty) {
      emit(state.copyWith(
        titleError: state.title.isEmpty,
        textError: state.text.isEmpty,
      ));
      return;
    }

    emit(state.copyWith(cubitStatus: Status.loading));
    final result = await _createNoteDocumentation(
      CreateNoteDocumentationParams(
        assignmentId: assignmentId,
        title: state.title,
        description: state.text,
      ),
    );
    result.fold(
      (failure) {
        if (failure.runtimeType == AuthorizationFailure) {
          _authenticationRepository.unauthenticate();
        }
        emit(state.copyWith(cubitStatus: Status.error));
      },
      (success) {
        emit(state.copyWith(cubitStatus: Status.loaded));
      },
    );
  }

  Future<void> edit({
    required int assignmentId,
    required int documentationId,
  }) async {
    if (state.title.isEmpty || state.text.isEmpty) {
      emit(state.copyWith(
        titleError: state.title.isEmpty,
        textError: state.text.isEmpty,
      ));
      return;
    }

    emit(state.copyWith(cubitStatus: Status.loading));
    final result = await _editNoteDocumentation(
      EditNoteDocumentationParams(
        assignmentId: assignmentId,
        documentationId: documentationId,
        title: state.title,
        description: state.text,
      ),
    );
    result.fold(
      (failure) {
        if (failure.runtimeType == AuthorizationFailure) {
          _authenticationRepository.unauthenticate();
        }
        emit(state.copyWith(cubitStatus: Status.error));
      },
      (success) {
        emit(state.copyWith(cubitStatus: Status.loaded));
      },
    );
  }

  Future<void> delete({
    required int documentationId,
  }) async {
    final result = await _deleteDocumentation(
      DeleteDocumentationParams(
        id: documentationId,
      ),
    );

    emit(state.copyWith(cubitStatus: Status.loading));
    result.fold(
      (failure) {
        if (failure.runtimeType == AuthorizationFailure) {
          _authenticationRepository.unauthenticate();
        }
        emit(state.copyWith(cubitStatus: Status.error));
      },
      (success) {
        emit(state.copyWith(cubitStatus: Status.loaded));
      },
    );
  }

  Future<void> setTitle(String value) async {
    emit(state.copyWith(
      title: value,
      cubitStatus: Status.initial,
      titleError: state.cubitStatus == Status.error && value.isEmpty,
    ));
  }

  Future<void> setText(String value) async {
    emit(state.copyWith(
      text: value,
      cubitStatus: Status.initial,
      textError: state.cubitStatus == Status.error && value.isEmpty,
    ));
  }
}
