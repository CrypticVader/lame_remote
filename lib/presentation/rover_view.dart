import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lame_remote/application/ssh_bloc/ssh_bloc.dart';
import 'package:lame_remote/infrastructure/rover_http_service.dart';
import 'package:lame_remote/infrastructure/rover_ssh_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RoverView extends StatefulWidget {
  const RoverView({super.key});

  @override
  State<RoverView> createState() => _RoverViewState();
}

class _RoverViewState extends State<RoverView> {
  late WebViewController controller;
  late TextEditingController runCommandController;

  @override
  void initState() {
    runCommandController = TextEditingController();
    // set initial orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // enable fullscreen view
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('http://192.168.8.106:8000/stream.mjpg'));
  }

  @override
  void dispose() {
    runCommandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SshBloc, SshState>(
      listener: (context, state) {
        if (state is SshUninitializedState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            await showDialog(
              context: context,
              useRootNavigator: true,
              useSafeArea: false,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Quit'),
                  content: const Text(
                    'Are you sure you want to close the connection to the rover?',
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                      ),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(100, 42),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          context.read<SshBloc>().add(SshDisconnectEvent());

                          SystemChrome.setPreferredOrientations([]);
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.edgeToEdge);
                        },
                        child: const Text('Yes'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                      ),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(100, 42),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                );
              },
            );
            return false;
          },
          child: Scaffold(
            body: Stack(
              children: [
                // Video stream
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    // child: WebViewWidget(
                    //   controller: controller,
                    // ),
                    child: StreamBuilder<Uint8List>(
                      stream: RoverHTTPService().getVideoStream(),
                      builder: (context, snapshot) {
                        return Image.memory(snapshot.data!);
                      },
                    ),
                  ),
                ),

                // Buttons
                Opacity(
                  opacity: 0.65,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        // Forward button
                        Positioned(
                          bottom: 120,
                          right: 40,
                          child: GestureDetector(
                            onTapDown: (details) {
                              HapticFeedback.vibrate();
                              context.read<SshBloc>().add(
                                  SshKeyPressEvent(key: MovementEvent.forward));
                            },
                            onTapCancel: () {
                              context.read<SshBloc>().add(SshKeyReleaseEvent(
                                  key: MovementEvent.forward));
                            },
                            child: IconButton.filled(
                              onPressed: () {},
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                iconSize: 64,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_up_rounded,
                              ),
                            ),
                          ),
                        ),

                        // Backward button
                        Positioned(
                          bottom: 40,
                          right: 40,
                          child: GestureDetector(
                            onTapDown: (details) {
                              HapticFeedback.vibrate();
                              context.read<SshBloc>().add(SshKeyPressEvent(
                                  key: MovementEvent.backward));
                            },
                            onTapCancel: () {
                              context.read<SshBloc>().add(SshKeyReleaseEvent(
                                  key: MovementEvent.backward));
                            },
                            child: IconButton.filled(
                              onPressed: () {},
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                iconSize: 64,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                              ),
                            ),
                          ),
                        ),

                        // Left button
                        Positioned(
                          left: 40,
                          bottom: 80,
                          child: GestureDetector(
                            onTapDown: (details) {
                              HapticFeedback.vibrate();
                              context.read<SshBloc>().add(
                                  SshKeyPressEvent(key: MovementEvent.left));
                            },
                            onTapCancel: () {
                              context.read<SshBloc>().add(
                                  SshKeyReleaseEvent(key: MovementEvent.left));
                            },
                            child: IconButton.filled(
                              onPressed: () {},
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                iconSize: 64,
                              ),
                              icon: const Icon(
                                Icons.arrow_left_rounded,
                              ),
                            ),
                          ),
                        ),

                        // Right button
                        Positioned(
                          left: 140,
                          bottom: 80,
                          child: GestureDetector(
                            onTapDown: (details) {
                              HapticFeedback.vibrate();
                              context.read<SshBloc>().add(
                                  SshKeyPressEvent(key: MovementEvent.right));
                            },
                            onTapCancel: () {
                              context.read<SshBloc>().add(
                                  SshKeyReleaseEvent(key: MovementEvent.right));
                            },
                            child: IconButton.filled(
                              onPressed: () {},
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                iconSize: 64,
                              ),
                              icon: const Icon(
                                Icons.arrow_right_rounded,
                              ),
                            ),
                          ),
                        ),

                        // Run command button
                        Positioned(
                          left: 32,
                          top: 32,
                          child: IconButton.filledTonal(
                            onPressed: () async {
                              final shouldRun = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Run Command'),
                                    content: TextField(
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.text,
                                      controller: runCommandController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        prefixIcon:
                                            const Icon(Icons.location_on),
                                        hintText:
                                            'Enter command to run on host',
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer
                                                .withAlpha(100),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 3,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withAlpha(150),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      OutlinedButton.icon(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        label: const Text('Cancel'),
                                        icon: const Icon(Icons.cancel),
                                      ),
                                      FilledButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        icon: const Icon(Icons.send_sharp),
                                        label: const Text('Run'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldRun != null && shouldRun) {
                                context.read<SshBloc>().add(SshRunCommandEvent(
                                    command: runCommandController.text));
                                runCommandController.text = '';
                              }
                            },
                            icon: const Icon(
                              Icons.start_sharp,
                            ),
                          ),
                        ),

                        // Kill process button
                        Positioned(
                          left: 32,
                          top: 72,
                          child: IconButton.filledTonal(
                            onPressed: () => context
                                .read<SshBloc>()
                                .add(SshKillProcessEvent()),
                            icon: const Icon(
                              Icons.stop,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
