import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TestWidget(),
    );
  }
}

class TestWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final lvController = ScrollController();
  ExpandableController exController = ExpandableController();
  @override
  void initState() {
    //  controller = new ExpandableController(initialExpanded: true);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void listenScrolling() {
    if (lvController.position.atEdge) {
      final isTop = lvController.position.pixels < 50;

      if (isTop) {
        print("scrolled to top");
        setState(() {
          exController.toggle();
        });
      }
    } else if (lvController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        exController.expanded) {
      setState(() {
        exController.toggle();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: ExpandableNotifier(
            initialExpanded: true,
            child: Container(
                color: Theme.of(context).backgroundColor,
                child: Scaffold(
                    appBar: sappBar(context),
                    body: Column(children: [
                      Expanded(
                          child: Stack(fit: StackFit.expand, children: [
                        Positioned(
                            top: 0,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Expandable(
                                  collapsed: Container(),
                                  expanded: testCard(),
                                ))),
                        buildList()
                      ]))
                    ])))));
  }

  Widget testCard() {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Text(
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium."),
          color: Colors.white,
        ));
  }

  Widget buildList() => ListView.builder(
      shrinkWrap: true,
      controller: lvController,
      itemCount: 50,
      itemBuilder: (context, index) => ListTile(
              title: Center(
            child: Text('${index + 1}', style: TextStyle(fontSize: 32)),
          )));
  PreferredSizeWidget sappBar(BuildContext context) {
    return AppBar(backgroundColor: Theme.of(context).backgroundColor, actions: [
      Builder(builder: (context) {
        exController = ExpandableController.of(context, required: true)!;
        lvController.addListener(listenScrolling);
        return IconButton(
            icon: Icon(CupertinoIcons.rectangle_compress_vertical),
            onPressed: () {
              setState(() {
                exController.toggle();
              });
            });
      }),
    ]);
  }
}
