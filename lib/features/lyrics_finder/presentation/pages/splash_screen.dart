import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_project/core/permissions/permissions.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/album_cubit/album_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/artists_cubit/artists_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/auth_cubit/auth_cubit.dart';

import '../bloc/song_bloc/song_bloc.dart';
import 'main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  late AuthCubit authCubit;
  bool? visible;
  bool isSnackBarShown = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!authCubit.authNeed()) {
        BlocProvider.of<SongBloc>(context).add(LoadSongs());
        setState(() {
          visible = false;
        });
        {
          Timer(
            const Duration(seconds: 1),
            () {
              navigateToMainPage();
            },
          );
        }
      }
    }
  }

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
    visible = authCubit.authNeed();
    print(visible);
    Permissions permissions = Permissions();
    permissions.permissionServicesCall().then(
      (value) {
        if (value) {
          if (!authCubit.authNeed()) {
            BlocProvider.of<SongBloc>(context).add(LoadSongs());
            Timer(
              const Duration(seconds: 3),
              () {
                navigateToMainPage();
              },
            );
          }
        }
      },
    );
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (authCubit.subscription() != null) {
      authCubit.subscription()!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthDone) {
            BlocProvider.of<SongBloc>(context).add(LoadSongs());
            navigateToMainPage();
          }
          if (state is AuthError) {
            if (!isSnackBarShown) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.message,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 18,
                            ),
                          ),
                          const Icon(Icons.wifi_off)
                        ],
                      ),
                      backgroundColor: Colors.white,
                    ),
                  )
                  .closed
                  .then((value) {
                isSnackBarShown = false;
              });
            }
          }
        },
        builder: (context, state) {
          return Body(size);
        },
      ),
    );
  }

  void navigateToMainPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()));
  }

  Widget Body(Size size) {
    return Container(
      padding: EdgeInsets.only(top: size.height * 0.2),
      width: double.maxFinite,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            maintainSize: false,
            visible: !visible!,
            child: Expanded(
              child: SvgPicture.asset(
                "assets/icons/music.svg",
                color: Colors.white,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: visible! ? size.height * 0.5 : size.height * 0.4,
                child: Column(
                  children: const [
                    Text(
                      "LYRICS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 61,
                        fontFamily: "Jomolhari",
                        letterSpacing: 5,
                      ),
                    ),
                    Text(
                      "FINDER",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 61,
                        fontFamily: "Josefin Sans",
                        fontWeight: FontWeight.w100,
                        letterSpacing: 5,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: visible!,
                child: ElevatedButton(
                  onPressed: () {
                    authCubit.launchUrl();
                    authCubit.initUniLinks();
                  },
                  style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    )),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(0),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.all(10)),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
