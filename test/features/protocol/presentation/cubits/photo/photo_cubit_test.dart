import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/blocs/status.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/core/utils/image_converter.dart';
import 'package:share/features/assignments/domain/entities/documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/create_image_documentation.dart';
import 'package:share/features/assignments/domain/usecases/documentation/delete_documentation.dart';
import 'package:share/features/protocol/presentation/cubits/photo/photo_cubit.dart';
import 'package:share/features/protocol/presentation/cubits/photo/photo_state.dart';

import '../../../../../core/utils.dart';

class MockCreateImageDocumentation extends Mock
    implements CreateImageDocumentation {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockDeleteDocumentation extends Mock implements DeleteDocumentation {}

class MockImageConverter extends Mock implements ImageConverter {}

void main() async {
  late MockCreateImageDocumentation createImageDocumentation;
  late MockAuthenticationRepository authenticationRepository;
  late MockDeleteDocumentation deleteDocumentation;
  late MockImageConverter imageConverter;
  late PhotoCubit photoCubit;

  setUpAll(() {
    registerFallbackValue(CreateImageDocumentationParams(
      assignmentId: 1,
      image: Uint8List(0),
      title: '',
    ));
  });

  setUp(() {
    createImageDocumentation = MockCreateImageDocumentation();
    authenticationRepository = MockAuthenticationRepository();
    deleteDocumentation = MockDeleteDocumentation();
    imageConverter = MockImageConverter();
    photoCubit = PhotoCubit(
      createImageDocumentation,
      authenticationRepository,
      deleteDocumentation,
      imageConverter,
    );
  });

  test('initial state should be PhotoState with empty lists', () {
    // assert
    expect(
      photoCubit.state,
      equals(PhotoState(
        photosPath: List.empty(),
        hints: List.empty(),
      )),
    );
  });

  test(
      'should emit PhotoState with photosPath and hints '
      'after calling addImages', () {
    // assert
    photoCubit.addImages(
      ['test'],
      ['test'],
      hasChanges: false,
    );
    expect(
      photoCubit.state,
      equals(const PhotoState(
        photosPath: ['test'],
        hints: ['test'],
      )),
    );
  });

  test(
      'should emit PhotoState with currentIndex '
      'after calling changeCurrentPhotoListIndex', () {
    // assert
    photoCubit.changeCurrentPhotoListIndex(
      5,
    );
    expect(
      photoCubit.state,
      equals(const PhotoState(
        photosPath: [],
        hints: [],
        selectedImageIndex: 5,
      )),
    );
  });

  blocTest<PhotoCubit, PhotoState>(
    'should emit PhotoState with new hints '
    'after calling changeHint',
    build: () => photoCubit,
    seed: () => const PhotoState(
      photosPath: ['test_image1', 'test_image2'],
      hints: ['test_hint1', 'test_hint2', 'test_hint3'],
      selectedImageIndex: 1,
    ),
    act: (cubit) => cubit.changeHint('test_hint5'),
    expect: () => <PhotoState>[
      const PhotoState(
        photosPath: ['test_image1', 'test_image2'],
        hints: ['test_hint1', 'test_hint5', 'test_hint3'],
        selectedImageIndex: 1,
        hasChanges: true,
      ),
    ],
  );

  blocTest<PhotoCubit, PhotoState>(
    'should remove image and hint '
    'after calling removeImage',
    build: () => photoCubit,
    seed: () => const PhotoState(
      photosPath: ['test_image1', 'test_image2'],
      hints: ['test_hint1', 'test_hint2'],
      selectedImageIndex: 1,
    ),
    act: (cubit) => cubit.removeImage(),
    expect: () => <PhotoState>[
      const PhotoState(
        photosPath: ['test_image1'],
        hints: ['test_hint1'],
        hasChanges: true,
      ),
    ],
  );

  blocTest<PhotoCubit, PhotoState>(
    'Should emit loading and loaded status if uploadImages returns Right()',
    setUp: () {
      final tSingleDocumentationHolder = SingleDocumentationHolder(
        documentation: getDummyDocumentation(),
      );

      when(() => createImageDocumentation(any())).thenAnswer((_) async {
        return Right(tSingleDocumentationHolder);
      });
      when(() => imageConverter.convertFileToBytes(any()))
          .thenAnswer((_) async {
        return Uint8List.fromList([1, 2, 3]);
      });
    },
    build: () => photoCubit,
    seed: () => const PhotoState(
      photosPath: ['test_image1', 'test_image2'],
      hints: ['test_hint1', 'test_hint2'],
    ),
    act: (cubit) => cubit.uploadImages(
      1,
    ),
    expect: () => <PhotoState>[
      const PhotoState(
        photosPath: ['test_image1', 'test_image2'],
        hints: ['test_hint1', 'test_hint2'],
        cubitStatus: Status.loading,
      ),
      const PhotoState(
        photosPath: ['test_image1', 'test_image2'],
        hints: ['test_hint1', 'test_hint2'],
        cubitStatus: Status.loaded,
      ),
    ],
  );

  blocTest<PhotoCubit, PhotoState>(
    'Should emit loading and error status if uploadImages returns Left()',
    setUp: () {
      when(() => createImageDocumentation(any())).thenAnswer((_) async {
        return Left(InternetConnectionFailure());
      });
      when(() => imageConverter.convertFileToBytes(any()))
          .thenAnswer((_) async {
        return Uint8List.fromList([1, 2, 3]);
      });
    },
    build: () => photoCubit,
    seed: () => const PhotoState(
      photosPath: ['test_image1', 'test_image2'],
      hints: ['test_hint1', 'test_hint2'],
    ),
    act: (cubit) => cubit.uploadImages(
      1,
    ),
    expect: () => <PhotoState>[
      const PhotoState(
        photosPath: ['test_image1', 'test_image2'],
        hints: ['test_hint1', 'test_hint2'],
        cubitStatus: Status.loading,
      ),
      const PhotoState(
        photosPath: ['test_image1', 'test_image2'],
        hints: ['test_hint1', 'test_hint2'],
        cubitStatus: Status.error,
      ),
    ],
  );
}
