package br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class ReprintDeeplink: Deeplink {
    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val showFeedbackScreen: Boolean = bundle.getBoolean("show_feedback_screen") ?: false
            val atk: String? = bundle.getString("atk")
            val typeCustomer: String? = bundle.getString("type_customer")

            if (atk == null) {
                throw IllegalArgumentException("Invalid reprint data: atk")
            }
            if (typeCustomer == null) {
                throw IllegalArgumentException("Invalid reprint data: typeCustomer")
            }

            val uriBuilder = Uri.Builder()
            uriBuilder.authority("reprint")
            uriBuilder.scheme("reprinter-app")
            uriBuilder.appendQueryParameter("SHOW_FEEDBACK_SCREEN", showFeedbackScreen.toString())
            uriBuilder.appendQueryParameter("ATK", atk)
            uriBuilder.appendQueryParameter("TYPE_CUSTOMER", typeCustomer)
            uriBuilder.appendQueryParameter("SCHEME_RETURN", "return_reprint")

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
            Log.d("validateIntentImpressao", "$intent")
            if (returnUri != null) {
                val success = returnUri.getQueryParameter("success")
                if (success == "true") {
                    return mapOf(
                        "code" to "SUCCESS",
                        "data" to "true",
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
                "message" to e.message.toString()
            )
        }
    }
}