import 'package:niiflicks/creditcard/credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:niiflicks/creditcard/credit_card_model.dart';
// import 'credit_card_widget.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;
  String _chosenValue;
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  var items = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'watermelon',
    'Pineapple'
  ];

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _value;
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: TextFormField(
                controller: _cardNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: Colors.red,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card number',
                    labelStyle: TextStyle(color: Colors.red),
                    hintText: 'xxxx xxxx xxxx xxxx',
                    hintStyle: TextStyle(color: Colors.red)),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _expiryDateController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  labelStyle: TextStyle(color: Colors.red),
                  hintText: 'MM/YY',
                  hintStyle: TextStyle(color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextField(
                focusNode: cvvFocusNode,
                controller: _cvvCodeController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: Colors.red,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  labelStyle: TextStyle(color: Colors.red),
                  hintText: 'XXXX',
                  hintStyle: TextStyle(color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (String text) {
                  setState(() {
                    cvvCode = text;
                  });
                },
              ),
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(30.0),
            //       color: Colors.orangeAccent,
            //       border: Border.all(color: Colors.black38)),
            //   child: DropdownButtonHideUnderline(
            //       child: DropdownButton(
            //           icon: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Icon(Icons.account_balance_wallet),
            //           ),
            //           value: _value,
            //           items: [
            //         DropdownMenuItem(
            //           child: Padding(
            //             padding: const EdgeInsets.all(10.0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text(
            //                   "Diamond Bank",
            //                   style: TextStyle(
            //                       fontFamily: 'Montserrat',
            //                       color: Colors.black87),
            //                 ),
            //                 Text(
            //                   "063",
            //                   style: TextStyle(
            //                       fontFamily: 'Montserrat',
            //                       color: Colors.black87),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           value: 1,
            //         ),
            //       ])),
            // ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: TextFormField(
                controller: _cardHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                style: TextStyle(
                  color: Colors.red,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                  labelStyle: TextStyle(color: Colors.red),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
