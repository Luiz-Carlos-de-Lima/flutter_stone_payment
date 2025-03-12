package br.com.jclan.alphaxStonePayment.flutter_stone_payment

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink.CancelDeeplink
import br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink.Deeplink
import br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink.PaymentDeeplink
import br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink.PrintDeeplink
import br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink.ReprintDeeplink
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterStonePaymentPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel

  private val paymentDeeplink = PaymentDeeplink()
  private val cancelDeeplink = CancelDeeplink()
  private val printDeeplink = PrintDeeplink()
  private val reprintDeeplink = ReprintDeeplink()

  private var binding: ActivityPluginBinding? = null
  private var resultScope: Result? = null


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_stone_payment")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(newBinding: ActivityPluginBinding) {
    binding = newBinding
    binding?.addOnNewIntentListener { intent: Intent ->
      val uri: Uri? = intent.data
      if (uri != null && uri.scheme != null) {
        if (uri.scheme.equals("return_payment")) {
          val payment: Map<String, Any?> = paymentDeeplink.validateIntent(intent)
          sendResultData(payment)
        } else if (uri.scheme.equals("return_cancel")) {
          val cancel: Map<String, Any?> = cancelDeeplink.validateIntent(intent)
          sendResultData(cancel)
        }
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
    resultScope = result

    if ((binding?.activity is Activity).not()) {
      resultScope!!.error("UNAVAILABLE", "Activity is not available", null)
      return
    }

    when (call.method) {
      "pay" -> {
        val bundle = Bundle().apply {
          putString("amount", call.argument<String>("amount"))
          putString("transaction_type", call.argument<String>("transaction_type"))
          putString("installment_type", call.argument<String>("installment_type"))
          putString("installment_count", call.argument<String>("installment_count"))
          putString("order_id", call.argument<String>("order_id"))
          putBoolean("editable_amount", call.argument<Boolean?>("editable_amount") ?: false)
        }
        starDeeplink(paymentDeeplink, bundle)
      }
      "cancel" -> {
        val bundle = Bundle().apply {
          putString("amount", call.argument<String>("amount"))
          putString("atk", call.argument<String>("atk"))
          putBoolean("editable_amount", call.argument<Boolean?>("editable_amount") ?: false)
        }
        starDeeplink(cancelDeeplink, bundle)
      }
      "print" -> {
        val bundle = Bundle().apply {
          putBoolean("show_feedback_screen", call.argument<Boolean>("show_feedback_screen") ?: false)
          val listPrintContent: List<HashMap<String, Any?>>? = call.argument<List<HashMap<String, Any?>>>("printable_content")
          putParcelableArrayList("printable_content", listPrintContent?.toBundleList())
        }
        starDeeplink(printDeeplink, bundle)
      }
      "reprint" -> {
        val bundle = Bundle().apply {
          putBoolean("show_feedback_screen", call.argument<Boolean>("show_feedback_screen") ?: false)
          putString("atk", call.argument<String>("atk"))
          putString("type_customer", call.argument<String>("type_customer"))
        }
        starDeeplink(reprintDeeplink, bundle)
      }
      else ->  {
        resultScope?.error("ERROR", "Value of ", null)
      }
    }
    return
  }

  private fun starDeeplink(deeplink: Deeplink, bundle: Bundle) {
    val bundleStartDeeplink: Bundle = deeplink.startDeeplink(binding!!, bundle)
    val code: String = bundleStartDeeplink.getString("code") ?: "ERROR"

    if (code == "ERROR") {
      val message: String = (bundleStartDeeplink.getString("message") ?: "start deeplink error").toString()
      resultScope?.error(code, message, null)
    }
  }

  private fun sendResultData(paymentData: Map<String, Any?>) {
    if (paymentData["code"] == "SUCCESS") {
      resultScope?.success(paymentData["data"])
    } else {
      val message: String = (paymentData["message"] ?: "result error").toString()
      resultScope?.error((paymentData["code"] ?: "ERROR").toString(), message, null)
    }
  }

  private fun List<Map<String, Any?>>.toBundleList(): ArrayList<Bundle> {
    val bundleList = ArrayList<Bundle>()
    for (map in this) {
      bundleList.add(map.toBundle())
    }
    return bundleList
  }

  private fun Map<String, Any?>.toBundle(): Bundle {
    val bundle = Bundle()
    for ((key, value) in this) {
      when (value) {
        is String -> bundle.putString(key, value)
        is Int -> bundle.putInt(key, value)
        is Boolean -> bundle.putBoolean(key, value)
        is Double -> bundle.putDouble(key, value)
        is Float -> bundle.putFloat(key, value)
        is Long -> bundle.putLong(key, value)
        is Map<*, *> -> {
          @Suppress("UNCHECKED_CAST")
          bundle.putBundle(key, (value as? Map<String, Any?>)?.toBundle())
        }
      }
    }
    return bundle
  }
}