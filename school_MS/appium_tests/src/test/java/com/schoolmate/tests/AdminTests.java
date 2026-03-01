package com.schoolmate.tests;

import com.schoolmate.base.BaseTest;
import com.schoolmate.pages.LoginPage;
import com.schoolmate.pages.DashboardPage;
import com.schoolmate.pages.ActivityLogPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class AdminTests extends BaseTest {

    @Test(priority = 1)
    public void testClearActivityLogHistory() throws InterruptedException {
        LoginPage loginPage = new LoginPage(driver);
        DashboardPage dashboardPage = new DashboardPage(driver);
        ActivityLogPage logPage = new ActivityLogPage(driver);

        // 1. Login
        loginPage.selectRole("admin");
        loginPage.enterEmail("admin@gmail.com");
        loginPage.enterPassword("123456");
        loginPage.clickLogin();

        // 2. Go to Activity Log
        dashboardPage.goToActivityLog();

        // 3. Clear Logs
        logPage.clearLogs();
        Thread.sleep(2000);

        Assert.assertTrue(driver.getPageSource().contains("No activity recorded"), "Logs should be cleared.");

        dashboardPage.logout();
    }
}
