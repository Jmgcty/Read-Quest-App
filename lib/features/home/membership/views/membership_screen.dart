import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:read_quest/core/constants/app_colors.dart';
import 'package:read_quest/core/services/shared_preferences/shared_pref_helper.dart';
import 'package:read_quest/features/auth/login/views/login_screen.dart';
import 'package:read_quest/shared/widgets/stroke_button.dart';

import '../../../../core/loader/loading_provider.dart';
import '../../../../core/provider/user_id_provider.dart';
import '../../../../core/services/database/institution/institution_provider.dart';
import '../../../../core/services/database/institution/institution_service.dart';
import '../../../../core/services/shared_preferences/shared_pref_enum.dart';
import '../../../../core/utils/membership_result.dart';
import '../../../../core/utils/user_role.dart';

import '../../../../core/widgets/dialogs/cancellation_modal.dart';
import '../../../../routing/route_names.dart';
import '../provider/form_provider.dart';
import '../widgets/membership_modal.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  const MembershipScreen({super.key});

  @override
  ConsumerState<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    final userID = ref.read(userIDProvider.notifier);
    int id = await SharedPrefHelper.get(SharedPrefKey.userID) ?? 0;
    userID.setUserID(id);
  }

  @override
  Widget build(BuildContext context) {
    final userID = ref.watch(userIDProvider);
    final institutionProvider = ref.watch(getUserInstitutionProvider(userID));

    //
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: institutionProvider.when(
            data: (data) {
              log(data.toString());
              if (data['message'] == MembershipResult.reject.message) {
                return const RejectedInstitutionScreen();
              }
              if (data['message'] == MembershipResult.review.message) {
                return AcceptedInstitutionScreen(
                    data: data['data'], instituteKey: data['key']);
              }

              return const NoInstitutionScreen();
            },
            error: (error, stackTrace) => Text('Error: $error'),
            loading: () => const Center(
              child: Text('error'),
            ),
          ),
        ),
      ),
    );
  }
}

class NoInstitutionScreen extends ConsumerStatefulWidget {
  const NoInstitutionScreen({super.key});

  @override
  ConsumerState<NoInstitutionScreen> createState() =>
      _NoInstitutionScreenState();
}

class _NoInstitutionScreenState extends ConsumerState<NoInstitutionScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Start at Joining To Your Organization',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge!.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(size.height * 0.02),
        Text(
          'To register your account with the organization, please request the access key from your administrator.',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall!.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        ),
        Gap(size.height * 0.05),
        CStrokeButton(
          textStyle: theme.textTheme.titleLarge!.copyWith(
            color: AppColors.secondary,
          ),
          title: 'Join Organization',
          onPressed: () async {
            await showAssignKeyDialog(context);
          },
        ),
      ],
    );
  }
}

class PendingInstitutionScreen extends ConsumerStatefulWidget {
  const PendingInstitutionScreen({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  ConsumerState<PendingInstitutionScreen> createState() =>
      _PendingInstitutionScreenState();
}

class _PendingInstitutionScreenState
    extends ConsumerState<PendingInstitutionScreen> {
  //
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your request join is Pending for approval',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge!.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(size.height * 0.02),
        Text(
          'To finish your registration, please wait for the administrator to approve your request.',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall!.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        ),
        Gap(size.height * 0.05),
        CStrokeButton(
          textStyle: theme.textTheme.titleLarge!.copyWith(
            color: AppColors.error,
          ),
          title: 'Cancel',
          onPressed: () async {
            final confirmed = await showCancelConfirmationModal(context);

            final loading = ref.read(loadingProvider.notifier);
            if (confirmed == true) {
              //
              loading.setLoading(true);
              await InstitutionService.cancelMembershipRequest(
                  widget.data['user_id']);
              loading.setLoading(false);

              //
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Membership request canceled successfully!'),
                ),
              );
              ref.refresh(getUserInstitutionProvider(widget.data['user_id']));
            }
          },
        ),
      ],
    );
  }
}

class RejectedInstitutionScreen extends StatelessWidget {
  const RejectedInstitutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your request join has been rejected',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge!.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(size.height * 0.02),
        Text(
          'Please make sure your ID is correct and try again. Or contact your administrator.',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall!.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        ),
        Gap(size.height * 0.05),
        CStrokeButton(
          textStyle: theme.textTheme.titleLarge!.copyWith(
            color: AppColors.secondary,
          ),
          title: 'Retry Joining',
          onPressed: () async {
            // await showAssignKeyDialog(context, ref);
          },
        ),
      ],
    );
  }
}

class AcceptedInstitutionScreen extends StatelessWidget {
  const AcceptedInstitutionScreen(
      {super.key, required this.data, required this.instituteKey});

  final Map<String, dynamic> data;

  final String instituteKey;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your request join has been accepted',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge!.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(size.height * 0.02),
        Text(
          'Please click the button below to join your organization.',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall!.copyWith(
            color: AppColors.textLabel,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
        ),
        Gap(size.height * 0.05),
        CStrokeButton(
          textStyle: theme.textTheme.titleLarge!.copyWith(
            color: AppColors.secondary,
          ),
          title: 'Continue',
          onPressed: () async {
            if (data['role'] == 'student') {
              await SharedPrefHelper.set(
                  SharedPrefKey.institutionKey, instituteKey);
              await SharedPrefHelper.set(SharedPrefKey.userRole, data['role']);
              await SharedPrefHelper.set(SharedPrefKey.userID, data['user_id']);
              //
              context.goNamed(RouteNames.home.name);
            } else {
              await SharedPrefHelper.set(
                  SharedPrefKey.institutionKey, instituteKey);
              await SharedPrefHelper.set(SharedPrefKey.userRole, data['role']);
              await SharedPrefHelper.set(SharedPrefKey.userID, data['user_id']);
              //
              context.goNamed(RouteNames.dashboard.name);
            }
          },
        ),
      ],
    );
  }
}
