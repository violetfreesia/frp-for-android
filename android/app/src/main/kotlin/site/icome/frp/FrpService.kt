package site.icome.frp

import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import site.icome.frp.consts.Consts.FRPC_NOTIFICATION_CHANNEL_ID

@RequiresApi(Build.VERSION_CODES.P)
class FrpService : Service() {
    private val binder = FrpBinder()
    private var frpcProcess: Process? = null

    inner class FrpBinder : Binder() {
        val service get() = this@FrpService
    }

    override fun onBind(intent: Intent?) = binder

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startFrpc()
        startForeground(1, createNotification())
        return START_STICKY
    }

    fun status(): Int {
        return if (frpcProcess?.isAlive == true) 1 else 0
    }

    @Synchronized
    fun startFrpc(): Int {
        if (frpcProcess?.isAlive == true) {
            return 2
        }

        val context = applicationContext
        val frpcDir = context.applicationInfo.nativeLibraryDir
        val configDir = context.filesDir.absolutePath
        frpcProcess = ProcessBuilder(
            "$frpcDir/libfrpc.so",
            "-c",
            "$configDir/config.toml"
        ).start()

        return 1
    }

    @Synchronized
    fun stopFrpc() {
        if (frpcProcess?.isAlive == true) {
            frpcProcess?.destroy()
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
            frpcProcess = null
        }
    }


    private fun createNotification(): Notification {
        val pendingIntent = Intent(this, MainActivity::class.java).let {
            PendingIntent.getActivity(this, 0, it, PendingIntent.FLAG_IMMUTABLE)
        }
        // 创建通知
        val builder: NotificationCompat.Builder =
            NotificationCompat.Builder(this, FRPC_NOTIFICATION_CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setBadgeIconType(NotificationCompat.BADGE_ICON_LARGE)
                .setContentTitle("Fast Reverse Proxy")
                .setContentText("frpc is running")
                .setAutoCancel(false)
                .setOngoing(true)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setContentIntent(pendingIntent)

        // 如果需要，可以设置通知的其他属性
        return builder.build()
    }

}