package br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class PaymentDeeplink: Deeplink {
    override fun startDeeplink(binding: ActivityPluginBinding ,bundle: Bundle) : Bundle {
        try {
            val amount: String? = bundle.getString("amount")
            val transactionType: String? = bundle.getString("transaction_type")
            val orderId: String? = bundle.getString("order_id")
            val installmentType: String? = bundle.getString("installment_type")
            val installmentCount: String? = bundle.getString("installment_count")
            val returnIntentName: String = "return_payment"

            var editableAmount: String = "0"

            if (orderId == null) {
                throw IllegalArgumentException("Invalid payment data: orderId")
            }
            if (bundle.getBoolean("editable_amount")) {
                editableAmount = "1"
            }

            val uriBuilder = Uri.Builder().apply {
                authority("pay")
                scheme("payment-app")
                appendQueryParameter("amount", amount)
                appendQueryParameter("transaction_type", transactionType)
                appendQueryParameter("order_id", orderId)
                appendQueryParameter("editable_amount", editableAmount)
                appendQueryParameter("return_scheme", returnIntentName)
            }

            if (installmentType != null) {
                uriBuilder.appendQueryParameter("installment_type", installmentType)
            }
            if (installmentCount != null) {
                uriBuilder.appendQueryParameter("installment_count", installmentCount)
            }

            val paymentIntent = Intent(Intent.ACTION_VIEW)
            paymentIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            paymentIntent.data = uriBuilder.build()
            binding.activity.startActivity(paymentIntent)

            return Bundle().apply {
                putString("code", "SUCCESS")
            }
        } catch (e: IllegalArgumentException) {
            return Bundle().apply {
                putString("code", "ERROR")
                putString("message", e.message)
            }
        } catch (e: Exception) {
            return Bundle().apply {
                putString("code", "ERROR")
                putString("message", e.message ?: "An unexpected error occurred")
            }
        }
    }

    override fun validateIntent(intent: Intent?): Map<String, Any?> {
        try {
            val returnUri: Uri? = intent?.data
            if (returnUri != null) {
                val code = returnUri.getQueryParameter("code")
                val success = returnUri.getQueryParameter("success")
                if (code == "0") {
                    return mapOf(
                        "code" to "SUCCESS",
                        "data" to mapOf(
                            "cardholder_name" to returnUri.getQueryParameter("cardholder_name"),
                            "itk" to returnUri.getQueryParameter("itk"),
                            "atk" to returnUri.getQueryParameter("atk"),
                            "authorization_date_time" to returnUri.getQueryParameter("authorization_date_time"),
                            "brand" to returnUri.getQueryParameter("brand"),
                            "order_id" to returnUri.getQueryParameter("order_id"),
                            "authorization_code" to returnUri.getQueryParameter("authorization_code"),
                            "installment_count" to returnUri.getQueryParameter("installment_count"),
                            "pan" to returnUri.getQueryParameter("pan"),
                            "type" to returnUri.getQueryParameter("type"),
                            "entry_mode" to returnUri.getQueryParameter("entry_mode"),
                            "account_id" to returnUri.getQueryParameter("account_id"),
                            "customer_wallet_provider_id" to returnUri.getQueryParameter("customer_wallet_provider_id"),
                            "code" to returnUri.getQueryParameter("code"),
                            "transaction_qualifier" to returnUri.getQueryParameter("transaction_qualifier"),
                            "amount" to returnUri.getQueryParameter("amount")
                        )
                    )
                } else if (success == "false") {
                    val message = returnUri.getQueryParameter("message") ?: "Unauthorized"
                    return mapOf(
                        "code" to "ERROR",
                        "message" to message
                    )
                } else {
                    return mapOf(
                        "code" to "ERROR",
                        "message" to "Unauthorized"
                    )
                }
            } else {
                return mapOf(
                    "code" to "ERROR",
                    "message" to "No data return of intent"
                )
            }
        } catch (e: Exception) {
            return mapOf(
                "code" to "ERROR",
                "message" to e.toString()
            )
        }
    }
}