import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/auth_screens.dart';
import '../features/onboarding/screens/onboarding_screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/', redirect: (_, _) => '/splash'),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (_, _) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding-one',
      name: 'onboarding-one',
      builder: (_, _) => const OnboardingOneScreen(),
    ),
    GoRoute(
      path: '/onboarding-two',
      name: 'onboarding-two',
      builder: (_, _) => const OnboardingTwoScreen(),
    ),
    GoRoute(
      path: '/choose-role',
      name: 'choose-role',
      builder: (_, _) => const ChooseRoleScreen(),
    ),
    GoRoute(
      path: '/student-signup',
      name: 'student-signup',
      builder: (_, _) => const StudentSignupScreen(),
    ),
    GoRoute(
      path: '/email-verification',
      name: 'email-verification',
      builder: (_, _) => const EmailVerificationScreen(),
    ),
    GoRoute(
      path: '/student-login',
      name: 'student-login',
      builder: (_, _) => const StudentLoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (_, _) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (_, _) => const ResetPasswordScreen(),
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    body: Center(child: Text('Không tìm thấy trang: ${state.uri.path}')),
  ),
);
