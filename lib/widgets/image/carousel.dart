import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:longlive/widgets/dialog/simple.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
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
                    onPressed: _addImages,
                  ),
                  FlatButton(
                    child: const Text('전체삭제'),
                    onPressed: _deleteAllImages,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 이미지를 추가합니다.
  Future<void> _addImages() async {
    try {
      final assets = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
      final paths = await Future.wait(
          assets.map((e) => FlutterAbsolutePath.getAbsolutePath(e.identifier)));

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(
        () => _controller.images +=
            paths.map((e) => File(e)).map((e) => FileImage(e)).toList(),
      );
    } on Exception catch (e) {
      // 아무 이미지도 고르지 않은 것은, 오류로 생각하지 않습니다.
      if (e.runtimeType == NoImagesSelectedException) {
        return;
      }
      // 오류가 발생하면, 이를 알림창으로 알립니다.
      await showMessageDialog(
        context: context,
        content: e.toString(),
      );
    }
  }

  /// 모든 이미지를 삭제합니다.
  Future<void> _deleteAllImages() async {
    await showYesNoDialog(
      context: context,
      content: '정말 모든 이미지들을 목록에서 지우겠습니까?',
      onAccept: () => setState(() {
        _controller.images.clear();
      }),
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
        imageProvider: image,
      ),
    );
  }
}

class CarouselToolController {
  List<ImageProvider> images;

  /// 이미지 추가/삭제 기능
  final bool append;

  int _currentIndex = 0;

  CarouselToolController({
    this.images,
    this.append = false,
  });
}
