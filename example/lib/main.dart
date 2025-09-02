import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stone_payment/constants/stone_info_exception.dart';

import 'package:flutter_stone_payment/constants/stone_installment_type.dart';
import 'package:flutter_stone_payment/constants/stone_print_content_types.dart';
import 'package:flutter_stone_payment/constants/stone_reprint_type.dart';
import 'package:flutter_stone_payment/constants/stone_transaction_type.dart';
import 'package:flutter_stone_payment/exceptions/stone_cancel_exception.dart';
import 'package:flutter_stone_payment/exceptions/stone_payment_exception.dart';
import 'package:flutter_stone_payment/exceptions/stone_print_exception.dart';
import 'package:flutter_stone_payment/exceptions/stone_reprint_exception.dart';
import 'package:flutter_stone_payment/flutter_stone_payment.dart';
import 'package:flutter_stone_payment/models/stone_cancel_payload.dart';
import 'package:flutter_stone_payment/models/stone_content_print.dart';
import 'package:flutter_stone_payment/models/stone_payment_payload.dart';
import 'package:flutter_stone_payment/models/stone_print_payload.dart';
import 'package:flutter_stone_payment/models/stone_reprint_payload.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

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
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final info = await FlutterStonePayment().deviceInfo();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Device info: ${info.toJson()}")));
                    } on StoneInfoException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                  child: Text('Device Info'),
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
  const _PaymentPage();

  @override
  State<_PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<_PaymentPage> {
  final _amountEC = TextEditingController();
  final _qtdEC = TextEditingController();
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final List<DropdownMenuItem<StoneTransactionType?>> _listTypes =
      StoneTransactionType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<StoneInstallmentType?>> _listInstallmentType =
      StoneInstallmentType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  StoneTransactionType? _transactionType;
  StoneInstallmentType? _transactionInstallmentType;

  bool _editableAmount = false;

  @override
  void initState() {
    super.initState();
    _listTypes.add(DropdownMenuItem<StoneTransactionType>(value: null, child: Text('NENHUM')));
    _listInstallmentType.add(DropdownMenuItem<StoneInstallmentType>(value: null, child: Text('NENHUM')));
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
                  // if (_transactionType == StoneTransactionType.CREDIT)
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
                        final payment = StonePaymentPayload(
                            amount: amount,
                            transactionType: _transactionType,
                            orderId: Random().nextInt(1000).toString(),
                            installmentCount: qtdPar,
                            installmentType: _transactionInstallmentType,
                            editableAmount: _editableAmount);
                        final response = await _flutterStonePaymentPlugin.pay(paymentPayload: payment);

                        final print = StonePrintPayload(
                            printableContent: [StoneContentprint(type: StonePrintType.line, content: response.toJson().toString())], showFeedbackScreen: false);
                        await _flutterStonePaymentPlugin.print(printPayload: print);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Simulacao pagamento e Impressão realizada com sucesso!")));
                      } on StonePaymentException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                      } on StonePrintException catch (e) {
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
  const _CancelPage();

  @override
  State<_CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<_CancelPage> {
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final _amountEC = TextEditingController();
  final _atkEC = TextEditingController();

  String _responseCancel = "";
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
                  Text(_responseCancel),
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
                        _responseCancel = "SEM RESPOSTA";
                        double? amount = double.tryParse(_amountEC.text);
                        final cancel = StoneCancelPayload(amount: amount, atk: _atkEC.text, editableAmount: _editableAmount);
                        final response = await _flutterStonePaymentPlugin.cancel(cancelPayload: cancel);
                        _responseCancel = response.toJson().toString();
                        final print = StonePrintPayload(printableContent: [
                          StoneContentprint(
                              type: StonePrintType.text,
                              align: StonePrintAlign.center,
                              size: StonePrintSize.big,
                              content: "Cancelamento Simulado\n\n${response.toJson().toString()}"),
                        ], showFeedbackScreen: false);
                        await _flutterStonePaymentPlugin.print(printPayload: print);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Simulacao Cancelamento e Impressão realizada com sucesso! $cancel")));
                      } on StoneCancelException catch (e) {
                        _responseCancel = e.message;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                      } on StonePrintException catch (e) {
                        _responseCancel = e.message;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Simulação de pagamento realizado mas erro na impressão: ${e.message}")));
                      } catch (e) {
                        _responseCancel = "Erro desconhecido";
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                      } finally {
                        setState(() {});
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
  const _PrintPage();

  @override
  State<_PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<_PrintPage> {
  final _printTextEC = TextEditingController();
  final _imagePathEC = TextEditingController();
  final List<DropdownMenuItem<StonePrintType>> _listPrintType = StonePrintType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<StonePrintAlign>> _listPrintAlign = StonePrintAlign.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();
  final List<DropdownMenuItem<StonePrintSize>> _listPrintSize = StonePrintSize.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();

  StonePrintType _printType = StonePrintType.line;
  StonePrintAlign? _printAlign = null;
  StonePrintSize? _printSize = null;
  bool _ignoreLineBreak = false;
  String? _defaultImage64;
  List<Map> _previewBase64 = [];

  final List<StoneContentprint> _receiptContent = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultImage();
  }

  @override
  void dispose() {
    _printTextEC.dispose();
    _imagePathEC.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultImage() async {
    final image64 = await imageToBase64('https://css-tricks.com/wp-content/uploads/2022/08/flutter-clouds.jpg');
    setState(() {
      _defaultImage64 = image64;
      if (_imagePathEC.text.isEmpty && image64 != null) {
        _imagePathEC.text = image64;
      }
    });
  }

  void _addToReceipt() {
    String? image64;
    if (_printType == StonePrintType.image) {
      image64 = _imagePathEC.text.isNotEmpty ? _imagePathEC.text : _defaultImage64;
      if (image64 == null || image64.isEmpty) return;
    }
    if (_printType != StonePrintType.image && _printTextEC.text.isEmpty) return;

    final item = StoneContentprint(
      type: _printType,
      align: _printAlign,
      content: _printTextEC.text,
      size: _printSize,
      imagePath: image64,
      ignoreLineBreak: _ignoreLineBreak,
    );
    setState(() {
      _receiptContent.add(item);
      _printTextEC.clear();
    });
  }

  void _removeLine(int index) {
    setState(() {
      _receiptContent.removeAt(index);
    });
  }

  void _clearReceipt() {
    setState(() {
      _receiptContent.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Impressão'), centerTitle: true, leading: Container()),
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
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                    height: 55,
                    child: DropdownButton(
                      value: _printType,
                      items: _listPrintType,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        setState(() {
                          _printType = value!;
                          if (_printType == StonePrintType.text) {
                            _printAlign = StonePrintAlign.center;
                            _printSize = StonePrintSize.medium;
                          } else {
                            _printAlign = null;
                            _printSize = null;
                          }
                        });
                      },
                    ),
                  ),
                  if (_printType == StonePrintType.text) ...[
                    SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: Text('Alinhamento da Impressão')),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                      height: 55,
                      child: DropdownButton(
                        value: _printAlign,
                        items: _listPrintAlign,
                        isExpanded: true,
                        underline: Container(),
                        onChanged: (value) {
                          setState(() {
                            _printAlign = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: Text('Tamanho da Impressão')),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
                      height: 55,
                      child: DropdownButton(
                        value: _printSize,
                        items: _listPrintSize,
                        isExpanded: true,
                        underline: Container(),
                        onChanged: (value) {
                          setState(() {
                            _printSize = value!;
                          });
                        },
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Ignorar Quebra de Linha'),
                      value: _ignoreLineBreak,
                      onChanged: (val) {
                        setState(() {
                          _ignoreLineBreak = val;
                        });
                      },
                    ),
                  ],
                  if (_printType != StonePrintType.image)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(alignment: Alignment.centerLeft, child: Text('Texto para Impressão')),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _printTextEC,
                          decoration: InputDecoration(hintText: 'Texto', border: OutlineInputBorder()),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(alignment: Alignment.centerLeft, child: Text('Base64 da Imagem')),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _imagePathEC,
                          decoration: InputDecoration(hintText: 'Cole o Base64 da imagem', border: OutlineInputBorder()),
                          minLines: 2,
                          maxLines: 4,
                        ),
                        if (_defaultImage64 != null)
                          Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Image.memory(base64Decode(_defaultImage64!))),
                      ],
                    ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(onPressed: _addToReceipt, child: Text('Adicionar ao Recibo')),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(onPressed: _receiptContent.isEmpty ? null : _clearReceipt, child: Text('Remover tudo')),
                      ),
                    ],
                  ),
                  Divider(height: 32),
                  if (_receiptContent.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Conteúdo do Recibo:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ..._receiptContent.asMap().entries.map(
                              (entry) => Card(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(entry.value.type.name),
                                  subtitle: Text(entry.value.type == StonePrintType.image ? 'Imagem' : (entry.value.content ?? '')),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Remover linha',
                                    onPressed: () => _removeLine(entry.key),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  SizedBox(height: 20),
                  if (_previewBase64.isNotEmpty) ...[
                    Text("Pré-visualização:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ...List.generate(_previewBase64.length, (index) {
                      if (_previewBase64[index]['imageBase64'] is String && _previewBase64[index]['imageBase64'].isNotEmpty) {
                        return Column(
                          children: [
                            if (_previewBase64[index]['messageError'] != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(_previewBase64[index]['messageError'], style: TextStyle(color: Colors.red)),
                              ),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Image.memory(base64Decode(_previewBase64[index]['imageBase64']))),
                          ],
                        );
                      }

                      return SizedBox.shrink();
                    }),
                    SizedBox(height: 10),
                  ],
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
                    onPressed: _receiptContent.isEmpty
                        ? null
                        : () async {
                            try {
                              final flutterStonePaymentPlugin = FlutterStonePayment();
                              final print = StonePrintPayload(
                                  printableContent: List<StoneContentprint>.from([
                                    StoneContentprint(
                                        type: StonePrintType.text,
                                        content: '''                 JCLAN SISTEMAS                 
------------------------------------------------
          BAR           
================================================
Comanda: 44             
------------------------------------------------
Entregar na Mesa: 12                            
------------------------------------------------
IMP: 01/2 (BR)                                  
At: 0 - Suporte                                 
Term: 1                       Dt: 25/08/25 11:01
================================================
Qtde - Produto                                  
------------------------------------------------
1 - FANTA UVA                                   
------------------------------------------------
                  Data Impressao: 25/08/25 11:01
                                                                 JCLAN SISTEMAS                 
------------------------------------------------
          BAR           
================================================
Comanda: 44             
------------------------------------------------
Entregar na Mesa: 12                            
------------------------------------------------
IMP: 11/2 (BR)                                  
At: 0 - Suporte                                 
Term: 1                       Dt: 25/08/25 11:01
================================================
Qtde - Produto                                  
------------------------------------------------
1 - DEL VALLE MARACUJA                          
------------------------------------------------
                  Data Impressao: 25/08/25 11:01
''',
                                        size: StonePrintSize.small,
                                        ignoreLineBreak: true,
                                        align: StonePrintAlign.left)
                                  ]),
                                  showFeedbackScreen: true);
                              await flutterStonePaymentPlugin.print(printPayload: print);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Impressão realizada com sucesso!")));
                              setState(() {});
                            } on StonePrintException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro desconhecido')));
                            }
                          },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: Text('Imprimir'),
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
      if (kDebugMode) {
        print("Erro ao converter imagem para Base64: $e");
      }
    }
    return null;
  }
}

class _ReprintPage extends StatefulWidget {
  const _ReprintPage();

  @override
  State<_ReprintPage> createState() => _ReprintPageState();
}

class _ReprintPageState extends State<_ReprintPage> {
  final _flutterStonePaymentPlugin = FlutterStonePayment();
  final _atkEC = TextEditingController();
  final List<DropdownMenuItem<StoneTypeCustomer>> _listTypeCustomer =
      StoneTypeCustomer.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList();

  StoneTypeCustomer _typeCustomer = StoneTypeCustomer.MERCHANT;

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
                        final reprint = StoneReprintPayload(atk: _atkEC.text, typeCustomer: _typeCustomer, showFeedbackScreen: _showFeedbackScreen);
                        await _flutterStonePaymentPlugin.reprint(reprintPayload: reprint);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Impressão realizada com sucesso!")));
                      } on StoneReprintException catch (e) {
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
