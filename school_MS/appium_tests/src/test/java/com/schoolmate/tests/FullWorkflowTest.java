package com.schoolmate.tests;

import com.schoolmate.base.BaseTest;
import com.schoolmate.pages.ActivityLogPage;
import com.schoolmate.pages.DashboardPage;
import com.schoolmate.pages.LoginPage;
import com.schoolmate.pages.SignupPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class FullWorkflowTest extends BaseTest {

    @Test(priority = 1)
    public void testSignupAndActivityCheck() throws InterruptedException {
        LoginPage loginPage = new LoginPage(driver);
        SignupPage signupPage = new SignupPage(driver);
        DashboardPage dashboardPage = new DashboardPage(driver);
        ActivityLogPage logPage = new ActivityLogPage(driver);

        // 1. Go to Signup from Login
        loginPage.waitToDisplay();
        loginPage.goToSignup();
        Thread.sleep(2000);

        // 2. Perform Signup
        String uniqueEmail = "test_user_" + System.currentTimeMillis() + "@gmail.com";
        signupPage.selectRole("admin");
        signupPage.enterName("Automation Admin");
        signupPage.enterEmail(uniqueEmail);
        signupPage.enterPassword("password123");
        signupPage.clickSignup();
        Thread.sleep(3000);

        // 3. Login with new credentials
        loginPage.selectRole("admin");
        loginPage.enterEmail(uniqueEmail);
        loginPage.enterPassword("password123");
        loginPage.clickLogin();
        Thread.sleep(2000);

        // 4. Verify Admin Dashboard
        Assert.assertTrue(dashboardPage.isAdminDashboardVisible(), "Dashboard should be visible after signup/login.");

        // 5. Check Activity Log
        dashboardPage.goToActivityLog();
        Thread.sleep(2000);

        Assert.assertTrue(logPage.isPageVisible(), "Activity Log screen should open.");
        Assert.assertTrue(logPage.containsLog("Signed up as Automation Admin"), "Signup action should be recorded.");
    }
}
