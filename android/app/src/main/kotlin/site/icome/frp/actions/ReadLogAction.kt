package site.icome.frp.actions

import site.icome.frp.consts.Consts
import java.io.FileNotFoundException

class ReadLogAction : Action("ReadLog") {

    override fun doAction(context: ActionContext): Map<String, Any?> {
        val appContext = context.appContext
        return appContext.runCatching {
            openFileInput(Consts.FRP_LOG_FILE_NAME)
                .bufferedReader(Charsets.UTF_8).use {
                    success(it.readText())
                }
        }.getOrElse { if (it is FileNotFoundException) success("") else fail(it.message) }
    }
}