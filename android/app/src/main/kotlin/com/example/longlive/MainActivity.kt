package com.longlive.longlive

import android.app.AlertDialog
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Base64
import androidx.annotation.RequiresApi
import java.security.MessageDigest

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    @RequiresApi(Build.VERSION_CODES.P)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        logHashKey()
    }

    fun logHashKey() {
        try {
            val info = packageManager.getPackageInfo(
                packageName,
                PackageManager.GET_SIGNING_CERTIFICATES
            )
            for (signature in info.signingInfo.apkContentsSigners) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val key = String(Base64.encode(md.digest(), 0))

                val builder = AlertDialog.Builder(this)
                builder
                    .setTitle("그대로 캡처해주세요")
                    .setMessage(key)
                    .setPositiveButton("확인") { dialogInterface, i -> }
                    .show()
            }
        } catch (e: Exception) {}
    }
}
