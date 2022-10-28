import 'package:app/data/models/user.dart';
import 'package:app/data/repositories/authentication_repository.dart';
import 'package:app/utils/request_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {

  final AuthenticationRepository _authenticationRepository;

  AuthenticationCubit(this._authenticationRepository) : super(const AuthenticationState());

  Future<void> init() async {

  }
}
