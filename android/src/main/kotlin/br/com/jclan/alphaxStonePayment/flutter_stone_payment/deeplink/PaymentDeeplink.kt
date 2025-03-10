package br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class PaymentDeeplink() {
    fun call(binding: ActivityPluginBinding ,bundle: Bundle) : Bundle {
        try {
            val amount: String? = bundle.getString("amount")
            val transactionType: String? = bundle.getString("transaction_type")
            val orderId: String? = bundle.getString("order_id")
            val installmentType: String? = bundle.getString("installment_type")
            val installmentCount: String? = bundle.getString("installment_count")

            if (amount == null) {
                throw IllegalArgumentException("Invalid payment data: amount")
            }
            if (transactionType == null) {
                throw IllegalArgumentException("Invalid payment data: transaction_type")
            }
            if (orderId == null) {
                throw IllegalArgumentException("Invalid payment data: orderId")
            }

            val uriBuilder = Uri.Builder().apply {
                authority("pay")
                scheme("payment-app")
                appendQueryParameter("amount", amount)
                appendQueryParameter("transaction_type", transactionType)
                appendQueryParameter("order_id", orderId)
                appendQueryParameter("editable_amount", "0")
                appendQueryParameter("return_scheme", "return_payment")
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

    fun validateIntent(intent: Intent?) : Bundle {
        try {
            val returnUri: Uri? = intent?.data
            if (returnUri != null) {
                val code = returnUri.getQueryParameter("code")
                val success = returnUri.getQueryParameter("success")
                if (code == "0") {
                   return Bundle().apply {
                        putString("code", "SUCCESS")
                        putBundle("data", Bundle().apply {
                            putString("cardholder_name", returnUri.getQueryParameter("cardholder_name"))
                            putString("itk", returnUri.getQueryParameter("itk"))
                            putString("atk", returnUri.getQueryParameter("atk"))
                            putString("authorization_date_time", returnUri.getQueryParameter("authorization_date_time"))
                            putString("brand", returnUri.getQueryParameter("brand"))
                            putString("order_id", returnUri.getQueryParameter("order_id"))
                            putString("authorization_code", returnUri.getQueryParameter("authorization_code"))
                            putString("installment_count", returnUri.getQueryParameter("installment_count"))
                            putString("pan", returnUri.getQueryParameter("pan"))
                            putString("type", returnUri.getQueryParameter("type"))
                            putString("entry_mode", returnUri.getQueryParameter("entry_mode"))
                            putString("account_id", returnUri.getQueryParameter("account_id"))
                            putString("customer_wallet_provider_id", returnUri.getQueryParameter("customer_wallet_provider_id"))
                            putString("code", returnUri.getQueryParameter("code"))
                            putString("transaction_qualifier", returnUri.getQueryParameter("transaction_qualifier"))
                            putString("amount", returnUri.getQueryParameter("amount"))
                        })
                    }
                } else if (success == "false") {
                    val message = returnUri.getQueryParameter("message")
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", message ?: "Unauthorized")
                    }
                } else {
                    return Bundle().apply {
                        putString("code", "ERROR")
                        putString("message", "Unauthorized")
                    }
                }
            }  else {
                return Bundle().apply {
                    putString("code", "ERROR")
                    putString("message", "No data return of intent")
                }
            }
        } catch (e: Exception) {
            return Bundle().apply {
                putString("code", "ERROR")
                putString("message", e.toString())
            }
        }
    }
}