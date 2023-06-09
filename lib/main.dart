import 'dart:ui';

import 'package:LameRemote/rover_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          seedColor: Colors.lightGreen,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        splashFactory: InkSparkle.splashFactory,
      ),
      darkTheme: ThemeData(
        fontFamily: 'RobotoMono',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        splashFactory: InkSparkle.splashFactory,
      ),
      home: const HomePage(title: 'Lame Remote'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      SystemChrome.setPreferredOrientations([]);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/images/home_bg.svg',
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(150),
              BlendMode.srcIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 70,
                ),
                Text(
                  'Lame',
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(200),
                      fontSize: 66,
                      height: 0.2,
                      fontVariations: const <FontVariation>[
                        FontVariation('wght', 300)
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 0),
                  child: Text(
                    'Remote',
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(230),
                        fontSize: 64,
                        height: 0.85,
                        fontVariations: const <FontVariation>[
                          FontVariation('wght', 700)
                        ]),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                const Text(
                  'Enter the network details of the rover to connect.',
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(Icons.numbers),
                    hintText: 'Enter the IP Address',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: !isLoading
                        ? FilledButton.icon(
                            key: ValueKey<bool>(isLoading),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const RoverView();
                                  },
                                ),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(150, 36),
                            ),
                            icon: const Icon(
                              Icons.terminal_outlined,
                            ),
                            label: const Text(
                              'Connect',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                  fontVariations: <FontVariation>[
                                    FontVariation('wght', 400)
                                  ]),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: CircularProgressIndicator(
                              key: ValueKey<bool>(isLoading),
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
