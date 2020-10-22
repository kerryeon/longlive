import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// 이미지 목록을 보여줍니다.
/// - 이미지 추가 기능
class CarouselToolWidget extends StatefulWidget {
  final CarouselToolController _controller;

  const CarouselToolWidget(this._controller);

  @override
  State createState() => _State(this._controller);
}

class _State extends State {
  final CarouselToolController _controller;

  _State(this._controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 이미지 목록
        Visibility(
          visible: _controller.append || _controller.images.isNotEmpty,
          child: Container(
            color: Colors.black,
            child: CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() => _controller._currentIndex = index);
                },
              ),
              items: _controller.images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      child: Image(image: i),
                      onTap: () => _moveToFullScreenPage(i),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
        Stack(
          children: [
            // Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _controller.images.length,
                (index) => Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 2.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller._currentIndex == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
              ).toList(),
            ),
            // 이미지 추가/삭제 버튼
            Visibility(
              visible: _controller.append,
              child: ButtonBar(
                children: [
                  FlatButton(
                    child: const Text('이미지 추가'),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: const Text('전체삭제'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 이미지를 전체화면으로 봅니다.
  void _moveToFullScreenPage(ImageProvider image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => _FullScreenWidget(image),
      ),
    );
  }
}

class _FullScreenWidget extends StatelessWidget {
  final ImageProvider image;

  const _FullScreenWidget(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        minScale: 0.5,
        maxScale: 2.0,
        imageProvider: image,
      ),
    );
  }
}

class CarouselToolController {
  List<ImageProvider> images;

  final bool append;

  int _currentIndex = 0;

  CarouselToolController({
    this.images,
    this.append = false,
  });
}
