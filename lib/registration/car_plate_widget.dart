import 'package:flutter/material.dart';

class CarPlatePicker extends StatelessWidget {
  final List<String> letters = [
    'أ',
    'ب',
    'ت',
    'ث',
    'ج',
    'ح',
    'خ',
    'د',
    'ذ',
    'ر',
    'ز',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ع',
    'غ',
    'ف',
    'ق',
    'ك',
    'ل',
    'م',
    'ن',
    'ه',
    'و',
    'ي',
  ];

  final List<String> numbers = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩'
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 64,
          decoration: BoxDecoration(
            color: Color(0xFF0060FF),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            border: Border.all(color: Colors.black, width: 5.0),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 120,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFE6E6E6),
            border: Border(
              bottom: BorderSide(width: 5.0),
              left: BorderSide(width: 5.0),
              right: BorderSide(width: 5.0),
              top: BorderSide(width: 0.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CarPlateScrollColumn(items: ['', ...numbers]),
                  SizedBox(width: 4),
                  CarPlateScrollColumn(items: ['', ...numbers]),
                  SizedBox(width: 4),
                  CarPlateScrollColumn(items: numbers),
                  SizedBox(width: 4),
                  CarPlateScrollColumn(items: numbers),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 12,
                  height: 120,
                  color: Colors.grey,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CarPlateScrollColumn(items: ['', ...letters]),
                  SizedBox(width: 4),
                  CarPlateScrollColumn(items: letters),
                  SizedBox(width: 4),
                  CarPlateScrollColumn(items: letters),
                  SizedBox(width: 4)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CarPlateScrollColumn extends StatefulWidget {
  final List<String> items;

  const CarPlateScrollColumn({Key key, @required this.items}) : super(key: key);
  @override
  _CarPlateScrollColumnState createState() => _CarPlateScrollColumnState();
}

class _CarPlateScrollColumnState extends State<CarPlateScrollColumn> {
  int _selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 120,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        onPageChanged: (int idx) {
          setState(() => _selectedItemIndex = idx);
        },
        physics: BouncingScrollPhysics(),
        controller: PageController(
          viewportFraction: 0.42,
          initialPage: _selectedItemIndex,
        ),
        itemCount: widget.items.length,
        itemBuilder: (context, idx) {
          return Center(
            child: Text(
              widget.items[idx],
              style: TextStyle(
                color: idx == _selectedItemIndex ? Colors.black : Colors.grey,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
