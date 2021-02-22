import 'package:bank_todo/data/models/user_model.dart';
import 'package:bank_todo/ui/main/main_screen.dart';

class StartLoadingAction {
  StartLoadingAction(this.email, this.password);

  final String email;
  final String password;
}

class LoginSuccessAction {
  final UserModel user;

  LoginSuccessAction(this.user);
}

class LoginFailedAction {
  LoginFailedAction();
}

class LogoutUserAction {
  LogoutUserAction();
}

class UpdateUserInfo {
  final UserModel user;
  final RefreshItemsAction completer;

  UpdateUserInfo(this.user, this.completer);
}
