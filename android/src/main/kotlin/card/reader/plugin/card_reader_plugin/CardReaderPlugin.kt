package card.reader.plugin.card_reader_plugin

import card.reader.plugin.card_reader_plugin.core_libs.NALibsService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CardReaderPlugin : FlutterPlugin, ActivityAware {

    private var binding: FlutterPlugin.FlutterPluginBinding? = null
    private var naLibsService: NALibsService? = null

    override fun onAttachedToEngine(
        flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        binding = flutterPluginBinding
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        binding?.let {
            naLibsService = NALibsService(
                binaryMessenger = it.binaryMessenger,
                activity = activityPluginBinding.activity
            )
        }
    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binding = null
    }

    override fun onDetachedFromActivity() {
        naLibsService = null
    }

    override fun onDetachedFromActivityForConfigChanges() {}


}
