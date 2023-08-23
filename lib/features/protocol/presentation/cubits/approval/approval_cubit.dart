import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/blocs/status.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/repositories/authentication_repository.dart';
import '../../../../assignments/domain/usecases/documentation/create_signature_documentation.dart';

part 'approval_state.dart';

class ApprovalCubit extends Cubit<ApprovalState> {
  final CreateSignatureDocumentation createSignatureDocumentation;
  final AuthenticationRepository authenticationRepository;

  ApprovalCubit({
    required this.createSignatureDocumentation,
    required this.authenticationRepository,
  }) : super(const ApprovalState());

  void addSignature(SignatureType signatureType, Object? signature) {
    final signatureBytes = signature as Uint8List? ?? Uint8List(0);
    if (signatureBytes.isEmpty) {
      return;
    }

    switch (signatureType) {
      case SignatureType.customer:
        emit(state.copyWith(
          customerSignature: signatureBytes,
          cubitStatus: Status.initial,
        ));
        break;
      case SignatureType.executor:
        emit(state.copyWith(
          executorSignature: signatureBytes,
          cubitStatus: Status.initial,
        ));
        break;
    }
  }

  void setCustomer(String customer) {
    emit(state.copyWith(customerName: customer, cubitStatus: Status.initial));
  }

  Future<void> submitApproval(
    int assignmentId,
  ) async {
    if (state.cubitStatus == Status.loading) {
      return;
    }

    if (state.customerName.isEmpty ||
        state.customerSignature == null ||
        state.executorSignature == null) {
      emit(state.copyWith(cubitStatus: Status.error));
      return;
    }

    emit(state.copyWith(cubitStatus: Status.loading));

    final result = await createSignatureDocumentation(
      CreateSignatureDocumentationParams(
        assignmentId: assignmentId,
        title: state.customerName,
        uploadFile1: state.customerSignature ?? Uint8List(0),
        uploadFile2: state.executorSignature ?? Uint8List(0),
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
        Future.delayed(const Duration(seconds: 1), () {
          emit(state.copyWith(
            cubitStatus: Status.loaded,
            isSaving: false,
          ));
        });
      },
    );
  }
}

enum SignatureType {
  customer,
  executor,
}
