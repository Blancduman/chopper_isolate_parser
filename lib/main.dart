import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:worker_manager/worker_manager.dart';


import 'package:chopper_test/logic/blocs/auth/auth_bloc.dart';
import 'package:chopper_test/logic/blocs/products/products_bloc.dart';
import 'package:chopper_test/screen/AuthScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runZonedGuarded<void>(
    () async {
      // await Executor().warmUp(log: true);
      runApp(MyApp());
    },
    (Object error, StackTrace stackTrace) {
      debugPrint(error.toString());
    });
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(),
      lazy: false,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductsBloc>(
      create: (context) => ProductsBloc(authBloc: context.read<AuthBloc>()),
      lazy: false,
      child: Builder(
          builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Builder(
                    builder: (context) {
                      String token =
                          context.select((AuthBloc value) => value.state.token);
                      if (token.isNotEmpty) {
                        return Text(token);
                      }
                      return Text(widget.title);
                    },
                  ),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state.token.isEmpty) {
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<AuthBloc>(),
                                      child: AuthScreen()
                                      ),
                                  ),
                                );
                              },
                              child: Text('auth'),
                            );
                          }
                          return ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthLogout());
                            },
                            child: Text('logout'),
                          );
                        },
                      ),
                      BlocBuilder<ProductsBloc, ProductsState>(
                        builder: (context, state) {
                          if (state is ProductsFail) {
                            return Text('${state.statusCode} ${state.message}');
                          }
                          if (state is ProductsSuccess) {
                            return Column(
                              children: state.products
                                  .map((e) => Text('${e.toString()}'))
                                  .toList(),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      )
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    context.read<ProductsBloc>().add(ProductsGetAll());
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ), // This trailing comma makes auto-formatting nicer for build methods.
              )),
    );
  }
}
