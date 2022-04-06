import 'package:credicxo_task/app_cubit/app_cubit.dart';
import 'package:credicxo_task/app_cubit/app_states.dart';
import 'package:credicxo_task/core/functions.dart';
import 'package:credicxo_task/screens/bookmark_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Widget buildDrawerListItems({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    Function()? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(leadingIcon, color: Colors.redAccent),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemsDivider() {
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Column(
                children: [
                  SizedBox(height: 40, child: Container()),
                  buildDrawerListItems(
                    leadingIcon: Icons.favorite_outlined,
                    title: 'Bookmarks`',
                    onTap: () {
                      navigateTo(context, const BookmarkPage());
                    },
                  ),
                  buildDrawerListItemsDivider(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
