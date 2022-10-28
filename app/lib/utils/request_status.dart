import 'package:equatable/equatable.dart';

enum RequestStatusEnum {
  loading,
  loaded,
  error,
  none
}

class RequestStatus extends Equatable{

  final RequestStatusEnum value;
  final String? message;

  const RequestStatus(this.value,{this.message});

  factory RequestStatus.none(){
    return const RequestStatus(RequestStatusEnum.none);
  }

  factory RequestStatus.loading(){
    return const RequestStatus(RequestStatusEnum.loading);
  }

  factory RequestStatus.loaded(){
    return const RequestStatus(RequestStatusEnum.loaded);
  }

  factory RequestStatus.error(String message){
    return RequestStatus(RequestStatusEnum.error,message: message);
  }

  bool get isError => value == RequestStatusEnum.error;

  @override
  List<Object?> get props => [value,message];

}