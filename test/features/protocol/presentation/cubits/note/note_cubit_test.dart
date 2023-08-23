import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/blocs/status.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_note_documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/delete_documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/edit_note_documentation.dart';
import 'package:share/features/protocol/presentation/cubits/note/note_cubit.dart';
import 'package:share/generated/l10n.dart';

import '../../../../../core/utils.dart';

class MockCreateNoteDocumentation extends Mock
    implements CreateNoteDocumentation {}

class MockEditNoteDocumentation extends Mock implements EditNoteDocumentation {}

class MockDeleteDocumentation extends Mock implements DeleteDocumentation {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() async {
  await S.load(const Locale.fromSubtags(languageCode: 'en'));

  late MockCreateNoteDocumentation createNoteDocumentation;
  late MockEditNoteDocumentation editNoteDocumentation;
  late MockDeleteDocumentation deleteDocumentation;
  late MockAuthenticationRepository authenticationRepository;
  late NoteCubit noteCubit;

  setUpAll(() {
    registerFallbackValue(const CreateNoteDocumentationParams(
      assignmentId: 1,
      description: '',
      title: '',
    ));
    registerFallbackValue(const EditNoteDocumentationParams(
      assignmentId: 1,
      documentationId: 1,
      title: '',
      description: '',
    ));
    registerFallbackValue(const DeleteDocumentationParams(
      id: 1,
    ));
  });

  setUp(() {
    createNoteDocumentation = MockCreateNoteDocumentation();
    editNoteDocumentation = MockEditNoteDocumentation();
    deleteDocumentation = MockDeleteDocumentation();
    authenticationRepository = MockAuthenticationRepository();
    noteCubit = NoteCubit(
      createNoteDocumentation: createNoteDocumentation,
      editNoteDocumentation: editNoteDocumentation,
      deleteDocumentation: deleteDocumentation,
      authenticationRepository: authenticationRepository,
    );
  });

  test('initial state should be empty NoteState', () {
    // assert
    expect(
      noteCubit.state,
      equals(const NoteState()),
    );
  });

  test('should emit NoteState with text and title', () {
    // assert
    noteCubit.setInitialValue(
      title: 'title',
      text: 'text',
    );
    expect(
      noteCubit.state,
      equals(const NoteState(title: 'title', text: 'text')),
    );
  });

  group('save', () {
    blocTest<NoteCubit, NoteState>(
      'Should emit error status if title is empty or text is empty',
      build: () => noteCubit,
      seed: () => const NoteState(
        title: 'title',
      ),
      act: (cubit) => cubit.save(
        assignmentId: 1,
      ),
      expect: () => <NoteState>[
        const NoteState(
          title: 'title',
          textError: true,
        ),
      ],
    );

    blocTest<NoteCubit, NoteState>(
      'Should emit loading and loaded status if save returns Right()',
      setUp: () {
        final tSingleDocumentationHolder = SingleDocumentationHolder(
          documentation: getDummyDocumentation(),
        );

        when(() => createNoteDocumentation(any())).thenAnswer((_) async {
          return Right(tSingleDocumentationHolder);
        });
      },
      build: () => noteCubit,
      seed: () => const NoteState(
        title: 'title',
        text: 'text',
      ),
      act: (cubit) => cubit.save(
        assignmentId: 1,
      ),
      expect: () => <NoteState>[
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loading,
        ),
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loaded,
        ),
      ],
    );

    blocTest<NoteCubit, NoteState>(
      'Should emit loading and error status if save returns Left()',
      setUp: () {
        when(() => createNoteDocumentation(any())).thenAnswer((_) async {
          return Left(InternetConnectionFailure());
        });
      },
      build: () => noteCubit,
      seed: () => const NoteState(
        title: 'title',
        text: 'text',
      ),
      act: (cubit) => cubit.save(
        assignmentId: 1,
      ),
      expect: () => <NoteState>[
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loading,
        ),
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.error,
        ),
      ],
    );
  });

  group('edit', () {
    blocTest<NoteCubit, NoteState>(
      'Should emit textError if title is empty or text is empty',
      build: () => noteCubit,
      seed: () => const NoteState(
        title: 'title',
      ),
      act: (cubit) => cubit.edit(
        assignmentId: 1,
        documentationId: 1,
      ),
      expect: () => <NoteState>[
        const NoteState(
          title: 'title',
          textError: true,
        ),
      ],
    );

    blocTest<NoteCubit, NoteState>(
      'Should emit loading and loaded status if save returns Right()',
      setUp: () {
        final tSingleDocumentationHolder = SingleDocumentationHolder(
          documentation: getDummyDocumentation(),
        );

        when(() => editNoteDocumentation(any())).thenAnswer((_) async {
          return Right(tSingleDocumentationHolder);
        });
      },
      build: () => noteCubit,
      seed: () => const NoteState(
        title: 'title',
        text: 'text',
      ),
      act: (cubit) => cubit.edit(
        assignmentId: 1,
        documentationId: 1,
      ),
      expect: () => <NoteState>[
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loading,
        ),
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loaded,
        ),
      ],
    );

    blocTest<NoteCubit, NoteState>(
      'Should emit loading and error status if status save returns Left()',
      setUp: () {
        when(() => editNoteDocumentation(any())).thenAnswer((_) async {
          return Left(InternetConnectionFailure());
        });
      },
      build: () => noteCubit,
      seed: () => const NoteState(
        title: 'title',
        text: 'text',
      ),
      act: (cubit) => cubit.edit(
        assignmentId: 1,
        documentationId: 1,
      ),
      expect: () => <NoteState>[
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loading,
        ),
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.error,
        ),
      ],
    );
  });

  group('delete', () {
    blocTest<NoteCubit, NoteState>(
      'Should emit loading and loaded status if save returns Right()',
      setUp: () {
        when(() => deleteDocumentation(any())).thenAnswer((_) async {
          return const Right(dynamic);
        });
      },
      build: () => noteCubit,
      seed: () => const NoteState(
        title: 'title',
        text: 'text',
      ),
      act: (cubit) => cubit.delete(
        documentationId: 1,
      ),
      expect: () => <NoteState>[
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loading,
        ),
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loaded,
        ),
      ],
    );

    blocTest<NoteCubit, NoteState>(
      'Should emit loading and error status if status save returns Left()',
      setUp: () {
        when(() => deleteDocumentation(any())).thenAnswer((_) async {
          return Left(InternetConnectionFailure());
        });
      },
      build: () => noteCubit,
      seed: () => const NoteState(
        title: 'title',
        text: 'text',
      ),
      act: (cubit) => cubit.delete(
        documentationId: 1,
      ),
      expect: () => <NoteState>[
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.loading,
        ),
        const NoteState(
          title: 'title',
          text: 'text',
          cubitStatus: Status.error,
        ),
      ],
    );
  });
}
