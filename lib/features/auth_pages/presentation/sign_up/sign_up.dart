import 'package:clew_app/core/ui/unfocused_widget.dart';
import 'package:clew_app/features/auth_pages/presentation/bloc/bloc/auth_bloc.dart';
import 'package:clew_app/features/auth_pages/presentation/sign_in/sign_in.dart';
import 'package:clew_app/features/home_page/presentation/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AppUnfocuser(child: HomePage())));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is UnAuthenticated) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 230,
                          height: 230,
                          child: Image.asset('assets/images/logo.jpg'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "РЕГИСТРАЦИЯ",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    hintText: "Имя",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    hintText: "Почта",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null &&
                                            !EmailValidator.validate(value)
                                        ? "Введите корректную почту"
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    hintText: "Пароль",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null && value.length < 6
                                        ? "Минимально 6 символов"
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  controller: _passwordCheckController,
                                  decoration: const InputDecoration(
                                    hintText: "Повторите пароль",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != _passwordController.text
                                        ? "Пароли не совпадают"
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 59,
                                  child: ElevatedButton(
                                    child: const Text("Регистрация"),
                                    onPressed: () {
                                      _authenticateWithEmailAndPassword(
                                          context);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Регистрация при помощи"),
                        const SizedBox(
                          height: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            _athenticateWithGoogle(context);
                          },
                          icon: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png"),
                        ),
                        const Text("Уже есть аккаунт?"),
                        TextButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                        width: 1, color: Colors.grey))),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AppUnfocuser(
                                          child: SignInScreen())));
                            },
                            child: const Text("Войти"))
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(_usernameController.text, _emailController.text,
            _passwordController.text),
      );
    }
  }

  void _athenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}

static showInfoMessage(BuildContext context, String title, String message,
      [Function(void)? onTap]) {
    Flushbar(
      onTap: (flushbar) {
        onTap!(flushbar);
      },
      backgroundColor: Theme.of(context).backgroundColor,
      messageText: Text(message),
      titleText: Text(title),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: AppColors.accentSwatch,
      icon: Icon(
        Icons.info,
        color: AppColors.accentSwatch,
      ),
    )..show(context);
  }

  VoteButtons(
                  comment: state.comment,
                  isLoggedIn: state.isLoggedIn,
                  onTapUpVote: () {
                    if (state.isLoggedIn!) {
                      _commentCardBloc.add(
                          RateCommentEvent(comment: state.comment, rate: 1));
                    } else {
                      Messages.showInfoMessage(
                        context,
                        AppLocalizations.of(context)!.messagesHelperError,
                        AppLocalizations.of(context)!
                            .recoverPasswordPageUserUnknown,
                        (flushbar) =>
                            AutoRouter.of(context).navigate(LoginRoute()),
                      );
                    }
                  },
                  onTapDownVote: () {
                    if (state.isLoggedIn!) {
                      _commentCardBloc.add(
                          RateCommentEvent(comment: state.comment, rate: -1));
                    } else {
                      Messages.showInfoMessage(
                        context,
                        AppLocalizations.of(context)!.messagesHelperError,
                        AppLocalizations.of(context)!
                            .recoverPasswordPageUserUnknown,
                        (flushbar) =>
                            AutoRouter.of(context).navigate(LoginRoute()),
                      );
                    }
                  },
                )
