package site.icome.frp.actions

import android.content.Intent
import android.os.Build
import androidx.annotation.RequiresApi
import site.icome.frp.FrpService

class FrpcAction : Action("FRP") {

    @RequiresApi(Build.VERSION_CODES.P)
    override fun doAction(context: ActionContext): Map<String, Any?> {
        val type: String = context.getArg("type") ?: return fail("type must not null.")
        val appContext = context.appContext
        val frpService = context.frpService ?: return fail("frp service not found.")
        return when (type) {
            "start" -> {
                appContext.startService(Intent(appContext, FrpService::class.java))
                success(1)
            }

            "stop" -> {
                frpService.stopFrpc()
                success(null)
            }

            "status" -> {
                success(frpService.status())
            }

            else -> fail("unsupported type.")
        }
    }
}