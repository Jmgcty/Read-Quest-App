import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/routing/route_names.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/shared_preferences/shared_pref_enum.dart';
import '../../../core/services/shared_preferences/shared_pref_helper.dart';
import '../../../shared/widgets/primary_button.dart';

class GetStartedScreen extends ConsumerWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    //
    void getStart() async {
      context.goNamed(RouteNames.login.name);
      // await SharedPrefHelper.set(SharedPrefKey.isGetStarted, true);
    }

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        primary: true,
        backgroundColor: theme.colorScheme.primary,
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.05),
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.6,
              image: AssetImage('assets/images/app_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svgs/bird_cartoon.svg',
                  width: size.width * 0.54,
                ),
                Gap(size.width * 0.02),
                SvgPicture.asset(
                  'assets/svgs/app_name.svg',
                  width: size.width * 0.70,
                ),
                Gap(size.width * 0.2),
                CPrimaryButton(
                  title: 'Get Started',
                  backgroundColor: theme.colorScheme.secondary,
                  onPressed: () => getStart(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
