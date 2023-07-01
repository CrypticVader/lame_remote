import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lame_remote/application/ssh_bloc/ssh_bloc.dart';
import 'package:lame_remote/presentation/rover_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late TextEditingController _hostFieldController;
  late TextEditingController _portFieldController;
  late TextEditingController _usernameFieldController;
  late TextEditingController _passwordFieldController;

  @override
  void initState() {
    _hostFieldController = TextEditingController();
    _portFieldController = TextEditingController();
    _usernameFieldController = TextEditingController();
    _passwordFieldController = TextEditingController();

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
    return BlocConsumer<SshBloc, SshState>(
      listener: (context, state) async {
        if (state is SshConnectedState) {
          // Navigate to RoverView
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider<SshBloc>.value(
                value: context.read<SshBloc>(),
                child: const RoverView(),
              ),
            ),
          );
        } else {
          if (state.exception != null) {
            await showDialog(
              context: context,
              useRootNavigator: true,
              builder: (context) {
                return AlertDialog(
                  icon: const Icon(
                    Icons.error_outline_sharp,
                    size: 48,
                  ),
                  title: const Text('Error'),
                  content: Text(state.exception!),
                  actions: [
                    OutlinedButton(
                      // style: OutlinedButton.styleFrom(
                      //   minimumSize: const Size(100, 42),
                      // ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      builder: (context, state) {
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  SvgPicture.asset(
                    'assets/images/home_bg.svg',
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.tertiary.withAlpha(90),
                      BlendMode.srcIn,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AnimatedContainer(
                          height: isKeyboardVisible ? 36 : 70,
                          duration: const Duration(milliseconds: 200),
                        ),
                        Text(
                          'Lame',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withAlpha(170),
                            fontSize: isKeyboardVisible ? 40 : 68,
                            height: 0.2,
                            fontVariations: const <FontVariation>[
                              FontVariation('wght', 300)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              isKeyboardVisible ? 16 : 32.0, 0, 0, 0),
                          child: Text(
                            'Remote',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(225),
                              fontSize: isKeyboardVisible ? 36 : 68,
                              height: 0.85,
                              fontVariations: const <FontVariation>[
                                FontVariation('wght', 700)
                              ],
                            ),
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
                        TextField(
                          enabled: !state.isLoading,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          controller: _hostFieldController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: const Icon(Icons.location_on),
                            hintText: 'Enter the host address',
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.onSecondary,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(4),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withAlpha(100),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(150),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        TextField(
                          enabled: !state.isLoading,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          controller: _portFieldController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: const Icon(Icons.door_front_door_sharp),
                            hintText: 'Enter the port to be used',
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.onSecondary,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withAlpha(100),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(150),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        TextField(
                          enabled: !state.isLoading,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          controller: _usernameFieldController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: const Icon(Icons.person_2_sharp),
                            hintText: 'Enter the username of the host',
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.onSecondary,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withAlpha(100),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(150),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        TextField(
                          enabled: !state.isLoading,
                          autocorrect: false,
                          controller: _passwordFieldController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: const Icon(Icons.password_sharp),
                            hintText: 'Enter the password/key',
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.onSecondary,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                    .withAlpha(100),
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(150),
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: state.isLoading
                                    ? Container(
                                        padding: const EdgeInsets.all(6.0),
                                        constraints:
                                            const BoxConstraints(maxWidth: 130),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        child: SpinKitThreeBounce(
                                          key: ValueKey<bool>(state.isLoading),
                                          size: 30,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      )
                                    : FilledButton.icon(
                                        key: ValueKey<bool>(state.isLoading),
                                        onPressed: () => context
                                            .read<SshBloc>()
                                            .add(SshConnectEvent(
                                              host: _hostFieldController.text,
                                              port: int.tryParse(
                                                      _portFieldController
                                                          .text) ??
                                                  22,
                                              username:
                                                  _usernameFieldController.text,
                                              password:
                                                  _passwordFieldController.text,
                                            )),
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
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            FilledButton.tonalIcon(
                              onPressed: state.isLoading
                                  ? null
                                  : () {
                                      _hostFieldController.text =
                                          '192.168.8.69';
                                      _portFieldController.text = '22';
                                      _usernameFieldController.text =
                                          'pi';
                                      _passwordFieldController.text = 'raspberry';
                                    },
                              icon: const Icon(
                                  Icons.settings_backup_restore_sharp),
                              label: const Text('Use default details'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
