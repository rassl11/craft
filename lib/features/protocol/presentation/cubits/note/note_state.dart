part of 'note_cubit.dart';


class NoteState extends Equatable {
  final String title;
  final String text;
  final Status cubitStatus;
  final bool titleError;
  final bool textError;

  const NoteState({
    this.title = '',
    this.text = '',
    this.cubitStatus = Status.initial,
    this.titleError = false,
    this.textError = false,
  });

  @override
  List<Object?> get props => [
        title,
        text,
        cubitStatus,
        titleError,
        textError,
      ];

  NoteState copyWith({
    String? text,
    String? title,
    Status? cubitStatus,
    bool? titleError,
    bool? textError,
  }) {
    return NoteState(
      text: text ?? this.text,
      title: title ?? this.title,
      cubitStatus: cubitStatus ?? this.cubitStatus,
      titleError: titleError ?? this.titleError,
      textError: textError ?? this.textError,
    );
  }
}
