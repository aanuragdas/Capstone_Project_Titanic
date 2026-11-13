
# Titanic Disaster: Data Cleaning & Survival Analysis

**RMS (Royal Mail Ship) Titanic** was a British passenger liner that sank in the North Atlantic Ocean on April 15, 1912, after striking an iceberg during her maiden voyage from Southampton, England, to New York City. The disaster remains one of the deadliest peacetime commercial maritime sinkings in history.

The name Titanic derives from the Titans of Greek mythology, symbolizing immense size and strength. But the vessel was referred to with the traditional female pronouns "she" and "her"—a nod to centuries-old naval customs and the deep bond sailors forged with their vessels. On board were an estimated 2,224 passengers and crew, carrying some of the wealthiest individuals alongside hundreds of emigrants seeking a new life abroad.

Titanic was equipped with advanced safety features, including watertight compartments and remotely activated watertight doors, earning it the reputation of being "unsinkable." However, the ship carried only 20 lifeboats—four of which were collapsible—with a combined capacity of just 1,178 people, roughly half the souls on board. Compounding the tragedy, many lifeboats were launched only half-full during the evacuation.

## Introduction

The goal of this project is to apply the skills acquired during the Google Data Analytics Professional Certificate program to the [Kaggle Titanic dataset](https://www.kaggle.com/datasets/yasserh/titanic-dataset) (one of the most renowned benchmarks in data science) and deliver an analytical report addressing key survival questions. Based on historical passenger records, this project analyzes the standard training split of 891 records, curated specifically for exploratory data analysis and predictive modelling.

>Note:
>**Only interested in the analysis and its outcomes?**
>A complete, deep-dive detailed report and visual interpretations is documented.
> 📄 **[Read the full report](https://app.notion.com/p/The-Titanic-An-Analysis-of-Passenger-Survival-40b3b2a379dd80448befe54134bc343d?source=copy_link)**

## Understanding the Data

The primary objective of this phase is to evaluate the schema, available fields, and underlying data types within the dataset. Preliminary data preparation and structural transformations were applied to the raw records. Using **Excel Power Query**, raw demographic and passenger data were cleaned, standardized, and enriched to prepare the dataset for downstream relational database modeling and SQL-driven exploratory analysis.

---

### 1. Data Cleaning & Transformation Steps

#### Step 1: Standardize Column Naming Convention
To establish consistent naming conventions across SQL databases, all column headers were converted from TitleCase/PascalCase to `snake_case`:
- `PassengerId` $\rightarrow$ `p_id`
- `Survived` $\rightarrow$ `is_survived`
- `Pclass` $\rightarrow$ `p_class`
- `SibSp` $\rightarrow$ `sib_sp`
- `Parch` $\rightarrow$ `par_ch`
- `Name`, `Sex`, `Age`, `Ticket`, `Fare`, `Cabin`, `Embarked` were converted to lowercase: `name`, `sex`, `age`, `ticket`, `fare`, `cabin`, `embarked`.

---

#### Step 2: Extracted `surname` and `title`
The original `name` column follows a standard format: `Surname, Title. Firstname Middlename`. 
Using **Column From Examples** and conditional transformations in **Excel Power Query**:
1. Extracted `surname` (all characters preceding the comma).
2. Extracted `title` (the salutation preceding the period).
3. The dataset initially contained 18 unique titles. To reduce cardinality and standardize categories, titles were grouped into 5 categories:
   - **Mr:** Standard male title.
   - **Miss:** Combined `Miss`, `Mlle`, and `Ms`.
   - **Mrs:** Combined `Mrs` and `Mme`.
   - **Master:** Young boys / male children.
   - **Rare:** Combined infrequent noble, professional, and military titles (`Dr`, `Rev`, `Col`, `Major`, `Capt`, `Sir`, `Lady`, `Don`, `Jonkheer`, `the Countess`).

---

#### Step 3: New Column Created  `family_size`
Created a calculated column `family_size` by summing sibling/spouse count and parent/child count, plus the passenger themselves:

            family_size = sib_sp + par_ch +1

*(Note: A `family_size` of 1 indicates the passenger was traveling alone.)*

---

#### Step 4: Missing Value Imputation (`embarked`)
- The `embarked` column had 2 missing (NULL) values.
- These were imputed using the dataset's mode (most frequent port): `'S'` (Southampton).

---

#### Step 5: Handling Remaining Missing Values
- **`age` (177 NULLs):** Preserved as NULL in Excel; left for statistical/SQL-based imputation in subsequent analysis stages.
- **`cabin` (687 NULLs):** Retained as NULL due to high sparsity (~77% missing).

---

### 2. Data Dictionary / Metadata

| Column Name | Data Type | Description | Values / Range / Details |
| :--- | :--- | :--- | :--- |
| `p_id` | INT | Unique passenger identifier | Integer: `1` to `891` |
| `is_survived` | BOOLEAN | Survival indicator | `0` = Did not survive, `1` = Survived |
| `p_class` | INT | Ticket class | `1` = 1st Class, `2` = 2nd Class, `3` = 3rd Class |
| `name` | TEXT | Full passenger name | Original raw format: *Surname, Title. Names* |
| `surname` | TEXT | Extracted family name | Extracted from `name` |
| `title` | TEXT | Extracted & standardized passenger title | Categorical: `Mr`, `Miss`, `Mrs`, `Master`, `Rare` |
| `sex` | TEXT | Biological gender | Categorical: `male`, `female` |
| `age` | NUMERIC(4, 1) | Passenger age in years | Fractional if under 1; 177 NULL values |
| `sib_sp` | INT | Number of siblings/spouses aboard | Integer: `0` to `8` |
| `par_ch` | INT | Number of parents/children aboard | Integer: `0` to `6` |
| `family_size` | INT | Total traveling party size including passenger | Integer: `sib_sp + par_ch + 1` (Min: 1, Max: 11) |
| `ticket` | TEXT | Ticket reference number | Alphanumeric (shared tickets exist for groups/families) |
| `fare` | NUMERIC(8, 2) | Passenger fare paid | Monetary value; `0.00` indicates complimentary tickets |
| `cabin` | TEXT | Cabin room number | Alphanumeric; 687 NULL values |
| `embarked` | TEXT | Port of embarkation | `S` = Southampton, `C` = Cherbourg, `Q` = Queenstown |

## The Analysis

After analyzing the Titanic dataset, I used **SQL** to investigate several key questions regarding passenger survival patterns.

### [Question 1](project_sql/question_1.sql)- What is the total passenger count and the percentage of men vs. women?

The dataset contains a total of **891** passenger records, comprising **577 males (64.8%)** and **314 females (35.2%)**.

### [Question 2](project_sql/question_2.sql)- What is the percentage of passengers by embarkation port and ticket class?

- Southampton had the highest passenger volume, with over half (54.6%) traveling in third class.
- Cherbourg saw the highest proportion of luxury travel, with 50.6% of its passengers in first class.
- Queenstown had the lowest overall volume, with the vast majority (93.5%) traveling in third class.

<img src="images\Que2-Ans.png" width="600">

### [Question 3](project_sql/question_3.sql)- What is the statistical spread of individual passenger ticket prices?

- Minimum: 0.00
- 25th Percentile (Q1): 7.77
- Median: 8.85
- 75th Percentile (Q3): 24.29
- Maximum: 221.78

A total of 15 passengers traveled with a ticket price of 0.00, likely holding complimentary tickets or crew passes.

### [Question 4](project_sql/question_4.sql)- How does the median passenger age vary across ticket class and gender?

The median age of both male and female passengers was highest in first class and lowest in third class, with second-class passengers falling in between.

<img src="images\Que4-Ans.png" width="600">

### [Question 5](project_sql/question_5.sql)- How many passengers survived, and what percentage were male and female?

<img src="images\Que5-Viz.png" width="600">

### [Question 6](project_sql/question_6.sql)- What is the survival rate by ticket class?

<img src="images\Que6-Viz.png" width="600">

### [Question 7](project_sql/question_7.sql)- What is the survival rate by class and gender?

Female passengers traveling in first and second class had the highest survival rates at 96.8% and 92.1% respectively, but this rate dropped sharply to 50.0% for female passengers in third class. Among male passengers, first-class travelers had a 36.9% survival rate, which fell steeply in second class (15.7%) and third class (13.5%).

<img src="images\Que7-Viz.png" width="600">

### [Question 8](project_sql/question_8.sql)- What was the survival rate by port of embarkation?

<img src="images\Que8-Viz.png" width="600">

### [Question 9](project_sql/question_9.sql)- What was the survival rate across different age groups?

- **Toddlers:** They had the highest rate at 65.9%, well ahead of every other group.
- **Children, Teens and Mid-Aged:** These groups were in the middle, between 40.8% and 47.7%.
- **Young Adults:** At 34.7%, they had the second-lowest rate, even though they were by far the largest group (528 passengers).
- **Seniors:** At 30.0%, they had the lowest rate.

Some age groups have few passengers: Toddlers (44), Children (29), Teens (44), and Seniors (40). For these groups, a change of just one or two passengers would shift the survival rate noticeably. Because of this, differences between the smaller groups, such as Children (44.8%) and Teens (47.7%), should be read with caution. The broader pattern is more reliable: Toddlers had the highest survival rate (65.9%), and Seniors had the lowest (30.0%).

<img src="images\Que9-Viz.png" width="600">

### [Question 10](project_sql/question_10.sql)- What was the survival rate across different family sizes?

<img src="images\Que10-Viz.png" width="600">

### [Question 11](project_sql/question_11.sql)- What percentage of passengers survived in each fare bracket?

Passengers were split into four equal-sized groups (quartiles) by the fare they paid, from Q1 (lowest fares) to Q4 (highest fares). Survival was lowest in the two cheapest groups (about 25%) and highest in the top group (64.4%).

<img src="images\Que11-Viz.png" width="600">

## Conclusion

- **Overall:** Only about 4 in 10 passengers survived (342 of 891), and roughly two-thirds of the survivors were women.
- **Ticket class:** Survival dropped steadily from 1st to 3rd class. A 1st-class passenger was more than twice as likely to survive as a 3rd-class passenger.
- **Gender and class together:** Almost all women in 1st and 2nd class survived, but only half of the women in 3rd class did. Men showed the same pattern: about 1 in 3 first-class men survived, compared with about 1 in 7 third-class men. Third-class men were also the largest group on board.
- **Port and family size:** Passengers who boarded at Cherbourg had the highest survival rate, likely because a larger share of them were in 1st class. Medium-sized families survived at a higher rate than solo travelers and large families, and large families had the lowest rate.
- **Age and fare:** Toddlers had the highest survival rate and seniors the lowest. Survival also rose with the fare paid, and the highest-fare group survived at the highest rate.

## Tools I Used

For my deep dive into the Titanic dataset, I used the following tools:

- **Excel:** Used to prepare the data for analysis by cleaning it and handling NULL values.
- **SQL:** The backbone of my analysis, used to query the database and uncover key insights.
- **PostgreSQL:** The database management system I chose, well suited to aggregate and statistical functions.
- **Visual Studio Code:** My editor for writing and running SQL queries.
- **Git & GitHub:** Used for version control and for sharing my SQL scripts and analysis, which supports collaboration and project tracking.
- **AI:** My assistant throughout the project. It helped me whenever I got stuck, and it created the charts and helped with the written explanations.

## What I Learned

Throughout this project, I strengthened my SQL and analytical skills:

- **Complex Query Writing:** Learned to write more advanced SQL queries.
- **Data Aggregation:** Became comfortable with `GROUP BY` and used aggregate functions like `COUNT()` and `AVG()` to summarize data.
- **Statistical Analysis:** Calculated survival rates and percentages across groups and compared them with the overall rate.
- **Analytical Thinking:** Improved my problem-solving skills by turning real-world questions into insightful SQL queries.
- **Working with AI:** Improved my prompt writing through iteration, which helped me get the results I wanted.
