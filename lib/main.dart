import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lame_remote/application/ssh_bloc/ssh_bloc.dart';
import 'package:lame_remote/presentation/auth_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.002),
    ),
  );

  runApp(const LameRemote());
}

class LameRemote extends StatelessWidget {
  const LameRemote({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lame Remote',
      themeAnimationCurve: Curves.ease,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(74, 246, 38, 1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        splashFactory: InkSparkle.splashFactory,
      ),
      darkTheme: ThemeData(
        fontFamily: 'RobotoMono',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(74, 246, 38, 1),
          brightness: Brightness.dark,
          background: Colors.black,
        ),
        useMaterial3: true,
        splashFactory: InkSparkle.splashFactory,
      ),
      home: BlocProvider<SshBloc>(
        create: (context) => SshBloc(),
        child: const AuthView(),
      ),
    );
  }
}
