import 'dart:async';

import 'package:fromcrudbloc/src/bloc/validacion.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validaciones {
  final _passwordController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();

  //Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  // Insertar valores al Stream
  Function(String) get cambiarEmail => _emailController.sink.add;
  Function(String) get cambiarPassword => _passwordController.sink.add;

  //opbtener los valores ingresados
  String get email => _emailController.value;
  String get pass => _passwordController.value;
  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
