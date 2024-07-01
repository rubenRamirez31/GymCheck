import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gym_check/src/components/app_text_form_field.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';
import 'package:gym_check/src/screens/authentication/email_verification_page.dart';
import 'package:gym_check/src/services/auth_service.dart';
import 'package:gym_check/src/services/firebase_services.dart';
import 'package:gym_check/src/utils/common_widgets/gradient_background.dart';
import 'package:gym_check/src/values/app_colors.dart';
import 'package:gym_check/src/values/app_constants.dart';
import 'package:gym_check/src/values/app_regex.dart';
import 'package:gym_check/src/values/app_strings.dart';
import 'package:gym_check/src/values/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
    final AuthService _authService = AuthService(); // Instancia de AuthService


  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController nicknameController;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    nicknameController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()..addListener(controllerListener);
    confirmPasswordController = TextEditingController()..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    nicknameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;
    final nickname = nicknameController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty && nickname.isEmpty && password.isEmpty && confirmPassword.isEmpty) return;

    if (AppRegex.emailRegex.hasMatch(email) &&
        AppRegex.passwordRegex.hasMatch(password) &&
        AppRegex.passwordRegex.hasMatch(confirmPassword)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
  }

  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<void> registrarUsuario() async {
    SmartDialog.showLoading(msg: "Cargando");
    bool resNick = await _authService.checkNick(nicknameController.text);

    if (resNick) {
      SmartDialog.dismiss();
      SmartDialog.showToast("Nombre de usuario en uso");
    } else {
      String? res = await _authService.crearUsuario(emailController.text, passwordController.text);

      if (res == 'Este correo ya esta en uso') {
        SmartDialog.dismiss();
        SmartDialog.showToast(res!);
      } else {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          SmartDialog.dismiss();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => EmailVerificationPage(user: user),
          ));
        } else {
          SmartDialog.dismiss();
          SmartDialog.showToast("Error al crear el usuario. Inténtalo de nuevo.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const GradientBackground(
            children: [
              Text(AppStrings.register, style: AppTheme.titleLarge),
              SizedBox(height: 6),
              Text(AppStrings.createYourAccount, style: AppTheme.bodySmall),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextFormField(
                    textStyle: const TextStyle(color: Colors.black),
                    labelText: AppStrings.email,
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.pleaseEnterEmailAddress
                          : AppConstants.emailRegex.hasMatch(value)
                              ? null
                              : AppStrings.invalidEmailAddress;
                    },
                  ),
                  AppTextFormField(
                    textStyle: const TextStyle(color: Colors.black),
                    textInputAction: TextInputAction.next,
                    labelText: 'Usuario',
                    keyboardType: TextInputType.text,
                    controller: nicknameController,
                    maxLength: 15,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.nickname
                          : AppConstants.nickRegex.hasMatch(value)
                              ? null
                              : AppStrings.invalidNickName;
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: passwordNotifier,
                    builder: (_, passwordObscure, __) {
                      return AppTextFormField(
                        textStyle: const TextStyle(color: Colors.black),
                        obscureText: passwordObscure,
                        controller: passwordController,
                        labelText: AppStrings.password,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? AppStrings.pleaseEnterPassword
                              : AppConstants.passwordRegex.hasMatch(value)
                                  ? null
                                  : AppStrings.invalidPassword;
                        },
                        suffixIcon: Focus(
                          descendantsAreFocusable: false,
                          child: IconButton(
                            onPressed: () => passwordNotifier.value = !passwordObscure,
                            style: IconButton.styleFrom(minimumSize: const Size.square(48)),
                            icon: Icon(
                              passwordObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: confirmPasswordNotifier,
                    builder: (_, confirmPasswordObscure, __) {
                      return AppTextFormField(
                        textStyle: const TextStyle(color: Colors.black),
                        labelText: AppStrings.confirmPassword,
                        controller: confirmPasswordController,
                        obscureText: confirmPasswordObscure,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_) => _formKey.currentState?.validate(),
                        validator: (value) {
                          return value!.isEmpty
                              ? AppStrings.pleaseReEnterPassword
                              : AppConstants.passwordRegex.hasMatch(value)
                                  ? passwordController.text == confirmPasswordController.text
                                      ? null
                                      : AppStrings.passwordNotMatched
                                  : AppStrings.invalidPassword;
                        },
                        suffixIcon: Focus(
                          descendantsAreFocusable: false,
                          child: IconButton(
                            onPressed: () => confirmPasswordNotifier.value = !confirmPasswordObscure,
                            style: IconButton.styleFrom(minimumSize: const Size.square(48)),
                            icon: Icon(
                              confirmPasswordObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: fieldValidNotifier,
                    builder: (_, isValid, __) {
                      return FilledButton(
                        onPressed: isValid ? registrarUsuario : null,
                        child: const Text(
                          AppStrings.register,
                          style: TextStyle(color: AppColors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.iHaveAnAccount,
                style: AppTheme.bodySmall.copyWith(color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
                },
                child: const Text(
                  AppStrings.login,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
