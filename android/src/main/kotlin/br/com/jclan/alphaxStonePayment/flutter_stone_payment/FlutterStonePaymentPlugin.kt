package br.com.jclan.alphaxStonePayment.flutter_stone_payment

import android.app.Activity
import android.net.Uri
import android.os.Bundle
import android.util.Log
import br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink.PaymentDeeplink
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterStonePaymentPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel: MethodChannel
  private var binding: ActivityPluginBinding? = null
  private var resultScope: Result? = null
  private var paymentDeeplink = PaymentDeeplink()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_stone_payment")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(newBinding: ActivityPluginBinding) {
    binding = newBinding
    binding?.addOnNewIntentListener { intent ->
      val uri: Uri? = intent.data
      if (uri != null && uri.scheme != null && uri.scheme.equals("return_payment")) {
        val bundle: Bundle = paymentDeeplink.validateIntent(intent)
        paymentResult(bundle)
      }
      true
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    binding = null
  }

  override fun onReattachedToActivityForConfigChanges(newBinding: ActivityPluginBinding) {
    onAttachedToActivity(newBinding)
  }

  override fun onDetachedFromActivity() {
    binding = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "pay" -> {
        if ((binding?.activity is Activity).not()) {
          result.error("UNAVAILABLE", "Activity is not available", null)
          return
        }

        resultScope = result

        val bundle = Bundle().apply {
          putString("amount", call.argument<String>("amount"))
          putString("transaction_type", call.argument<String>("transactionType"))
          putString("installment_type", call.argument<String>("installmentType"))
          putString("installment_count", call.argument<String>("installmentCount"))
          putString("order_id", call.argument<String>("orderId"))
        }

        paymentDeeplink.call(binding!!, bundle)
      }
      else ->  {
        resultScope?.notImplemented()
      }
    }
    return
  }

  private fun paymentResult(bundle: Bundle) {
    val code: String? = bundle.getString("code")

    if (code == "SUCCESS") {
      val dataBundle = bundle.getBundle("data")

      val resultMap = mapOf(
        "code" to code,
        "data" to mapOf(
          "cardholder_name" to dataBundle?.getString("cardholder_name"),
          "itk" to dataBundle?.getString("itk"),
          "atk" to dataBundle?.getString("atk"),
          "brand" to dataBundle?.getString("brand"),
          "authorization_date_time" to dataBundle?.getString("authorization_date_time"),
          "order_id" to dataBundle?.getString("order_id"),
          "authorization_code" to dataBundle?.getString("authorization_code"),
          "installment_count" to dataBundle?.getString("installment_count"),
          "pan" to dataBundle?.getString("pan"),
          "type" to dataBundle?.getString("type"),
          "entry_mode" to dataBundle?.getString("entry_mode"),
          "account_id" to dataBundle?.getString("account_id"),
          "customer_wallet_provider_id" to dataBundle?.getString("customer_wallet_provider_id"),
          "code" to dataBundle?.getString("code"),
          "transaction_qualifier" to dataBundle?.getString("transaction_qualifier"),
          "amount" to dataBundle?.getString("amount")
        )
      )

      resultScope?.success(resultMap)
    } else {
        val message = bundle.getString("message") ?: "Payment error"
        resultScope?.error(code ?: "ERROR", message, null)
    }
  }
}