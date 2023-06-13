import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';

class RoverView extends StatefulWidget {
  const RoverView({
    super.key,
    required this.disconnectClient,
    required this.client,
  });

  final Function() disconnectClient;
  final SSHClient client;

  @override
  State<RoverView> createState() => _RoverViewState();
}

class _RoverViewState extends State<RoverView> {
  String _assetPath = 'assets/images/imgTest_1.jpg';

  Future<void> toggleAsset() async {
    if (_assetPath == 'assets/images/imgTest_1.jpg') {
      setState(() {
        _assetPath = 'assets/images/imgTest_2.png';
      });
    } else {
      setState(() {
        _assetPath = 'assets/images/imgTest_1.jpg';
      });
    }
    await Future.delayed(const Duration(milliseconds: 500), toggleAsset);
  }

  @override
  void initState() {
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
    toggleAsset();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool? shouldPop = await showDialog(
          context: context,
          useRootNavigator: true,
          useSafeArea: false,
          builder: (context) {
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
                    onPressed: () async {
                      await widget.disconnectClient();
                      Navigator.of(context).pop(true);
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

        if (shouldPop ?? false) {
          SystemChrome.setPreferredOrientations([]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image.asset(_assetPath),
            ),
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
                        },
                        onTapCancel: () {},
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
                        },
                        onTapCancel: () {},
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
                        },
                        onTapCancel: () {},
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
                        },
                        onTapCancel: () {},
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
