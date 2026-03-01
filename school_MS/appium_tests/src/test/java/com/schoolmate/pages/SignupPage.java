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

public class SignupPage {
    private AndroidDriver driver;
    private WebDriverWait wait;

    public SignupPage(AndroidDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        PageFactory.initElements(driver, this);
    }

    private By getRoleDropdownLocator() {
        return By.xpath(
                "//android.widget.Button[contains(@content-desc, 'STUDENT') or contains(@content-desc, 'TEACHER') or contains(@content-desc, 'ADMIN') or contains(@content-desc, 'student') or contains(@content-desc, 'teacher') or contains(@content-desc, 'admin')]");
    }

    @FindBy(xpath = "//android.widget.Button[@content-desc='Sign Up' or @text='Sign Up' or @content-desc='SIGN UP' or @text='SIGN UP']")
    private WebElement signupButton;

    @FindBy(xpath = "//android.widget.Button[@content-desc='Already have an account? Login' or contains(@text, 'Login')]")
    private WebElement loginLink;

    public void selectRole(String role) {
        // Find and click dropdown dynamically to avoid stale elements
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

    public void enterName(String name) {
        wait.until(d -> getEditTexts().size() >= 3);
        WebElement field = getEditTexts().get(0);
        field.click();
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
        field.clear();
        field.sendKeys(name);
        try {
            Thread.sleep(500);
        } catch (Exception e) {
        }
    }

    public void enterEmail(String email) {
        wait.until(d -> getEditTexts().size() >= 3);
        WebElement field = getEditTexts().get(1);
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
        wait.until(d -> getEditTexts().size() >= 3);
        WebElement field = getEditTexts().get(2);
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

    public void clickSignup() {
        try {
            if (driver.isKeyboardShown()) {
                driver.hideKeyboard();
                Thread.sleep(1500);
            }
        } catch (Exception e) {
        }

        // Use By locator for signup button too for more reliability
        By signupBtnLocator = By.xpath(
                "//android.widget.Button[@content-desc='Sign Up' or @text='Sign Up' or @content-desc='SIGN UP' or @text='SIGN UP']");
        wait.until(ExpectedConditions.elementToBeClickable(signupBtnLocator)).click();

        try {
            Thread.sleep(2000);
        } catch (Exception e) {
        }
    }

    public void goToLogin() {
        wait.until(ExpectedConditions.elementToBeClickable(loginLink)).click();
    }
}
