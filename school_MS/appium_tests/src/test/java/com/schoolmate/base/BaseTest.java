package com.schoolmate.base;

import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.options.UiAutomator2Options;
import org.testng.ITestListener;
import org.testng.ITestResult;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;

public class BaseTest implements ITestListener {
    protected AndroidDriver driver;

    @Override
    public void onTestStart(ITestResult result) {
        System.out.println("\n🚀 RUNNING TEST: " + result.getName());
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        System.out.println("✅ TEST PASSED: " + result.getName());
    }

    @Override
    public void onTestFailure(ITestResult result) {
        System.out.println("❌ TEST FAILED: " + result.getName());
        System.out.println("Reason: " + result.getThrowable());
    }

    @BeforeMethod
    public void setUp() throws java.net.MalformedURLException, java.net.URISyntaxException {
        UiAutomator2Options options = new UiAutomator2Options();
        options.setPlatformName("Android");
        options.setDeviceName("Android Emulator");
        options.setAutomationName("UiAutomator2");

        options.setApp(System.getProperty("user.dir") + "/../build/app/outputs/flutter-apk/app-debug.apk");
        options.setAppPackage("com.example.school_ms");
        options.setAppActivity(".MainActivity");
        options.setNoReset(true);
        options.setFullReset(false);

        driver = new AndroidDriver(new java.net.URI("http://127.0.0.1:4723").toURL(), options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));

        // RESET APP STATE: Terminate and Relaunch to ensure we start at Login
        try {
            String pkg = options.getAppPackage().orElse("com.example.school_ms");
            driver.terminateApp(pkg);
            Thread.sleep(1000);
            driver.activateApp(pkg);
            Thread.sleep(5000); // Wait for app to load completely
        } catch (Exception e) {
            System.out.println("Warning: App restart failed - " + e.getMessage());
        }
    }

    @AfterMethod
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
