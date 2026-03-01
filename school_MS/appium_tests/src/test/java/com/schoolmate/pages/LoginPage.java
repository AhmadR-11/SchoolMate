package com.schoolmate.pages;

import io.appium.java_client.android.AndroidDriver;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import java.util.List;
import java.util.Collections;
import org.openqa.selenium.interactions.PointerInput;
import org.openqa.selenium.interactions.Sequence;

public class LoginPage {
    private AndroidDriver driver;
    private WebDriverWait wait;

    public LoginPage(AndroidDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        PageFactory.initElements(driver, this);
    }

    private By getRoleDropdownLocator() {
        return By.xpath(
                "//android.widget.Button[contains(@content-desc, 'STUDENT') or contains(@content-desc, 'TEACHER') or contains(@content-desc, 'ADMIN') or contains(@content-desc, 'student') or contains(@content-desc, 'teacher') or contains(@content-desc, 'admin')]");
    }

    private By getLoginButtonLocator() {
        return By.xpath(
                "//android.widget.Button[@content-desc='Login' or @text='Login' or @content-desc='LOGIN' or @text='LOGIN']");
    }

    @FindBy(xpath = "//android.widget.Button[contains(@content-desc, \"Don't have an account\")]")
    private WebElement signupLink;

    public void waitToDisplay() {
        wait.until(ExpectedConditions.presenceOfElementLocated(getRoleDropdownLocator()));
    }

    public void goToSignup() {
        wait.until(ExpectedConditions.elementToBeClickable(signupLink)).click();
    }

    public void selectRole(String role) {
        wait.until(ExpectedConditions.elementToBeClickable(getRoleDropdownLocator())).click();

        // Dynamic locator for the role option
        String xpath = "//*[@content-desc='" + role.toUpperCase() + "' or @text='" + role.toUpperCase() + "' or " +
                "@content-desc='" + role.toLowerCase() + "' or @text='" + role.toLowerCase() + "']";

        wait.until(ExpectedConditions.elementToBeClickable(By.xpath(xpath))).click();

        try {
            Thread.sleep(1500); // Wait for dropdown to close
        } catch (InterruptedException e) {
        }
    }

    private List<WebElement> getEditTexts() {
        return driver.findElements(By.className("android.widget.EditText"));
    }

    private WebElement getEmailField() {
        wait.until(d -> getEditTexts().size() >= 2);
        List<WebElement> fields = getEditTexts();
        if (fields.size() >= 3)
            return fields.get(1);
        return fields.get(0);
    }

    private WebElement getPasswordField() {
        wait.until(d -> getEditTexts().size() >= 2);
        List<WebElement> fields = getEditTexts();
        if (fields.size() >= 3)
            return fields.get(2);
        return fields.get(1);
    }

    public void enterEmail(String email) {
        WebElement field = getEmailField();
        field.click();
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
        field.clear();
        field.sendKeys(email);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
    }

    public void enterPassword(String password) {
        WebElement field = getPasswordField();
        field.click();
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
        field.clear();
        field.sendKeys(password);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
    }

    public void clickLogin() {
        try {
            if (driver.isKeyboardShown()) {
                driver.hideKeyboard();
                Thread.sleep(1500);
            }
        } catch (Exception e) {
        }

        try {
            wait.until(ExpectedConditions.elementToBeClickable(getLoginButtonLocator())).click();
        } catch (Exception e) {
            // Fallback for Flutter
            WebElement btn = driver.findElement(getLoginButtonLocator());
            int x = btn.getLocation().getX() + (btn.getSize().getWidth() / 2);
            int y = btn.getLocation().getY() + (btn.getSize().getHeight() / 2);
            PointerInput finger = new PointerInput(PointerInput.Kind.TOUCH, "finger");
            Sequence tap = new Sequence(finger, 1);
            tap.addAction(finger.createPointerMove(Duration.ZERO, PointerInput.Origin.viewport(), x, y));
            tap.addAction(finger.createPointerDown(PointerInput.MouseButton.LEFT.asArg()));
            tap.addAction(finger.createPointerUp(PointerInput.MouseButton.LEFT.asArg()));
            driver.perform(Collections.singletonList(tap));
        }
        try {
            Thread.sleep(2000);
        } catch (Exception e) {
        }
    }

    public void login(String email, String password) {
        enterEmail(email);
        enterPassword(password);
        clickLogin();
    }
}
