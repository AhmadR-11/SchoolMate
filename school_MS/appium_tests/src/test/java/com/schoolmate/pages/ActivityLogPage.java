package com.schoolmate.pages;

import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import java.util.List;

public class ActivityLogPage {
    private AndroidDriver driver;
    private WebDriverWait wait;

    public ActivityLogPage(AndroidDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        PageFactory.initElements(driver, this);
    }

    private List<WebElement> getLogEntries() {
        return driver.findElements(org.openqa.selenium.By.className("android.view.View"));
    }

    @FindBy(xpath = "//*[contains(@content-desc, 'Activity Log') or contains(@text, 'Activity Log')]")
    private WebElement title;

    @FindBy(xpath = "//android.widget.Button[@content-desc='Clear Logs' or contains(@text, 'Clear')]")
    private WebElement clearButton;

    public boolean isPageVisible() {
        try {
            return wait.until(ExpectedConditions.visibilityOf(title)).isDisplayed();
        } catch (Exception e) {
            return false;
        }
    }

    public void clearLogs() {
        wait.until(ExpectedConditions.elementToBeClickable(clearButton)).click();
    }

    public boolean containsLog(String text) {
        try {
            // Wait up to 5 seconds for any log entries to appear
            new WebDriverWait(driver, Duration.ofSeconds(5)).until(d -> getLogEntries().size() > 0);
            for (WebElement entry : getLogEntries()) {
                String desc = entry.getAttribute("content-desc");
                if (desc != null && desc.contains(text))
                    return true;
                String textVal = entry.getText();
                if (textVal != null && textVal.contains(text))
                    return true;
            }
        } catch (Exception e) {
        }
        return false;
    }
}
