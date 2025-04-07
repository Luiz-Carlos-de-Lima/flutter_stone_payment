package br.com.jclan.alphaxStonePayment.flutter_stone_payment.services

import android.os.Build

class DeviceInfo {
    public fun getSerialNumberAndDeviceModel(): Map<String, Any?> {
        val model = Build.MODEL
        val serial = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            "Block Info"
        } else {
            Build.SERIAL
        }
        return mapOf(
            "deviceModel" to model,
            "serialNumber" to serial
        )
    }
}