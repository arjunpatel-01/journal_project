import 'package:go_router/go_router.dart';
import 'package:journal_project/pages/create_update_form.dart';
import 'package:journal_project/pages/home.dart';

class MyAppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: 'createorupdate',
      path: '/createorupdate',
      builder: (context, state) =>
          CreateOrUpdatePage(id: state.pathParameters['id']),
    ),
  ]);
}
