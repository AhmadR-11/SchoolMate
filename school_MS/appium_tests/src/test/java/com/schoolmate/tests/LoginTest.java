package com.schoolmate.tests;

import com.schoolmate.base.BaseTest;
import com.schoolmate.pages.DashboardPage;
import com.schoolmate.pages.LoginPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class LoginTest extends BaseTest {

    @Test(priority = 1)
    public void testSuccessfulAdminLogin() throws InterruptedException {
        LoginPage loginPage = new LoginPage(driver);
        DashboardPage dashboardPage = new DashboardPage(driver);

        // 1. Select Admin role
        loginPage.selectRole("admin");
        Thread.sleep(1000); // Small pause to 'see' the action

        // 2. Enter Credentials (using step-by-step for visibility)
        loginPage.enterEmail("admin@gmail.com");
        Thread.sleep(1000);
        loginPage.enterPassword("123456");
        Thread.sleep(1000);

        // 3. Click Login
        loginPage.clickLogin();

        // 4. Verify Dashboard
        Assert.assertTrue(dashboardPage.isAdminDashboardVisible(), "SUCCESS: Admin Dashboard displayed.");
        Thread.sleep(2000);

        // Cleanup
        dashboardPage.logout();
    }

    @Test(priority = 2)
    public void testFailedLoginWithWrongCredentials() throws InterruptedException {
        LoginPage loginPage = new LoginPage(driver);
        DashboardPage dashboardPage = new DashboardPage(driver);

        // 1. Select Admin role
        loginPage.selectRole("admin");
        Thread.sleep(1000);

        // 2. Enter WRONG Credentials
        loginPage.enterEmail("wrong_user@gmail.com");
        Thread.sleep(1000);
        loginPage.enterPassword("000000");
        Thread.sleep(1000);

        // 3. Click Login
        loginPage.clickLogin();

        // 4. Verify Dashboard is NOT visible (Test passes if dashboard is absent)
        Assert.assertFalse(dashboardPage.isAdminDashboardVisible(),
                "FAILURE: Dashboard should NOT be visible for wrong credentials.");
        Thread.sleep(2000);
    }
}
