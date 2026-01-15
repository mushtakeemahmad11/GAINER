import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:get/get.dart';
import '../../../gainer/screens/constant_image_path.dart';
import '../../core/constants/gainer_color.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: const Color(0xFFE6F5F4),
      backgroundColor: GainerColors.background,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 30),

                        /// Top Image (natural height)
                        Image.asset(
                          AppImages.loginBanner,
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.appLogo,
                              height: 50,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Tel-e-scope',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 20),
                        const Spacer(),
                        // Image.asset(
                        //   Constants.scsBlack,
                        //   height: 100,
                        // ),
                        // const SizedBox(height: 12),
                        /// THIS TAKES REMAINING HEIGHT
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: GainerColors.secondary,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                            // border: Border.symmetric(horizontal: BorderSide(color: Colors.black26))
                          ),
                          child: Form(
                            key: controller.loginKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                Image.asset(
                                  AppImages.scsBlack,
                                  height: 100,
                                ),
                                // const Text(
                                //   'Welcome Back',
                                //   style: TextStyle(
                                //     fontSize: 30,
                                //     fontWeight: FontWeight.bold
                                //   ),
                                // ),
                                // const Text(
                                //   'Enter your details below',
                                //   style: TextStyle(
                                //     fontSize: 18,
                                //   ),
                                // ),
                                // const Text("Login",style: TextStyle(fontSize: 22)),

                                ///Error msg
                                // CustomErrorMsg(text: 'text'),
                                Obx(() {
                                  final err = controller.errMsg.value;
                                  return err != null
                                      ? Text(
                                          controller.errMsg.value ?? "",
                                          style: TextStyle(
                                              color: GainerColors.error,
                                              fontSize: 14),
                                        )
                                      : SizedBox.shrink();
                                }),
                                const SizedBox(height: 20),

                                /// User ID
                                TextFormField(
                                  controller: controller.userIdCtrl,
                                  decoration: InputDecoration(
                                    labelText: 'Enter your user id',
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    fillColor: GainerColors.white,
                                    filled: true,
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? 'user id required'
                                          : null,
                                ),

                                const SizedBox(height: 15),

                                /// Password
                                Obx(
                                  () => TextFormField(
                                    controller: controller.passwordCtrl,
                                    obscureText:
                                        !controller.isPasswordVisible.value,
                                    decoration: InputDecoration(
                                      labelText: 'Enter Your Password',
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible.value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: controller.togglePassword,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fillColor: GainerColors.white,
                                      filled: true,
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'password required'
                                            : null,
                                  ),
                                ),

                                // const SizedBox(height: 10),

                                /// Remember Me
                                Row(
                                  children: [
                                    Obx(
                                      () => Checkbox(
                                        activeColor: GainerColors.primary,
                                        value: controller.rememberMe.value,
                                        onChanged: (_) =>
                                            controller.toggleRemember(),
                                      ),
                                    ),
                                    const Text('Remember Me'),
                                  ],
                                ),

                                // const SizedBox(height: 20),

                                /// Login Button
                                Obx(
                                  () => SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // backgroundColor: const Color(0xFF2C9AA0),
                                        backgroundColor: GainerColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : controller.login,
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * .03),
                                // const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Loading Indicator
          GainerAppLoader(isLoading: controller.isLoading),
          // Obx(() => controller.isLoading.value
          //     ? Container(
          //         color: Colors.black26,
          //         child: CircularProgressIndicator(),
          //       )
          //     : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
