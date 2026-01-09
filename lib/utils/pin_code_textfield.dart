// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';

typedef OnDone = void Function(String text);
typedef PinBoxDecoration = BoxDecoration Function(Color borderColor);

/// class to provide some standard PinBoxDecoration such as standard box or underlined
class ProvidedPinBoxDecoration {
  /// Default BoxDecoration
  static PinBoxDecoration defaultPinBoxDecoration = (borderColor) {
    return BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)));
  };

  /// Underlined BoxDecoration
  static PinBoxDecoration underlinedPinBoxDecoration = (borderColor) {
    return BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 2.0)));
  };
}

class ProvidedPinBoxTextAnimation {
  /// A combination of RotationTransition, DefaultTextStyleTransition, ScaleTransition
  static AnimatedSwitcherTransitionBuilder awesomeTransition =
      (child, animation) {
    return RotationTransition(
        turns: animation,
        child: DefaultTextStyleTransition(
          style: TextStyleTween(
                  begin: const TextStyle(color: Colors.pink),
                  end: const TextStyle(color: Colors.blue))
              .animate(animation),
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        ));
  };

  /// Simple Scaling Transition
  static AnimatedSwitcherTransitionBuilder scalingTransition =
      (child, animation) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  };

  /// No transition
  static AnimatedSwitcherTransitionBuilder defaultNoTransition =
      (child, animation) {
    return child;
  };

  /// Rotate Transition
  static AnimatedSwitcherTransitionBuilder rotateTransition =
      (child, animation) {
    return RotationTransition(turns: animation, child: child);
  };
}

class PinCodeTextField extends StatefulWidget {
  final bool enable;
  final int maxLength;
  final TextEditingController controller;
  final bool hideCharacter;
  final bool highlight;
  final Color highlightColor;
  final Color defaultBorderColor;
  final PinBoxDecoration pinBoxDecoration;
  final String maskCharacter;
  final TextStyle pinTextStyle;
  final double pinBoxHeight;
  final double pinBoxWidth;
  final OnDone onDone;
  final bool hasError;
  final Color errorBorderColor;
  final Color hasTextBorderColor;
  final Function(String) onTextChanged;
  final bool autofocus;
  final AnimatedSwitcherTransitionBuilder pinTextAnimatedSwitcherTransition;
  final Duration pinTextAnimatedSwitcherDuration;
  final WrapAlignment wrapAlignment;
  final PinCodeTextFieldLayoutType pinCodeTextFieldLayoutType;
  final TextInputType keyboardType;

  const PinCodeTextField(
      {Key? key,
      this.enable = true,
      this.maxLength = 6,
      required this.controller,
      this.hideCharacter = false,
      this.highlight = false,
      this.highlightColor = Colors.black,
      required this.pinBoxDecoration,
      this.maskCharacter = " ",
      this.pinBoxWidth = 70.0,
      this.pinBoxHeight = 70.0,
      required this.pinTextStyle,
      required this.onDone,
      this.defaultBorderColor = Colors.black,
      this.hasTextBorderColor = Colors.black,
      required this.pinTextAnimatedSwitcherTransition,
      this.pinTextAnimatedSwitcherDuration = const Duration(),
      this.hasError = false,
      this.errorBorderColor = Colors.red,
      required this.onTextChanged,
      this.autofocus = false,
      this.wrapAlignment = WrapAlignment.start,
      this.pinCodeTextFieldLayoutType = PinCodeTextFieldLayoutType.normal,
      this.keyboardType = TextInputType.number})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PinCodeTextFieldState();
  }
}

class PinCodeTextFieldState extends State<PinCodeTextField> {
  FocusNode focusNode = FocusNode();
  String text = "";
  int currentIndex = 0;
  List<String> strList = [];
  bool hasFocus = false;
  double? pinWidth;
  double? screenWidth;

  @override
  void didUpdateWidget(PinCodeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxLength < widget.maxLength) {
      setState(() {
        currentIndex = text.length;
      });
      widget.controller.text = text;
      widget.controller.selection =
          TextSelection.collapsed(offset: text.length);
    } else if (oldWidget.maxLength > widget.maxLength &&
        widget.maxLength > 0 &&
        text.isNotEmpty &&
        text.length > widget.maxLength) {
      setState(() {
        text = text.substring(0, widget.maxLength);
        currentIndex = text.length;
      });
      widget.controller.text = text;
      widget.controller.selection =
          TextSelection.collapsed(offset: text.length);
    }
  }

  _calculateStrList() async {
//    strList.length = widget.maxLength;
    if (strList.length > widget.maxLength) {
      strList.length = widget.maxLength;
    }
    while (strList.length < widget.maxLength) {
      strList.add("");
    }
  }

  _calculatePinWidth() async {
    if (widget.pinCodeTextFieldLayoutType ==
        PinCodeTextFieldLayoutType.autoAdjustWidth) {
      screenWidth = MediaQuery.of(context).size.width;
      var tempPinWidth = widget.pinBoxWidth;
      var maxLength = widget.maxLength;
      while ((tempPinWidth * maxLength) > screenWidth!) {
        tempPinWidth -= 4;
      }
      tempPinWidth -= 10;
      setState(() {
        pinWidth = tempPinWidth;
      });
    } else {
      setState(() {
        pinWidth = widget.pinBoxWidth;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateStrList();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _touchPinBoxRow(),
        _fakeTextInput(),
      ],
    );
  }

  Widget _touchPinBoxRow() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (hasFocus) {
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(const Duration(milliseconds: 100), () {
            FocusScope.of(context).requestFocus(focusNode);
          });
        } else {
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
      child: _pinBoxRow(context),
    );
  }

  Widget _fakeTextInput() {
    return Visibility(
      visible: false,
      maintainState: true,
      child: Container(
        constraints: const BoxConstraints(),
        child: TextField(
          enabled: widget.enable,
          autofocus: widget.autofocus,
          focusNode: focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          style: const TextStyle(
            color: Colors.grey,
          ),
          decoration: const InputDecoration(
            fillColor: Colors.grey,
            border: InputBorder.none,
          ),
          cursorColor: Colors.grey,
          maxLength: widget.maxLength,
          onChanged: _onTextChanged,
        ),
      ),
    );
  }

  void _onTextChanged(text) {
    widget.onTextChanged(text);
    setState(() {
      this.text = text;
      if (text.length < currentIndex) {
        strList[text.length] = "";
      } else {
        strList[text.length - 1] =
            widget.hideCharacter ? widget.maskCharacter : text[text.length - 1];
      }
      currentIndex = text.length;
    });
    if (text.length == widget.maxLength) {
      FocusScope.of(context).requestFocus(FocusNode());
      widget.onDone(text);
    }
  }

  Widget _pinBoxRow(BuildContext context) {
    _calculateStrList();
    _calculatePinWidth();
    List<Widget> pinCodes = List.generate(widget.maxLength, (i) {
      return _buildPinCode(i, context);
    });
    return widget.pinCodeTextFieldLayoutType == PinCodeTextFieldLayoutType.wrap
        ? Wrap(
            direction: Axis.horizontal,
            alignment: widget.wrapAlignment,
            verticalDirection: VerticalDirection.down,
            children: pinCodes,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            children: pinCodes);
  }

  Widget _buildPinCode(int i, BuildContext context) {
    Color borderColor;
    BoxDecoration boxDecoration;
    if (widget.hasError) {
      borderColor = widget.errorBorderColor;
    } else if (widget.highlight &&
        hasFocus &&
        (i == text.length ||
            (i == text.length - 1 && text.length == widget.maxLength))) {
      borderColor = widget.highlightColor;
    } else if (i < text.length) {
      borderColor = widget.hasTextBorderColor;
    } else {
      borderColor = widget.defaultBorderColor;
    }

    if (widget.pinBoxDecoration != null) {
      boxDecoration = widget.pinBoxDecoration(borderColor);
    } else {
      boxDecoration =
          ProvidedPinBoxDecoration.defaultPinBoxDecoration(borderColor);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        key: ValueKey<String>("container$i"),
        decoration: boxDecoration,
        width: pinWidth,
        height: widget.pinBoxHeight,
        child: Center(child: _animatedTextBox(strList[i], i)),
      ),
    );
  }

  Widget _animatedTextBox(String text, int i) {
    if (widget.pinTextAnimatedSwitcherTransition != null) {
      return AnimatedSwitcher(
        duration: widget.pinTextAnimatedSwitcherDuration,
        transitionBuilder: widget.pinTextAnimatedSwitcherTransition,
        child: Text(
          text,
          key: ValueKey<String>("$text$i"),
          style: widget.pinTextStyle,
        ),
      );
    } else {
      return Text(
        text,
        key: ValueKey<String>("${strList[i]}$i"),
        style: widget.pinTextStyle,
      );
    }
  }
}

enum PinCodeTextFieldLayoutType { normal, wrap, autoAdjustWidth }
