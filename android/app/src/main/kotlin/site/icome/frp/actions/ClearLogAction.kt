package site.icome.frp.actions

import android.content.Context
import site.icome.frp.consts.Consts
import java.io.FileNotFoundException

class ClearLogAction : Action("ClearLog") {

    override fun doAction(context: ActionContext): Map<String, Any?> {
        val appContext = context.appContext
        return appContext.runCatching {
            openFileOutput(Consts.FRP_LOG_FILE_NAME, Context.MODE_PRIVATE)
                .bufferedWriter(Charsets.UTF_8).use {
                    it.write("")
                    success("")
                }
        }.getOrElse {
            if (it is FileNotFoundException) success("") else fail(it.message)
        }
    }
}