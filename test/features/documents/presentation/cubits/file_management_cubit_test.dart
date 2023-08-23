import 'dart:io';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_file/open_file.dart';
import 'package:share/core/blocs/status.dart';
import 'package:share/core/error/failures.dart';
import 'package:share/core/repositories/authentication_repository.dart';
import 'package:share/core/utils/file_opener.dart';
import 'package:share/features/assignments/domain/entities/document.dart';
import 'package:share/features/documents/domain/usecases/get_file.dart';
import 'package:share/features/documents/presentation/cubits/file_management_cubit.dart';
import 'package:share/generated/l10n.dart';

class MockGetFile extends Mock implements GetFile {}

class MockFileOpener extends Mock implements FileOpener {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() async {
  await S.load(const Locale.fromSubtags(languageCode: 'en'));

  late MockGetFile mockGetFile;
  late MockFileOpener mockFileOpener;
  late MockAuthenticationRepository authenticationRepository;
  late FileManagementCubit fileManagementCubit;

  setUp(() {
    mockGetFile = MockGetFile();
    mockFileOpener = MockFileOpener();
    authenticationRepository = MockAuthenticationRepository();
    fileManagementCubit = FileManagementCubit(
      mockGetFile,
      mockFileOpener,
      authenticationRepository,
    );
  });

  setUpAll(() {
    registerFallbackValue(const FileParams(
      url: '',
      fileName: '',
    ));
    registerFallbackValue(File(''));
  });

  test('initial state should be FileManagementState', () {
    // assert
    expect(
      fileManagementCubit.state,
      equals(const FileManagementState()),
    );
  });

  group('getDocument', () {
    final downloadedFile = File('initial/file');
    const fileTitle = 'fileTitle';
    const fileName = 'fileName';
    const fileUrl = 'fileUrl';
    const fileType = FileType.pdf;

    blocTest<FileManagementCubit, FileManagementState>(
      'should finally emit a state with Status.loaded, file and progress=100'
      ' if file was successfully received',
      setUp: () {
        when(() => mockGetFile(any())).thenAnswer((_) async {
          return Right(downloadedFile);
        });
      },
      build: () => fileManagementCubit,
      act: (cubit) {
        return cubit.getDocument(
          fileUrl: fileUrl,
          fileName: fileName,
          title: fileTitle,
          fileType: fileType,
        );
      },
      expect: () => <FileManagementState>[
        const FileManagementState(
          cubitStatus: Status.loading,
          title: fileTitle,
          fileType: fileType,
        ),
        FileManagementState(
          file: downloadedFile,
          cubitStatus: Status.loaded,
          progress: 100,
          title: fileTitle,
          fileType: fileType,
        ),
      ],
      verify: (_) {
        final captured = verify(() => mockGetFile(captureAny())).captured;
        expect(captured[0], isA<FileParams>());
      },
    );

    blocTest<FileManagementCubit, FileManagementState>(
      'should finally emit a state with Status.error, and '
      'errorMsg=No internet connection if file was failed to receive',
      setUp: () {
        when(() => mockGetFile(any())).thenAnswer((_) async {
          return Left(InternetConnectionFailure());
        });
      },
      build: () => fileManagementCubit,
      act: (cubit) {
        return cubit.getDocument(
          fileUrl: fileUrl,
          fileName: fileName,
          title: fileTitle,
          fileType: fileType,
        );
      },
      expect: () => <FileManagementState>[
        const FileManagementState(
          cubitStatus: Status.loading,
          title: fileTitle,
          fileType: fileType,
        ),
        const FileManagementState(
          cubitStatus: Status.error,
          errorMsg: 'No internet connection',
          title: fileTitle,
          fileType: fileType,
        ),
      ],
      verify: (_) {
        final captured = verify(() => mockGetFile(captureAny())).captured;
        expect(captured[0], isA<FileParams>());
      },
    );
  });

  group('openDocument', () {
    blocTest<FileManagementCubit, FileManagementState>(
      'should emit a state with Status.error and errorMsg=File is invalid'
      ' if file is null',
      build: () => fileManagementCubit,
      act: (cubit) => cubit.openDocument(),
      expect: () => <FileManagementState>[
        const FileManagementState(
          cubitStatus: Status.error,
          errorMsg: 'File is invalid',
        ),
      ],
    );

    final file = File('file');
    blocTest<FileManagementCubit, FileManagementState>(
      'should emit a state with Status.error and errorMsg=No apps can perform '
      'this action if a file is not supported',
      setUp: () {
        when(() => mockFileOpener.openFile(any())).thenAnswer((_) async {
          return OpenResult(type: ResultType.noAppToOpen);
        });
      },
      seed: () => FileManagementState(file: file),
      build: () => fileManagementCubit,
      act: (cubit) => cubit.openDocument(),
      expect: () => <FileManagementState>[
        FileManagementState(
          cubitStatus: Status.error,
          errorMsg: 'No apps can perform this action',
          file: file,
        ),
      ],
      verify: (_) {
        verify(() => mockFileOpener.openFile(file));
      },
    );
  });
}
