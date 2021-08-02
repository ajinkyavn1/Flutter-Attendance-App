
import 'package:flutter/material.dart';
import 'package:untitled1/commonWidgets/customFormfield.dart';

enum InputStatus { valid, invalid, none }

class AnimTFF extends StatefulWidget {
  const AnimTFF(
      {Key key,
      this.validator,
      this.successIcon = const Icon(
        Icons.check,
        color: Colors.white,
      ),
      this.keyboardType,
      this.errorIcon = const Icon(
        Icons.warning,
        color: Colors.white,
      ),
      this.onSave,
      @required this.inputIcon,
      this.labelText,
      this.successText,
      this.suffix = true,
      this.errorColor = Colors.red,
      this.successColor = Colors.green,
      this.backgroundColor = Colors.white,
      this.labelColor = Colors.grey,
      this.maxLength,
      this.initialValue,
      this.enabled = true,
      this.controller})
      : super(key: key);

  final Color backgroundColor;
  final bool enabled;
  final Color errorColor;
  final Icon errorIcon;
  final String initialValue;
  final Icon inputIcon;
  final TextInputType keyboardType;
  final Color labelColor;
  final String labelText;
  final FormFieldSetter<String> onSave;
  final Color successColor;
  final Icon successIcon;
  final String successText;
  final bool suffix;
  final FormFieldValidator<String> validator;
  final int maxLength;
  final TextEditingController controller;

  @override
  _AnimTFFState createState() => _AnimTFFState();
}

class _AnimTFFState extends State<AnimTFF> {
  Border border;
  FocusNode focusNode;
  InputStatus inputStatus = InputStatus.none;
  Color labelColor;
  String lableText;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()
      ..addListener(() {
        if (focusNode.hasFocus && inputStatus == InputStatus.none)
          setState(() {
            var color = Colors.blue;
            border = getBorder(color);
            labelColor = color;
          });
      });
    setInputDetails();
  }

  String validator(String text) {
    if (widget.validator == null) return null;
    String error = widget.validator(text);
    InputStatus inst;
    if (error == null)
      inst = InputStatus.valid;
    else
      inst = InputStatus.invalid;

    if (inst != inputStatus) {
      inputStatus = inst;
      setInputDetails(error);
      setState(() {});
    }

    return error;
  }

  Border getBorder(Color color) {
    return Border.all(width: 3, color: color);
  }

  void setInputDetails([String error]) {
    switch (inputStatus) {
      case InputStatus.invalid:
        var color = widget.errorColor;
        lableText = error;
        border = getBorder(color);
        labelColor = color;
        break;
      case InputStatus.valid:
        var color = widget.successColor;
        lableText = widget.successText;
        border = getBorder(color);
        labelColor = color;
        break;
      default:
        labelColor = widget.labelColor;
        lableText = widget.labelText;
        border = getBorder(Colors.white);
    }
  }

  Widget getInputIcon() {
    return SizedBox(
      width: 50,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          widget.inputIcon,
          buildIcon(
            inputStatus == InputStatus.invalid,
            widget.errorColor,
            widget.errorIcon,
          ),
          buildIcon(
            inputStatus == InputStatus.valid,
            widget.successColor,
            widget.successIcon,
          )
        ],
      ),
    );
  }

  Widget buildIcon(bool shouldAnimate, Color color, Icon icon,
      [Curve curve = Curves.fastOutSlowIn]) {
    final double animVal = shouldAnimate ? 0 : -50;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      right: widget.suffix ? animVal : null,
      top: 0,
      left: widget.suffix ? null : animVal,
      bottom: 0,
      curve: curve,
      child: Container(
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(5),
            ),
            color: color,
          ),
          child: icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: border,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!widget.suffix) getInputIcon(),
            Expanded(
              child: CTextFormField(
                controller: widget.controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: lableText,
                    labelStyle: TextStyle(color: labelColor),
                    contentPadding: EdgeInsets.all(10)),
                validator: validator,
                onSaved: widget.onSave,
                keyboardType: widget.keyboardType,
                enabled: widget.enabled,
                initialValue: widget.initialValue,
                maxLength: widget.maxLength,
              ),
            ),
            if (widget.suffix) getInputIcon()
          ],
        ),
      ),
    );
  }
}
