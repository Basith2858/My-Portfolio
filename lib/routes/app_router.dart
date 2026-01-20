import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/projects/project_detail_screen.dart';
import '../screens/projects/projects_list_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const ProjectsListScreen(),
    ),
    GoRoute(
      path: '/project/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return ProjectDetailScreen(projectId: id ?? '');
      },
    ),
  ],
  errorBuilder: (context, state) =>
      const Scaffold(body: Center(child: Text('Page not found'))),
);
