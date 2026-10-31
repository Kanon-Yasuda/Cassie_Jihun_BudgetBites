**BudgetBites by Cassie Nguyen and Jihun Kim**

**About Our Project**

BudgetBites is an app where users can add, view, edit, and delete meals they want to keep track of. Our app also allows users to see their spending history and keep track of their monthly budget. We also have a Smart Helper that gives suggestions based on how much money the user has spent and recommends food based on saved meals.

**Features**

Our app allows users to add, edit, and delete meals. Users can also view their meal history, track spending, and change their monthly budget. The Smart Helper gives spending warnings and food suggestions based on previous purchases.

**How to Run the App**

First, make sure Flutter and Android Studio are installed on your computer. Download the project from GitHub and open the folder in Visual Studio Code. Open the terminal and enter the following commands:

```bash
flutter pub get
flutter run
```

Make sure an Android emulator is running before using `flutter run`. Once the app starts, you can begin adding meals and tracking your spending.

**Database**

Our app uses SQLite to store meals and purchases. We first used temporary data to test our screens before connecting the real database. After connecting SQLite, we tested adding, editing, and deleting meals to make sure everything worked correctly. The meals stay saved even after closing and reopening the app.

**Testing**

We tested our app on Windows and an Android emulator. We checked the different screens, meal functions, and spending calculations. We also tested SQLite to make sure the meals were saved correctly. The Android emulator allowed us to run and test the database successfully.

**Smart Helper**

Our Smart Helper uses rules to give suggestions based on the user's spending. It checks whether the user has spent half or all of their monthly budget. It can also look at saved meals and purchases to suggest affordable food options. One limitation is that it uses previous purchase prices, which may not always match current prices.

**What We Learned**

During this project, we learned how to connect Flutter to SQLite and save information locally. We also learned how to separate our screens, models, and database functions into different files. We had trouble getting SQLite to work on Windows, but we were able to test it using an Android emulator.