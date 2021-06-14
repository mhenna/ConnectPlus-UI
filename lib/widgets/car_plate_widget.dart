import 'package:flutter/material.dart';

/// Car Plate Picker that shows a design of an Egyptian License plate
/// with a scroll wheel to choose the letters and numbers from.
///
/// If using for editing then moving to non-editing, make sure to change the
/// initial plate to the new value in case of confirmation in order to
/// see the changes
class CarPlatePicker extends StatefulWidget {
  /// Callback that runs whenever a change happens to the picker.
  /// It is also called with the initial license plate during
  /// initialization
  final void Function(String carPlate) onChanged;

  /// The initial plate letters and numbers to show instead of
  /// starting the picker at the top
  final String initialPlate;

  /// Set to false to change the picker to read-only mode
  final bool editable;

  CarPlatePicker({
    Key key,
    @required this.onChanged,
    this.editable = true,
    this.initialPlate,
  }) : super(key: key);

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

  // to store values during editing
  String _letters;
  String _numbers;

  /// Returns list of letters from the initial license plate
  List<String> _getInitialLetters() {
    List<String> ltrs = [];
    if (widget.initialPlate != null) {
      widget.initialPlate.characters.forEach((char) {
        if (letters.contains(char)) {
          ltrs.add(char);
        }
      });
      return ltrs;
    }
    return null;
  }

  /// Returns list of numbers from the initial license plate
  List<String> _getInitialNumbers() {
    List<String> nums = [];
    if (widget.initialPlate != null) {
      widget.initialPlate.characters.forEach((nm) {
        if (numbers.contains(nm)) {
          nums.add(nm);
        }
      });
      return nums;
    }
    return null;
  }

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: CarPlateNumbers(
                  editable: widget.editable,
                  numbers: numbers,
                  initialNumbers: _getInitialNumbers(),
                  onChanged: (numbers) {
                    _numbers = numbers;
                    if (widget.onChanged != null) {
                      widget.onChanged('$_letters$_numbers');
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 12,
                  height: 120,
                  color: Colors.grey,
                ),
              ),
              Flexible(
                flex: 1,
                child: CarPlateLetters(
                  editable: widget.editable,
                  letters: letters,
                  initialLetters: _getInitialLetters(),
                  onChanged: (letters) {
                    _letters = letters;
                    if (widget.onChanged != null) {
                      widget.onChanged('$_letters$_numbers');
                    }
                  },
                ),
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
    this.initialLetters,
    this.editable = true,
  }) : super(key: key);

  final List<String> letters;
  final void Function(String letters) onChanged;
  final List<String> initialLetters;
  final bool editable;
  @override
  _CarPlateLettersState createState() => _CarPlateLettersState();
}

class _CarPlateLettersState extends State<CarPlateLetters> {
  String _char1, _char2, _char3;

  /// Returns the letters at a certain position from the initial letters
  String _getInitialLetterAt(int position) {
    if (widget.initialLetters != null) {
      // shift letters to right by 1 if 2 letters
      if (widget.initialLetters.length == 2) {
        if (position == 2) {
          return null;
        } else {
          return widget.initialLetters[position];
        }
      } else if (widget.initialLetters.length == 3) {
        return widget.initialLetters[position];
      }
    }
    return null;
  }

  void _onChanged() {
    String letters = "";
    if (_char1 != null) letters += _char1;
    if (_char2 != null) letters += _char2;
    if (_char3 != null) letters += _char3;
    widget.onChanged(letters);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // SizedBox(
        //   width: 19, // makes letters and numbers containers have same size
        // ),
        CarPlateScrollColumn(
          editable: widget.editable,
          items: ['', ...widget.letters],
          initialItem: _getInitialLetterAt(2),
          onChanged: (character) {
            _char3 = character;
            // characters are switched as arabic switched alignments
            _onChanged();
          },
        ),
        CarPlateScrollColumn(
          editable: widget.editable,
          items: widget.letters,
          initialItem: _getInitialLetterAt(1),
          onChanged: (character) {
            _char2 = character;
            _onChanged();
          },
        ),
        CarPlateScrollColumn(
          editable: widget.editable,
          items: widget.letters,
          initialItem: _getInitialLetterAt(0),
          onChanged: (character) {
            _char1 = character;
            _onChanged();
          },
        ),
        // SizedBox(
        //   width: 19, // makes letters and numbers containers have same size
        // ),
      ],
    );
  }
}

class CarPlateNumbers extends StatefulWidget {
  final Function(String numbers) onChanged;
  final List<String> initialNumbers;
  final bool editable;
  final List<String> numbers;
  const CarPlateNumbers({
    Key key,
    @required this.numbers,
    @required this.onChanged,
    this.initialNumbers,
    this.editable = true,
  }) : super(key: key);

  @override
  _CarPlateNumbersState createState() => _CarPlateNumbersState();
}

class _CarPlateNumbersState extends State<CarPlateNumbers> {
  String _no1, _no2, _no3, _no4;

  /// Returns the number at a certain position from the initial numbers
  String _getInitialNumberAt(int position) {
    if (widget.initialNumbers != null) {
      if (widget.initialNumbers.length == 2) {
        if (position == 0) return null;
        if (position == 1) return null;
        return widget.initialNumbers[position - 2];
      } else if (widget.initialNumbers.length == 3) {
        if (position == 0) return null;
        return widget.initialNumbers[position - 1];
      } else if (widget.initialNumbers.length == 4) {
        return widget.initialNumbers[position];
      }
    }
    return null;
  }

  void _onChanged() {
    String nums = "";
    if (_no1 != null) nums += _no1;
    if (_no2 != null) nums += _no2;
    if (_no3 != null) nums += _no3;
    if (_no4 != null) nums += _no4;
    widget.onChanged(nums);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CarPlateScrollColumn(
          editable: widget.editable,
          items: ['', ...widget.numbers],
          initialItem: _getInitialNumberAt(0),
          onChanged: (number) {
            _no1 = number;
            _onChanged();
          },
        ),
        CarPlateScrollColumn(
          editable: widget.editable,
          items: ['', ...widget.numbers],
          initialItem: _getInitialNumberAt(1),
          onChanged: (number) {
            _no2 = number;
            _onChanged();
          },
        ),
        CarPlateScrollColumn(
          editable: widget.editable,
          items: widget.numbers,
          initialItem: _getInitialNumberAt(2),
          onChanged: (number) {
            _no3 = number;
            _onChanged();
          },
        ),
        CarPlateScrollColumn(
          editable: widget.editable,
          items: widget.numbers,
          initialItem: _getInitialNumberAt(3),
          onChanged: (number) {
            _no4 = number;
            _onChanged();
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

/// This widget is responsible for scrolling and selection logic
/// of one character (letter / number) only
class CarPlateScrollColumn extends StatefulWidget {
  final List<String> items;
  final String initialItem;
  final bool editable;
  final void Function(String character) onChanged;
  const CarPlateScrollColumn({
    Key key,
    @required this.items,
    @required this.onChanged,
    this.initialItem,
    this.editable = true,
  }) : super(key: key);
  @override
  _CarPlateScrollColumnState createState() => _CarPlateScrollColumnState();
}

class _CarPlateScrollColumnState extends State<CarPlateScrollColumn> {
  int _selectedItemIndex = 0;

  @override
  void initState() {
    if (widget.initialItem != null) {
      _selectedItemIndex =
          widget.items.indexWhere((item) => item == widget.initialItem);
    }

    widget.onChanged(widget.items[_selectedItemIndex]);
    super.initState();
  }

  /// To restore to initial license plate when moving from editing mode to non-editing mode.
  ///
  /// If the mode change was due to confirmation not cancellation, the initialItem should
  /// be replaced with the new confirmed plate
  @override
  void didUpdateWidget(old) {
    if (!widget.editable && widget.initialItem != null) {
      _selectedItemIndex =
          widget.items.indexWhere((item) => item == widget.initialItem);
    }
    super.didUpdateWidget(old);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 120,
      child: widget.editable
          ? PageView.builder(
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
                      color: idx == _selectedItemIndex
                          ? Colors.black
                          : Colors.grey,
                      fontSize: 34,
                      fontWeight: idx == _selectedItemIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                widget.items[_selectedItemIndex],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
