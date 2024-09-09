package site.icome.frp.actions

import site.icome.frp.consts.Consts
import java.io.FileNotFoundException

class ReadConfigAction : Action("ReadConfig") {

    override fun doAction(context: ActionContext): Map<String, Any?> {
        val appContext = context.appContext
        return appContext.runCatching {
            openFileInput(Consts.FRP_CONFIG_FILE_NAME)
                .bufferedReader(Charsets.UTF_8).use {
                    val content = it.readText()
                    if (content.contains("#_generated")) {
                        return success(content.split("#_generated\n")[1])
                    }
                    success(content)
                }
        }.getOrElse { if (it is FileNotFoundException) success("") else fail(it.message) }
    }
}

