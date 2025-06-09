import 'dart:async';

import 'package:file_hub/core/di/di.dart';
import 'package:file_hub/core/resources/themes/text_styles.dart';
import 'package:file_hub/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final int startSeconds;
  final VoidCallback onTimerExpire;

  const CountdownTimerWidget({
    super.key,
    this.startSeconds = 300,
    required this.onTimerExpire,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late final SecureStorageService _service;
  late int _secondsRemaining;
  late Timer _timer;

  static const String _lastOtpTimeKey = "last_otp_timestamp";

  @override
  void initState() {
    super.initState();
    _service = getIt<SecureStorageService>();
    _secondsRemaining = 0;
    _loadTimer();
  }

  /// ✅ Load previous OTP timestamp and calculate remaining time
  Future<void> _loadTimer() async {
    final String? time = await _service.getData(_lastOtpTimeKey);
    int? lastOtpTime = time != null ? int.parse(time) : null;
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds

    if (lastOtpTime != null) {
      int elapsed = currentTime - lastOtpTime;
      int remaining = widget.startSeconds - elapsed;

      if (remaining > 0) {
        _secondsRemaining = remaining;
      } else {
        _secondsRemaining = 0;
        await _expireOtp(); // ✅ Timer expire hone pe data delete hoga
      }
    } else {
      _secondsRemaining = widget.startSeconds;
      _saveOtpTime();
    }

    _startTimer();
  }

  /// ✅ Save new OTP timestamp
  Future<void> _saveOtpTime() async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _service.saveData(_lastOtpTimeKey, currentTime.toString());
  }

  /// ❌ OTP Expired -> Delete Stored Time + Invoke Callback
  Future<void> _expireOtp() async {
    await _service.deleteData(_lastOtpTimeKey); // ✅ Secure storage se delete karega
    widget.onTimerExpire(); // ✅ Callback invoke hoga
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        _expireOtp(); // ✅ Call expire function
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Otp will expire in  ',
        style: CustomTextStyles.custom14Regular,
        children: [
          TextSpan(
            text: _formatTime(_secondsRemaining),
            style: CustomTextStyles.custom14Bold.copyWith(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
