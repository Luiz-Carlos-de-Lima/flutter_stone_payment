import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stone_payment/constants/installment_type.dart';
import 'package:flutter_stone_payment/constants/print_content_types.dart';
import 'package:flutter_stone_payment/constants/reprint_type.dart';
import 'package:flutter_stone_payment/constants/transaction_type.dart';
import 'package:flutter_stone_payment/exceptions/cancel_exception.dart';
import 'package:flutter_stone_payment/exceptions/payment_exception.dart';
import 'package:flutter_stone_payment/exceptions/print_exception.dart';
import 'package:flutter_stone_payment/exceptions/reprint_exception.dart';
import 'package:flutter_stone_payment/flutter_stone_payment.dart';
import 'package:flutter_stone_payment/models/cancel_payload.dart';
import 'package:flutter_stone_payment/models/content_print.dart';
import 'package:flutter_stone_payment/models/payment_payload.dart';
import 'package:flutter_stone_payment/models/print_payload.dart';
import 'package:flutter_stone_payment/models/reprint_payload.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(home: PaymentApp()));
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: 15.0,
            children: [
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PaymentPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  child: Text('Pagamento'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _CancelPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: Text('Cancelar'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _PrintPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: Text('Imprimir'),
                ),
              ),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _ReprintPage()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  child: Text('Reimprimir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentPage extends StatefulWidget {
  const _PaymentPage({super.key});

  @override
  State<_PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<_PaymentPage> {
  final _amountEC = TextEditingController();
  final _qtdEC = TextEditingController();
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final List<DropdownMenuItem<TransactionType?>> _listTypes = TransactionType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<InstallmentType?>> _listInstallmentType =
      InstallmentType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  TransactionType? _transactionType;
  InstallmentType? _transactionInstallmentType;

  bool _editableAmount = false;

  @override
  void initState() {
    super.initState();
    _listTypes.add(DropdownMenuItem<TransactionType>(value: null, child: Text('NENHUM')));
    _listInstallmentType.add(DropdownMenuItem<InstallmentType>(value: null, child: Text('NENHUM')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('pagamento'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: Text('Tipo do Pagamento')),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 55,
                    child: DropdownButton(
                      value: _transactionType,
                      items: _listTypes,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        _transactionInstallmentType = null;
                        _qtdEC.text = '';
                        _transactionType = value;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(alignment: Alignment.centerLeft, child: Text('Valor')),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _amountEC,
                    decoration: InputDecoration(
                      hintText: 'Valor',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  // if (_transactionType == TransactionType.CREDIT)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft, child: Text('tipo parcelamento')),
                              SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 55,
                                child: DropdownButton(
                                  value: _transactionInstallmentType,
                                  items: _listInstallmentType,
                                  isExpanded: true,
                                  underline: Container(),
                                  onChanged: (value) {
                                    _transactionInstallmentType = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Align(alignment: Alignment.centerLeft, child: Text('Qtd parcelamento')),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _qtdEC,
                                decoration: InputDecoration(
                                  hintText: 'Qtd parcelamento',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _editableAmount = !_editableAmount;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                            value: _editableAmount,
                            onChanged: (_) {
                              setState(() {
                                _editableAmount = !_editableAmount;
                              });
                            }),
                        Text(
                          "Valor Editável",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        double? amount = double.tryParse(_amountEC.text);
                        int? qtdPar = int.tryParse(_qtdEC.text);
                        final payment = PaymentPayload(
                            amount: amount,
                            transactionType: _transactionType,
                            orderId: Random().nextInt(1000).toString(),
                            installmentCount: qtdPar,
                            installmentType: _transactionInstallmentType,
                            editableAmount: _editableAmount);
                        final response = await _flutterStonePaymentPlugin.pay(paymentPayload: payment);

                        final print = PrintPayload(
                            printableContent: [Contentprint(type: PrintType.line, content: response.toJson().toString())], showFeedbackScreen: false);
                        await _flutterStonePaymentPlugin.print(printPayload: print);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Simulacao pagamento e Impressão realizada com sucesso!")));
                      } on PaymentException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                      } on PrintException catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Simulação de pagamento realizado mas erro na impressão: ${e.message}")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: Text('Pagar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CancelPage extends StatefulWidget {
  const _CancelPage({super.key});

  @override
  State<_CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<_CancelPage> {
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final _amountEC = TextEditingController();
  final _atkEC = TextEditingController();

  bool _editableAmount = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('cancelar'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: Text('Valor')),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _amountEC,
                    decoration: InputDecoration(
                      hintText: 'Valor',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: Text('Identificação do pagamento')),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _atkEC,
                    decoration: InputDecoration(
                      hintText: 'ATK',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _editableAmount = !_editableAmount;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                            value: _editableAmount,
                            onChanged: (_) {
                              setState(() {
                                _editableAmount = !_editableAmount;
                              });
                            }),
                        Text(
                          "Valor Editável",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        double? amount = double.tryParse(_amountEC.text);
                        final cancel = CancelPayload(amount: amount, atk: _atkEC.text, editableAmount: _editableAmount);
                        final response = await _flutterStonePaymentPlugin.cancel(cancelPayload: cancel);
                        final print = PrintPayload(printableContent: [
                          Contentprint(
                              type: PrintType.text,
                              align: PrintAlign.center,
                              size: PrintSize.big,
                              content: "Cancelamento Simulado\n\n${response.toJson().toString()}"),
                        ], showFeedbackScreen: false);
                        await _flutterStonePaymentPlugin.print(printPayload: print);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Simulacao Cancelamento e Impressão realizada com sucesso! $cancel")));
                      } on CancelException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                      } on PrintException catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Simulação de pagamento realizado mas erro na impressão: ${e.message}")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: Text('Continuar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrintPage extends StatefulWidget {
  const _PrintPage({super.key});

  @override
  State<_PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<_PrintPage> {
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final _printTextEC = TextEditingController();
  final List<DropdownMenuItem<PrintType>> _listPrintType = PrintType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<PrintAlign>> _listPrintAlign = PrintAlign.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<PrintSize>> _listPrintSize = PrintSize.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();

  PrintType _printType = PrintType.line;
  PrintAlign? _printAlign = PrintAlign.center;
  PrintSize? _printSize = PrintSize.medium;

  bool _showFeedbackScreen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('impresssão'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: Text('Tipo de Impressão')),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 55,
                    child: DropdownButton(
                      value: _printType,
                      items: _listPrintType,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        _printType = value!;
                        if (_printType == PrintType.text) {
                          _printAlign = PrintAlign.center;
                          _printSize = PrintSize.medium;
                        } else {
                          _printAlign = null;
                          _printSize = null;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  if (_printType == PrintType.text)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(alignment: Alignment.centerLeft, child: Text('Alinhamento da Impressão')),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 55,
                          child: DropdownButton(
                            value: _printAlign,
                            items: _listPrintAlign,
                            isExpanded: true,
                            underline: Container(),
                            onChanged: (value) {
                              _printAlign = value!;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  if (_printType == PrintType.text)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(alignment: Alignment.centerLeft, child: Text('Tamanho da Impressão')),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 55,
                          child: DropdownButton(
                            value: _printSize,
                            items: _listPrintSize,
                            isExpanded: true,
                            underline: Container(),
                            onChanged: (value) {
                              _printSize = value!;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  (_printType != PrintType.image)
                      ? Column(
                          children: [
                            SizedBox(height: 10),
                            Align(alignment: Alignment.centerLeft, child: Text('Texto para Impressão')),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _printTextEC,
                              decoration: InputDecoration(
                                hintText: 'Texto',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [Image.network('https://zup.com.br/wp-content/uploads/2021/03/5ce2fde702ef93c1e994d987_flutter.png')],
                        ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showFeedbackScreen = !_showFeedbackScreen;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                            value: _showFeedbackScreen,
                            onChanged: (_) {
                              setState(() {
                                _showFeedbackScreen = !_showFeedbackScreen;
                              });
                            }),
                        Expanded(
                          child: Text(
                            "Mostrar tela de feedback",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        String? image64;
                        if (_printType == PrintType.image) {
                          image64 = await imageToBase64('https://zup.com.br/wp-content/uploads/2021/03/5ce2fde702ef93c1e994d987_flutter.png');
                        }
                        final print = PrintPayload(printableContent: [
                          Contentprint(type: _printType, align: _printAlign, content: _printTextEC.text, size: _printSize, imagePath: image64)
                        ], showFeedbackScreen: _showFeedbackScreen);
                        await _flutterStonePaymentPlugin.print(printPayload: print);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Impressão realizada com sucesso!")));
                      } on PrintException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: Text('imprimir'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> imageToBase64(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }
    } catch (e) {
      print("Erro ao converter imagem para Base64: $e");
    }
    return null;
  }
}

class _ReprintPage extends StatefulWidget {
  const _ReprintPage({super.key});

  @override
  State<_ReprintPage> createState() => _ReprintPageState();
}

class _ReprintPageState extends State<_ReprintPage> {
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final _atkEC = TextEditingController();
  final List<DropdownMenuItem<TypeCustomer>> _listTypeCustomer = TypeCustomer.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();

  TypeCustomer _typeCustomer = TypeCustomer.MERCHANT;

  bool _showFeedbackScreen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reimprimir'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Align(alignment: Alignment.centerLeft, child: Text('Tipo de Impressão')),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 55,
                    child: DropdownButton(
                      value: _typeCustomer,
                      items: _listTypeCustomer,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        _typeCustomer = value!;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: Text('Identificação do pagamento')),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _atkEC,
                    decoration: InputDecoration(
                      hintText: 'ATK',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showFeedbackScreen = !_showFeedbackScreen;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                            value: _showFeedbackScreen,
                            onChanged: (_) {
                              setState(() {
                                _showFeedbackScreen = !_showFeedbackScreen;
                              });
                            }),
                        Expanded(
                          child: Text(
                            "Mostrar tela de feedback",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: Text('Voltar'),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final reprint = ReprintPayload(atk: _atkEC.text, typeCustomer: _typeCustomer, showFeedbackScreen: _showFeedbackScreen);
                        await _flutterStonePaymentPlugin.reprint(reprintPayload: reprint);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Impressão realizada com sucesso!")));
                      } on ReprintException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: Text('Reimprimir'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
