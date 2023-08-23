import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../../core/blocs/status.dart';

class DraftState extends Equatable {
  final String title;
  final Uint8List? draft;
  final Status cubitStatus;
  final bool titleError;
  final bool draftError;
  final bool isSaving;

  const DraftState({
    this.title = '',
    this.draft,
    this.cubitStatus = Status.initial,
    this.titleError = false,
    this.draftError = false,
    this.isSaving = false,
  });

  @override
  List<Object?> get props => [
        title,
        draft,
        cubitStatus,
        titleError,
        draftError,
        isSaving,
      ];

  DraftState copyWith({
    String? title,
    Uint8List? draft,
    Status? cubitStatus,
    bool? titleError,
    bool? draftError,
    bool? isSaving,
  }) {
    return DraftState(
      title: title ?? this.title,
      draft: draft ?? this.draft,
      cubitStatus: cubitStatus ?? this.cubitStatus,
      titleError: titleError ?? this.titleError,
      draftError: draftError ?? this.draftError,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
