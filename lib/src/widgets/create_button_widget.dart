import 'package:flutter/material.dart';

class CreateButton extends StatefulWidget {
  final String text;
  final Color buttonColor;
  final Color iconColor;
  final Color textColor; // Nuevo parámetro para el color del texto
  final IconData iconData;
  final List<SecondaryButton> secondaryButtons;
  final double width;
  final double height;
  final VoidCallback onPressed;

  CreateButton({
    required this.text,
    required this.buttonColor,
    required this.iconData,
    required this.onPressed,
    required this.iconColor,
    required this.textColor, // Nuevo parámetro
    this.secondaryButtons = const [],
    this.width = 45,
    this.height = 45,
  });

  @override
  _CreateButtonState createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: widget.width,
          height: widget.height,
          child: ElevatedButton(
            onPressed: () {
              if (widget.secondaryButtons.isEmpty) {
                widget.onPressed();
              } else {
                setState(() {
                  isExpanded = !isExpanded;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(10.0),
              backgroundColor: widget.buttonColor,
            ),
            child: Icon(
              widget.iconData,
              size: 24.0,
              color: widget.iconColor,
            ),
          ),
        ),
        SizedBox(height: 1.0),
        Visibility(
          visible: !isExpanded,
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 18.0,
              color: widget.textColor, // Se aplica el color especificado
            ),
          ),
        ),
        if (isExpanded)
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: widget.secondaryButtons
                .map((secondaryButton) => ElevatedButton(
                      onPressed: secondaryButton.onPressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(10.0),
                        backgroundColor: secondaryButton.buttonColor,
                      ),
                      child: Icon(
                        secondaryButton.iconData,
                        size: 24.0,
                        color: secondaryButton.iconColor,
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }
}

class SecondaryButton {
  final String text;
  final Color buttonColor;
  final Color iconColor;
  final IconData iconData;
  final VoidCallback onPressed;
  final double width;
  final double height;

  SecondaryButton({
    required this.text,
    required this.buttonColor,
    required this.iconData,
    required this.onPressed,
    required this.iconColor,
    this.width = 45,
    this.height = 45,
  });
}
