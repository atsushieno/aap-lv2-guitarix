package org.androidaudioplugin.aap_guitarix

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.rule.ServiceTestRule
import org.androidaudioplugin.hosting.AudioPluginHostHelper
import org.androidaudioplugin.androidaudioplugin.testing.AudioPluginServiceTesting
import org.junit.Assert
import org.junit.Rule
import org.junit.Test

class PluginTest {
    private val applicationContext = ApplicationProvider.getApplicationContext<Context>()
    private val testing = AudioPluginServiceTesting(applicationContext)
    @get:Rule
    val serviceRule = ServiceTestRule()

    @Test
    fun queryAudioPluginServices() {
        val appContext = InstrumentationRegistry.getInstrumentation().targetContext
        val services = AudioPluginHostHelper.queryAudioPluginServices(appContext)
        assert(services.all { s -> s.plugins.size > 0 })
        assert(services.any { s -> s.packageName == "org.androidaudioplugin.ports.lv2.guitarix" && s.label == "AAPBareBoneSamplePlugin" })
    }

    // testSinglePluginInformation() is not suitable for this plugin (guitarix has 70+ plugins)
    //@Test
    fun testPluginInfo() {
        testing.testSinglePluginInformation {
            Assert.assertEquals("lv2:http://guitarix.sourceforge.net/plugins/gx_aclipper_#_aclipper_", it.pluginId)
            Assert.assertEquals(4, it.parameters.size)
            Assert.assertEquals(4, it.ports.size)
        }
    }

    @Test
    fun basicServiceOperationsForAllPlugins() {
        testing.basicServiceOperationsForAllPlugins()
    }

    @Test
    fun repeatDirectServieOperations() {
        for (i in 0 until 5)
            basicServiceOperationsForAllPlugins()
    }
}
