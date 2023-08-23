import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/blocs/status.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_signature_documentation.dart';
import 'package:share/features/protocol/presentation/cubits/approval/approval_cubit.dart';

import '../../../../../core/utils.dart';

class MockCreateSignatureDocumentation extends Mock
    implements CreateSignatureDocumentation {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late ApprovalCubit approvalCubit;
  late CreateSignatureDocumentation createSignatureDocumentation;
  late MockAuthenticationRepository authenticationRepository;

  setUp(() {
    createSignatureDocumentation = MockCreateSignatureDocumentation();
    authenticationRepository = MockAuthenticationRepository();
    approvalCubit = ApprovalCubit(
      createSignatureDocumentation: createSignatureDocumentation,
      authenticationRepository: authenticationRepository,
    );
  });

  setUpAll(() {
    registerFallbackValue(CreateSignatureDocumentationParams(
      assignmentId: 1,
      title: '',
      uploadFile1: Uint8List(0),
      uploadFile2: Uint8List(0),
    ));
  });

  test('initial state should be ApprovalState', () {
    // assert
    expect(
      approvalCubit.state,
      equals(const ApprovalState()),
    );
  });

  group('addSignature', () {
    final signature = Uint8List.fromList('elements'.codeUnits);

    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit nothing if signature bytes is empty',
      build: () => approvalCubit,
      act: (cubit) => cubit.addSignature(SignatureType.customer, null),
      expect: () => const <ApprovalState>[],
    );

    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit customer signature and initial status if signature bytes is '
      'not empty and type is customer',
      build: () => approvalCubit,
      act: (cubit) {
        return cubit.addSignature(
          SignatureType.customer,
          signature,
        );
      },
      expect: () => <ApprovalState>[
        ApprovalState(
          customerSignature: signature,
        ),
      ],
    );

    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit executor signature and initial status if signature bytes is '
      'not empty and type is executor',
      build: () => approvalCubit,
      act: (cubit) {
        return cubit.addSignature(
          SignatureType.executor,
          signature,
        );
      },
      expect: () => <ApprovalState>[
        ApprovalState(
          executorSignature: signature,
        ),
      ],
    );
  });

  group('setCustomer', () {
    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit customer name and initial status',
      build: () => approvalCubit,
      act: (cubit) => cubit.setCustomer('customer'),
      expect: () => <ApprovalState>[
        const ApprovalState(
          customerName: 'customer',
        ),
      ],
    );
  });

  group('submitApproval', () {
    final signature = Uint8List.fromList('elements'.codeUnits);

    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit nothing if status is loading',
      seed: () => const ApprovalState(cubitStatus: Status.loading),
      build: () => approvalCubit,
      act: (cubit) => cubit.submitApproval(1),
      expect: () => const <ApprovalState>[],
    );

    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit error status if customerName is empty',
      seed: () => ApprovalState(
        executorSignature: signature,
        customerSignature: signature,
      ),
      build: () => approvalCubit,
      act: (cubit) => cubit.submitApproval(1),
      expect: () => <ApprovalState>[
        ApprovalState(
          cubitStatus: Status.error,
          executorSignature: signature,
          customerSignature: signature,
        ),
      ],
    );

    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit error status if customerSignature is null',
      seed: () => ApprovalState(
        customerName: 'name',
        executorSignature: signature,
      ),
      build: () => approvalCubit,
      act: (cubit) => cubit.submitApproval(1),
      expect: () => <ApprovalState>[
        ApprovalState(
          cubitStatus: Status.error,
          customerName: 'name',
          executorSignature: signature,
        ),
      ],
    );

    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit error status if executorSignature is null',
      seed: () => ApprovalState(
        customerName: 'name',
        customerSignature: signature,
      ),
      build: () => approvalCubit,
      act: (cubit) => cubit.submitApproval(1),
      expect: () => <ApprovalState>[
        ApprovalState(
          cubitStatus: Status.error,
          customerName: 'name',
          customerSignature: signature,
        ),
      ],
    );

    blocTest<ApprovalCubit, ApprovalState>(
      'Should emit loading and loaded if everything is ok',
      setUp: () {
        final tSingleDocumentationHolder = SingleDocumentationHolder(
          documentation: getDummyDocumentation(),
        );

        when(() => createSignatureDocumentation(any())).thenAnswer((_) async {
          return Right(tSingleDocumentationHolder);
        });
      },
      seed: () => ApprovalState(
        customerName: 'name',
        customerSignature: signature,
        executorSignature: signature,
      ),
      build: () => approvalCubit,
      act: (cubit) async => cubit.submitApproval(1),
      wait: const Duration(seconds: 3),
      expect: () => <ApprovalState>[
        ApprovalState(
          cubitStatus: Status.loading,
          customerName: 'name',
          customerSignature: signature,
          executorSignature: signature,
        ),
        ApprovalState(
          cubitStatus: Status.loading,
          customerName: 'name',
          customerSignature: signature,
          executorSignature: signature,
          isSaving: true,
        ),
        ApprovalState(
          cubitStatus: Status.loaded,
          customerName: 'name',
          customerSignature: signature,
          executorSignature: signature,
        ),
      ],
    );
  });
}
