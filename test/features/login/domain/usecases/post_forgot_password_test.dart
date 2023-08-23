import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/features/login/domain/entities/forgot_password.dart';
import 'package:share/features/login/domain/repositories/login_repository.dart';
import 'package:share/features/login/domain/usecases/post_forgot_password.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late PostForgotPassword useCase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    useCase = PostForgotPassword(mockLoginRepository);
  });

  const String tEmail = 'email';
  const ForgotPassword tForgotPassword = ForgotPassword(success: 'success');

  test(
    'should get ForgotPassword from the repository',
    () async {
      // arrange
      when(() => mockLoginRepository.forgotPassword(any()))
          .thenAnswer((_) async => const Right(tForgotPassword));
      // act
      final result = await useCase(const ForgotPasswordParams(tEmail));
      // assert
      expect(result, const Right(tForgotPassword));
      verify(() => mockLoginRepository.forgotPassword(tEmail));
      verifyNoMoreInteractions(mockLoginRepository);
    },
  );
}
