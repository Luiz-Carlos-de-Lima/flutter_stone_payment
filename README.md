# Flutter Stone Payment Plugin

O **Flutter Stone Payment Plugin** é uma solução desenvolvida para integrar as funcionalidades de pagamento da Stone em aplicações Flutter que rodam em terminais POS Android. Este plugin permite realizar transações de pagamento (crédito, débito e voucher, Pix), cancelamentos, impressão de recibos e reimpressão de transações, tudo diretamente no dispositivo POS. Ele utiliza deep links para se comunicar com os aplicativos da Stone, garantindo uma integração segura e eficiente.

---

## Requisitos

Antes de utilizar o plugin, certifique-se de que os seguintes requisitos sejam atendidos:

- **Aplicação Android rodando em um terminal POS compatível**.
- **Versão mínima do Android**: 5.0+ (API 21).
- **Cadastro no programa de parcerias da Stone**.
- **Aplicativos da Stone instalados no dispositivo POS**.

---

## Modelos de POS Suportados

O plugin é compatível com os seguintes modelos de terminais POS:

- Ingenico APOS A8
- Sunmi P2-B
- Positivo L400
- Positivo L300
- Gertec GPOS 700X
- Gertec GPOS 700
- Tectoy T8

---

## Configuração no `AndroidManifest.xml`

Para garantir o funcionamento correto do plugin e seus retornos, adicione os seguintes filtros de intenção na activity principal (`intent-filter`) no arquivo `AndroidManifest.xml`, localizado em `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter>
    <action android:name="android.intent.action.MAIN"/>
    <category android:name="android.intent.category.LAUNCHER"/>
</intent-filter>
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:host="pay-response" android:scheme="return_payment" />
</intent-filter>
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:host="cancel" android:scheme="return_cancel" />
</intent-filter>
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:host="print" android:scheme="return_print" />
</intent-filter>
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:host="reprint" android:scheme="return_reprint" />
</intent-filter>
```

## Instalação

Adicione a dependência do plugin ao seu projeto Flutter:

```yaml
dependencies:
  flutter_stone_payment: ^1.0.2
```

## Uso

Para utilizar o plugin, basta criar uma instância e chamar os métodos disponíveis:

```dart
import 'package:flutter_stone_payment/flutter_stone_payment.dart';

final _flutterStonePaymentPlugin = FlutterStonePayment();

// Para realizar um pagamento
final response = await _flutterStonePaymentPlugin.pay(paymentPayload: payment);

// Para cancelar um pagamento
final response = await _flutterStonePaymentPlugin.cancel(cancelPayload: cancel);

// Para imprimir um recibo
final response = await _flutterStonePaymentPlugin.print(printPayload: print);

// Para reimprimir um recibo
final response = await _flutterStonePaymentPlugin.reprint(reprintPayload: reprint);
```

## Enums Disponíveis

`TransactionType`

Define os tipos de transação disponíveis:

* `DEBIT` - Transação via débito.

* `CREDIT` - Transação via crédito.

* `VOUCHER` - Transação com voucher.

* `INSTANT_PAYMENT` - Pagamento instantâneo.

* `PIX` - Transação via PIX.

`InstallmentType`

Utilizado apenas quando `TransactionTyp.CREDIT`.

* `MERCHANT` - Parcelamento via estabelecimento.

* `ISSUER` - Parcelamento via emissor do cartão.

* `NONE` - Sem parcelamento.

`TypeCustomer`

Usado no reprint para determinar o tipo de guia impressa:

* `CLIENT` - Guia do cliente.

* `MERCHANT` - Guia da loja.

`PrintType`

Define os tipos de impressão disponíveis:

* `text` - Impressão de texto.

* `line` - Impressão de linha.

* `image` - Impressão de imagem.

`PrintAlign`

Define o alinhamento do conteúdo impresso na instância de ContentPrint, Utilizado apenas quando `PrintType.text`:

* `center` - Centralizado.

* `right` - Alinhado à direita.

* `left` - Alinhado à esquerda.

`PrintSize`

Define o tamanho do texto impresso na instância de ContentPrint:
Utilizado apenas quando `PrintType.text`:

`big` - Grande.

`medium` - Médio.

`small` - Pequeno.

## Eceptions

```dart	
PaymentException() // Exceção lançada quando ocorre algum erro na execução do método pay.
CancelException() // Exceção lançada quando ocorre algum erro na execução do método cancel.
PrintException() // Exceção lançada quando ocorre algum erro na execução do método print.
ReprintException() // Exceção lançada quando ocorre algum erro na execução do método reprint.
```
## Método `pay`

No método pay, é necessário criar uma instância do tipo PaymentPayload com os seguintes parâmetros:

```dart	
final payment = PaymentPayload(
  amount: 100.00,
  transactionType: TransactionType.CREDIT,
  orderId: '123456', //Exemplo de ID de pedido
  installmentCount: 4,
  installmentType: InstallmentType.ISSUER,
  editableAmount: false
);
```

A estrutura de `PaymentPayload` é a seguinte:

```dart
class PaymentPayload {
  final double? amount;
  final TransactionType? transactionType;
  final InstallmentType? installmentType; //Apenas para TransactionType.CREDIT
  final int? installmentCount; //Apenas para TransactionType.CREDIT
  final bool editableAmount;
  final String orderId;

  PaymentPayload({
    this.amount,
    this.transactionType,
    this.installmentType,
    this.installmentCount,
    this.editableAmount = false,
    required this.orderId,
  }) : assert(
          transactionType == TransactionType.CREDIT || (installmentType == null && installmentCount == null),
          'installmentType and installmentCount must be null for DEBIT, INSTANT_PAYMENT, VOUCHER, and PIX transactionType.',
        ),
        assert(
          transactionType != TransactionType.CREDIT ||
              (installmentType == null && installmentCount == null) || 
              (installmentType == InstallmentType.NONE && (installmentCount == null || installmentCount == 1)) || 
              ((installmentType == InstallmentType.MERCHANT || installmentType == InstallmentType.ISSUER) && (installmentCount == null || installmentCount > 1)),
          'For CREDIT transactions: installmentType can be null, but if it is NONE, installmentCount must be null or 1; '
          'if it is MERCHANT or ISSUER, installmentCount must be null or greater than 1.',
        );

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'transaction_type': transactionType?.name,
      'installment_type': transactionType == TransactionType.CREDIT ? installmentType?.name : null,
      'installment_count': transactionType == TransactionType.CREDIT && installmentType != null ? installmentCount?.toString() : null,
      'editable_amount': amount is double ? editableAmount : true,
      'order_id': orderId,
    };
  }

  static PaymentPayload fromJson(Map json) {
    return PaymentPayload(
      amount: json['amount'],
      transactionType: TransactionType.values.firstWhere((e) => e.name == json['transaction_type']),
      installmentType: json['installment_type'] != null ? InstallmentType.values.firstWhere((e) => e.name == json['installment_type']) : null,
      installmentCount: json['installment_count'],
      editableAmount: json['editable_amount'],
      orderId: json['order_id'],
    );
  }
}
```

O único parâmetro obrigatório é o `orderId`, que corresponde ao ID do pedido. Caso os demais valores não sejam informados, eles serão solicitados diretamente na aplicação de pagamento da Stone.

## Resposta do Pagamento

Caso a transação seja bem-sucedida, o retorno será uma instância do tipo `PaymentResponse` com a seguinte estrutura, Caso contrário, vai ser lançado uma exceção do tipo `PaymentException`.

```dart
class PaymentResponse {
  final String cardholderName;
  final String itk;
  final String atk;
  final String brand;
  final String authorizationDateTime;
  final String orderId;
  final String authorizationCode;
  final String installmentCount;
  final String pan;
  final String type;
  final String entryMode;
  final String accountId;
  final String customerWalletProviderId;
  final String code;
  final String transactionQualifier;
  final String amount;

  PaymentResponse({
    required this.cardholderName,
    required this.itk,
    required this.atk,
    required this.brand,
    required this.authorizationDateTime,
    required this.orderId,
    required this.authorizationCode,
    required this.installmentCount,
    required this.pan,
    required this.type,
    required this.entryMode,
    required this.accountId,
    required this.customerWalletProviderId,
    required this.code,
    required this.transactionQualifier,
    required this.amount,
  });

  static PaymentResponse fromJson(Map json) {
    return PaymentResponse(
      cardholderName: json['cardholder_name'] ?? "cardholder_name is Null",
      itk: json['itk'] ?? "itk is Null",
      atk: json['atk'] ?? "atk is Null",
      brand: json['brand'] ?? "brand is Null",
      authorizationDateTime: json['authorization_date_time'] ?? "authorization_date_time is Null",
      orderId: json['order_id'],
      authorizationCode: json['authorization_code'],
      installmentCount: json['installment_count'],
      pan: json['pan'],
      type: json['type'],
      entryMode: json['entry_mode'],
      accountId: json['account_id'],
      customerWalletProviderId: json['customer_wallet_provider_id'],
      code: json['code'],
      transactionQualifier: json['transaction_qualifier'],
      amount: json['amount'],
    );
  }
}
```

## Método `cancel`

No método cancel, é necessário criar uma instância do tipo CancelPayload com os seguintes parâmetros:

```dart	
CancelPayload(
  amount: 30.00, 
  atk: '17251082184988', //ID do pagamento
  editableAmount: false,
);
```

A estrutura de `CancelPayload` é a seguinte:

```dart
class CancelPayload {
  final double? amount;
  final String atk;
  final bool editableAmount;

  CancelPayload({required this.amount, required this.atk, this.editableAmount = false});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'atk': atk,
      'editable_amount': amount is double ? editableAmount : true,
    };
  }

  static CancelPayload fromJson(Map json) {
    return CancelPayload(
      amount: json['amount'],
      atk: json['atk'],
      editableAmount: json['editable_amount'],
    );
  }
}
```

## Resposta do Cancelamento

Se a transação de cancelamento for bem-sucedida, o retorno será uma instância do tipo `CancelResponse` com a seguinte estrutura, caso contrario, será lançado uma exceção do tipo `CancelException`.

```dart	
class CancelResponse {
  final String responseCode;
  final String atk;
  final String canceledAmount;
  final String paymentType;
  final String transactionAmount;
  final String orderId;
  final String authorizationCode;
  final String reason;

  CancelResponse(
      {required this.responseCode,
      required this.atk,
      required this.canceledAmount,
      required this.paymentType,
      required this.transactionAmount,
      required this.orderId,
      required this.authorizationCode,
      required this.reason});

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'atk': atk,
      'canceled_amount': canceledAmount,
      'payment_type': paymentType,
      'transaction_amount': transactionAmount,
      'order_id': orderId,
      'authorization_code': authorizationCode,
      'reason': reason,
    };
  }

  static CancelResponse fromJson(Map json) {
    return CancelResponse(
      responseCode: json['response_code'] ?? "response_code is Null",
      atk: json['atk'],
      canceledAmount: json['canceled_amount'] ?? "canceled_amount is Null",
      paymentType: json['payment_type'] ?? "payment_type is Null",
      transactionAmount: json['transaction_amount'] ?? "transaction_amount is Null",
      orderId: json['order_id'] ?? "order_id is Null",
      authorizationCode: json['authorization_code'] ?? "authorization_code is Null",
      reason: json['reason'] ?? "reason is Null",
    );
  }
}
```

## Método `print`

No método print, é necessário criar uma instância do tipo `PrintPayload` com os seguintes parâmetros:

```dart
PrintPayload(
  printableContent: [
    Contentprint(
      type: PrintType.line,
      content: 'Texto a ser impresso'
    ),
     Contentprint(
      type: PrintType.text,
      align: PrintAlign.center, //Obrigatório quando PrintType.text
      size: PrintSize.big, ////Obrigatório quando PrintType.text
      content: 'Texto a ser impresso'
    ),
     Contentprint(
      type: PrintType.image, 
      imagePath: 'iVBORw0KGgoAAAANSUhEUgAAAHcAAAAuCAAAAAA309lpAAACMklEQVRYw91YQXLDIAyUMj027Us606f6RL7lJP0Ise/bg7ERSLLdZkxnyiVGIK0AoRVh0J+0l2ZITCAmSus8tYNNv9wUl8Xn2A6XZec8tsK9lN0zEaFBCxMc0M3IoHawBAAxffLx9/frY1kkEV0/iYjC8bjjmSRuCrHjcXMoS9zD4/nqePNf10v2whrkDRjLR4t8BWPXbdyRmccDgBMZUXDiiv2DeSK4sKwWrfgIda8V/6L6blZvLMARTescAohCD7xlcsItjYXEXHn2LIESzO3mDARPYTJXwiQ/VgWFobsYGKRdRy5x6/1QuAPpKdq89MiTS1x9EBXuYJyVZd46p6ndXVwAqfwJpd4C20uLk/LsUIilQ5Q11A4tuIU8Ti4bi8oz6lNX8iD8rNUdXDm3iMs81le4pUOLOJrGatzBx1VqVRSU8qAdNRc855GwHxcFblQbYTvqx3M0ZxZnZeBq+UoayI0h3y7QPMhOyQA9JMkO9aMIqs6Rmrw73T6ey9anvDX5kbinvT2PW7yYzj8ogrcYqBOJjNxc21d5EjmH0e/iaqUV9dXj3YgYtkvCjbjaqs5O+85MxVvwTcZdhR5YuFbckCSfNkHUolTcE9Cq9iQfXtV62bo9nUBIm8AXedPidimVFIjZCdYlTw4W8RtsatKC7Bt7D4t5tMle9qPD+y4uyL81FS/UnnVu3eMzhuj3G7CqzkHF77ISsaoraSsqVnRhq3rSZ+F5Ur//b5zOOVoAwDc6szxdC+PYAAAAAABJRU5ErkJggg=='
    )
  ], 
  showFeedbackScreen: false,
);
```

A propriedade `printableContent` é uma lista de objetos `Contentprint` que representam o conteúdo a ser impresso. O objeto `Contentprint` possui as seguintes propriedades:

```dart
class Contentprint {
  final PrintType type;
  final String? content; //Obrigatório quando PrintType.text ou PrintType.line
  final PrintAlign? align; //Obrigatório quando PrintType.text
  final PrintSize? size; //Obrigatório quando PrintType.text
  final String? imagePath; //Obrigatório quando PrintType.image

  Contentprint({
    required this.type,
    this.content,
    this.align,
    this.size,
    this.imagePath,
  })  : assert(
          type != PrintType.text || (content is String && align is PrintAlign && size is PrintSize),
          "content, align, and size must be defined when type is text",
        ),
        assert(
          type != PrintType.image || imagePath is String,
          "imagePath cannot be null when type is image",
        ),
        assert(
          type != PrintType.line || content is String,
          "content cannot be null when type is line",
        );

  Map<String, dynamic> toJson() {
    bool disableAlignAndSize = type != PrintType.text;

    return {
      'type': type.name.toString(),
      'content': type != PrintType.image ? content : null,
      'align': disableAlignAndSize ? null : align?.name.toString(),
      'size': disableAlignAndSize ? null : size?.name.toString(),
      'imagePath': type == PrintType.image ? imagePath : null,
    };
  }

  static Contentprint fromJson(Map<String, dynamic> json) {
    return Contentprint(
      type: PrintType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      align: json['align'] != null ? PrintAlign.values.firstWhere((e) => e.name == json['align']) : null,
      size: json['size'] != null ? PrintSize.values.firstWhere((e) => e.name == json['size']) : null,
      imagePath: json['imagePath'],
    );
  }
}
```

## Resposta de impressão

Caso a impressão seja bem-sucedida, a resposta será `void` caso contrário, será lançada uma exceção `PrintException` com a mensagem de erro.

## Método `reprint`

No método reprint, é necessário criar uma instância do tipo `ReprintPayload` com os seguintes parâmetros:

```dart
ReprintPayload(
  atk: '17251082184988', //identificador do pagamento
  typeCustomer: TypeCustomer.CLIENT, //tipo de guia (CLIENT ou MERCHANT)
  showFeedbackScreen: false, //se true, exibe a tela de feedback após a impressão
);
```
A estrutura de `ReprintPayload` é a seguinte:

```dart
class ReprintPayload {
  final String atk;
  final TypeCustomer typeCustomer;
  final bool showFeedbackScreen;

  ReprintPayload({required this.atk, required this.typeCustomer, required this.showFeedbackScreen});

  Map<String, dynamic> toJson() {
    return {
      'atk': atk,
      'type_customer': typeCustomer.name,
      'show_feedback_screen': showFeedbackScreen,
    };
  }

  static ReprintPayload fromJson(Map json) {
    return ReprintPayload(
      atk: json['atk'],
      typeCustomer: TypeCustomer.values.firstWhere((e) => e.name == json['type_customer'], orElse: () => TypeCustomer.MERCHANT),
      showFeedbackScreen: json['show_feedback_screen'],
    );
  }
}
```
## Resposta de reeimpressão

Caso a impressão seja bem-sucedida, a resposta será `void` caso contrário, será lançada uma exceção `ReprintException` com a mensagem de erro.

## Considerações Finais

Este plugin foi desenvolvido para rodar exclusivamente em terminais POS Android suportados pela Stone. Certifique-se de que sua aplicação atende a todos os requisitos antes de utilizá-lo.

Para mais informações, consulte a documentação oficial da Stone ou entre em contato com o suporte técnico da empresa.

## Licença

Este projeto está sob a licença MIT.