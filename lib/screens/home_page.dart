import 'dart:async';
import 'package:credicxo_task/core/functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:credicxo_task/app_cubit/app_cubit.dart';
import 'package:credicxo_task/app_cubit/app_states.dart';
import 'package:credicxo_task/core/widgets.dart';
import 'package:credicxo_task/screens/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: const Text('Trending'),
      ),
      drawer: const MyDrawer(),
      body: _connectivityResult?.toValue() == 'none'
          ? const Center(child: Text('No Internet Connection'))
          : BlocConsumer<AppCubit, AppStates>(
              listener: (context, state) {},
              builder: (context, state) {
                var appCubit = AppCubit.get(context);
                if (appCubit.trackModel == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildTrendingSong(
                                false,
                                appCubit,
                                context,
                                appCubit
                                    .trackModel!.message.body.trackList[index],
                                appCubit.bookmarksMap,
                              ),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: appCubit
                              .trackModel!.message.body.trackList.length),
                    ),
                  );
                }
              },
            ),
    );
  }
}
