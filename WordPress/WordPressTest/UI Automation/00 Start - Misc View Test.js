var testName = "Misc view test"

UIALogger.logStart(testName);

var target = UIATarget.localTarget();

target.frontMostApp().mainWindow().buttons()[0].tap();
target.delay(1);
target.frontMostApp().mainWindow().buttons()["Terms of Service"].tap();
target.delay(1);
target.captureScreenWithName("Terms_Of_Service_empty");
target.delay(3);
//target.pushTimeout(3) / popTimeout(); pushTimeOut/popTimeout does not work as we wanted.
target.captureScreenWithName("Terms_Of_Service_loaded");
target.frontMostApp().navigationBar().buttons()["navbar actions"].tap();
target.delay(1);
target.captureScreenWithName("Action_Sheet_TOS");
target.delay(1);
target.frontMostApp().actionSheet().cancelButton().tap();

target.delay(2);
target.frontMostApp().toolbar().buttons()["Refresh"].tap();
target.delay(2);

target.frontMostApp().navigationBar().leftButton().tap();

target.delay(1);
target.captureScreenWithName("Misc_Main_View_back_from_TOS");

target.frontMostApp().mainWindow().buttons()["Privacy Policy"].tap();
target.delay(1);
target.captureScreenWithName("Privacy_empty");
target.delay(3);
target.captureScreenWithName("Privacy_loaded");

target.frontMostApp().navigationBar().buttons()["navbar actions"].tap();
target.delay(1);
target.captureScreenWithName("Action_Sheet_Privacy");
target.frontMostApp().actionSheet().cancelButton().tap();
target.delay(1);

target.frontMostApp().toolbar().buttons()["Refresh"].tap();
target.delay(3);
target.frontMostApp().navigationBar().leftButton().tap();
target.delay(1);
target.captureScreenWithName("Misc_Main_View_back_from_Privacy");

target.frontMostApp().navigationBar().rightButton().tap();
target.delay(1);
target.captureScreenWithName("WordPress_Main_View_back_from_misc");

UIALogger.logPass(testName);