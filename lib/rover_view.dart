import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoverView extends StatefulWidget {
  const RoverView({super.key});

  @override
  State<RoverView> createState() => _RoverViewState();
}

class _RoverViewState extends State<RoverView> {
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
                    onPressed: () {
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
            Padding(
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
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 150,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: Icon(
                Icons.videocam_rounded,
                size: 256,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
