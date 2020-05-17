import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';

import './label.dart';
import './assets.dart';

class Button extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onPress;
  final VoidCallback onPressReleased;
  final String label;
  final Color labelColor;
  final Sprite sprite;
  final Sprite pressedSprite;
  final double width;
  final double height;

  Button({
    this.onPressed,
    this.onPress,
    this.onPressReleased,
    this.label,
    this.labelColor,
    this.sprite,
    this.pressedSprite,

    this.width,
    this.height,
  });

  Button.primaryButton({
    VoidCallback onPressed,
    VoidCallback onPress,
    VoidCallback onPressReleased,
    String label,

    double width,
    double height,
  }): this(
    onPressed: onPressed,
    onPress: onPress,
    onPressReleased: onPressReleased,
    label: label,
    width: width,
    height: height,

    labelColor: Color(0xFFb13e53),
    sprite: ButtonSprites.primaryButton(),
    pressedSprite: ButtonSprites.primaryButtonPressed(),
  );

  Button.secondaryButton({
    VoidCallback onPressed,
    VoidCallback onPress,
    VoidCallback onPressReleased,
    String label,

    double width,
    double height,
  }): this(
    onPressed: onPressed,
    onPress: onPress,
    onPressReleased: onPressReleased,
    label: label,
    width: width,
    height: height,

    labelColor: Color(0xFF5d275d),
    sprite: ButtonSprites.secondaryButton(),
    pressedSprite: ButtonSprites.secondaryButtonPressed(),
  );

  Button.dpadButton({
    VoidCallback onPressed,
    VoidCallback onPress,
    VoidCallback onPressReleased,
    String label,

    double width,
    double height,
  }): this(
    onPressed: onPressed,
    onPress: onPress,
    onPressReleased: onPressReleased,
    label: label,
    width: width,
    height: height,

    labelColor: Color(0xFF333c57),
    sprite: ButtonSprites.dpadButton(),
    pressedSprite: ButtonSprites.dpadButtonPressed(),
  );

  Button.switchButton({
    VoidCallback onPressed,
    VoidCallback onPress,
    VoidCallback onPressReleased,
    String label,

    double width,
    double height,

    bool isOn = true
  }): this(
    onPressed: onPressed,
    onPress: onPress,
    onPressReleased: onPressReleased,
    label: label,
    width: width,
    height: height,
    labelColor: isOn ? Color(0xFFa7f070) : Color(0xFF5d275d),
    sprite: isOn ? ButtonSprites.onButton() : ButtonSprites.offButton(),
    pressedSprite: isOn ? ButtonSprites.onButtonPressed() : ButtonSprites.offButtonPressed(),
  );

  @override
  State createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _pressed = false;

  void _press() {
    widget.onPress?.call();
    setState(() {
      _pressed = true;
    });
  }

  void _release() {
    setState(() {
      _pressed = false;
    });

    widget.onPressReleased?.call();
    widget.onPressed?.call();
  }

  @override
  Widget build(_) {
    final width = widget.width ?? 200;
    final height = widget.height ?? 50;

    return GestureDetector(
        onTapDown: (_) {
          _press();
        },
        onTapUp: (_) {
          _release();
        },
        onTapCancel: () {
          _release();
        },
        child: Container(
            width: width,
            height: height,
            child: CustomPaint(
                painter: _ButtonPainer(_pressed ? widget.pressedSprite : widget.sprite),
                child: Center(
                    child: widget.label != null ? Label(
                        label: widget.label,
                        fontColor: widget.labelColor,
                        fontSize: height * 0.6,
                    ) : null,
                ),
            ),
        ),
    );
  }
}

class _ButtonPainer extends CustomPainter {
  Sprite _sprite;

  _ButtonPainer(this._sprite);

  @override
  bool shouldRepaint(_ButtonPainer old) => old._sprite != _sprite;

  @override
  void paint(Canvas canvas, Size size) {
    _sprite.renderRect(canvas, Rect.fromLTWH(0, 0, size.width, size.height));
  }
}
