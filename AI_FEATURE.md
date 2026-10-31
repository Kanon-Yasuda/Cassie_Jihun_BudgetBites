# AI Feature – Smart Helper

**Overview**

Our Budget Bites app has a Smart Helper that gives users suggestions based on their budget and spending. It can also recommend food using meals and purchases saved in the database.

**Rationale and Alternative**

We used a rule-based system because it is simple and does not need a lot of data. Another option was machine learning, but that would require training data. We decided to use rules because they are easier to make and test.

**Baseline**

Our baseline only checks if the user has reached their budget limit. Our Smart Helper also warns users when they reach half of their budget. This helps users know when they should slow down their spending.

**Cases and Metrics**

We use five cases with a $200 budget to check if the Smart Helper gives the correct message.

| Total Spent | Expected Result |
|---|---|
| $30 | Below halfway |
| $100 | Halfway warning |
| $180 | Spending warning |
| $200 | Budget limit warning |
| $220 | Budget limit warning |

We compare the actual message with the expected result to check if the helper works correctly.

**Counterexample**

One problem is that the Smart Helper uses old purchase prices. For example, a meal that cost $8 before might now cost $12. This means the food suggestion might not always be accurate.

**Revision and Limitation**

We changed the code so it checks if the user has reached their budget limit before checking the halfway point. This fixes the problem where users who went over their budget would only get a halfway warning. The food suggestions still use saved prices, which is one limitation.

**User Control**

The Smart Helper only gives suggestions and does not make changes to the user's meals. Users can choose whether to follow the suggestions or ignore them. We do not have a separate override button.

**Offline Proof**

Our Smart Helper uses rules and information saved in SQLite. It does not need an internet connection or an online AI service to give suggestions. The saved information can still be used while offline.