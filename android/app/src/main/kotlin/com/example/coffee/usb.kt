//import java.io.BufferedReader
//import java.io.InputStreamReader
//
//fun rebootUsbPort() {
//    try {
//        val process = Runtime.getRuntime().exec("su")
//        val outputStream = process.outputStream
//        outputStream.write("echo 0 > /sys/bus/usb/devices/usbX/authorized".toByteArray()) // замените "usbX" на соответствующий USB-порт
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
//        } else {
//            // ошибка выполнения команды
//        }
//    } catch (e: Exception) {
//        e.printStackTrace()
//    }
//}