// loading required packages
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/radio_panel.dart';

class RadioBar extends StatefulWidget {
  @override
  RadioBarState createState() => RadioBarState();
}

class RadioBarState extends State<RadioBar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    globals.playPauseAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    globals.playPauseAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: globals.playPauseAnimationController,
    );
    if (!globals.radioPlayerIsPaused)
      globals.playPauseAnimationController.forward();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/golden_mosque_50percent.png'),
          fit: BoxFit.fitHeight,
          alignment: Alignment.lerp(Alignment.centerLeft, Alignment.center, .5),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 0,
            offset: Offset(0, -1),
            color: Colors.black.withOpacity(.12),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Future.delayed(
              Duration(milliseconds: 250),
              () {
                Navigator.of(context).push(
                  globals.createRoute(RadioPanel()),
                );
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 5),
              RawMaterialButton(
                constraints: BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                padding: EdgeInsets.all(10),
                shape: CircleBorder(),
                elevation: globals.radioStreamIsLoaded ? 2 : 0,
                child: globals.radioStreamIsLoaded
                    ? AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        size: 36,
                        color: Theme.of(context).primaryColor,
                        progress: globals.playPauseAnimation,
                      )
                    : Container(
                        height: 36,
                        width: 36,
                        child: CircularProgressIndicator(),
                      ),
                onPressed: globals.radioStreamIsLoaded
                    ? () {
                        if (globals.radioPlayerIsPaused) {
                          globals.playPauseAnimationController.forward();
                          globals.radioPlayer.play();
                        } else {
                          globals.playPauseAnimationController.reverse();
                          globals.radioPlayer.pause();
                        }
                        globals.radioPlayerIsPaused =
                            !globals.radioPlayerIsPaused;
                      }
                    : null,
              ),
              Expanded(
                flex: 1,
                child: IgnorePointer(
                  child: CarouselSlider.builder(
                    itemCount: globals.currentAndNextItem.length,
                    options: CarouselOptions(
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 10),
                      autoPlayAnimationDuration: Duration(seconds: 1),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.vertical,
                    ),
                    itemBuilder: (BuildContext context, int index, _) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        title: Text(
                          globals
                                      .radioItemList[
                                          globals.currentAndNextItem[index]]
                                      .description !=
                                  ''
                              ? globals
                                      .radioItemList[
                                          globals.currentAndNextItem[index]]
                                      .title +
                                  ' (' +
                                  globals
                                      .radioItemList[
                                          globals.currentAndNextItem[index]]
                                      .description +
                                  ')'
                              : globals
                                  .radioItemList[
                                      globals.currentAndNextItem[index]]
                                  .title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: index == 0 ? Colors.red : Colors.lightGreen,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            index == 0 ? 'پخش زنده' : 'برنامه بعد',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
