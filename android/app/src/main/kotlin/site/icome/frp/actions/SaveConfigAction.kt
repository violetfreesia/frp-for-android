package site.icome.frp.actions

import android.content.Context
import site.icome.frp.consts.Consts

class SaveConfigAction : Action("SaveConfig") {

    override fun doAction(context: ActionContext): Map<String, Any?> {
        val content: String = context.getArg("content") ?: return fail("content must not null.")

        val appContext = context.appContext
        return appContext.runCatching {
            openFileOutput(Consts.FRP_CONFIG_FILE_NAME, Context.MODE_PRIVATE)
                .bufferedWriter(Charsets.UTF_8).use {
                    val logPath = "${appContext.filesDir.absolutePath}/${Consts.FRP_LOG_FILE_NAME}"
                    it.write("log.to=\"${logPath}\" #_generated\n${content}")
                    success(null)
                }
        }.getOrElse { fail(it.message) }
    }
}