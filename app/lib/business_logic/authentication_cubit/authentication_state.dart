part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {

  late final RequestStatus status;
  final User? user;

  AuthenticationState({RequestStatus? status,this.user}){
    this.status = status ?? RequestStatus.none();
  }

  @override
  List<Object?> get props => [status,user];

  AuthenticationState copyWith({
  RequestStatus? status
}){
    return AuthenticationState(
      status: status ?? this.status
    );
  }
}
