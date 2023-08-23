import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/features/documents/domain/repositories/file_repository.dart';
import 'package:share/features/documents/domain/usecases/get_file.dart';

class MockFileRepository extends Mock implements FileRepository {}

void main() {
  late MockFileRepository mockFileRepository;
  late GetFile usecase;

  setUp(() {
    mockFileRepository = MockFileRepository();
    usecase = GetFile(mockFileRepository);
  });

  setUpAll(() {
    registerFallbackValue(const FileParams(
      url: '',
      fileName: '',
    ));
  });

  test('should download file', () async {
    // arrange
    when(() {
      return mockFileRepository.downloadFile(
        url: any(named: 'url'),
        fileName: any(named: 'fileName'),
        onProgressChanged: any(named: 'onProgressChanged'),
      );
    }).thenAnswer((_) async => Right(File('')));
    // act
    await usecase(const FileParams(
      url: '',
      fileName: '',
    ));
    // assert
    verify(() => mockFileRepository.downloadFile(
          url: any(named: 'url'),
          fileName: any(named: 'fileName'),
          onProgressChanged: any(named: 'onProgressChanged'),
        ));
    verifyNoMoreInteractions(mockFileRepository);
  });
}
