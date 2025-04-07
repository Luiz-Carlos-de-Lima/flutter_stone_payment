package br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import br.com.jclan.alphaxStonePayment.flutter_stone_payment.services.Print
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class PrintDeeplink: Deeplink {
    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        try {
            val showFeedbackScreen: Boolean = bundle.getBoolean("show_feedback_screen") ?: false
            val printableContent: List<Bundle>? = bundle.getParcelableArrayList("printable_content")

            validatePrintContent(printableContent)

            val gson = Gson()
            val printableToJson = gson.toJson(Print().convertPrintableItemsToImageBase64(binding.activity, printableContent!!))
            val uriBuilder = Uri.Builder()

            uriBuilder.authority("print")
            uriBuilder.scheme("printer-app")
            uriBuilder.appendQueryParameter("SHOW_FEEDBACK_SCREEN", showFeedbackScreen.toString())
            uriBuilder.appendQueryParameter("PRINTABLE_CONTENT", printableToJson)
            uriBuilder.appendQueryParameter("SCHEME_RETURN", "return_print")

            val intent = Intent(Intent.ACTION_VIEW)

            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent.data = uriBuilder.build()
            Log.d("Antes do startActivity", "$intent")
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

    private fun validatePrintContent(printableContent: List<Bundle>?) {
        if (printableContent == null) {
            throw IllegalArgumentException("Invalid print data: printable_content")
        }

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
    }



    private fun Bundle.toMap(): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        for (key in this.keySet()) {
            map[key] = this.getString(key)
        }
        return map
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
                            "message" to "Impressão efetuada com sucesso"
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