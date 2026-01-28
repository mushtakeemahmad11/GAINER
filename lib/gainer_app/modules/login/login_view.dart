import 'package:flutter/material.dart';
import 'package:gainer/gainer_app/core/constants/gainer_image.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_app_loader.dart';
import 'package:gainer/gainer_app/core/widgets/gainer_text_form_field.dart';
import 'package:get/get.dart';
import '../../../gainer/screens/constant_image_path.dart';
import '../../core/constants/gainer_color.dart';
import '../../core/widgets/error_text.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    // return Scaffold(
    //     backgroundColor: GainerColors.background,
    //     body: SafeArea(
    //         child: Stack(
    //       children: [
    //         // Scrollable content
    //         CustomScrollView(
    //           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    //           slivers: [
    //             // SliverToBoxAdapter(child: SizedBox(height: size.height * 0.02)),
    //
    //             /// Top banner (keep natural height, but fit screen nicely)
    //             SliverToBoxAdapter(
    //               child: Image.asset(
    //                 // AppImages.loginBanner,
    //                 GainerImages.loginBanner2,
    //                 fit: BoxFit.contain,
    //                 // width: size.width - 10,
    //               ),
    //             ),
    //
    //             const SliverToBoxAdapter(child: SizedBox(height: 12)),
    //
    //             SliverToBoxAdapter(
    //               child: Image.asset(AppImages.scsBlack, height: 92),
    //             ),
    //             // /// Logo + App Name
    //             // SliverToBoxAdapter(
    //             //   child: Row(
    //             //     mainAxisAlignment: MainAxisAlignment.center,
    //             //     children: [
    //             //       Image.asset(AppImages.appLogo, height: 46),
    //             //       const SizedBox(width: 10),
    //             //       const Text(
    //             //         'Tel-e-scope',
    //             //         style: TextStyle(
    //             //           fontSize: 24,
    //             //           fontWeight: FontWeight.w800,
    //             //         ),
    //             //       ),
    //             //     ],
    //             //   ),
    //             // ),
    //
    //             const SliverToBoxAdapter(child: SizedBox(height: 16)),
    //
    //             /// Form container (bottom sheet style)
    //             SliverFillRemaining(
    //               hasScrollBody: false,
    //               child: Align(
    //                 alignment: Alignment.bottomCenter,
    //                 child: AnimatedPadding(
    //                   duration: const Duration(milliseconds: 160),
    //                   curve: Curves.easeOut,
    //                   padding: EdgeInsets.only(bottom: bottomInset),
    //                   child: Container(
    //                     width: double.infinity,
    //                     padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
    //                     decoration: const BoxDecoration(
    //                       color: GainerColors.secondary,
    //                       borderRadius: BorderRadius.vertical(
    //                         top: Radius.circular(30),
    //                       ),
    //                     ),
    //                     child: Form(
    //                       key: controller.loginKey,
    //                       child: Column(
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               Image.asset(AppImages.appLogo, height: 46),
    //                               const SizedBox(width: 10),
    //                               const Text(
    //                                 'Tel-e-scope',
    //                                 style: TextStyle(
    //                                   fontSize: 24,
    //                                   fontWeight: FontWeight.w800,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           // Image.asset(AppImages.scsBlack, height: 92),
    //
    //                           /// Error msg
    //                           AppErrorText(error: controller.errMsg),
    //
    //                           const SizedBox(height: 16),
    //
    //                           /// User ID
    //                           GainerTextField(
    //                             controller: controller.userIdCtrl,
    //                             label: 'Enter your user id',
    //                             prefixIcon: const Icon(Icons.person),
    //                             validator: (value) =>
    //                                 (value == null || value.trim().isEmpty)
    //                                     ? 'user id required'
    //                                     : null,
    //                           ),
    //
    //                           const SizedBox(height: 14),
    //
    //                           /// Password
    //                           Obx(
    //                             () => GainerTextField(
    //                               label: 'Enter your password',
    //                               controller: controller.passwordCtrl,
    //                               isPass: !controller.isPasswordVisible.value,
    //                               prefixIcon: const Icon(Icons.lock),
    //                               suffixIcon: IconButton(
    //                                 icon: Icon(
    //                                   controller.isPasswordVisible.value
    //                                       ? Icons.visibility_off
    //                                       : Icons.visibility,
    //                                 ),
    //                                 onPressed: controller.togglePassword,
    //                               ),
    //                               onChanged: (val) {
    //                                 final filteredValue = val.replaceAll(
    //                                   RegExp(
    //                                       r'[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:,.<>?/|]'),
    //                                   '',
    //                                 );
    //                                 if (val != filteredValue) {
    //                                   controller.passwordCtrl.value =
    //                                       TextEditingValue(
    //                                     text: filteredValue,
    //                                     selection: TextSelection.collapsed(
    //                                       offset: filteredValue.length,
    //                                     ),
    //                                   );
    //                                 }
    //                               },
    //                               validator: (value) {
    //                                 if (value == null || value.isEmpty) {
    //                                   return 'Please enter your password';
    //                                 }
    //                                 return null;
    //                               },
    //                             ),
    //                           ),
    //
    //                           const SizedBox(height: 6),
    //
    //                           /// Remember Me
    //                           Row(
    //                             children: [
    //                               Obx(
    //                                 () => Checkbox(
    //                                   activeColor: GainerColors.primary,
    //                                   value: controller.rememberMe.value,
    //                                   onChanged: (_) =>
    //                                       controller.toggleRemember(),
    //                                 ),
    //                               ),
    //                               const Text('Remember Me'),
    //                             ],
    //                           ),
    //
    //                           const SizedBox(height: 8),
    //
    //                           /// Login Button
    //                           Obx(
    //                             () => GainerPrimaryButton(
    //                               title: 'Login',
    //                               isLoading: controller.isLoading.value,
    //                               onPressed: controller.login,
    //                             ),
    //                           ),
    //
    //                           SizedBox(height: size.height * 0.02),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //
    //         /// Loader overlay (unchanged)
    //         GainerAppLoader(isLoading: controller.isLoading),
    //       ],
    //     )));

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        // appBar: AppBar(backgroundColor: GainerColors.background),
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
                          // const SizedBox(height: 30),

                          /// Top Image (natural height)
                          Image.asset(
                            GainerImages.loginBanner4,
                            width: size.width,
                            height: size.height * .5,
                            fit: BoxFit.cover,
                          ),

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.appLogo,
                                  height: 30,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Tel-e-scope',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 10),

                          // const SizedBox(height: 20),
                          // const Spacer(),
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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30)),
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
                                    // AppImages.scsBlackLinear,
                                    AppImages.scsBlack,
                                    height: 60,
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
                                    final err = controller.errMsg;
                                    return err.value != null
                                        ? AppErrorText(error: controller.errMsg)
                                        : SizedBox.shrink();
                                  }),
                                  const SizedBox(height: 20),

                                  /// User ID
                                  GainerTextFormField(
                                    label: 'Enter your user id',
                                    controller: controller.userIdCtrl,
                                    prefixIcon: const Icon(Icons.person),
                                    // onChanged: controller.onSearchChanged,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'user id required'
                                            : null,
                                  ),
                                  // const SizedBox(height: 15),
                                  // TextFormField(
                                  //   controller: controller.userIdCtrl,
                                  //   decoration: InputDecoration(
                                  //     labelText: 'Enter your user id',
                                  //     prefixIcon: const Icon(Icons.person),
                                  //     border: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(12),
                                  //     ),
                                  //     fillColor: GainerColors.white,
                                  //     filled: true,
                                  //   ),
                                  //   validator: (value) =>
                                  //       value == null || value.isEmpty
                                  //           ? 'user id required'
                                  //           : null,
                                  // ),

                                  const SizedBox(height: 15),

                                  /// Password
                                  Obx(
                                    () => GainerTextFormField(
                                      label: 'Enter Your Password',
                                      controller: controller.passwordCtrl,
                                      obscureText:
                                          !controller.isPasswordVisible.value,
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible.value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: controller.togglePassword,
                                      ),
                                      // onChanged: controller.onSearchChanged,

                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'password required'
                                              : null,
                                    ),
                                    //       TextFormField(
                                    //     controller: controller.passwordCtrl,
                                    //     obscureText:
                                    //         !controller.isPasswordVisible.value,
                                    //     decoration: InputDecoration(
                                    //       labelText: 'Enter Your Password',
                                    //       prefixIcon: const Icon(Icons.lock),
                                    //       suffixIcon: IconButton(
                                    //         icon: Icon(
                                    //           controller.isPasswordVisible.value
                                    //               ? Icons.visibility
                                    //               : Icons.visibility_off,
                                    //         ),
                                    //         onPressed: controller.togglePassword,
                                    //       ),
                                    //       border: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.circular(12),
                                    //       ),
                                    //       fillColor: GainerColors.white,
                                    //       filled: true,
                                    //     ),
                                    //     validator: (value) =>
                                    //         value == null || value.isEmpty
                                    //             ? 'password required'
                                    //             : null,
                                    //   ),
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
                                      height: 45,
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
      ),
    );
  }
}

//
// class LoginView extends GetView<LoginController> {
//   const LoginView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       // backgroundColor: const Color(0xFFE6F5F4),
//       backgroundColor: GainerColors.background,
//       body: Stack(
//         children: [
//           LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minHeight: constraints.maxHeight,
//                   ),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const SizedBox(height: 30),
//
//                         /// Top Image (natural height)
//                         Image.asset(
//                           AppImages.loginBanner,
//                         ),
//
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               AppImages.appLogo,
//                               height: 50,
//                             ),
//                             const SizedBox(width: 10),
//                             const Text(
//                               'Tel-e-scope',
//                               style: TextStyle(
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         // const SizedBox(height: 20),
//                         const Spacer(),
//
//                         /// THIS TAKES REMAINING HEIGHT
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           decoration: BoxDecoration(
//                             color: GainerColors.secondary,
//                             borderRadius:
//                                 BorderRadius.vertical(top: Radius.circular(30)),
//                             // border: Border.symmetric(horizontal: BorderSide(color: Colors.black26))
//                           ),
//                           child: Form(
//                             key: controller.loginKey,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(height: 10),
//                                 Image.asset(
//                                   AppImages.scsBlack,
//                                   height: 100,
//                                 ),
//
//                                 ///Error msg
//                                 AppErrorText(error: controller.errMsg),
//
//                                 const SizedBox(height: 20),
//
//                                 /// User ID
//                                 GainerTextField(
//                                   controller: controller.userIdCtrl,
//                                   label: 'Enter your user id',
//                                   prefixIcon: const Icon(Icons.person),
//                                   validator: (value) =>
//                                       value == null || value.isEmpty
//                                           ? 'user id required'
//                                           : null,
//                                 ),
//
//                                 const SizedBox(height: 15),
//
//                                 /// Password
//                                 Obx(
//                                   () => GainerTextField(
//                                     label: 'Enter your password',
//                                     controller: controller.passwordCtrl,
//                                     isPass: !controller.isPasswordVisible.value,
//                                     prefixIcon: const Icon(Icons.lock),
//                                     suffixIcon: IconButton(
//                                       icon: Icon(
//                                         controller.isPasswordVisible.value
//                                             ? Icons.visibility_off
//                                             : Icons.visibility,
//                                       ),
//                                       onPressed: controller.togglePassword,
//                                     ),
//                                     onChanged: (val) {
//                                       String filteredValue = val.replaceAll(
//                                           RegExp(
//                                               r'[^a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:,.<>?/|]'),
//                                           ''); // Removes invalid characters
//
//                                       if (val != filteredValue) {
//                                         controller.passwordCtrl.value =
//                                             TextEditingValue(
//                                           text: filteredValue,
//                                           selection: TextSelection.collapsed(
//                                               offset: filteredValue.length),
//                                         );
//                                       }
//                                     },
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your password';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//
//                                 /// Remember Me
//                                 Row(
//                                   children: [
//                                     Obx(
//                                       () => Checkbox(
//                                         activeColor: GainerColors.primary,
//                                         value: controller.rememberMe.value,
//                                         onChanged: (_) =>
//                                             controller.toggleRemember(),
//                                       ),
//                                     ),
//                                     const Text('Remember Me'),
//                                   ],
//                                 ),
//
//                                 /// Login Button
//                                 Obx(() => GainerPrimaryButton(
//                                       title: 'Login',
//                                       isLoading: controller.isLoading.value,
//                                       onPressed: controller.login,
//                                     )),
//                                 SizedBox(height: size.height * .03),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           // Loading Indicator
//           GainerAppLoader(isLoading: controller.isLoading),
//         ],
//       ),
//     );
//   }
// }
