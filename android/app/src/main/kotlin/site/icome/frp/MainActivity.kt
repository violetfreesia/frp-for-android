package site.icome.frp

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import site.icome.frp.actions.ActionContext
import site.icome.frp.actions.ActionManager
import site.icome.frp.consts.Consts.FRPC_NOTIFICATION_CHANNEL_ID


const val ACTION_HANDLER = "ACTION_HANDLER"

@RequiresApi(Build.VERSION_CODES.P)
class MainActivity : FlutterActivity() {

    private var frpService: FrpService? = null
    private var frpServiceConnection: FrpServiceConnection = FrpServiceConnection()

    inner class FrpServiceConnection : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            frpService = (service as FrpService.FrpBinder).service
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            frpService = null
        }
    }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
            != PackageManager.PERMISSION_GRANTED
        ) {
            // 如果权限未被授予，则请求权限
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS), 1
            )
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                FRPC_NOTIFICATION_CHANNEL_ID,
                "Frp后台服务运行通知",
                NotificationManager.IMPORTANCE_HIGH
            )
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
        val intent = Intent(this, FrpService::class.java)
        bindService(intent, frpServiceConnection, Context.BIND_AUTO_CREATE)
    }

    override fun onDestroy() {
        super.onDestroy()
        unbindService(frpServiceConnection)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ACTION_HANDLER)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                result.success(ActionManager.doAction(ActionContext(context, call, frpService)))
            }
    }
}
