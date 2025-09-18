import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 16),
        height: 52,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: Get.isDarkMode ? Colors.grey[100]! : Colors.grey,
              width: 1),
          //color: primaryClr,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: bodyStyle,
            ),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.only(left: 14),
                height: 52,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: Get.isDarkMode ? Colors.grey[100]! : Colors.grey,
                      width: 1),
                  //color: primaryClr,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: widget == null ? false : true,
                        autofocus: false,
                        cursorColor: Get.isDarkMode
                            ? Colors.grey[100]
                            : Colors.grey[700],
                        controller: controller,
                        style: subtitelStyle,
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: subtitelStyle,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.isDarkMode
                                    ? Colors.grey[100]!
                                    : Colors.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.isDarkMode
                                    ? Colors.grey[100]!
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    widget == null
                        ? Container()
                        : Container(
                            child: widget,
                          )
                  ],
                )),
          ],
        ));
  }
}
