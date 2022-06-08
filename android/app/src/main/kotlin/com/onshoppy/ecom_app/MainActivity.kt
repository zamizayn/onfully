package com.onshoppy.ecom_app

import android.content.Intent
import android.net.Uri
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private lateinit var channel:MethodChannel


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"")


        channel.setMethodCallHandler{
            call,result->
            if(call.method == "gpay"){
                Toast.makeText(applicationContext,"Invoked GPAY",Toast.LENGTH_LONG).show()
                val GOOGLE_PAY_PACKAGE_NAME = "com.google.android.apps.nbu.paisa.user"
                val GOOGLE_PAY_REQUEST_CODE = 123

                val uri: Uri = Uri.Builder()
                    .scheme("upi")
                    .authority("pay")
                    .appendQueryParameter("pa", "onfullymarketinglimited@icici")
                    .appendQueryParameter("pn", "ONFULLY MARTING LIMITED")
                    .appendQueryParameter("am", "1")
                    .appendQueryParameter("cu", "INR")
                    .build()
                val intent = Intent(Intent.ACTION_VIEW)
                intent.setData(uri)
                intent.setPackage(GOOGLE_PAY_PACKAGE_NAME)
                activity.startActivityForResult(intent, GOOGLE_PAY_REQUEST_CODE)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(resultCode == RESULT_OK || resultCode ==11){
            if(data!=null){
                val transaction = data.getStringExtra("response")
                Toast.makeText(context,"response after successful payment"+transaction.toString(),Toast.LENGTH_LONG).show()
            }
        }
        else{
            Toast.makeText(context,"Payment Cancelled by user",Toast.LENGTH_LONG).show()
        }
    }
}
