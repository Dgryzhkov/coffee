package com.example.coffee

import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.DataOutputStream
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase

import java.io.BufferedReader
import java.io.InputStreamReader
import android.content.Context
import java.io.OutputStream

class MainActivity : FlutterActivity() {

    private val channelName = "get_data_bases"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)

        val dbName = "coffee.db"
        val dbPath = "/data/data/com.jinuo.mhwang.jetinnocoffe/databases/"

        channel.setMethodCallHandler { call, result ->
            if (call.method == "getDataBase") {

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
                    if (applicationContext != null) {
                        Toast.makeText(applicationContext!!, ex.localizedMessage, Toast.LENGTH_LONG).show()
                    }
                } finally {
                    try {
                        dataOutputStream?.close()
                        process!!.destroy()
                    } catch (ex: Exception) {
                        if (applicationContext != null) {
                            Toast.makeText(applicationContext!!, ex.localizedMessage, Toast.LENGTH_LONG).show()
                        }
                    }
                }

                try {
                    val database = SQLiteDatabase.openDatabase(
                        dbPath + dbName, null,
                        SQLiteDatabase.OPEN_READWRITE or SQLiteDatabase.NO_LOCALIZED_COLLATORS
                    )
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

                        database.execSQL("UPDATE product SET orderInList = 1 WHERE recipeName = 'Латте'")
                        database.close()
                    } else {
                        Toast.makeText(applicationContext, "Ошибка подключения", Toast.LENGTH_LONG).show()
                    }
                } catch (ex: Exception) {
                    if (applicationContext != null) {
                        Toast.makeText(applicationContext!!, ex.localizedMessage, Toast.LENGTH_LONG).show()
                    }
                }

                Toast.makeText(this, "Toast bobobobobo", Toast.LENGTH_LONG).show()
            } else {
                //rebootUsbPort(this)
                //disableUsbPortPower(this)
                rebootUsb()
            }
        }
    }
}
private fun rebootUsbPort(context: Context) {
    val usbPort = "usb1"

    try {
        val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "reboot"))
        process.waitFor()

        val exitValue = process.exitValue()
        if (exitValue == 0) {
            // команда выполнена успешно
            Toast.makeText(context, "Устройство перезагружается", Toast.LENGTH_LONG).show()
        } else {
            // ошибка выполнения команды
            Toast.makeText(context, "Ошибка при перезагрузке устройства", Toast.LENGTH_LONG).show()
        }
    } catch (e: Exception) {
        e.printStackTrace()
        Toast.makeText(context, "Ошибка: ${e.localizedMessage}", Toast.LENGTH_LONG).show()
    }
}

fun rebootUsb() {
    try {
        val process = Runtime.getRuntime().exec("su")
        val outputStream = DataOutputStream(process.outputStream)
        outputStream.writeBytes("echo 0 > /sys/bus/usb/devices/usb1/authorized\n")
      outputStream.writeBytes("echo 1 > /sys/bus/usb/devices/usb1/authorized\n")
        outputStream.writeBytes("exit\n")
        outputStream.flush()
        process.waitFor()
    } catch (e: Exception) {
        e.printStackTrace()
    }
}



//private fun disableUsbPortPower(context: Context) {
//    val usbPort = "usb3"
//
//    try {
//        val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "echo '0' > /sys/bus/usb/devices/$usbPort/power/level"))
//        process.waitFor()
//
//        val exitValue = process.exitValue()
//        if (exitValue == 0) {
//            // команда выполнена успешно
//            Toast.makeText(context, "Питание USB-порта отключено", Toast.LENGTH_LONG).show()
//        } else {
//            // ошибка выполнения команды
//            Toast.makeText(context, "Ошибка при отключении питания USB-порта", Toast.LENGTH_LONG).show()
//        }
//    } catch (e: Exception) {
//        e.printStackTrace()
//        Toast.makeText(context, "Ошибка: ${e.localizedMessage}", Toast.LENGTH_LONG).show()
//    }
//}

//private fun rebootUsbPort(context: Context) {
//    val usbPort = "usb2"
//
//    try {
//        val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "echo 0 > /sys/bus/usb/devices/$usbPort/authorized"))
//        //val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "echo suspend > /sys/bus/usb/devices/usb1/power/level"))
//        process.waitFor()
//
//        val exitValue = process.exitValue()
//        if (exitValue == 0) {
//            // команда выполнена успешно
//            Toast.makeText(context, "USB-порт перезагружен", Toast.LENGTH_LONG).show()
//        } else {
//            // ошибка выполнения команды
//            Toast.makeText(context, "Ошибка при перезагрузке USB-порта", Toast.LENGTH_LONG).show()
//        }
//    } catch (e: Exception) {
//        e.printStackTrace()
//        Toast.makeText(context, "Ошибка: ${e.localizedMessage}", Toast.LENGTH_LONG).show()
//    }
//}
//


//private fun rebootUsbPort(context: Context) {
//    var outputStream: OutputStream? = null
//    var process: Process? = null
//
//    try {
//        process = Runtime.getRuntime().exec("su")
//        outputStream = process.outputStream
//        outputStream.write("echo 0 > /sys/bus/usb/devices/usbX/authorized".toByteArray()) // замените "usbX" на соответствующий USB-порт
//        //outputStream.write("echo suspend > /sys/bus/usb/devices/usb2/power/level".toByteArray())
//        outputStream.flush()
//        outputStream.close()
//        process.waitFor()
//
//        val inputStream = process.inputStream
//        val bufferedReader = BufferedReader(InputStreamReader(inputStream))
//        val stringBuilder = StringBuilder()
//        var line: String? = null
//        while ({ line = bufferedReader.readLine(); line }() != null) {
//            stringBuilder.append(line)
//        }
//        inputStream.close()
//
//        val exitValue = process.exitValue()
//        if (exitValue == 0) {
//            // команда выполнена успешно
//            Toast.makeText(context, "работает", Toast.LENGTH_LONG).show()
//        } else {
//            // ошибка выполнения команды
//            Toast.makeText(context, "не работает", Toast.LENGTH_LONG).show()
//
//        }
//    } catch (e: Exception) {
//        e.printStackTrace()
//    } finally {
//        try {
//            outputStream?.close()
//            process?.destroy()
//        } catch (ex: Exception) {
//            Toast.makeText(context, ex.localizedMessage, Toast.LENGTH_LONG).show()
//        }
//    }
//}
//class MainActivity : FlutterActivity() {
//
//    private val channelName = "get_data_bases"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
//
//        val dbName = "coffee.db"
//        val dbPath = "/data/data/com.jinuo.mhwang.jetinnocoffe/databases/"
//
//        channel.setMethodCallHandler { call, result ->
//            if (call.method == "getDataBase") {
//
//                var process: Process? = null
//                var dataOutputStream: DataOutputStream? = null
//
//                try {
//                    process = Runtime.getRuntime().exec("su")
//                    dataOutputStream = DataOutputStream(process.outputStream)
//                    dataOutputStream.writeBytes("chmod 666 $dbPath$dbName\n")
//                    dataOutputStream.writeBytes("exit\n")
//                    dataOutputStream.flush()
//                    process.waitFor()
//                } catch (ex: Exception) {
//                    if (applicationContext != null) {
//                        Toast.makeText(applicationContext!!, ex.localizedMessage, Toast.LENGTH_LONG)
//                            .show()
//                    }
//                } finally {
//                    try {
//                        dataOutputStream?.close()
//                        process!!.destroy()
//                    } catch (ex: Exception) {
//                        if (applicationContext != null) {
//                            Toast.makeText(
//                                applicationContext!!,
//                                ex.localizedMessage,
//                                Toast.LENGTH_LONG
//                            ).show()
//                        }
//                    }
//                }
//
//                try {
//                    val database = SQLiteDatabase.openDatabase(
//                        dbPath + dbName, null,
//                        SQLiteDatabase.OPEN_READWRITE or SQLiteDatabase.NO_LOCALIZED_COLLATORS
//                    )
//                    if (database.isOpen) {
//                        Toast.makeText(applicationContext, "Установлено!", Toast.LENGTH_LONG).show()
//                        val c: Cursor = database.rawQuery("SELECT * FROM product", null)
//
//                        if (c != null) {
//                            if (c.moveToFirst()) {
//                                do {
//                                    // logtxt.setText(logtxt.text.toString() + c.getString(4) + "; ");
//                                } while (c.moveToNext())
//                            }
//                        }
//                        c.close()
//
//                        database.execSQL("UPDATE product SET orderInList = 1 WHERE recipeName = 'Латте'");
//
//                        database.close();
//                    } else
//                        Toast.makeText(applicationContext, "Ошибка подключения", Toast.LENGTH_LONG)
//                            .show()
//                } catch (ex: Exception) {
//                    if (applicationContext != null) {
//                        Toast.makeText(applicationContext!!, ex.localizedMessage, Toast.LENGTH_LONG)
//                            .show()
//                    }
//                } finally {
//
//                }
//
//
//                Toast.makeText(this, "Toast bobobobobo", Toast.LENGTH_LONG).show()
//
//
//            } else {
//                rebootUsbPort(this)
//            }
//
//
//        }
//    }
//
//}
//
//
//private fun rebootUsbPort(context: Context) {
//    var outputStream: OutputStream? = null
//    var process: Process? = null
//
//    try {
//        process = Runtime.getRuntime().exec("su")
//        outputStream = process.outputStream
//        //outputStream.write("echo 0 > /sys/bus/usb/devices/usbX/authorized".toByteArray()) // замените "usbX" на соответствующий USB-порт
//        outputStream.write("echo suspend > /sys/bus/usb/devices/usb2/power/level".toByteArray())
//        outputStream.flush()
//        outputStream.close()
//        process.waitFor()
//
//        val inputStream = process.inputStream
//        val bufferedReader = BufferedReader(InputStreamReader(inputStream))
//        val stringBuilder = StringBuilder()
//        var line: String? = null
//        while ({ line = bufferedReader.readLine(); line }() != null) {
//            stringBuilder.append(line)
//        }
//        inputStream.close()
//
//        val exitValue = process.exitValue()
//        if (exitValue == 0) {
//            // команда выполнена успешно
//            Toast.makeText(context, "работает", Toast.LENGTH_LONG).show()
//        } else {
//            // ошибка выполнения команды
//            Toast.makeText(context, "не работает", Toast.LENGTH_LONG).show()
//        }
//    } catch (e: Exception) {
//        e.printStackTrace()
//    } finally {
//        try {
//            outputStream?.close()
//            process?.destroy()
//        } catch (ex: Exception) {
//            Toast.makeText(context, ex.localizedMessage, Toast.LENGTH_LONG).show()
//        }
//    }
//}
//}