import 'package:chopper_test/logic/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController.fromValue(TextEditingValue(text: 'bruno@email.com'));
  final TextEditingController password = TextEditingController.fromValue(TextEditingValue(text: 'bruno'));

  AuthScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: email,
                inputFormatters: [],
                keyboardType: TextInputType.emailAddress,
                autofillHints: [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: 'Email',
                  contentPadding: const EdgeInsets.all(8)
                ),
              ),
              TextField(
                controller: password,
                inputFormatters: [],
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                autofillHints: [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding: const EdgeInsets.all(8),
                  suffixIcon: Icon(Icons.remove_red_eye),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: () {
                    context.read<AuthBloc>().add(AuthLogin(email: email.value.text, password: password.value.text));
                    Navigator.pop(context);
                  }, child: Text('Login'),),
                  ElevatedButton(onPressed: () {
                    context.read<AuthBloc>().add(AuthRegister(email: email.value.text, password: password.value.text));
                    Navigator.pop(context);
                  }, child: Text('Register'),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}