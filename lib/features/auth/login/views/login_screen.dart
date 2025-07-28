import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/core/utils/formatter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/loader/loading_provider.dart';
import '../../../../core/services/authentication/auth_helper.dart';
import '../../../../core/services/shared_preferences/shared_pref_enum.dart';
import '../../../../core/services/shared_preferences/shared_pref_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/dialogs/error_dialog.dart';
import '../../../../core/widgets/dialogs/success_modal.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../provider/login_form_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed:
                isLoading ? null : () => context.goNamed(RouteNames.root.name),
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.008,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.6,
              image: AssetImage('assets/images/app_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.only(
                top: size.width * 0.14,
                left: size.width * 0.06,
                right: size.width * 0.06,
                bottom: size.width * 0.06,
              ),
              child: const Column(
                children: [
                  LoginHeader(),
                  Gap(32),
                  LoginFormFields(),
                  Gap(32),
                  LoginFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          'LOGIN ACCOUNT',
          style: theme.textTheme.headlineMedium!.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(size.height * 0.01),
        Text(
          'Please enter your existing account..',
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.normal,
            color: AppColors.textLabel,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class LoginFormFields extends ConsumerStatefulWidget {
  const LoginFormFields({super.key});

  @override
  ConsumerState<LoginFormFields> createState() => _LoginFormFieldsState();
}

class _LoginFormFieldsState extends ConsumerState<LoginFormFields> {
  String? emailValidator(String? value) {
    final validationError = ref.watch(loginServerValidationProvider);

    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }

    if (!validateEmail(value)) {
      return 'Please enter a valid email address';
    }

    if (validationError.isNotEmpty && validationError['email'] != null) {
      return formatToUppercaseFirstLetter(validationError['email']);
    }
    return null;
  }

  String? passwordValidator(String? value) {
    final validationError = ref.watch(loginServerValidationProvider);
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (validationError.isNotEmpty && validationError['password'] != null) {
      return formatToUppercaseFirstLetter(validationError['password']);
    }
    return null;
  }

  //
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // PROVIDERS
    final loginFormKey = ref.watch(loginFormKeyProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final showPassword = ref.watch(loginShowPasswordProvider);

    final isLoading = ref.watch(loadingProvider);

    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          TextFormField(
            readOnly: isLoading,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: AppColors.textLabel,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              prefixIconColor: AppColors.textLabel,
              labelText: 'Email',
            ),
            validator: emailValidator,
          ),
          Gap(size.height * 0.016),
          TextFormField(
            readOnly: isLoading,
            controller: passwordController,
            obscureText: !showPassword,
            cursorColor: AppColors.textLabel,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              prefixIconColor: AppColors.textLabel,
              suffixIcon: GestureDetector(
                child: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off),
                onTap: () =>
                    ref.read(loginShowPasswordProvider.notifier).toggle(),
              ),
              labelText: 'Password',
            ),
            validator: passwordValidator,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textLabel,
              ),
              onPressed: isLoading ? null : () {},
              child: const Text('Forgot Password?'),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginFooter extends ConsumerStatefulWidget {
  const LoginFooter({super.key});

  @override
  ConsumerState<LoginFooter> createState() => _LoginFooterState();
}

class _LoginFooterState extends ConsumerState<LoginFooter> {
  void login() async {
    final loginFormKey = ref.watch(loginFormKeyProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);

    //
    final loading = ref.read(loadingProvider.notifier);

    if (!loginFormKey.currentState!.validate()) {
      loading.setLoading(false);
      return;
    }

    loading.setLoading(true);
    final value = await AuthHelper.login(
      email: emailController.text,
      password: passwordController.text,
    );

    //
    if (value['status'] == 'success') {
      await SharedPrefHelper.set(
          SharedPrefKey.session, value['data']['session_token']);

      await SharedPrefHelper.set(
          SharedPrefKey.userID, value['data']['user_id']);
      //
      await showSuccessDialog(context, 'Successfully logged in!');
      loading.setLoading(false);
      context.goNamed(RouteNames.membership.name);
      return;
    }

    //
    final validationError = ref.watch(loginServerValidationProvider.notifier);
    validationError.reset();
    //
    if (value['status'] == 'failed') {
      loading.setLoading(false);

      validationError.setError(value['errors']);
      loginFormKey.currentState!.validate();
      return;
    }

    await showErrorDialog(
        context, formatToUppercaseFirstLetter(value['message']));
    loading.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        CPrimaryButton(
          isLoading: isLoading,
          backgroundColor: theme.colorScheme.secondary,
          textStyle: theme.textTheme.titleLarge!.copyWith(
            color: AppColors.white,
          ),
          title: isLoading ? 'Signing in...' : 'Log in',
          onPressed: login,
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don\'t have an account?'),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      context.goNamed(RouteNames.signup.name);
                    },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ],
    );
  }
}
