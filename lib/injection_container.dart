import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_project/core/network/network_info.dart';
import 'package:new_project/features/lyrics_finder/data/data_sources/local_data_source.dart';
import 'package:new_project/features/lyrics_finder/data/data_sources/remote_data_source.dart';
import 'package:new_project/features/lyrics_finder/data/repositories/auth_repository_impl.dart';
import 'package:new_project/features/lyrics_finder/data/repositories/lyrics_repository_impl.dart';
import 'package:new_project/features/lyrics_finder/data/repositories/song_repositoy_impl.dart';
import 'package:new_project/features/lyrics_finder/domain/repositories/auth_repository.dart';
import 'package:new_project/features/lyrics_finder/domain/repositories/lyrics_repository.dart';
import 'package:new_project/features/lyrics_finder/domain/repositories/songs_repository.dart';
import 'package:new_project/features/lyrics_finder/domain/usecases/get_albums.dart';
import 'package:new_project/features/lyrics_finder/domain/usecases/get_artists.dart';
import 'package:new_project/features/lyrics_finder/domain/usecases/get_lyrics.dart';
import 'package:new_project/features/lyrics_finder/domain/usecases/get_songs.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/album_cubit/album_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/artists_cubit/artists_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/lyrics_bloc/lyrics_bloc.dart';
import 'package:new_project/features/lyrics_finder/presentation/bloc/song_bloc/song_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Bloc
  sl.registerFactory(() => SongBloc(getSongs: sl()));
  sl.registerFactory(() => LyricsBloc(getLyrics: sl()));
  sl.registerFactory(() => AlbumCubit(getAlbums: sl()));
  sl.registerFactory(() => ArtistsCubit(getArtists: sl()));
  sl.registerFactory(() => AuthCubit(authRepository: sl()));

  //UseCases
  sl.registerLazySingleton(() => GetSongs(repository: sl()));
  sl.registerLazySingleton(() => GetLyrics(repository: sl()));
  sl.registerLazySingleton(() => GetAlbums(repository: sl()));
  sl.registerLazySingleton(() => GetArtists(repository: sl()));

  //Repositories
  sl.registerLazySingleton<SongsRepository>(() => SongRepositoryImpl(sl()));
  sl.registerLazySingleton<LyricsRepository>(() => LyricsRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        networkInfo: sl(),
        remoteDataSource: sl(),
        sharedPreferences: sl(),
      ));

  //DataSources
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  sl.registerFactory<RemoteDataSource>(
      () => RemoteDataSourceImpl(sharedPreferences: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => sharedPreferences);
}
