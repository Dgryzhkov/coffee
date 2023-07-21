package com.example.coffee

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.DataOutputStream
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase

class MainActivity : FlutterActivity() {

    private val channelName = "get_data_bases"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        super.configureFlutterEngine(flutterEngine)

        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)

        val dbName = "coffee.db"
        val dbPath = "/data/data/com.jinuo.mhwang.jetinnocoffe/databases/"

        channel.setMethodCallHandler{call, result->
            if (call.method == "getDataBase"){

                var process: Process? = null
                var dataOutputStream: DataOutputStream? = null

                try {
                    process = Runtime.getRuntime().exec("su")
                    dataOutputStream = DataOutputStream(process.outputStream)
                    dataOutputStream.writeBytes("chmod 666 $dbPath$dbName\n")
                    dataOutputStream.writeBytes("exit\n")
                    dataOutputStream.flush()
                    process.waitFor()
                } catch (ex: Exception) {
                    if (applicationContext != null){
                        Toast.makeText(applicationContext!!,ex.localizedMessage, Toast.LENGTH_LONG).show()
                    }
                } finally {
                    try {
                        dataOutputStream?.close()
                        process!!.destroy()
                    } catch (ex: Exception) {
                        if (applicationContext != null){
                            Toast.makeText(applicationContext!!,ex.localizedMessage, Toast.LENGTH_LONG).show()
                        }
                    }
                }

                try {
                    val database = SQLiteDatabase.openDatabase(dbPath + dbName, null,
                        SQLiteDatabase.OPEN_READWRITE or SQLiteDatabase.NO_LOCALIZED_COLLATORS)
                    if (database.isOpen) {
                        Toast.makeText(applicationContext, "Установлено!", Toast.LENGTH_LONG).show()
                        val c: Cursor = database.rawQuery("SELECT * FROM product", null)

                        if (c != null) {
                            if (c.moveToFirst()) {
                                do {
                                   // logtxt.setText(logtxt.text.toString() + c.getString(4) + "; ");
                                } while (c.moveToNext())
                            }
                        }
                        c.close()

                        database.execSQL("UPDATE product SET orderInList = 1 WHERE recipeName = 'Латте'");

                        database.close();
                    }
                    else
                        Toast.makeText(applicationContext,"Ошибка подключения",Toast.LENGTH_LONG).show()
                }
                catch (ex:Exception)
                {
                    if (applicationContext != null){
                        Toast.makeText(applicationContext!!,ex.localizedMessage, Toast.LENGTH_LONG).show()
                    }
                }
                finally {

                }


                Toast.makeText(this, "Toast bobobobobo", Toast.LENGTH_LONG).show()


            }
        }
    }
}
