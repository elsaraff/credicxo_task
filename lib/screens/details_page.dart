import 'dart:async';
import 'package:credicxo_task/core/functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:credicxo_task/app_cubit/app_cubit.dart';
import 'package:credicxo_task/app_cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  ConnectivityResult? _connectivityResult;
  late StreamSubscription _connectivitySubscription;

  @override
  initState() {
    super.initState();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      debugPrint('Current connectivity status: $result');
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Details'),
        centerTitle: false,
      ),
      body: _connectivityResult?.toValue() == 'none'
          ? const Center(child: Text('No Internet Connection'))
          : BlocConsumer<AppCubit, AppStates>(
              listener: (context, state) {},
              builder: (context, state) {
                if (AppCubit.get(context).trackIdModel == null ||
                    AppCubit.get(context).trackLyrics == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var trackId =
                      AppCubit.get(context).trackIdModel!.message.body.track;
                  var trackLyrics = AppCubit.get(context)
                      .trackLyrics!
                      .message
                      .body
                      .lyrics
                      .lyricsBody
                      .toString();
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(trackId.trackName,
                              style: const TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          const Text(
                            'Artist:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(trackId.artistName,
                              style: const TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          const Text(
                            'Album Name:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(trackId.albumName,
                              style: const TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          const Text(
                            'Explicit:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(trackId.explicit == 1 ? 'True' : 'False',
                              style: const TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          const Text(
                            'Rating:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(trackId.trackRating.toString() + '%',
                              style: const TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          const Text(
                            'Lyrics:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(trackLyrics,
                              style: const TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
