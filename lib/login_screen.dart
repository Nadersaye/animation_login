import 'package:animation_login/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginExample extends StatefulWidget {
  const LoginExample({super.key});

  @override
  State<LoginExample> createState() => _LoginExampleState();
}

class _LoginExampleState extends State<LoginExample> {
  Artboard? _artboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final String _testEmail = 'nsyd1582@gmail.com';
  final String _testPassword = '12345678';
  bool isLookingLeft = false;
  bool isLookingRight = false;
  void removeAllControllers() {
    _artboard?.artboard.removeController(controllerIdle);
    _artboard?.artboard.removeController(controllerHandsUp);
    _artboard?.artboard.removeController(controllerHandsDown);
    _artboard?.artboard.removeController(controllerLookRight);
    _artboard?.artboard.removeController(controllerLookLeft);
    _artboard?.artboard.removeController(controllerSuccess);
    _artboard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllControllers();
    _artboard?.artboard.addController(controllerIdle);
    debugPrint('idle');
  }

  void addHandsUpController() {
    removeAllControllers();
    _artboard?.artboard.addController(controllerHandsUp);
    debugPrint('Hands Up');
  }

  void addHandsDownController() {
    removeAllControllers();
    _artboard?.artboard.addController(controllerHandsDown);
    debugPrint('Hands Down');
  }

  void addLookRightController() {
    isLookingRight = true;
    removeAllControllers();
    _artboard?.artboard.addController(controllerLookRight);
    debugPrint('Look Right');
  }

  void addLookLeftController() {
    isLookingLeft = true;
    removeAllControllers();
    _artboard?.artboard.addController(controllerLookLeft);
    debugPrint('Look Left');
  }

  void addSuccessController() {
    removeAllControllers();
    _artboard?.artboard.addController(controllerSuccess);
    debugPrint('Success');
  }

  void addFailController() {
    removeAllControllers();
    _artboard?.artboard.addController(controllerFail);
    debugPrint('Fail');
  }

  //check focusNode to change AnimationState
  void checkFocusNode() {
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!_passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationStatusExample.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationStatusExample.Hands_up.name);
    controllerHandsDown =
        SimpleAnimation(AnimationStatusExample.hands_down.name);
    controllerLookRight =
        SimpleAnimation(AnimationStatusExample.Look_down_right.name);
    controllerLookLeft =
        SimpleAnimation(AnimationStatusExample.Look_down_left.name);
    controllerSuccess = SimpleAnimation(AnimationStatusExample.success.name);
    controllerFail = SimpleAnimation(AnimationStatusExample.fail.name);
    rootBundle.load('assets/animation/login.riv').then((value) {
      final file = RiveFile.import(value);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        _artboard = artboard;
      });
    });
    checkFocusNode();
  }

  void checkEmailPasswordValidation() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: _artboard == null
                  ? const SizedBox.shrink()
                  : Rive(
                      artboard: _artboard!,
                    ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      addIdleController();
                    },
                    decoration: InputDecoration(
                      label: const Text('Enter your email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      return value != _testEmail ? 'wrong email' : null;
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty &&
                          value.length < 16 &&
                          !isLookingLeft) {
                        addLookLeftController();
                      } else if (value.isNotEmpty &&
                          value.length >= 16 &&
                          !isLookingRight) {
                        addLookRightController();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      addIdleController();
                    },
                    decoration: InputDecoration(
                      label: const Text('Enter your password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      return value != _testPassword ? 'wrong password' : null;
                    },
                    focusNode: _passwordFocusNode,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.all(15)),
                      onPressed: () {
                        _passwordFocusNode.unfocus();
                        checkEmailPasswordValidation();
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
