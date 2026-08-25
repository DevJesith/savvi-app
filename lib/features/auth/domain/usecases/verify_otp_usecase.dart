import 'package:savvi/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;
  VerifyOtpUsecase(this.repository);

  Future<void> execute(String email, String token) {
    return repository.verifyOTP(email: email, token: token);
  }
}
