import 'package:flutter/material.dart';

class MaskedPinCodeTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  MaskedPinCodeTextField({this.onChanged});

  @override
  _MaskedPinCodeTextFieldState createState() => _MaskedPinCodeTextFieldState();
}

class _MaskedPinCodeTextFieldState extends State<MaskedPinCodeTextField> {
  late List<TextEditingController> _controllers;
  static const int _pinLength = 4;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_pinLength, (index) => TextEditingController());
    for (int i = 0; i < _pinLength - 1; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1) {
          FocusScope.of(context).nextFocus(); // Move to the next field
        }
      });
    }
    _controllers[_pinLength - 1].addListener(_onLastPinTextChanged);
  }

  void _onLastPinTextChanged() {
    String pin = '';
    for (TextEditingController controller in _controllers) {
      pin += controller.text;
    }
    widget.onChanged?.call(pin);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < _pinLength; i++)
          _buildPinCodeTextField(_controllers[i]),
      ],
    );
  }

  Widget _buildPinCodeTextField(TextEditingController controller) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(fontSize: 24),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
