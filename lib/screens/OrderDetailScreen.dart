import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:occipital_tech/util/widgets.dart';

class OrderDetailScreen extends StatelessWidget {
  final List<String> imageUrls;
  OrderDetailScreen(this.imageUrls);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets.appBar('Detail'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image(
                  image: NetworkImageWithRetry(imageUrls[index]),
                );
              },
              loop: false,
              itemCount: imageUrls.length,
              pagination: SwiperPagination(),
              control: SwiperControl(color: Colors.white),
            ),
          ),
          Expanded(
            child: Container(),
          )
        ],
      ),
    );
  }
}
