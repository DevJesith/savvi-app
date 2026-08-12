// import 'package:savvi/data/repositories/auth_repository.dart';
import 'package:savvi/features/auth/domain/entities/user_entity.dart';
import 'package:savvi/features/auth/domain/repositories/auth_repository.dart';

class RegisterUserUsecase {
  final AuthRepository repository;

  RegisterUserUsecase(this.repository);

  Future<void> excute(UserEntity user, String password) {
    return repository.registerWithEmail(user: user, password: password);
  }
}
