import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/Theme/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.payload});
  final String payload;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final List<String> _payloadParts;

  @override
  void initState() {
    super.initState();
    _payloadParts = widget.payload.split('|');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final title = _payloadParts[0];
    final description = _payloadParts.length > 1 ? _payloadParts[1] : '';
    final date = _payloadParts.length > 2 ? _payloadParts[2] : '';

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Reminder",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: isDark ? darkGreyClr.withOpacity(0.4) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildInfoRow(Icons.text_format, "Title", title, isDark),
                  const Divider(height: 30),
                  _buildInfoRow(Icons.description, "Description", description, isDark),
                  const Divider(height: 30),
                  _buildInfoRow(Icons.calendar_today_outlined, "Date", date, isDark),
                  const SizedBox(height: 30),
                  CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(12),
                    child: const Text("Mark as Read"),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: primaryClr, size: 26),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : darkGreyClr,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value.isNotEmpty ? value : '—',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.grey[200] : Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
