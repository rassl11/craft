part of 'create_documentation_cubit.dart';

class CreateDocumentationState extends Equatable {
  final bool requiredFieldsAreNotFilled;
  final Status blocStatus;
  final String errorMsg;

  const CreateDocumentationState({
    this.requiredFieldsAreNotFilled = false,
    this.blocStatus = Status.initial,
    this.errorMsg = '',
  });

  @override
  List<Object?> get props => [
        requiredFieldsAreNotFilled,
        blocStatus,
        errorMsg,
      ];

  CreateDocumentationState copyWith({
    bool? noFilledFields,
    Status? blocStatus,
    String? errorMsg,
  }) {
    return CreateDocumentationState(
      requiredFieldsAreNotFilled: noFilledFields ?? requiredFieldsAreNotFilled,
      blocStatus: blocStatus ?? this.blocStatus,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
