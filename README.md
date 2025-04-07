<h1 align="center">Flutter Stone Payment</h1>

<div align="center" id="top"> 
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Stone_pagamentos.png/800px-Stone_pagamentos.png" alt="Stone" height=120 />
</div>

## Plugin não oficial

<a href="https://buymeacoffee.com/luiz.carlos199" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="150">
</a>
<br />

<a href="https://www.linkedin.com/in/luizcarlos199lcdl/" target="_blank">
    <img src="https://img.shields.io/badge/-LinkedIn-%230077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" width="100"  style="margin: 5px 0px 5px 0;" />
</a>
<br />

<a href="https://github.com/Luiz-Carlos-de-Lima" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-black?style=for-the-badge&logo=github" alt="GitHub Repo" width="100" >
</a>

## Sobre

O **Flutter Stone Payment** Plugin é uma solução não oficial desenvolvida para integrar as funcionalidades de pagamento da Stone em aplicações Flutter executadas em terminais POS Android. Com este plugin, é possível processar transações de pagamento via `crédito`, `débito`, `voucher` e `Pix`, além de realizar `cancelamentos`, `impressão de recibos` e `reimpressão de transações` — tudo diretamente no dispositivo POS. A comunicação com os aplicativos da Stone é feita por meio de deeplinks, garantindo uma integração segura, eficiente e fluída.

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
  flutter_stone_payment: any
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

`StoneTransactionType`

Define os tipos de transação disponíveis:

* `DEBIT` - Transação via débito.

* `CREDIT` - Transação via crédito.

* `VOUCHER` - Transação com voucher.

* `INSTANT_PAYMENT` - Pagamento instantâneo.

* `PIX` - Transação via PIX.

`StoneInstallmentType`

Utilizado apenas quando `TransactionTyp.CREDIT`.

* `MERCHANT` - Parcelamento sem juros.

* `ISSUER` - Parcelamento com juros.

* `NONE` - à vista.

`StoneTypeCustomer`

Usado no reprint para determinar o tipo de guia impressa:

* `CLIENT` - Guia do cliente.

* `MERCHANT` - Guia da loja.

`StonePrintType`

Define os tipos de impressão disponíveis:

* `text` - Impressão de texto.

* `line` - Impressão de linha.

* `image` - Impressão de imagem.

`StonePrintAlign`

Define o alinhamento do conteúdo impresso na instância de ContentPrint, Utilizado apenas quando `StonePrintType.text`:

* `center` - Centralizado.

* `right` - Alinhado à direita.

* `left` - Alinhado à esquerda.

`StonePrintSize`

Define o tamanho do texto impresso na instância de ContentPrint:
Utilizado apenas quando `StonePrintType.text`:

`big` - Grande.

`medium` - Médio.

`small` - Pequeno.

## Exceptions

```dart	
StonePaymentException() // Exceção lançada quando ocorre algum erro na execução do método pay.
StoneCancelException() // Exceção lançada quando ocorre algum erro na execução do método cancel.
StonePrintException() // Exceção lançada quando ocorre algum erro na execução do método print.
StoneReprintException() // Exceção lançada quando ocorre algum erro na execução do método reprint.
```
## Método `pay`

No método `pay`, é necessário criar uma instância do tipo `StonePaymentPayload` com os seguintes parâmetros:

```dart	
final payment = StonePaymentPayload(
  amount: 100.00,
  transactionType: StoneTransactionType.CREDIT,
  orderId: '123456', //Exemplo de ID de pedido
  installmentCount: 4,
  installmentType: StoneInstallmentType.ISSUER,
  editableAmount: false
);
```

A estrutura de `StonePaymentPayload` é a seguinte:

```dart
class StonePaymentPayload {
  final double? amount;
  final StoneTransactionType? transactionType;
  final StoneInstallmentType? installmentType; //Apenas para StoneTransactionType.CREDIT
  final int? installmentCount; //Apenas para StoneTransactionType.CREDIT
  final bool editableAmount;
  final String orderId;

  StonePaymentPayload({
    this.amount,
    this.transactionType,
    this.installmentType,
    this.installmentCount,
    this.editableAmount = false,
    required this.orderId,
  }) : assert(
          transactionType == StoneTransactionType.CREDIT || (installmentType == null && installmentCount == null),
          'installmentType and installmentCount must be null for DEBIT, INSTANT_PAYMENT, VOUCHER, and PIX transactionType.',
        ),
        assert(
          transactionType != StoneTransactionType.CREDIT ||
              (installmentType == null && installmentCount == null) || 
              (installmentType == StoneInstallmentType.NONE && (installmentCount == null || installmentCount == 1)) || 
              ((installmentType == StoneInstallmentType.MERCHANT || installmentType == StoneInstallmentType.ISSUER) && (installmentCount == null || installmentCount > 1)),
          'For CREDIT transactions: installmentType can be null, but if it is NONE, installmentCount must be null or 1; '
          'if it is MERCHANT or ISSUER, installmentCount must be null or greater than 1.',
        );

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'transaction_type': transactionType?.name,
      'installment_type': transactionType == StoneTransactionType.CREDIT ? installmentType?.name : null,
      'installment_count': transactionType == StoneTransactionType.CREDIT && installmentType != null ? installmentCount?.toString() : null,
      'editable_amount': amount is double ? editableAmount : true,
      'order_id': orderId,
    };
  }

  static StonePaymentPayload fromJson(Map json) {
    return StonePaymentPayload(
      amount: json['amount'],
      transactionType: StoneTransactionType.values.firstWhere((e) => e.name == json['transaction_type']),
      installmentType: json['installment_type'] != null ? StoneInstallmentType.values.firstWhere((e) => e.name == json['installment_type']) : null,
      installmentCount: json['installment_count'],
      editableAmount: json['editable_amount'],
      orderId: json['order_id'],
    );
  }
}
```

O único parâmetro obrigatório é o `orderId`, que corresponde ao ID do pedido. Caso os demais valores não sejam informados, eles serão solicitados diretamente na aplicação de pagamento da Stone.

## Resposta do Pagamento

Caso a transação seja bem-sucedida, o retorno será uma instância do tipo `StonePaymentResponse` com a seguinte estrutura, Caso contrário, vai ser lançado uma exceção do tipo `StonePaymentException`.

```dart
class StonePaymentResponse {
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

  StonePaymentResponse({
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

  static StonePaymentResponse fromJson(Map json) {
    return StonePaymentResponse(
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

No método `cancel`, é necessário criar uma instância do tipo `StoneCancelPayload` com os seguintes parâmetros:

```dart	
StoneCancelPayload(
  amount: 30.00, 
  atk: '17251082184988', //ID do pagamento
  editableAmount: false,
);
```

A estrutura de `StoneCancelPayload` é a seguinte:

```dart
class StoneCancelPayload {
  final double? amount;
  final String atk;
  final bool editableAmount;

  StoneCancelPayload({required this.amount, required this.atk, this.editableAmount = false});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount is double ? (amount! * 100).toInt().toString() : '0',
      'atk': atk,
      'editable_amount': amount is double ? editableAmount : true,
    };
  }

  static StoneCancelPayload fromJson(Map json) {
    return StoneCancelPayload(
      amount: json['amount'],
      atk: json['atk'],
      editableAmount: json['editable_amount'],
    );
  }
}
```

O único parâmetro obrigatório é o `atk`, que corresponde ao ID do pagamento. Caso o amount não seja informado, ele será solicitado diretamente na aplicação de pagamento da Stone.

## Resposta do Cancelamento

Se a transação de cancelamento for bem-sucedida, o retorno será uma instância do tipo `StoneCancelResponse` com a seguinte estrutura, caso contrario, será lançado uma exceção do tipo `StoneCancelException`.

```dart	
class StoneCancelResponse {
  final String responseCode;
  final String atk;
  final String canceledAmount;
  final String paymentType;
  final String transactionAmount;
  final String orderId;
  final String authorizationCode;
  final String reason;

  StoneCancelResponse(
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

  static StoneCancelResponse fromJson(Map json) {
    return StoneCancelResponse(
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

No método `print`, é necessário criar uma instância do tipo `StonePrintPayload` com os seguintes parâmetros:

```dart
StonePrintPayload(
  printableContent: [
    StoneContentprint(
      type: StonePrintType.line,
      content: 'Texto a ser impresso'
    ),
     StoneContentprint(
      type: StonePrintType.text,
      align: StonePrintAlign.center, //Obrigatório quando StonePrintType.text
      size: StonePrintSize.big, ////Obrigatório quando StonePrintType.text
      content: 'Texto a ser impresso'
    ),
     StoneContentprint(
      type: StonePrintType.image, 
      imagePath: 'iVBORw0KGgoAAAANSUhEUgAAAHcAAAAuCAAAAAA309lpAAACMklEQVRYw91YQXLDIAyUMj027Us606f6RL7lJP0Ise/bg7ERSLLdZkxnyiVGIK0AoRVh0J+0l2ZITCAmSus8tYNNv9wUl8Xn2A6XZec8tsK9lN0zEaFBCxMc0M3IoHawBAAxffLx9/frY1kkEV0/iYjC8bjjmSRuCrHjcXMoS9zD4/nqePNf10v2whrkDRjLR4t8BWPXbdyRmccDgBMZUXDiiv2DeSK4sKwWrfgIda8V/6L6blZvLMARTescAohCD7xlcsItjYXEXHn2LIESzO3mDARPYTJXwiQ/VgWFobsYGKRdRy5x6/1QuAPpKdq89MiTS1x9EBXuYJyVZd46p6ndXVwAqfwJpd4C20uLk/LsUIilQ5Q11A4tuIU8Ti4bi8oz6lNX8iD8rNUdXDm3iMs81le4pUOLOJrGatzBx1VqVRSU8qAdNRc855GwHxcFblQbYTvqx3M0ZxZnZeBq+UoayI0h3y7QPMhOyQA9JMkO9aMIqs6Rmrw73T6ey9anvDX5kbinvT2PW7yYzj8ogrcYqBOJjNxc21d5EjmH0e/iaqUV9dXj3YgYtkvCjbjaqs5O+85MxVvwTcZdhR5YuFbckCSfNkHUolTcE9Cq9iQfXtV62bo9nUBIm8AXedPidimVFIjZCdYlTw4W8RtsatKC7Bt7D4t5tMle9qPD+y4uyL81FS/UnnVu3eMzhuj3G7CqzkHF77ISsaoraSsqVnRhq3rSZ+F5Ur//b5zOOVoAwDc6szxdC+PYAAAAAABJRU5ErkJggg=='
    )
  ], 
  showFeedbackScreen: false,
);
```

A propriedade `printableContent` é uma lista de objetos `StoneContentprint` que representam o conteúdo a ser impresso. O objeto `StoneContentprint` possui as seguintes propriedades:

```dart
class StoneContentprint {
  final StonePrintType type;
  final String? content; //Obrigatório quando StonePrintType.text ou StonePrintType.line
  final StonePrintAlign? align; //Obrigatório quando StonePrintType.text
  final StonePrintSize? size; //Obrigatório quando StonePrintType.text
  final String? imagePath; //Obrigatório quando StonePrintType.image

  StoneContentprint({
    required this.type,
    this.content,
    this.align,
    this.size,
    this.imagePath,
  })  : assert(
          type != StonePrintType.text || (content is String && align is StonePrintAlign && size is StonePrintSize),
          "content, align, and size must be defined when type is text",
        ),
        assert(
          type != StonePrintType.image || imagePath is String,
          "imagePath cannot be null when type is image",
        ),
        assert(
          type != StonePrintType.line || content is String,
          "content cannot be null when type is line",
        );

  Map<String, dynamic> toJson() {
    bool disableAlignAndSize = type != StonePrintType.text;

    return {
      'type': type.name.toString(),
      'content': type != StonePrintType.image ? content : null,
      'align': disableAlignAndSize ? null : align?.name.toString(),
      'size': disableAlignAndSize ? null : size?.name.toString(),
      'imagePath': type == StonePrintType.image ? imagePath : null,
    };
  }

  static StoneContentprint fromJson(Map<String, dynamic> json) {
    return StoneContentprint(
      type: StonePrintType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      align: json['align'] != null ? StonePrintAlign.values.firstWhere((e) => e.name == json['align']) : null,
      size: json['size'] != null ? StonePrintSize.values.firstWhere((e) => e.name == json['size']) : null,
      imagePath: json['imagePath'],
    );
  }
}
```

## Resposta de impressão

Caso a impressão seja bem-sucedida, a resposta será `void` caso contrário, será lançada uma exceção `StonePrintException` com a mensagem de erro.

## Método `reprint`

No método `reprint`, é necessário criar uma instância do tipo `StoneReprintPayload` com os seguintes parâmetros:

```dart
StoneReprintPayload(
  atk: '17251082184988', //identificador do pagamento
  typeCustomer: StoneTypeCustomer.CLIENT, //tipo de guia (CLIENT ou MERCHANT)
  showFeedbackScreen: false, //se true, exibe a tela de feedback após a impressão
);
```
A estrutura de `StoneReprintPayload` é a seguinte:

```dart
class StoneReprintPayload {
  final String atk;
  final StoneTypeCustomer typeCustomer;
  final bool showFeedbackScreen;

  StoneReprintPayload({required this.atk, required this.typeCustomer, required this.showFeedbackScreen});

  Map<String, dynamic> toJson() {
    return {
      'atk': atk,
      'type_customer': typeCustomer.name,
      'show_feedback_screen': showFeedbackScreen,
    };
  }

  static StoneReprintPayload fromJson(Map json) {
    return StoneReprintPayload(
      atk: json['atk'],
      typeCustomer: StoneTypeCustomer.values.firstWhere((e) => e.name == json['type_customer'], orElse: () => StoneTypeCustomer.MERCHANT),
      showFeedbackScreen: json['show_feedback_screen'],
    );
  }
}
```
## Resposta de reeimpressão

Caso a impressão seja bem-sucedida, a resposta será `void` caso contrário, será lançada uma exceção `StoneReprintException` com a mensagem de erro.

## Considerações Finais

Este plugin foi desenvolvido para rodar exclusivamente em terminais POS Android suportados pela Stone. Certifique-se de que sua aplicação atende a todos os requisitos antes de utilizá-lo.

Para mais informações, consulte a documentação oficial da Stone ou entre em contato com o suporte técnico da empresa.

## :memo: Autores

Este projeto foi desenvolvido por:
<a href="https://github.com/Luiz-Carlos-de-Lima" target="_blank">Luiz Carlos de Lima</a>
</br>
<div> 
<a href="https://github.com/Luiz-Carlos-de-Lima">
  <img src="https://avatars.githubusercontent.com/u/82920625?s=400&u=a114c12a6e61d2f9b907feb450587a37aae068bb&v=4" height=90 />
</a>
<br>
<a href="https://github.com/Luiz-Carlos-de-Lima" target="_blank">Luiz Carlos de Lima</a>
</div>

&#xa0;

## Licença

Este projeto está sob a licença MIT.

<a href="#top">Voltar para o topo</a>