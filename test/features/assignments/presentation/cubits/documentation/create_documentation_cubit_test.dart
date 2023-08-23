import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/blocs/status.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/utils/date_utils.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_time_documentation.dart';
import 'package:share/features/assignments/presentation/cubits/documentation/create_documentation_cubit.dart';
import 'package:share/features/assignments/presentation/cubits/time_picker/time_picker_cubit.dart';
import 'package:share/generated/l10n.dart';

class MockCreateTimeDocumentation extends Mock
    implements CreateTimeDocumentation {}

void main() async {
  await S.load(const Locale.fromSubtags(languageCode: 'en'));

  late MockCreateTimeDocumentation createTimeDocumentation;
  late CreateDocumentationCubit createDocumentationCubit;

  setUp(() {
    createTimeDocumentation = MockCreateTimeDocumentation();
    createDocumentationCubit = CreateDocumentationCubit(
      createTimeDocumentation: createTimeDocumentation,
    );
  });

  setUpAll(() {
    registerFallbackValue(const CreateTimeDocumentationParams(
      assignmentId: 1,
      workingTime: 0,
      breakTime: 0,
      drivingTime: 0,
      description: '',
      title: '',
    ));
  });

  test('initial state should be CreateDocumentationState', () {
    // assert
    expect(
      createDocumentationCubit.state,
      equals(const CreateDocumentationState()),
    );
  });

  blocTest<CreateDocumentationCubit, CreateDocumentationState>(
    'should emit noFilledFields: false if resetFieldsErrors() was called',
    act: (cubit) => cubit.resetFieldsErrors(),
    seed: () => const CreateDocumentationState(
      requiredFieldsAreNotFilled: true,
    ),
    build: () => CreateDocumentationCubit(
      createTimeDocumentation: createTimeDocumentation,
    ),
    expect: () =>
    <CreateDocumentationState>[
      const CreateDocumentationState(),
    ],
  );

  group('createDocumentation', () {
    const tAssignmentId = 1;
    const tTimeRecords = <TimeRecordType, TimePickerTime?>{};
    const tTitle = 'title';
    const tAttachment = 'attachment';

    blocTest<CreateDocumentationCubit, CreateDocumentationState>(
      'should emit state with noFilledFields: true if there are '
      'no filled fields',
      act: (cubit) => cubit.createDocumentation(
        assignmentId: tAssignmentId,
        timeRecords: tTimeRecords,
        title: tTitle,
        attachment: tAttachment,
      ),
      build: () => CreateDocumentationCubit(
        createTimeDocumentation: createTimeDocumentation,
      ),
      expect: () => <CreateDocumentationState>[
        const CreateDocumentationState(requiredFieldsAreNotFilled: true),
      ],
    );

    blocTest<CreateDocumentationCubit, CreateDocumentationState>(
      'should emit loading and loaded if documentation was '
      'successfully created',
      setUp: () {
        const tSingleDocumentationHolder = SingleDocumentationHolder(
          documentation: Documentation(
            assignmentId: 1,
            workingTime: 0,
            breakTime: 0,
            drivingTime: 0,
            type: DocumentationType.time,
            title: '',
            description: '',
          ),
        );

        when(() => createTimeDocumentation(any())).thenAnswer((_) async {
          return const Right(tSingleDocumentationHolder);
        });
      },
      // seed: () => {},
      act: (cubit) => cubit.createDocumentation(
        assignmentId: tAssignmentId,
        timeRecords: {
          TimeRecordType.timeSpent: const TimePickerTime(
            duration: Duration(minutes: 1),
            humanReadableTime: '0h 01m',
          )
        },
        title: tTitle,
        attachment: tAttachment,
      ),
      build: () => CreateDocumentationCubit(
        createTimeDocumentation: createTimeDocumentation,
      ),
      expect: () => <CreateDocumentationState>[
        const CreateDocumentationState(blocStatus: Status.loading),
        const CreateDocumentationState(blocStatus: Status.loaded),
      ],
      verify: (_) {
        verify(() => createTimeDocumentation(
              const CreateTimeDocumentationParams(
                assignmentId: tAssignmentId,
                workingTime: 1,
                breakTime: 0,
                drivingTime: 0,
                description: tAttachment,
                title: tTitle,
              ),
            )).called(1);
      },
    );

    blocTest<CreateDocumentationCubit, CreateDocumentationState>(
      'should emit loading and error if documentation creation fails',
      setUp: () {
        when(() => createTimeDocumentation(any())).thenAnswer((_) async {
          return Left(InternetConnectionFailure());
        });
      },
      // seed: () => {},
      act: (cubit) => cubit.createDocumentation(
        assignmentId: tAssignmentId,
        timeRecords: {
          TimeRecordType.timeSpent: const TimePickerTime(
            duration: Duration(minutes: 1),
            humanReadableTime: '0h 01m',
          )
        },
        title: tTitle,
        attachment: tAttachment,
      ),
      build: () => CreateDocumentationCubit(
        createTimeDocumentation: createTimeDocumentation,
      ),
      expect: () => <CreateDocumentationState>[
        const CreateDocumentationState(blocStatus: Status.loading),
        const CreateDocumentationState(
          blocStatus: Status.error,
          errorMsg: 'No internet connection',
        ),
      ],
      verify: (_) {
        verify(() => createTimeDocumentation(
              const CreateTimeDocumentationParams(
                assignmentId: tAssignmentId,
                workingTime: 1,
                breakTime: 0,
                drivingTime: 0,
                description: tAttachment,
                title: tTitle,
              ),
            )).called(1);
      },
    );
  });
}
