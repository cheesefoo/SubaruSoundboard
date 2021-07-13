import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';

final aspectRatio = 390 / 83;

class SoundButton extends StatefulWidget {
  const SoundButton({
    Key? key,
    required this.description,
    required this.filename,
    this.child,
  }) : super(key: key);

  final String description;
  final String filename;
  final Widget? child;

  @override
  _SoundButtonState createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  var _defaultBoxShadow = List.generate(8, (i) {
    return BoxShadow(
        color: Color(0xFF518DB9),
        offset: Offset(i + 1, i + 1),
        blurRadius: 1,
        spreadRadius: 1.0);
  });
  var _boxShadow = List.generate(8, (i) {
    return BoxShadow(
        color: Color(0xFF518DB9),
        offset: Offset(i + 1, i + 1),
        blurRadius: 1,
        spreadRadius: 1.0);
  });
  late AudioPlayer player;
  bool playing = false;

  var _margin,
      _defaultMargin =
          EdgeInsets.fromLTRB(12 * aspectRatio, 0, 0, 16 * aspectRatio);
  var _padding,
      _defaultPadding =
          EdgeInsets.fromLTRB(8 * aspectRatio, 8 * aspectRatio, 0, 0);

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 67),
      child: AspectRatio(
        aspectRatio: 6,
        child: AnimatedContainer(
            margin: EdgeInsets.all(8),
            width: 400,
            height: 67,
            decoration: buildBoxDecoration(),
            duration: Duration(milliseconds: 500),
            child: InkWell(onTap: soundButtonOnTap, child: buildText())),
      ),
    );
  }

  void soundButtonOnTap() async {
    setState(() {
      playing = !playing;
    });
    await player.setAsset('assets/sound/${widget.filename}');
    player.play().then((_) {
      setState(() {
        playing = !playing;
      });
    });
  }

  Widget buildText() {
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: Center(
            child: Text(
          widget.description,
          textAlign: TextAlign.center,
        )));
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
        color: playing ? Color(0xFFff6f62) : Color(0xFFFFFEF0),
        border: Border.all(
            color: Color(0xFF518DB9), width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(5),
        boxShadow: playing ? List.empty() : _boxShadow);
  }
}
