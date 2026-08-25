package card.reader.plugin.card_reader_plugin.core_libs

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel
import rd.nalib.NA
import rd.nalib.ResponseListener
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class NALibsCores(
    val activity: Activity,
) : CoroutineScopeAbstract(){

    /**
     * 0 NA_SUCCESS ทำางานได้สำาเร็จเสร็จสิ้น
     * -1 NA_INTERNAL_ERROR เกิดข้อผิดพลาดภายในระบบ
     * -2 NA_INVALID_LICENSE เครื่องอ่านนี้ใช้ไม่ได้เพราะใบอนุญาตไม่ถูกต้อง
     * -3 NA_READER_NOT_FOUND ไม่พบเครื่องอ่านบัตร
     * -4 NA_CONNECTION_ERROR ไม่สามารถติดต่อกบบัตรได้
     * -5 NA_GET_PHOTO_ERROR ไม่สามารถอ่านรูปภาพถ่ายใบหน้าได้
     * -6 NA_GET_TEXT_ERROR ไม่สามารถอ่านข้อมูลตัวอักษรได้
     * -7 NA_INVALID_CARD บัตรที่อ่านไม่ใช่บัตรประชาชน
     * -8 NA_UNKNOWN_CARD_VERSION ไม่รองรับการใช้งานกบบัตรประชาชนรุ่นนี้
     * -9 NA_DISCONNECTION_ERROR ไม่สามารถยกเลิกการเชื่อมต่อกบเครื่องอ่านบัตรได้
     * -10 NA_INIT_ERROR กระบวนการตั้งค่าเริ่มต้นทำางานผิดพลาด หรือยังไม่ ได้เรียกใช้งาน openLibNA
     * -11 NA_READER_NOT_SUPPORTED ไม่รองรับการใช้งานกบเครื่องอ่านนี้ หรือไม่พบเครื่องอ่านบัตร
     * -12 NA_LICENSE_FILE_ERROR ไม่พบแฟ้มใบอนุญาตหรือแฟ้มใบอนุญาตเสียหาย
     * -13 NA_PARAMETERS_ERROR พารามิเตอร์หรือตัวแปรผิดพลาด
     * -15 NA_INTERNET_ERROR ไม่สามารถติดต่ออินเทอร์เน็ตได้
     * -16 NA_CARD_NOT_FOUND ไม่พบบัตรในเครื่องอ่าน
     * -17 NA_BLUETOOTH_DISABLED ไม่ได้เปิดบลูทูธ
     * -18 NA_LICENSE_UPDATE_ERROR อัปเดตแฟ้มใบอนุญาตไม่สำาเร็จ
     * -31 NA_STORAGE_PERMISSION_ERROR มีข้อผิดพลาดหรือไม่ได้รับอนุญาตให้ใช้พื้นที่จัดเก็บ (Storage)
     * -32 NA_LOCATION_PERMISSION_ERROR มีข้อผิดพลาดหรือไม่ได้รับอนุญาตให้รับรู้ตำแหน่งของบลูทูธ (Bluetooth Location)
     * -33 NA_BLUETOOTH_PERMISSION_ERROR มีข้อผิดพลาดหรือไม่ได้รับอนุญาตให้ใช้งานบลูทูธ
     * -41 NA_LOCATION_SERVICE_ERROR บริการตำาแหน่ง (Location Service) ปิดอยู หรือมีข้อผิดพลาด
     */

    companion object {

        operator fun invoke(
            activity: Activity,
        ): NALibsCores = NALibsCores(
            activity = activity,
        )

        private const val MY_PERMISSION_CODE:Int = 0
        private const val PERMISSION_DENIED:Int = PackageManager.PERMISSION_DENIED
        private const val PERMISSION_GRANTED:Int = PackageManager.PERMISSION_GRANTED

        /** device code option */
        private const val NA_POPUP:Int = 0x80
        private const val NA_SCAN:Int = 0x10
        private const val NA_BLE1:Int = 0x08
        private const val NA_BLE0:Int = 0x04
        private const val NA_BT:Int = 0x02
        private const val NA_USB:Int = 0x01


    }

    private val naLibs: NA by lazy {
        NA(activity)
    }

    private suspend fun eventListener(
        response: MethodChannel.Result
    ) = withContextMain {

        with(response) {
            naLibs.setListenerNA(null)
            naLibs.setListenerNA(object : ResponseListener {

                override fun onOpenLibNA(code: Int) {
                    logs("onOpenLibNA: code: $code")

                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )

                }

                override fun onGetReaderListNA(
                    cardReaderList: ArrayList<String?>?,
                    code: Int
                ) {
                    logs("onGetReaderListNA: cardReaderList: $cardReaderList")
                    logs("onGetReaderListNA: code: $code")

                    val newList: List<String> = cardReaderList?.map {
                        it ?: ""
                    } ?: emptyList()
                    logs("onGetReaderListNA: newList: $newList")

                    mutableListOf<String>().let {
                        it.clear()
                        it.addAll(newList)
                        success(
                            mapOf<String, Any>(
                                "result" to it.toList(),
                                "code" to "$code"
                            )
                        )
                    }

                }

                override fun onSelectReaderNA(code: Int) {
                    logs("onSelectReaderNA: code: $code")

                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )
                }

                override fun onGetNIDNumberNA(idCardNumber: String?, code: Int) {
                    logs("onGetNIDNumberNA: idCardNumber: $idCardNumber")
                    logs("onGetNIDNumberNA: code: $code")

                    val result:String = idCardNumber ?: ""

                    success(
                        mapOf<String, Any>(
                            "result" to result,
                            "code" to "$code"
                        )
                    )
                }

                override fun onGetNIDTextNA(idCardText: String?, code: Int) {
                    logs("onGetNIDTextNA: idCardText: $idCardText")
                    logs("onGetNIDTextNA: code: $code")

                    val result:String = idCardText ?: ""

                    success(
                        mapOf<String, Any>(
                            "result" to result,
                            "code" to "$code"
                        )
                    )

                }

                override fun onGetNIDPhotoNA(byteImage: ByteArray?, code: Int) {
                    logs("onGetNIDPhotoNA: byteImage: $byteImage")
                    logs("onGetNIDPhotoNA: code: $code")

//                    val byte:ByteArray = byteImage ?: byteArrayOf(0)
//
//                    val result: ByteArray? = when {
//                        byte.isEmpty() -> null
//                        else -> byte
//                    }

                    success(
                        mapOf(
                            "result" to byteImage,
                            "code" to "$code"
                        )
                    )
                }

                override fun onUpdateLicenseFileNA(code: Int) {
                    logs("onUpdateLicenseFileNA: code: $code")

                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )
                }

            })

        }

    }


    private fun logs(print:String) = with(Unit){
        Log.d(NALibsCores::class.java.name, print)
    }

    suspend fun openLibrary (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        val fileName:String = when(arguments) {
            is String -> arguments
            else -> ""
        }
        logs("openLibrary: fileName: $fileName")

        /** set USB reader in-app permission ***/
        /**
         *  pms: 0 = Disable USB reader in-app permission (default).
         *  pms: 1 = Enable USB reader in-app permission.
         *  pms: -1 = Get current permissions state.
         */

        eventListener(response)
        withContextIO {
            naLibs.setPermissionsNA(1)
        }

        val filesDir: File = activity.filesDir
        val rdLibsFileName:String = "rdnidlib.dls"
        val rootFolder = "$filesDir/na_libs/$rdLibsFileName"
        logs("openLibrary: rootFolder: $rootFolder")

        try {
            withContextDefault {
                writeFile(
                    path = rootFolder,
                    fileName = "rdnidlib.dls"
                )
            }
            withContextIO {
                naLibs.openLibNA(rootFolder)
            }
        } catch (e: Exception) {
            e.printStackTrace()
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }

    }

    private fun writeFile(
        path:String,
        fileName:String,
    ) = with(activity.assets) {
        try {
            open(fileName).let { inputStream ->
                val outFile: File = File(path)
                if (outFile.exists()) return@with
                val parent: File = File(outFile.parent)
                parent.mkdirs()
                val buffer:ByteArray = ByteArray(1024)
                val fileOutputStream: FileOutputStream = FileOutputStream(outFile)

                var read:Int
                while (
                    (inputStream.read(buffer, 0, 1024).also { read = it }) >= 0
                ) {
                    fileOutputStream.write(buffer, 0, read)
                }

                fileOutputStream.flush()
                fileOutputStream.close()
                inputStream.close()
            }
        } catch (e: IOException) {
           throw e
        }
    }

    suspend fun findReader (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            var optionsList:Int = NA_POPUP + NA_SCAN + NA_BLE1 + NA_BLE0 + NA_BT + NA_USB

            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
                    (ContextCompat.checkSelfPermission(
                        activity,
                        Manifest.permission.BLUETOOTH_CONNECT) == PERMISSION_GRANTED
                            && ContextCompat.checkSelfPermission(
                        activity,
                        Manifest.permission.BLUETOOTH_SCAN) == PERMISSION_GRANTED
                    ).let { blePermissionGranted: Boolean ->
                        if (!blePermissionGranted) optionsList -= (NA_SCAN + NA_BLE1 + NA_BLE0 + NA_BT)
                    }
                }
                else -> {
                    (ContextCompat.checkSelfPermission(
                        activity,
                        Manifest.permission.ACCESS_FINE_LOCATION) == PERMISSION_GRANTED
                    ).let { blePermissionGranted ->
                        if (!blePermissionGranted) optionsList -= (NA_SCAN + NA_BLE1 + NA_BLE0 + NA_BT)
                    }
                }
            }

            eventListener(response)
            withContextIO {
                try {
                    naLibs.getReaderListNA(optionsList)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }

        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun closedLibrary (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            withContextIO {
                return@withContextIO naLibs.closeLibNA()
            }.let { code ->
                withContextMain {
                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun setPermissions (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        val pmsCode:Int = when(arguments) {
            is Int -> arguments
            else -> 1
        }
        try {
            withContextIO {
                return@withContextIO naLibs.setPermissionsNA(pmsCode)
            }.let { code ->
                withContextMain {
                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun closedEventsListener (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            withContextIO {
                return@withContextIO naLibs.setListenerNA(null)
            }.let {
                withContextMain {
                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "0"
                        )
                    )
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun getLicenseInfo (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            arrayOfNulls<String>(1).let {
                withContextIO {
                    return@withContextIO naLibs.getLicenseInfoNA(it)
                }.let { code ->
                    withContextMain {
                        when{
                            it.isNotEmpty() -> {
                                val licenseInfo: String = it[0].let {
                                        license -> license ?: ""
                                }
                                logs("getLicenseInfo: licenseInfo: $licenseInfo")
                                success(
                                    mapOf<String, Any>(
                                        "result" to licenseInfo,
                                        "code" to "$code"
                                    )
                                )
                            }
                            else -> {
                                success(
                                    mapOf<String, Any>(
                                        "result" to "",
                                        "code" to "$code"
                                    )
                                )
                            }
                        }
                    }
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun getReaderInfo (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            arrayOfNulls<String>(1).let {
                withContextIO {
                    return@withContextIO naLibs.getReaderInfoNA(it)
                }.let { code ->
                    withContextMain {
                        when{
                            it.isNotEmpty() -> {
                                val readerInfo: String = it[0].let {
                                        readerInfo -> readerInfo ?: ""
                                }
                                logs("getReaderInfo: readerInfo: $readerInfo")
                                success(
                                    mapOf<String, Any>(
                                        "result" to readerInfo,
                                        "code" to "$code"
                                    )
                                )
                            }
                            else -> {
                                success(
                                    mapOf<String, Any>(
                                        "result" to "",
                                        "code" to "$code"
                                    )
                                )
                            }
                        }
                    }
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun getSoftwareInfo (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            arrayOfNulls<String>(1).let {
                withContextIO {
                    return@withContextIO naLibs.getSoftwareInfoNA(it)
                }.let { code ->
                    withContextMain {
                        when{
                            it.isNotEmpty() -> {
                                val softwareInfo: String = it[0].let {
                                        softwareInfo ->  softwareInfo ?: ""
                                }
                                logs("getSoftwareInfo: softwareInfo: $softwareInfo")
                                success(
                                    mapOf<String, Any>(
                                        "result" to  softwareInfo,
                                        "code" to "$code"
                                    )
                                )
                            }
                            else -> {
                                success(
                                    mapOf<String, Any>(
                                        "result" to "",
                                        "code" to "$code"
                                    )
                                )
                            }
                        }
                    }
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun selectReader (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        val deviceName:String = when(arguments) {
            is String -> arguments
            else -> ""
        }
        logs("selectReader: deviceName: $deviceName")
        try {
            eventListener(response)
            withContextIO {
                naLibs.selectReaderNA(deviceName)
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun deselectReader (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            withContextIO {
                return@withContextIO naLibs.deselectReaderNA()
            }.let { code ->
                withContextMain {
                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun connectCard (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            withContextIO {
                return@withContextIO naLibs.connectCardNA()
            }.let { code ->
                withContextMain {
                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun disconnectCard (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            withContextIO {
                return@withContextIO naLibs.disconnectCardNA()
            }.let { code ->
                withContextMain {
                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun updateLicenseFile (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {

        /**
         * กรณีเป็นเลขตั้งแต่ 0 ขึ้นไป แสดงวาทำงานสำเร็จ โดยมีรายละเอียดดังนี้
         * 0, 1, 2 หรือ 3 คือ ได้อัปเดตแฟ้มใบอนุญาตเป็นแฟ้มใหม่แล้ว จากเครื่องแม่ข่าย หมายเลข
         * 0, 1, 2 หรือ 3 ตามลำาดับ
         * 100, 101, 102 หรือ 103 คือ ได้มีการดาวน์โหลดแฟ้มใบอนุญาตจากเครื่องแม่ข่าย
         * หมายเลข 0, 1, 2 หรือ 3 ตามลำดับแล้ว แต่ไม่ได้มีการอัปเดตเพราะแฟ้มที่มีอยูใน
         * เครื่องโทรศัพท์เป็นรุ่นล่าสุดอยูแล้ว
         * กรณีเป็นเลขลบ แสดงว่าทำงานไม่สำเร็จ Return Code มีความหมายตามค่าในตารางรหัส
         * ส่งกลับและรหัสข้อผิดพลาด เช่น
         * -15: ไม่สามารถติดต่ออินเทอร์เน็ตได้
         * -18: อัปเดตแฟ้มใบอนุญาตไม่สำาเร็จ
         */

        try {
            eventListener(response)
            withContextIO {
                naLibs.updateLicenseFileNA()
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun getIDCardNumber (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            eventListener(response)
            withContextIO {
                naLibs.nidNumberNA
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun getIDCardText (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            eventListener(response)
            withContextIO {
                naLibs.nidTextNA
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun getIDCardTextWithArgument (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {

        /**
         *  0 = ไม่ต้องอ่านข้อมูลเพิ่ม
         *  1 = อ่านข้อมูล AText ต่อท้ายข้อมูลหน้าบัตร
         *  ในกรณีที่กำหนดให้ getTextOption = 1 จะมีการเพิ่มข้อมูล AText อีก 5
         *  รายการ ต่อท้าย เลขหมายคำาขอ ดังนี้
         *  #หมายเลขบัตร/คำาร้อง#รหัสผู้ออกบัตร#รุ่นของโครงสร้าง#รหัสประเภทบัตร#รหัสคำานำา
         *  หน้านาม”
         */

        val optionNumber:Int = when(arguments) {
            is Int -> arguments
            else -> 0
        }
        val forceNumber:Int = when {
            optionNumber == 0 -> 0
            optionNumber != 1 -> 1
            else -> optionNumber
        }
        try {
            eventListener(response)
            withContextIO {
                naLibs.getNIDTextNA(forceNumber)
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun getPhotoByteImage (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            eventListener(response)
            withContextIO {
                naLibs.nidPhotoNA
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun getCardStatus (
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response) {
        try {
            withContextIO {
                return@withContextIO naLibs.cardStatusNA
            }.let { code ->
                withContextMain {
                    success(
                        mapOf<String, Any>(
                            "result" to "",
                            "code" to "$code"
                        )
                    )
                }
            }
        } catch (e: Exception) {
            error(
                ErrorName.ERROR_500.name,
                e.message,
                null
            )
        }
    }

    suspend fun requestPermission(
        arguments: Any?,
        response: MethodChannel.Result
    ) = with(response){

        withContextMain {
            when{
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {

                    val bleConnectCode:Int = ContextCompat.checkSelfPermission(
                        activity,
                        Manifest.permission.BLUETOOTH_CONNECT
                    )

                    val bleScanCode:Int = ContextCompat.checkSelfPermission(
                        activity,
                        Manifest.permission.BLUETOOTH_SCAN
                    )
                    logs("requestPermission: bleConnectCode: $bleConnectCode")
                    logs("requestPermission: bleScanCode: $bleScanCode")

                    when {
                        bleConnectCode == PERMISSION_DENIED
                                || bleScanCode == PERMISSION_DENIED -> {
                            try {
                                ActivityCompat.requestPermissions(
                                    activity,
                                    arrayOf<String>(
                                        Manifest.permission.BLUETOOTH_SCAN,
                                        Manifest.permission.BLUETOOTH_CONNECT
                                    ),
                                    MY_PERMISSION_CODE
                                )
                                success(
                                    "REQUEST_PERMISSION"
                                )
                            } catch (e: Exception) {
                                e.printStackTrace()
                                error(
                                    ErrorName.ERROR_500.name,
                                    e.message,
                                    null
                                )
                            }
                        }
                        else -> {
                            success(
                                "PERMISSION_GRANTED"
                            )
                        }
                    }

                }
                else -> {
                    ContextCompat.checkSelfPermission(
                        activity,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ).let { code ->

                        when (code){
                            PERMISSION_DENIED -> {
                                try {
                                    ActivityCompat.requestPermissions(
                                        activity,
                                        arrayOf<String>(Manifest.permission.ACCESS_FINE_LOCATION),
                                        MY_PERMISSION_CODE
                                    )
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                    error(
                                        ErrorName.ERROR_500.name,
                                        e.message,
                                        null
                                    )
                                }
                            }
                            else -> {
                                success(
                                    "PERMISSION_GRANTED"
                                )
                            }
                        }

                    }

                }
            }
        }

    }


}