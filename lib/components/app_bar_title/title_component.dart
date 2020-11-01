import 'package:flutter/material.dart';
class ScrollAwareAppBarTitle extends StatefulWidget {
  final Widget child;
  const ScrollAwareAppBarTitle({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _ScrollAwareAppBarTitleState createState() {
    return new _ScrollAwareAppBarTitleState();
  }
}
class _ScrollAwareAppBarTitleState extends State<ScrollAwareAppBarTitle> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }
  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }
  void _removeListener() {
    _position?.removeListener(_positionListener);
  }
  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
      context.dependOnInheritedWidgetOfExactType(aspect:FlexibleSpaceBarSettings);
    bool visible = settings == null || settings.currentExtent <= settings.minExtent*3;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}