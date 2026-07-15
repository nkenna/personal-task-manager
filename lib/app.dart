import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptm/core/navigation/app_router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerDelegate = ref.watch(appRouterDelegateProvider);
    final routeInformationParser =
        ref.watch(appRouteInformationParserProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PTM',

      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
    );
  }
}
