package com.schoolmate.pages;

import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import java.util.List;

public class ManageUsersPage {
    private AndroidDriver driver;
    private WebDriverWait wait;

    public ManageUsersPage(AndroidDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        PageFactory.initElements(driver, this);
    }

    private List<WebElement> getButtons() {
        return driver.findElements(
                org.openqa.selenium.By.xpath("//android.widget.Button | //android.view.View[@clickable='true']"));
    }

    private List<WebElement> getEditTexts() {
        return driver.findElements(org.openqa.selenium.By.className("android.widget.EditText"));
    }

    @FindBy(xpath = "//*[@content-desc='Add' or @text='Add' or @content-desc='ADD' or @text='ADD' or @content-desc='Save' or @text='Save' or @content-desc='SAVE' or @text='SAVE']")
    private WebElement addConfirmButton;

    @FindBy(xpath = "//android.widget.Button[@content-desc='Delete' or @text='Delete' or @content-desc='DELETE' or @text='DELETE']")
    private WebElement confirmDeleteButton;

    public void clickAddIcon() {
        try {
            wait.until(d -> getButtons().size() > 0);
            Thread.sleep(1500); // Give Flutter a moment to stabilize

            List<WebElement> buttons = getButtons();
            WebElement addBtn = null;

            for (WebElement btn : buttons) {
                String desc = btn.getAttribute("content-desc");
                String text = btn.getText();
                if (desc == null)
                    desc = "";
                if (text == null)
                    text = "";

                // Priority for the AppBar/FAB Add button
                if (desc.contains("Add") || desc.contains("ADD") || desc.contains("+") ||
                        text.contains("Add") || text.contains("ADD") || text.contains("+")) {
                    addBtn = btn;
                    break;
                }
            }

            if (addBtn != null) {
                addBtn.click();
            } else {
                // If we can't find a specific one, the FAB is usually the last button
                buttons.get(buttons.size() - 1).click();
            }
        } catch (Exception e) {
            System.out.println("Warning: clickAddIcon failed: " + e.getMessage());
        }

        try {
            Thread.sleep(2000);
        } catch (Exception e) {
        }
    }

    public void enterUserDetails(String name, String email, String password) {
        wait.until(d -> getEditTexts().size() >= 3);
        List<WebElement> fields = getEditTexts();

        // Field 1: Name
        WebElement nameField = fields.get(0);
        nameField.click();
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
        nameField.clear();
        nameField.sendKeys(name);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }

        // Field 2: Email
        WebElement emailField = fields.get(1);
        emailField.click();
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
        emailField.clear();
        emailField.sendKeys(email);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }

        // Field 3: Password
        WebElement passwordField = fields.get(2);
        passwordField.click();
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
        passwordField.clear();
        passwordField.sendKeys(password);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
    }

    public void confirmAdd() {
        try {
            if (driver.isKeyboardShown()) {
                driver.hideKeyboard();
                Thread.sleep(1000);
            }
        } catch (Exception e) {
        }

        // Try to find the Add/Save button inside the dynamic dialog
        try {
            List<WebElement> buttons = getButtons();
            WebElement finalBtn = null;
            for (WebElement btn : buttons) {
                String desc = btn.getAttribute("content-desc");
                String text = btn.getText();
                if (desc == null)
                    desc = "";
                if (text == null)
                    text = "";

                if (desc.equalsIgnoreCase("Add") || text.equalsIgnoreCase("Add") ||
                        desc.equalsIgnoreCase("Save") || text.equalsIgnoreCase("Save") ||
                        desc.equalsIgnoreCase("ADD") || text.equalsIgnoreCase("ADD")) {
                    finalBtn = btn;
                    break;
                }
            }
            if (finalBtn != null) {
                finalBtn.click();
            } else {
                wait.until(ExpectedConditions.elementToBeClickable(addConfirmButton)).click();
            }
        } catch (Exception e) {
            System.out.println("Retry: confirmAdd failed dynamically, trying fallback...");
            wait.until(ExpectedConditions.elementToBeClickable(addConfirmButton)).click();
        }

        try {
            Thread.sleep(3000);
        } catch (Exception e) {
        }
    }

    public boolean isUserPresent(String email) {
        // Scroll to find the user in the list
        try {
            driver.findElement(io.appium.java_client.AppiumBy.androidUIAutomator(
                    "new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(" +
                            "new UiSelector().descriptionContains(\"" + email + "\"))"));
        } catch (Exception e) {
            try {
                driver.findElement(io.appium.java_client.AppiumBy.androidUIAutomator(
                        "new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(" +
                                "new UiSelector().textContains(\"" + email + "\"))"));
            } catch (Exception ex) {
            }
        }

        try {
            return driver
                    .findElement(org.openqa.selenium.By
                            .xpath("//*[contains(@content-desc, '" + email + "') or contains(@text, '" + email + "')]"))
                    .isDisplayed();
        } catch (Exception e) {
            return false;
        }
    }

    public void deleteUser(String email) {
        String rowXpath = "//*[contains(@content-desc, '" + email + "') or contains(@text, '" + email + "')]";
        try {
            WebElement deleteBtn = driver
                    .findElement(org.openqa.selenium.By.xpath(rowXpath + "/following-sibling::android.widget.Button"));
            deleteBtn.click();
        } catch (Exception e) {
            WebElement deleteBtn = driver
                    .findElement(org.openqa.selenium.By.xpath(rowXpath + "/..//android.widget.Button"));
            deleteBtn.click();
        }

        try {
            Thread.sleep(1000);
        } catch (Exception ex) {
        }
        wait.until(ExpectedConditions.elementToBeClickable(confirmDeleteButton)).click();
        try {
            Thread.sleep(2000);
        } catch (Exception ex) {
        }
    }
}
