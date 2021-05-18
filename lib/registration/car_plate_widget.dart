import 'package:flutter/material.dart';

class CarPlatePicker extends StatefulWidget {
  final void Function(String carPlate) onChanged;
  CarPlatePicker({Key key, @required this.onChanged}) : super(key: key);

  @override
  _CarPlatePickerState createState() => _CarPlatePickerState();
}

class _CarPlatePickerState extends State<CarPlatePicker> {
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

  String _letters;
  String _numbers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarPlateHeader(),
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
              CarPlateNumbers(
                numbers: numbers,
                onChanged: (numbers) {
                  _numbers = numbers;
                  widget.onChanged('$_letters$_numbers');
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 12,
                  height: 120,
                  color: Colors.grey,
                ),
              ),
              CarPlateLetters(
                letters: letters,
                onChanged: (letters) {
                  _letters = letters;
                  widget.onChanged('$_letters$_numbers');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CarPlateLetters extends StatefulWidget {
  const CarPlateLetters({
    Key key,
    @required this.letters,
    @required this.onChanged,
  }) : super(key: key);

  final List<String> letters;
  final void Function(String letters) onChanged;
  @override
  _CarPlateLettersState createState() => _CarPlateLettersState();
}

class _CarPlateLettersState extends State<CarPlateLetters> {
  String _char1, _char2, _char3;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 19, // makes letters and numbers containers have same size
        ),
        CarPlateScrollColumn(
          items: ['', ...widget.letters],
          onChanged: (character) {
            _char3 = character;
            // characters are switched as arabic switched alignments
            widget.onChanged('$_char1$_char2$_char3');
          },
        ),
        CarPlateScrollColumn(
          items: widget.letters,
          onChanged: (character) {
            _char2 = character;
            widget.onChanged('$_char1$_char2$_char3');
          },
        ),
        CarPlateScrollColumn(
          items: widget.letters,
          onChanged: (character) {
            _char1 = character;
            widget.onChanged('$_char1$_char2$_char3');
          },
        ),
        SizedBox(
          width: 19, // makes letters and numbers containers have same size
        ),
      ],
    );
  }
}

class CarPlateNumbers extends StatefulWidget {
  final Function(String numbers) onChanged;
  const CarPlateNumbers({
    Key key,
    @required this.numbers,
    @required this.onChanged,
  }) : super(key: key);

  final List<String> numbers;

  @override
  _CarPlateNumbersState createState() => _CarPlateNumbersState();
}

class _CarPlateNumbersState extends State<CarPlateNumbers> {
  String _no1, _no2, _no3, _no4;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        CarPlateScrollColumn(
          items: ['', ...widget.numbers],
          onChanged: (number) {
            _no1 = number;
            widget.onChanged("$_no1$_no2$_no3$_no4");
          },
        ),
        SizedBox(width: 4),
        CarPlateScrollColumn(
          items: ['', ...widget.numbers],
          onChanged: (number) {
            _no2 = number;
            widget.onChanged("$_no1$_no2$_no3$_no4");
          },
        ),
        SizedBox(width: 4),
        CarPlateScrollColumn(
          items: widget.numbers,
          onChanged: (number) {
            _no3 = number;
            widget.onChanged("$_no1$_no2$_no3$_no4");
          },
        ),
        SizedBox(width: 4),
        CarPlateScrollColumn(
          items: widget.numbers,
          onChanged: (number) {
            _no4 = number;
            widget.onChanged("$_no1$_no2$_no3$_no4");
          },
        ),
      ],
    );
  }
}

class CarPlateHeader extends StatelessWidget {
  const CarPlateHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xFF0060FF),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
        border: Border.all(color: Colors.black, width: 5.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "EGYPT",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "مصر",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CarPlateScrollColumn extends StatefulWidget {
  final List<String> items;
  final void Function(String character) onChanged;
  const CarPlateScrollColumn({
    Key key,
    @required this.items,
    @required this.onChanged,
  }) : super(key: key);
  @override
  _CarPlateScrollColumnState createState() => _CarPlateScrollColumnState();
}

class _CarPlateScrollColumnState extends State<CarPlateScrollColumn> {
  int _selectedItemIndex = 0;

  @override
  void initState() {
    widget.onChanged(widget.items[_selectedItemIndex]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 120,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        onPageChanged: (int idx) {
          setState(() {
            _selectedItemIndex = idx;
          });
          widget.onChanged(widget.items[idx]);
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
                fontSize: 34,
                fontWeight: idx == _selectedItemIndex
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
