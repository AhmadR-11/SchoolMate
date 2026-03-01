package com.schoolmate.tests;

import com.schoolmate.base.BaseTest;
import com.schoolmate.pages.LoginPage;
import com.schoolmate.pages.SignupPage;
import com.schoolmate.pages.DashboardPage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class AuthTests extends BaseTest {

    @Test(priority = 1)
    public void testSuccessfulStudentSignup() throws InterruptedException {
        LoginPage loginPage = new LoginPage(driver);
        SignupPage signupPage = new SignupPage(driver);

        loginPage.waitToDisplay();
        loginPage.goToSignup();

        String email = "student_" + System.currentTimeMillis() + "@gmail.com";
        signupPage.selectRole("student");
        signupPage.enterName("Auto Student");
        signupPage.enterEmail(email);
        signupPage.enterPassword("password123");
        signupPage.clickSignup();

        Thread.sleep(2000);
        loginPage.waitToDisplay();
        Assert.assertTrue(driver.getPageSource().contains("Login"), "Should return to Login screen after signup.");
    }

    @Test(priority = 2)
    public void testDuplicateEmailPrevention() throws InterruptedException {
        LoginPage loginPage = new LoginPage(driver);
        SignupPage signupPage = new SignupPage(driver);

        loginPage.waitToDisplay();
        loginPage.goToSignup();

        // Using a known existing email
        signupPage.selectRole("admin");
        signupPage.enterName("Duplicate Admin");
        signupPage.enterEmail("admin@gmail.com");
        signupPage.enterPassword("password123");
        signupPage.clickSignup();

        Thread.sleep(2000);
        Assert.assertTrue(driver.getPageSource().contains("failed") || driver.getPageSource().contains("exist"),
                "Error message for duplicate email should be shown.");
    }

    @Test(priority = 3)
    public void testSuccessfulTeacherLogin() throws InterruptedException {
        // PRE-REQUISITE: Ensure a teacher exists (or use one added in previous session)
        // For independence, we'll assume 'teacher@gmail.com' exists or signup quickly
        LoginPage loginPage = new LoginPage(driver);
        DashboardPage dashboardPage = new DashboardPage(driver);

        loginPage.selectRole("teacher");
        loginPage.enterEmail("teacher@gmail.com");
        loginPage.enterPassword("123456");
        loginPage.clickLogin();

        Thread.sleep(2000);
        Assert.assertTrue(
                driver.getPageSource().contains("Teacher Dashboard") || driver.getPageSource().contains("Welcome"),
                "Teacher Dashboard should be visible.");
    }

    @Test(priority = 4)
    public void testInvalidPasswordHandling() throws InterruptedException {
        LoginPage loginPage = new LoginPage(driver);

        loginPage.selectRole("admin");
        loginPage.enterEmail("admin@gmail.com");
        loginPage.enterPassword("wrongpassword");
        loginPage.clickLogin();

        Thread.sleep(2000);
        Assert.assertTrue(driver.getPageSource().contains("Invalid credentials"),
                "Should show error for wrong password.");
    }

    @Test(priority = 5)
    public void testLoginRoleSecurity() throws InterruptedException {
        LoginPage loginPage = new LoginPage(driver);

        // Try to login as Student with Admin credentials
        loginPage.selectRole("student");
        loginPage.enterEmail("admin@gmail.com");
        loginPage.enterPassword("123456");
        loginPage.clickLogin();

        Thread.sleep(2000);
        Assert.assertTrue(driver.getPageSource().contains("Invalid credentials"),
                "Login should fail when incorrect role is selected for the user.");
    }
}
