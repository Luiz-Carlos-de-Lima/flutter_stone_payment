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
            if (returnUri != null) {
                val deeplinkReturn = returnUri.getQueryParameter("DEEPLINK_RETURN")
                if (deeplinkReturn == "SUCCESS") {
                    return mapOf(
                        "code" to "SUCCESS",
                        "data" to mapOf(
                            "message" to "Reimpressão efetuada com sucesso"
                        ),
                    )
                } else {
                    var message: String = "Service Error"

                    when (deeplinkReturn) {
                        "PRINTER_OUT_OF_PAPER" -> {
                            message = "Impressora sem papel ou com a tampa de bobina aberta"
                        }
                        "PRINTER_INIT_ERROR" -> {
                            message = "Erro ao inicializar a impressora"
                        }
                        "PRINTER_LOW_ENERGY" -> {
                            message = "Máquina com baixa energia"
                        }
                        "PRINTER_BUSY" -> {
                            message = "Impressora ocupada, ocorre quando já está imprimindo algo"
                        }
                        "PRINTER_UNSUPPORTED_FORMAT" -> {
                            message = "Algum formato enviado não corresponde ao padrão de texto, imagem ou texto customizado"
                        }
                        "PRINTER_INVALID_DATA" -> {
                            message = "Limite máximo do buffer foi ultrapassado"
                        }
                        "PRINTER_OVERHEATING" -> {
                            message = "Superaquecimento da impressora"
                        }
                        "PRINTER_PAPER_JAM" -> {
                            message = "Papel preso na caixa de bobina"
                        }
                        "PRINTER_PRINT_ERROR" -> {
                            message = "Erro genérico da impressora"
                        }
                    }

                    return mapOf(
                        "code" to "ERROR",
                        "message" to message,
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