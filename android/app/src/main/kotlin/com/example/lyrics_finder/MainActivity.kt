package com.example.lyrics_finder

import android.Manifest
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter

import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import android.os.Build.VERSION.SDK_INT
import android.os.Environment
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
//    private val CHANNEL = "flutter.dev/storage"
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            Log.d("KOTLIN", "INVOKED METHOD")
//            if (call.method == "getStoragePermission") {
//                Log.d("TAG", "getStoragePermission: METHOD")
//                getStoragePermission()
//            }
//        }
//    }
//
//    private fun hasManageAllFilesPermission() =
//            ActivityCompat.checkSelfPermission(this, Manifest.permission.MANAGE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
//
//    private fun getStoragePermission() {
//        Log.d("TAG", "getStoragePermission: PENDING")
//
//               Log.d("TAG", "getStoragePermission: DONE")
//           }
//        }

//        if (!hasManageAllFilesPermission()) {
//            permissions.add(Manifest.permission.MANAGE_EXTERNAL_STORAGE)
//            ActivityCompat.requestPermissions(this, permissions.toTypedArray(), 0)
//            Log.d("TAG", "getStoragePermission: DONE")
//        }
//    }
}
