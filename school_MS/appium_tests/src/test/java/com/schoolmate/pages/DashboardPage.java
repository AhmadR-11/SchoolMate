package com.schoolmate.pages;

import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

public class DashboardPage {
    private AndroidDriver driver;

    public DashboardPage(AndroidDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    // Detecting by either title or welcome text
    @FindBy(xpath = "//*[contains(@content-desc, 'Admin Dashboard') or contains(@text, 'Admin Dashboard') or contains(@content-desc, 'Welcome, Admin') or contains(@text, 'Welcome, Admin')]")
    private WebElement adminDashboardTitle;

    @FindBy(xpath = "//*[@content-desc='Logout' or @text='Logout' or contains(@content-desc, 'logout')]")
    private WebElement logoutButton;

    @FindBy(xpath = "//*[contains(@content-desc, 'Activity Log') or contains(@text, 'Activity Log')]")
    private WebElement activityLogCard;

    @FindBy(xpath = "//*[contains(@content-desc, 'Manage Students') or contains(@text, 'Manage Students')]")
    private WebElement manageStudentsCard;

    @FindBy(xpath = "//*[contains(@content-desc, 'Manage Teachers') or contains(@text, 'Manage Teachers')]")
    private WebElement manageTeachersCard;

    @FindBy(xpath = "//*[contains(@content-desc, 'Attendance') or contains(@text, 'Attendance')]")
    private WebElement attendanceCard;

    @FindBy(xpath = "//*[contains(@content-desc, 'Assignments') or contains(@text, 'Assignments')]")
    private WebElement assignmentsCard;

    public boolean isAdminDashboardVisible() {
        try {
            WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
            wait.until(ExpectedConditions.visibilityOf(adminDashboardTitle));
            return adminDashboardTitle.isDisplayed();
        } catch (Exception e) {
            return false;
        }
    }

    public void logout() {
        try {
            waitToDisplay(logoutButton, 10);
            logoutButton.click();
        } catch (Exception e) {
        }
    }

    public void goToActivityLog() {
        // Scroll to the bottom to find the card
        try {
            driver.findElement(io.appium.java_client.AppiumBy.androidUIAutomator(
                    "new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(new UiSelector().textContains(\"Activity Log\"))"));
        } catch (Exception e) {
            // Fallback if UIAutomator scroll fails
        }
        waitToDisplay(activityLogCard, 10);
        activityLogCard.click();
    }

    public void goToManageStudents() {
        waitToDisplay(manageStudentsCard, 10);
        manageStudentsCard.click();
    }

    public void goToManageTeachers() {
        waitToDisplay(manageTeachersCard, 10);
        manageTeachersCard.click();
    }

    public void goToAttendance() {
        // Scroll to find Attendance if needed
        try {
            driver.findElement(io.appium.java_client.AppiumBy.androidUIAutomator(
                    "new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(new UiSelector().textContains(\"Attendance\"))"));
        } catch (Exception e) {
        }
        waitToDisplay(attendanceCard, 10);
        attendanceCard.click();
    }

    public void goToAssignments() {
        waitToDisplay(assignmentsCard, 10);
        assignmentsCard.click();
    }

    private void waitToDisplay(WebElement element, int timeout) {
        new WebDriverWait(driver, Duration.ofSeconds(timeout)).until(ExpectedConditions.visibilityOf(element));
    }
}
