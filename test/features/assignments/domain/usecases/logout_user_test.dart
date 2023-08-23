import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/usecases/usecase.dart';
import 'package:share/features/assignments/domain/entities/logout.dart';
import 'package:share/features/assignments/domain/repositories/more_repository.dart';
import 'package:share/features/assignments/domain/usecases/logout_user.dart';

class MockMoreRepository extends Mock implements MoreRepository {}

void main() {
  late LogoutUser useCase;
  late MockMoreRepository mockMoreRepository;

  setUp(() {
    mockMoreRepository = MockMoreRepository();
    useCase = LogoutUser(mockMoreRepository);
  });

  const String tSuccess = 'success';
  const Logout tLogout = Logout(success: tSuccess);

  test(
    'should call MoreRepository.logout()',
    () async {
      // arrange
      when(() => mockMoreRepository.logout())
          .thenAnswer((_) async => const Right(Logout(success: tSuccess)));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, const Right(tLogout));
      verify(() => mockMoreRepository.logout());
      verifyNoMoreInteractions(mockMoreRepository);
    },
  );
}
