package br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class PrintDeeplink: Deeplink {
    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val showFeedbackScreen: Boolean = bundle.getBoolean("show_feedback_screen") ?: false
            val printableContent: List<Bundle> = bundle.getParcelableArrayList("printable_content")
                ?: throw IllegalArgumentException("Invalid print data: printable_content")

            for (content: Bundle in printableContent) {
                val type: String? = content.getString("type")
                if (type == "text") {
                    val contentOfType: String? = content.getString("content")
                    val align: String? = content.getString("align")
                    val size: String? = content.getString("size")

                    if (contentOfType == null) throw IllegalArgumentException("Invalid printable_content data: content can't null when type equal 'text'")
                    if (align !in listOf("center", "right", "left")) throw IllegalArgumentException("Invalid printable_content data: align cannot be different from 'center | right | left' when type equal 'text'")
                    if (size !in listOf("big", "medium","small")) throw IllegalArgumentException("Invalid printable_content data: size  cannot be different from 'big | medium | small' when type equal 'text'")
                } else if (type == "line") {
                    if(content.getString("content") == null) {
                        throw IllegalArgumentException("Invalid printable_content data: content can't null when type equal 'text'")
                    }
                } else if (type == "image") {
                    if (content.getString("imagePath") == null) {
                        throw IllegalArgumentException("Invalid printable_content data: content can't null when type equal 'text'")
                    }
                } else {
                    throw IllegalArgumentException("Invalid printable_content data: Invalid type")
                }
            }

            val gson = Gson()
            val printableToJson = gson.toJson(printableContent)

            val uriBuilder = Uri.Builder()

            uriBuilder.authority("print")
            uriBuilder.scheme("printer-app")
            uriBuilder.appendQueryParameter("show_feedback_screen", showFeedbackScreen.toString())
            uriBuilder.appendQueryParameter("printable_content", printableToJson)
            uriBuilder.appendQueryParameter("return_scheme", "return_print")

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