import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/app_frame.dart';
import '../features/foundation/foundation_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'foundation',
      builder: (context, state) => const FoundationScreen(),
    ),
  ],
  errorBuilder: (context, state) => AppFrame(
    title: 'CareerMatch AI',
    body: Center(child: Text('Không tìm thấy trang: ${state.uri.path}')),
  ),
);
