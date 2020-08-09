part of refined_video_player;

class _VideoView extends StatefulWidget {
  final RVPController controller;

  _VideoView({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  MethodChannel methodChannel;
  RVPController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = widget.controller;
    if (controller.isFullScreen.value) {
      AutoOrientation.landscapeAutoMode();
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      AutoOrientation.portraitUpMode();
      SystemChrome.setEnabledSystemUIOverlays([
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    controller._context = context;
    return ValueListenableBuilder<Size>(
      valueListenable: controller.size,
      builder: (context, size, child) {
        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: size.aspectRatio,
            child: buildPlatformView(),
          ),
        );
      },
    );
  }

  Widget buildPlatformView() {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: "${RVPController.pluginBase}/view",
        onPlatformViewCreated: controller._initPlayer,
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
      );
    }
    if (Platform.isIOS) {
      return UiKitView(
        viewType: "${RVPController.pluginBase}/view",
        onPlatformViewCreated: controller._initPlayer,
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
      );
    }
    return Center(
      child: Text("Platform not supported"),
    );
  }
}
