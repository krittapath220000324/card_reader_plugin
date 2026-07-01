package card.reader.plugin.card_reader_plugin.core_libs

import android.app.Activity
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

class NALibsService(
    val binaryMessenger:BinaryMessenger,
    val activity: Activity,
) : CoroutineScopeAbstract(){

    companion object{

        operator fun invoke(
            binaryMessenger:BinaryMessenger,
            activity: Activity,
        ): NALibsService = NALibsService(
            binaryMessenger = binaryMessenger,
            activity = activity
        )

        private const val THAI_ID_CARD_READER:String = "THAI_ID_CARD_READER"

    }

    private val channel: MethodChannel by lazy {
        return@lazy MethodChannel(
            binaryMessenger,
            THAI_ID_CARD_READER
        )
    }

    private fun logs(print:String) = with(null){
        Log.d(NALibsService::class.java.name, print)
    }

    private val naLibsCores: NALibsCores by lazy {
        NALibsCores(
            activity = activity,
        )
    }

    init {
        channel.setMethodCallHandler {
                call: MethodCall,
                result: MethodChannel.Result ->
            launch(mainThread) {
                callHandler(call,result)
            }
        }
    }

    private suspend fun callHandler(
        request: MethodCall,
        response: MethodChannel.Result
    ) = with(request) {
        logs("callHandler: method: $method")

        when(method) {
            MethodName.GET_PLATFORM_VERSION.name -> {
                response.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            MethodName.READY_TO_USED.name -> {
                response.success(true)
            }
            MethodName.REQUEST_PERMISSIONS.name -> {
                naLibsCores.requestPermission(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.OPEN_LIBS.name -> {
                naLibsCores.openLibrary(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.UPDATE_LICENSE_FILE.name -> {
                naLibsCores.updateLicenseFile(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.CLOSED_EVENTS_LISTENER.name -> {
                naLibsCores.closedEventsListener(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.SET_PERMISSIONS.name -> {
                naLibsCores.setPermissions(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.CLOSED_LIBS.name -> {
                naLibsCores.closedLibrary(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.FIND_READER.name -> {
                naLibsCores.findReader(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.SELECT_READER.name -> {
                naLibsCores.selectReader(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.DESELECT_READER.name -> {
                naLibsCores.deselectReader(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.CONNECTED_CARD.name -> {
                naLibsCores.connectCard(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.DISCONNECTED_CARD.name -> {
                naLibsCores.disconnectCard(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.GET_LICENSE_INFO.name -> {
                naLibsCores.getLicenseInfo(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.GET_READER_INFO.name -> {
                naLibsCores.getReaderInfo(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.GET_SOFTWARE_INFO.name -> {
                naLibsCores.getSoftwareInfo(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.ID_CARD_NUMBER.name -> {
                naLibsCores.getIDCardNumber(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.ID_CARD_TEXT.name -> {
                naLibsCores.getIDCardText(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.ID_CARD_TEXT_WITH_OPTIONS.name -> {
                naLibsCores.getIDCardTextWithArgument(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.ID_CARD_PHOTO.name -> {
                naLibsCores.getPhotoByteImage(
                    arguments = arguments,
                    response = response
                )
            }
            MethodName.CARD_STATUS.name -> {
                naLibsCores.getCardStatus(
                    arguments = arguments,
                    response = response
                )
            }
            else -> {
                response.notImplemented()
            }
        }
    }
}