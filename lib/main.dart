import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/crypto/crypto_bloc.dart';
import 'repositories/crypto_repository.dart';
import 'screens/home_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CryptoBloc>(
      create: (_) => CryptoBloc(
        cryptoRepository: CryptoRepository(),
      )..add(AppStarted()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Crypto',
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.tealAccent,
        ),
        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}
