package br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CancelDeeplink: Deeplink {
    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val amount: String? = bundle.getString("amount")
            val atk: String? = bundle.getString("atk")
            val editableAmount: Boolean = bundle.getBoolean("editable_amount")

            if (atk == null) {
                throw IllegalArgumentException("Invalid cancel data: atk")
            }

            val uriBuilder = Uri.Builder()
            uriBuilder.authority("cancel")
            uriBuilder.scheme("cancel-app")
            uriBuilder.appendQueryParameter("amount", amount)
            uriBuilder.appendQueryParameter("atk", atk)
            uriBuilder.appendQueryParameter("editable_amount", editableAmount.toString())
            uriBuilder.appendQueryParameter("return_scheme", "return_cancel")

            val intent = Intent(Intent.ACTION_VIEW)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent.data = uriBuilder.build()
            binding.activity.startActivity(intent)

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
                val success = returnUri.getQueryParameter("success")
                if (success == "true") {
                    return mapOf(
                        "code" to "SUCCESS",
                        "data" to mapOf(
                            "response_code" to returnUri.getQueryParameter("responsecode"),
                            "atk" to returnUri.getQueryParameter("atk"),
                            "canceled_amount" to returnUri.getQueryParameter("canceledamount"),
                            "payment_type" to returnUri.getQueryParameter("paymenttype"),
                            "transaction_amount" to returnUri.getQueryParameter("transactionamount"),
                            "order_id" to returnUri.getQueryParameter("orderid"),
                            "authorization_code" to returnUri.getQueryParameter("authorizationcode"),
                            "reason" to returnUri.getQueryParameter("reason"),
                        )
                    )
                } else  {
                    val reason = returnUri.getQueryParameter("reason")

                    var message = returnUri.getQueryParameter("message") ?: "Cancel error"

                    if (reason == "7011") {
                        message = "Cancellation aborted"
                    } else if (reason == "7202") {
                        message = "Cancel failed to find ATK"
                    }

                    return mapOf(
                        "code" to "ERROR",
                        "message" to message
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