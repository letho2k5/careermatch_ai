import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/auth_screens.dart';
import '../features/cv/screens/cv_progress_screen.dart';
import '../features/cv/screens/cv_result_screen.dart';
import '../features/cv/screens/cv_upload_screen.dart';
import '../features/cv/screens/edit_extracted_skills_screen.dart';
import '../features/jobs/screens/job_detail_screens.dart';
import '../features/jobs/screens/job_filter_sort_screens.dart';
import '../features/jobs/screens/job_home_screen.dart';
import '../features/jobs/screens/job_search_screens.dart';
import '../features/onboarding/screens/onboarding_screens.dart';
import '../features/student_home/student_home_screen.dart';
import '../features/student_profile/screens/education_screen.dart';
import '../features/student_profile/screens/experience_screen.dart';
import '../features/student_profile/screens/profile_setup_screens.dart';
import '../features/student_profile/screens/skills_screen.dart';

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
    GoRoute(
      path: '/student-home',
      name: 'student-home',
      builder: (_, _) => const StudentHomeScreen(),
    ),
    GoRoute(
      path: '/student-profile-setup-1',
      name: 'student-profile-setup-1',
      builder: (_, _) => const ProfileSetupOneScreen(),
    ),
    GoRoute(
      path: '/student-profile-setup-2',
      name: 'student-profile-setup-2',
      builder: (_, _) => const ProfileSetupTwoScreen(),
    ),
    GoRoute(
      path: '/education',
      name: 'student-education',
      builder: (_, _) => const EducationScreen(),
    ),
    GoRoute(
      path: '/student-skills',
      name: 'student-skills',
      builder: (_, _) => const SkillsScreen(),
    ),
    GoRoute(
      path: '/student-experience',
      name: 'student-experience',
      builder: (_, _) => const ExperienceScreen(),
    ),
    GoRoute(
      path: '/cv-upload',
      name: 'cv-upload',
      builder: (_, _) => const CvUploadScreen(),
    ),
    GoRoute(
      path: '/cv-progress',
      name: 'cv-progress',
      builder: (_, _) => const CvProgressScreen(),
    ),
    GoRoute(
      path: '/cv-analysis-result',
      name: 'cv-analysis-result',
      builder: (_, _) => const CvResultScreen(),
    ),
    GoRoute(
      path: '/cv-edit-skills',
      name: 'cv-edit-skills',
      builder: (_, _) => const EditExtractedSkillsScreen(),
    ),
    GoRoute(
      path: '/jobs/home',
      name: 'job-home',
      builder: (_, _) => const JobHomeScreen(),
    ),
    GoRoute(
      path: '/jobs/search',
      name: 'job-search',
      builder: (_, state) =>
          JobSearchScreen(initialQuery: state.uri.queryParameters['q']),
    ),
    GoRoute(
      path: '/jobs/suggestions',
      name: 'job-suggestions',
      builder: (_, state) =>
          SearchSuggestionsScreen(initialQuery: state.uri.queryParameters['q']),
    ),
    GoRoute(
      path: '/jobs/results',
      name: 'job-results',
      builder: (_, _) => const JobSearchResultsScreen(),
    ),
    GoRoute(
      path: '/jobs/filters',
      name: 'job-filters',
      builder: (_, _) => const JobFiltersScreen(),
    ),
    GoRoute(
      path: '/jobs/sort',
      name: 'job-sort',
      builder: (_, _) => const JobSortScreen(),
    ),
    GoRoute(
      path: '/jobs/recommended',
      name: 'recommended-jobs',
      builder: (_, _) => const RecommendedJobsScreen(),
    ),
    GoRoute(
      path: '/companies/:companyId',
      name: 'company-detail',
      builder: (_, state) =>
          CompanyDetailScreen(companyId: state.pathParameters['companyId']!),
    ),
    GoRoute(
      path: '/jobs/:jobId/match',
      name: 'match-explanation',
      builder: (_, state) =>
          MatchExplanationScreen(jobId: state.pathParameters['jobId']!),
    ),
    GoRoute(
      path: '/jobs/:jobId',
      name: 'job-detail',
      builder: (_, state) =>
          JobDetailScreen(jobId: state.pathParameters['jobId']!),
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    body: Center(child: Text('Không tìm thấy trang: ${state.uri.path}')),
  ),
);
