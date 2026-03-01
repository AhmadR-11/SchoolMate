package com.schoolmate.pages;

import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import java.util.List;

public class TeacherFeaturesPage {
    private AndroidDriver driver;
    private WebDriverWait wait;

    public TeacherFeaturesPage(AndroidDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        PageFactory.initElements(driver, this);
    }

    private List<WebElement> getInputs() {
        return driver.findElements(org.openqa.selenium.By.className("android.widget.EditText"));
    }

    private List<WebElement> getButtons() {
        return driver.findElements(org.openqa.selenium.By.className("android.widget.Button"));
    }

    @FindBy(xpath = "//*[@content-desc='Save' or @text='Save' or @content-desc='Add' or @text='Add' or @content-desc='SAVE']")
    private WebElement saveButton;

    @FindBy(xpath = "//*[contains(@content-desc, 'Attendance Rate') or contains(@text, 'Attendance Rate')]")
    private WebElement attendanceRateCard;

    public void clickAddIcon() {
        try {
            wait.until(d -> getButtons().size() > 0);
            Thread.sleep(1000);

            List<WebElement> buttons = getButtons();
            WebElement addBtn = null;

            for (WebElement btn : buttons) {
                String desc = btn.getAttribute("content-desc");
                String text = btn.getText();
                if (desc == null)
                    desc = "";
                if (text == null)
                    text = "";

                if (desc.contains("Add") || desc.contains("ADD") || desc.contains("+") ||
                        text.contains("Add") || text.contains("ADD") || text.contains("+")) {
                    addBtn = btn;
                    break;
                }
            }

            if (addBtn != null) {
                addBtn.click();
            } else {
                // Fallback: Use the last button if we can't find a specific Add button
                buttons.get(buttons.size() - 1).click();
            }
        } catch (Exception e) {
            System.out.println("Warning: clickAddIcon failed: " + e.getMessage());
        }

        try {
            Thread.sleep(1500);
        } catch (Exception e) {
        }
    }

    public void createAssignment(String title, String desc, String cls, String sec, String date) {
        // Ensure form is open
        clickAddIcon();

        wait.until(d -> getInputs().size() >= 5);
        List<WebElement> fields = getInputs();

        // Field 1: Title
        fields.get(0).click();
        fields.get(0).clear();
        fields.get(0).sendKeys(title);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }

        // Field 2: Description
        fields.get(1).click();
        fields.get(1).clear();
        fields.get(1).sendKeys(desc);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }

        // Field 3: Class
        fields.get(2).click();
        fields.get(2).clear();
        fields.get(2).sendKeys(cls);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }

        // Field 4: Section
        fields.get(3).click();
        fields.get(3).clear();
        fields.get(3).sendKeys(sec);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }

        // Field 5: Date
        fields.get(4).click();
        fields.get(4).clear();
        fields.get(4).sendKeys(date);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }

        if (driver.isKeyboardShown())
            driver.hideKeyboard();

        wait.until(ExpectedConditions.elementToBeClickable(saveButton)).click();
    }

    public void markAttendance(String email, String date, String status) {
        clickAddIcon();

        wait.until(d -> getInputs().size() >= 2);
        List<WebElement> fields = getInputs();

        fields.get(0).click();
        fields.get(0).clear();
        fields.get(0).sendKeys(date);

        fields.get(1).click();
        fields.get(1).clear();
        fields.get(1).sendKeys(email);

        if (driver.isKeyboardShown())
            driver.hideKeyboard();
        saveButton.click();
    }

    public boolean isAttendanceSummaryVisible() {
        try {
            return wait.until(ExpectedConditions.visibilityOf(attendanceRateCard)).isDisplayed();
        } catch (Exception e) {
            return false;
        }
    }

    public boolean isAssignmentPresent(String title) {
        try {
            return driver
                    .findElement(org.openqa.selenium.By
                            .xpath("//*[contains(@content-desc, '" + title + "') or contains(@text, '" + title + "')]"))
                    .isDisplayed();
        } catch (Exception e) {
            return false;
        }
    }
}
