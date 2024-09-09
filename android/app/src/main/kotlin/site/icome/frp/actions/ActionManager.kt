package site.icome.frp.actions

import android.content.Context
import io.flutter.plugin.common.MethodCall
import site.icome.frp.FrpService

class ActionContext(
    val appContext: Context,
    private val call: MethodCall,
    val frpService: FrpService?
) {
    val actionName: String get() = call.method

    fun <T> getArg(key: String) = call.argument<T>(key)
}

abstract class Action(val name: String) {

    protected fun success(data: Any?): Map<String, Any?> {
        return mapOf(
            Pair("success", true),
            Pair("data", data)
        )
    }

    protected fun fail(message: String? = null): Map<String, Any?> {
        return mapOf(
            Pair("success", false),
            Pair("message", message)
        )
    }

    abstract fun doAction(context: ActionContext): Map<String, Any?>
}

object ActionManager {

    private val ActionMap: MutableMap<String, Action> = mutableMapOf()

    init {
        registerAction(ReadConfigAction())
        registerAction(SaveConfigAction())
        registerAction(FrpcAction())
        registerAction(ReadLogAction())
        registerAction(ClearLogAction())
    }

    private fun registerAction(action: Action) {
        ActionMap[action.name] = action
    }

    fun doAction(context: ActionContext): Map<String, Any?> {
        val actionName = context.actionName
        return ActionMap.runCatching {
            get(actionName)?.doAction(context) ?: mapOf(
                Pair("success", false),
                Pair("message", "action not found.")
            )
        }.getOrElse {
            mapOf(
                Pair("success", false),
                Pair("message", "action process fail: ${it.message}")
            )
        }
    }


}