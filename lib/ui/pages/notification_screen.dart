import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);

  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text(_payload.toString().split('|')[0],
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text(_payload.toString().split('|')[0],
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode ? Colors.white : darkGreyClr,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Text("You have a new reminder",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Get.isDarkMode ? Colors.white : darkGreyClr,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(_payload.toString().split('|')[0],
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: primaryClr,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.text_format,
                              size: 35,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text("Title",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : darkGreyClr,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(_payload.toString().split('|')[0],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.description,
                              size: 30,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text("Description",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : darkGreyClr,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          _payload.toString().split('|')[1],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 35,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text("Date",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : darkGreyClr,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(_payload.toString().split('|')[2],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
