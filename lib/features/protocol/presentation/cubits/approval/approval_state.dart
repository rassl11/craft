part of 'approval_cubit.dart';

class ApprovalState extends Equatable {
  final String customerName;
  final Uint8List? customerSignature;
  final Uint8List? executorSignature;
  final Status cubitStatus;
  final bool isSaving;

  const ApprovalState({
    this.customerName = '',
    this.customerSignature,
    this.executorSignature,
    this.cubitStatus = Status.initial,
    this.isSaving = false,
  });

  @override
  List<Object?> get props => [
        customerName,
        customerSignature,
        executorSignature,
        cubitStatus,
        isSaving,
      ];

  ApprovalState copyWith({
    String? customerName,
    Uint8List? customerSignature,
    Uint8List? executorSignature,
    Status? cubitStatus,
    bool? isSaving,
  }) {
    return ApprovalState(
      customerName: customerName ?? this.customerName,
      customerSignature: customerSignature ?? this.customerSignature,
      executorSignature: executorSignature ?? this.executorSignature,
      cubitStatus: cubitStatus ?? this.cubitStatus,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
