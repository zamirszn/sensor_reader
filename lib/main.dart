import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const SensorApp());
}

class SensorApp extends StatelessWidget {
  const SensorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Read',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double initX = 0.0, initY = 0.0;

  List<String> images = [
    "https://cdn.cnn.com/cnnnext/dam/assets/131120091046-01-mona-lisa-stolen-restricted-horizontal-large-gallery.jpg"
        "http://www.kiwithebeauty.com/wp-content/uploads/2017/11/BLACK-PANTHER-COLLAGE-KIWI-THE-BEAUTY-MOVIE-MARVEL-800x350.png",
    "https://static-ssl.businessinsider.com/image/5a7085a97e7a35f10c8b479f-1000/blackpanthershuri.jpg",
    "https://longreadsblog.files.wordpress.com/2018/02/black-panther.jpg?w=1680",
    "https://uziiw38pmyg1ai60732c4011-wpengine.netdna-ssl.com/wp-content/dropzone/2018/02/black-panther.jpg",
    "https://static2.srcdn.com/wp-content/uploads/2017/10/Black-Panther-Trailer-1.jpg?q=50&w=1000&h=500&fit=crop&dpr=1.5",
    "https://cdn.guidingtech.com/imager/media/assets/BP-2_acdb3e4bb37d0e3bcc26c97591d3dd6b.jpg",
    "https://cdn.guidingtech.com/imager/media/assets/BP-8_acdb3e4bb37d0e3bcc26c97591d3dd6b.jpg"
  ];

  Timer? _timer;
  int _imagePosition = 0;
  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      setState(() {
        _imagePosition = (_imagePosition + 1) % images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<GyroscopeEvent>(
              stream: SensorsPlatform.instance.gyroscopeEvents,
              builder: (context, snapshot) {
                log('${snapshot.data!.x * 1000}');
                if (snapshot.hasData) {
                  if (snapshot.data!.y.abs() > 0.0) {
                    initX = initX + (snapshot.data!.y) * 10;
                  }
                  if (snapshot.data!.x.abs() > 0.0) {
                    initY = initY + (snapshot.data!.x) * 10;
                  }
                }
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  left: 10 - initX,
                  right: 10 + initX,
                  top: 10 - initY,
                  bottom: 10 + initY,
                  child: Center(
                    child: Container(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: 230,
                              height: 330,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    isAntiAlias: true,
                                    opacity: 0.8,
                                    image: CachedNetworkImageProvider(
                                        images[_imagePosition]),
                                    colorFilter: ColorFilter.mode(
                                        Colors.white.withOpacity(.1),
                                        BlendMode.srcOver),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white.withOpacity(0.0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          Positioned(
            left: 10,
            right: 10,
            top: 10,
            bottom: 10,
            child: Center(
              child: Container(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: .1),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(images[_imagePosition]),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
