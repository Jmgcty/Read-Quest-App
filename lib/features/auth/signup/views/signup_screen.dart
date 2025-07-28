import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/core/services/authentication/auth_helper.dart';
import 'package:read_quest/core/utils/validators.dart';
import 'package:read_quest/core/widgets/dialogs/success_modal.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/loader/loading_provider.dart';
import '../../../../core/utils/formatter.dart';
import '../../../../core/widgets/dialogs/error_dialog.dart';
import '../../../../routing/route_names.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../provider/signup_form_provider.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: theme.colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed:
                isLoading ? null : () => context.goNamed(RouteNames.login.name),
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
                  SignupHeader(),
                  Gap(32),
                  SignupFormFields(),
                  Gap(32),
                  SignupFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          'CREATE ACCOUNT',
          style: theme.textTheme.headlineMedium!.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(size.height * 0.01),
        Text(
          'Please fill in the required fields...',
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

class SignupFormFields extends ConsumerStatefulWidget {
  const SignupFormFields({super.key});

  @override
  ConsumerState<SignupFormFields> createState() => _SignupFormFieldsState();
}

class _SignupFormFieldsState extends ConsumerState<SignupFormFields> {
  String? nameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    if (!validateName(value)) {
      return 'Name must contain only letters and spaces';
    }

    return null;
  }

  String? emailValidator(value) {
    final validationError = ref.watch(signupServerValidationProvider);
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!validateEmail(value)) {
      return 'Please enter a valid email';
    }

    if (validationError.isNotEmpty && validationError['email'] != null) {
      return formatToUppercaseFirstLetter(validationError['email']);
    }

    return null;
  }

  String? passwordValidator(value) {
    final validationError = ref.watch(signupServerValidationProvider);
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (!validatePasswordLength(value)) {
      return 'Password must be at least 6 characters long';
    }

    if (validationError.isNotEmpty && validationError['password'] != null) {
      return formatToUppercaseFirstLetter(validationError['password']);
    }

    return null;
  }

  String? confirmPasswordValidator(value) {
    final validationError = ref.watch(signupServerValidationProvider);
    final password = ref.watch(passwordControllerProvider).text;
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (!validatePasswordMatch(value, password)) {
      return 'Passwords do not match';
    }

    if (validationError.isNotEmpty &&
        validationError['password_confirmation'] != null) {
      return formatToUppercaseFirstLetter(
          validationError['password_confirmation']);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // PROVIDERS
    final signupFormKey = ref.watch(signUpFormKeyProvider);
    final nameController = ref.watch(nameControllerProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final confirmPasswordController =
        ref.watch(confirmPasswordControllerProvider);

    final showPassword = ref.watch(signupShowPasswordProvider);
    final showPasswordToggle = ref.read(signupShowPasswordProvider.notifier);
    final isLoading = ref.watch(loadingProvider);

    //
    return Form(
      key: signupFormKey,
      child: Column(
        children: [
          TextFormField(
            readOnly: isLoading,
            controller: nameController,
            keyboardType: TextInputType.name,
            cursorColor: AppColors.textLabel,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              prefixIconColor: AppColors.textLabel,
              labelText: 'Name',
            ),
            validator: nameValidator,
          ),
          Gap(size.height * 0.016),
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
                  onTap: () => showPasswordToggle.toggle()),
              suffixIconColor: AppColors.textLabel,
              labelText: 'Password',
            ),
            validator: passwordValidator,
          ),
          Gap(size.height * 0.016),
          TextFormField(
            readOnly: isLoading,
            controller: confirmPasswordController,
            obscureText: !showPassword,
            cursorColor: AppColors.textLabel,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              prefixIconColor: AppColors.textLabel,
              suffixIcon: GestureDetector(
                  child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off),
                  onTap: () => showPasswordToggle.toggle()),
              suffixIconColor: AppColors.textLabel,
              labelText: 'Confirm Password',
            ),
            validator: confirmPasswordValidator,
          ),
        ],
      ),
    );
  }
}

class SignupFooter extends ConsumerStatefulWidget {
  const SignupFooter({super.key});

  @override
  ConsumerState<SignupFooter> createState() => _SignupFooterState();
}

class _SignupFooterState extends ConsumerState<SignupFooter> {
  void signUp() async {
    final signupFormKey = ref.watch(signUpFormKeyProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final nameController = ref.watch(nameControllerProvider);
    final confirmPasswordController =
        ref.watch(confirmPasswordControllerProvider);

    final loading = ref.read(loadingProvider.notifier);

    if (!signupFormKey.currentState!.validate()) {
      loading.setLoading(false);
      return;
    }

    loading.setLoading(true);

    final value = await AuthHelper.signup(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        confirmPassword: confirmPasswordController.text);

    //
    if (value['status'] == 'success') {
      loading.setLoading(false);
      signupFormKey.currentState!.reset();
      await showSuccessDialog(context, 'Successfully signed up!');
      context.goNamed(RouteNames.login.name);
    }
    final validationError = ref.read(signupServerValidationProvider.notifier);
    validationError.reset();
    if (value['status'] == 'failed') {
      validationError.setError(value['errors']);
      loading.setLoading(false);
      signupFormKey.currentState!.validate();
    }
    if (value['status'] == 'error') {
      loading.setLoading(false);
      await showErrorDialog(context, value['message']);
    }

    signupFormKey.currentState!.validate();
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
          textStyle:
              theme.textTheme.titleLarge!.copyWith(color: AppColors.white),
          title: isLoading ? 'Signing up...' : 'Sign up',
          onPressed: signUp,
        ),
        const Gap(24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      context.goNamed(RouteNames.login.name);
                    },
              child: const Text('Log in'),
            ),
          ],
        ),
      ],
    );
  }
}
