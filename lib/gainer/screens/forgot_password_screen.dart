import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../widget/reusable_widget.dart';
import 'colors.dart';

TextEditingController userIdForgetField = TextEditingController();
TextEditingController userEmailForgetField = TextEditingController();

dialogForForgetPass() {
  return Get.defaultDialog(
      title: 'Forget Password',
      titlePadding: EdgeInsets.only(top: mq.height * .03),
      // textCancel: 'Cancel',
      titleStyle: const TextStyle(
        fontSize: 20,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: mq.height * .02),
      content: Column(
        children: [
          CustomTextFormField(
            controller: userIdForgetField,
            text: "User ID",
            suffixIcon: Icon(
              Icons.person,
              color: AppColor.primary,
            ),
          ),
          CustomTextFormField(
            controller: userEmailForgetField,
            text: "Email id",
            suffixIcon: Icon(
              Icons.mail,
              color: AppColor.primary,
            ),
          ),
          SizedBox(
            height: mq.height * .02,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColor.primary),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: const Text(
              'Request Password',
              // textAlign: TextAlign.end,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: mq.height * .01,
          ),
          const Text(
            'You will find your password on your register Email ID',
            // textAlign: TextAlign.center,
          )
        ],
      ),
  );
}
