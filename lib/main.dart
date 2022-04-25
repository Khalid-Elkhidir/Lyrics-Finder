import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/album_cubit/album_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/artists_cubit/artists_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/lyrics_bloc/lyrics_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/song_bloc/song_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/pages/splash_screen.dart';
import 'features/lyrics_finder/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SongBloc>(create: (_) => di.sl<SongBloc>()),
        BlocProvider<LyricsBloc>(create: (_) => di.sl<LyricsBloc>()),
        BlocProvider<AlbumCubit>(create: (_) => di.sl<AlbumCubit>()),
        BlocProvider<ArtistsCubit>(create: (_) => di.sl<ArtistsCubit>()),
        BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Lyrics Finder",
        theme: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme().copyWith(
              color: Colors.blue,
            ),
            colorScheme: ColorScheme.light()
                .copyWith(secondary: Colors.white, primary: Colors.blue),
            hintColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ))),
        home: SplashScreen(),
      ),
    );
  }
}
