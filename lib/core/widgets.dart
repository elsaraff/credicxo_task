import 'package:credicxo_task/core/functions.dart';
import 'package:credicxo_task/models/track_model.dart';
import 'package:credicxo_task/screens/details_page.dart';
import 'package:flutter/material.dart';

Widget buildTrendingSong(
  bool bookmarkScreen,
  appCubit,
  context,
  TrackList trackList,
  bookmarks,
) {
  return InkWell(
    onTap: () {
      if (bookmarkScreen) {
        appCubit.getTrackID(trackId: bookmarks['id']);
        appCubit.getTrackLyrics(trackId: bookmarks['id']);
      } else {
        appCubit.getTrackID(trackId: trackList.track.trackId);
        appCubit.getTrackLyrics(trackId: trackList.track.trackId);
      }

      navigateTo(context, const DetailsPage());
    },
    child: SizedBox(
      height: 90,
      child: Row(children: [
        const Expanded(
          flex: 1,
          child: Icon(
            Icons.library_music_rounded,
            size: 35,
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      bookmarkScreen
                          ? bookmarks['trackName']
                          : trackList.track.trackName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 5),
                  Text(
                      bookmarkScreen
                          ? bookmarks['albumName']
                          : trackList.track.albumName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      )),
                ]),
          ),
        ),
        Expanded(
            flex: 2,
            child: Text(
                bookmarkScreen
                    ? bookmarks['artistName']
                    : trackList.track.artistName,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                ))),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              if (bookmarkScreen) {
                appCubit.insertToDatabase(
                  trackName: bookmarks['trackName'],
                  albumName: bookmarks['albumName'],
                  artistName: bookmarks['artistName'],
                  trackId: bookmarks['id'],
                );
              } else {
                appCubit.insertToDatabase(
                  trackName: trackList.track.trackName,
                  albumName: trackList.track.albumName,
                  artistName: trackList.track.artistName,
                  trackId: trackList.track.trackId,
                );
              }
            },
            icon: bookmarkScreen
                ? const Icon(
                    Icons.favorite_outlined,
                    color: Colors.redAccent,
                    size: 35,
                  )
                : appCubit.favorites[trackList.track.trackId]
                    ? const Icon(
                        Icons.favorite_outlined,
                        color: Colors.redAccent,
                        size: 35,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        size: 35,
                      ),
          ),
        ),
        const SizedBox(width: 10),
      ]),
    ),
  );
}

Widget myDivider() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      color: Colors.grey,
      height: 2,
    ),
  );
}
