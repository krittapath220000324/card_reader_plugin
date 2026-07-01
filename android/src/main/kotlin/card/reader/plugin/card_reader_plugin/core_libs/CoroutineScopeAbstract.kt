package card.reader.plugin.card_reader_plugin.core_libs

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlin.coroutines.CoroutineContext

abstract class CoroutineScopeAbstract : CoroutineScope {
    override val coroutineContext: CoroutineContext
        get() = defaultThread

    private val _mainThread: CoroutineContext by lazy { Dispatchers.Main }
    val mainThread: CoroutineContext
        get() = _mainThread

    private val _ioThread: CoroutineContext by lazy { Dispatchers.IO }
    val ioThread: CoroutineContext
        get() = _ioThread

    private val _defaultThread: CoroutineContext by lazy { Dispatchers.Default }
    val defaultThread: CoroutineContext
        get() = _defaultThread

    private val _unconfinedThread: CoroutineContext by lazy { Dispatchers.Unconfined }
    val unconfinedThread: CoroutineContext
        get() = _unconfinedThread

    suspend fun<Type> withContextIO(
        action: () -> Type
    ):Type = withContext(_ioThread) {
        action.invoke()
    }

    suspend fun<Type> withContextMain(
        action: () -> Type
    ):Type = withContext(_mainThread) {
        action.invoke()
    }

    suspend fun<Type> withContextDefault(
        action: () -> Type
    ): Type = withContext(_defaultThread) {
        action.invoke()
    }

    suspend fun<Type> withContextUnconfined(
        action: () -> Type
    ): Type = withContext(_unconfinedThread) {
        action.invoke()
    }

}