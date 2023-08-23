import '../../generated/l10n.dart';
import '../error/failures.dart';

String mapFailureToMessage(Failure failure,
    {Function? onAuthenticationFailure}) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return S.current.serverFailure(
        '${failure.code}: ${failure.error?.displayMessage}',
      );
    case AuthorizationFailure:
      onAuthenticationFailure?.call();
      return onAuthenticationFailure == null
          ? S.current.authorizationFailure
          : S.current.sessionExpiredPleaseLogin;
    case UserValidationFailure:
      return S.current.validationFailure;
    case UnexpectedFailure:
      return S.current.unexpectedFailure(failure.message ?? '');
    case InternetConnectionFailure:
      return S.current.internetConnectionFailure;
    default:
      return S.current.unknownFailure;
  }
}
