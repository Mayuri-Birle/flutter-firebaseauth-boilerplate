import 'package:flutter/material.dart';
import 'package:flutter_firebase_boilerplate/widgets/form_submit_button.dart';
import 'package:flutter_firebase_boilerplate/widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../services/auth.dart';
import 'email_sign_in_model.dart';
import 'validators.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidator {
//  EmailSignInForm({@required this.auth});
//  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //  String email;
  String get _email => _emailController.text;

  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signin;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
//    print('submit code');
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    try {
//      await Future.delayed(Duration(seconds: 3));
      final auth = Provider.of<AuthBase>(context);
      if (_formType == EmailSignInFormType.signin) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
//        defaultActionText: 'OK',
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
//    print(email);
//    print(
//        'email: ${_emailController.text}, password: ${_passwordController.text}');
  }

  void _emailEditingComplete() {
//    print('email editing complete');
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signin
          ? EmailSignInFormType.Register
          : EmailSignInFormType.signin;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signin
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signin
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.emailValidator.isValid(_password) &&
        !_isLoading;
//        _email.isNotEmpty && _password.isNotEmpty;
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
//        onChanged: (value) => email = value,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
