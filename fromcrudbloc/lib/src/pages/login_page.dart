import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fromcrudbloc/src/bloc/provider.dart';
import 'package:fromcrudbloc/src/providers/usuario_provider.dart';
import 'package:fromcrudbloc/src/utils/utils.dart';

class LoginPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _crearFondo(context),
        _loginFrom(context),
      ],
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final tamano = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: tamano.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.3)),
    );
    return Stack(
      children: [
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 90.0, right: 20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(height: 10.0, width: double.infinity),
              Text(
                'Edwin Fonseca',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _loginFrom(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
            width: size.width * 0.80,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                Text(
                  'Ingreso',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 30.0),
                _crearInputEmail(bloc),
                SizedBox(height: 20.0),
                _crearInputPassword(bloc),
                SizedBox(height: 20.0),
                _crearBoton(bloc)
              ],
            ),
          ),
          FlatButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'registro'),
            child: Text('Crear una Nueva Cuenta'),
          ),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _crearInputEmail(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.email_outlined,
                    color: Colors.deepPurple,
                  ),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Correo electronico',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: (value) => bloc.cambiarEmail(value),
              //onChanged: (value)=> bloc.cambiarEmail(value), otra forma de enviarlo
            ),
          );
        });
  }

  Widget _crearInputPassword(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_outline,
                  color: Colors.deepPurple,
                ),
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error,
              ),
              onChanged: bloc.cambiarPassword,
            ),
          );
        });
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Container(
                child: Text('Login'),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 0.0,
              color: Colors.deepPurple,
              textColor: Colors.white,
              onPressed: snapshot.hasData ? () => _login(bloc, context) : null);
        });
  }

  _login(LoginBloc bloc, BuildContext context) async {
    print('*********************');
    print('email: ${bloc.email}');
    print('Password: ${bloc.pass}');
    print('************************');
    Map info = await usuarioProvider.login(bloc.email, bloc.pass);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }
}
