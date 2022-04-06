import 'package:credicxo_task/app_cubit/app_states.dart';
import 'package:credicxo_task/core/dio_helper.dart';
import 'package:credicxo_task/models/track_id_model.dart';
import 'package:credicxo_task/models/track_lyrics_model.dart';
import 'package:credicxo_task/models/track_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  TrackModel? trackModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    DioHelper.getData(url: 'chart.tracks.get').then((value) {
      //printFullText(value.data.toString());
      trackModel = trackModelFromJson(value.data);
      for (var element in trackModel!.message.body.trackList) {
        if (bookmarksIdsList.contains(element.track.trackId)) {
          favorites.addAll({element.track.trackId: true});
        } else {
          favorites.addAll({element.track.trackId: false});
        }
      }

      emit(SuccessHomeDataState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ErrorHomeDataState());
    });
  }

  TrackIdModel? trackIdModel;
  void getTrackID({required int trackId}) {
    trackIdModel = null;
    DioHelper.getData(
      url: 'track.get',
      trackId: trackId.toString(),
    ).then((value) {
      //printFullText(value.data.toString());
      trackIdModel = trackIdModelFromJson(value.data);

      emit(SuccessTrackIDState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ErrorTrackIDState());
    });
  }

  TrackLyrics? trackLyrics;
  void getTrackLyrics({required int trackId}) {
    trackLyrics = null;
    DioHelper.getData(
      url: 'track.lyrics.get',
      trackId: trackId.toString(),
    ).then((value) {
      //printFullText(value.data.toString());
      trackLyrics = trackLyricsFromJson(value.data);

      emit(SuccessTrackLyricsState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ErrorTrackLyricsState());
    });
  }

  late Database database;

  void createDatabase() {
    openDatabase('bookmarks.db', version: 1, onCreate: (database, version) {
      debugPrint('Database Created');
      database
          .execute('CREATE TABLE tracks (id INTEGER PRIMARY KEY,'
              ' trackName TEXT , albumName TEXT , artistName TEXT )')
          .then((value) {
        debugPrint('Table Created');
      }).catchError((error) {
        debugPrint('Error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      debugPrint('Database Opened');
    }).then((value) {
      database = value;
      emit(AppCreatDatabaseState());
    });
  }

  insertToDatabase({
    required int trackId,
    required String trackName,
    required String albumName,
    required String artistName,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tracks (id, trackName, albumName, artistName) VALUES ("$trackId", "$trackName", "$albumName", "$artistName")',
      )
          .then((value) {
        debugPrint('$value Inserted Done');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        for (var track in bookmarksMap) {
          if (track['id'] == trackId) {
            deleteData(id: trackId);
          }
        }
        //debugPrint('Error when inserted ${error.toString()}');
      });
    }).then((value) => getHomeData());
  }

  List<Map> bookmarksMap = [];
  List<int> bookmarksIdsList = [];

  void getDataFromDatabase(database) {
    bookmarksMap = [];
    bookmarksIdsList = [];

    database.rawQuery('SELECT * FROM tracks').then((value) {
      value.forEach((element) {
        bookmarksMap.add(element);
        bookmarksIdsList.add(element['id']);
      });

      emit(AppGetDatabaseState());
      debugPrint('bookmarksMap ' + bookmarksMap.toString());
      debugPrint('bookmarksIdsList ' + bookmarksIdsList.toString());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tracks WHERE id =?',
      [id],
    ).then((value) {
      debugPrint(id.toString() + ' deleted');
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
    });
  }
}
