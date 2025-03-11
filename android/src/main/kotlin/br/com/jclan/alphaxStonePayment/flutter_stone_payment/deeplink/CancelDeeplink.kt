package br.com.jclan.alphaxStonePayment.flutter_stone_payment.deeplink

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CancelDeeplink: Deeplink {
    override fun startDeeplink(binding: ActivityPluginBinding, bundle: Bundle): Bundle {
        TODO("Not yet implemented")
    }

    override fun validateIntent(intent: Intent?): Map<String, Any?> {
        TODO("Not yet implemented")
    }
}