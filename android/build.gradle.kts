
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.util.Properties

group = "card.reader.plugin.card_reader_plugin"
version = "1.0-SNAPSHOT"

/** Add Gradle Other Project */
buildscript {

    gradle.rootProject {
        findProject(":card_reader_plugin").let { pluginProject ->
            val mavenPath:String = when {
                pluginProject != null -> {
                    file("${pluginProject.projectDir}/na_maven").canonicalPath
                }
                else -> {
                    file("${projectDir}/na_maven").canonicalPath
                }
            }
//            println("buildscript: mavenPath: $mavenPath")

            /** Some Gradle Project */
            subprojects{
//                println("subprojects: buildscript: name: $name")
                when{
                    (name == "app") -> {
                        repositories{
                            maven {
                                url = uri(mavenPath)
//                                println("buildscript: url: rawPath: ${url.rawPath}")
                            }
                        }
                    }
                }
            }

            /** All Gradle Project */
//            allprojects{
//                repositories{
//                    maven {
//                        url = uri(mavenPath)
//                        println("buildscript: url: rawPath: ${url.rawPath}")
//                    }
//                }
//            }

        }
    }

}

/** Add Gradle Me Project */
repositories{
    google()
    mavenCentral()

    /** Me Plugin Project For Find NA Libs */
    maven {
        url = uri("$projectDir/na_maven")
//        println("repositories: url: rawPath: ${url.rawPath}")
    }

}

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

kotlin{
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

android {
    namespace = "card.reader.plugin.card_reader_plugin"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin", "src/main/java")
//            java.srcDirs("src/main/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.useJUnitPlatform()

                it.outputs.upToDateWhen { false }

                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }

}

dependencies {

    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.0.0")

    /** Kotlin coroutine scope */
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.11.0")
    implementation("androidx.core:core-ktx:1.12.0")

    /** Flutter SDK */
    Properties().let { properties ->

        rootProject.file("local.properties").let { rootFile ->
            when {
                rootFile.exists() -> {
                    rootFile.inputStream().use { input ->
                        properties.load(input)
                    }
                }
            }

            val engineFolderList: List<String> = listOf<String>(
                "android-arm",
                "android-arm-profile",
                "android-arm-release"
            )

            /**
             * ถ้า gradle sync ไม่ผ่าน
             * ใน flutterSDKPath ได้ค่าไม่ถูกต้อง
             * ให้ตรวจสอบ local.properties ใน project
             * แก้ไข path flutter.sdk ให้ถูกต้อง
             * --> ตัวอย่าง <--
             * flutter.sdk=C\:\\src\\flutter
             * # flutter.sdk=/Users/d1macbookair/flutter
             * sdk.dir=/Users/d1macbookair/Library/Android/sdk
             * */

            properties.getProperty("flutter.sdk")?.let { flutterSDKPath ->
//                println("flutterSDKPath: $flutterSDKPath")

                engineFolderList.map { engine ->
                    File("$flutterSDKPath/bin/cache/artifacts/engine/$engine/flutter.jar")
                }.let { flutterJarFile ->

                    flutterJarFile.firstOrNull {
                            file -> file.exists()
                    }?.let { jarFile ->
//                        println("jarFile.exists(): ${jarFile.exists()}")
//                        println("jarFile.path: ${jarFile.path}")
                        /// for MAC OS other flutter version
                        compileOnly(
                            project.files(jarFile)
                        )
                    } ?: also {
                        /// for Windows OS other flutter version
                        project
                            .file("$flutterSDKPath/bin/cache/artifacts/engine/${engineFolderList.first()}/flutter.jar")
                            .let { flutterJarFile ->
                                compileOnly(
                                    project.files(flutterJarFile)
                                )
                            }
                    }

                }
            }
        }
    }

    /** NA Library **/
    implementation("rd.nalib:NALib:0.1.1600")

//    val aarHashmap: Map<String,Any> = mapOf<String, Any>(
//        "include" to listOf("*.aar"),
//        "dir" to "na_libs",
//    )
//    val jarHashmap: Map<String,Any> = mapOf<String, Any>(
//        "include" to listOf("*.jar"),
//        "dir" to "na_libs",
//    )
//
//    compileOnly(
//        fileTree(aarHashmap)
//    )
//
//    implementation(
//        fileTree(jarHashmap)
//    )


}
