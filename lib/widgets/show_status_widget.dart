import 'dart:async';
import 'package:flutter/material.dart';
import '../appConfig.dart';
import '../models/status_model.dart';

class ShowStatusWidget extends StatefulWidget {
  final MapEntry<String, List<StatusModel>> groupedData;

  ShowStatusWidget({Key? key, required this.groupedData}) : super(key: key);

  @override
  State<ShowStatusWidget> createState() => _ShowStatusWidgetState();
}

class _ShowStatusWidgetState extends State<ShowStatusWidget> {
  PageController? _controller;
  Timer? _timer;
  int pageCount = 0;
  bool isScrollingPaused = false;
  int countdown = 5;

  @override
  void initState() {
    super.initState();
    pageCount = widget.groupedData.value.length;
    _controller = PageController(); // Initialize the PageController here
    startAutoScroll();
  }

  // Determine the gradient stops for the Container
  // List<double> determineGradientStops() {
  //   final double maxStop = 1.0;
  //   final double currentStop = countdown / 5.0;
  //   return [currentStop, maxStop];
  // }

  @override
  void dispose() {
    _controller?.dispose();
    // stopAutoScroll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final gradientStops = determineGradientStops();
    return Scaffold(
      backgroundColor: Color(0xFF190014),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTapDown: (_) {
          pauseAutoScroll();
        },
        onTap: () {
          if (_controller!.page == pageCount - 1) {
            Navigator.of(context).pop();
          } else {
            _controller!.nextPage(
                duration: Duration(milliseconds: 1), curve: Curves.ease);
          }
        },
        onTapUp: (_) {
          resumeAutoScroll();
        },
        child: PageView(
          controller: _controller,
          children: widget.groupedData.value
              .map((e) => Center(
                    child: Stack(
                      //  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        e.type == 'text'
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '${e.status}',
                                    style: TextStyle(
                                      color: Color(0xFF190014),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : Image.network(
                                '${AppConfig.baseUrl}/whatsapp_users/images/${e.status}',
                                // fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              ),
                        if (e.type != 'text' && e.type != "")
                          Positioned(
                            bottom: 0,
                            child: Container(
                              color: Colors.black54,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.13,
                              child: Center(
                                child: Text(
                                  e.type!,
                                  maxLines: 3,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        // Container(
                        //   height: 5, // Adjust the height of the line as needed
                        //   width: MediaQuery.of(context).size.width * 0.5,
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //       stops: gradientStops,
                        //       colors: [Color(0xFF190014), Colors.white],
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.topRight,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                        // Text(
                        //   'next in: $countdown seconds',
                        //   style: TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 14,
                        //   ),
                        // ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isScrollingPaused) {
        if (countdown == 0) {
          countdown = 5; // Reset countdown
          if (_controller!.page == pageCount - 1) {
            Navigator.of(context).pop();
          } else {
            _controller!.nextPage(
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }
        } else {
          setState(() {
            countdown--; // Decrease the countdown
          });
        }
      }
    });
  }

  void pauseAutoScroll() {
    isScrollingPaused = true;
  }

  void resumeAutoScroll() {
    isScrollingPaused = false;
  }

  // void stopAutoScroll() {
  //   _timer?.cancel();
  // }
}
