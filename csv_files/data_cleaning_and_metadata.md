# Data Cleaning & Metadata Documentation: Titanic Dataset

This document outlines the preliminary data preparations and structural transformations applied to the Kaggle Titanic dataset. Using **Excel Power Query**, raw demographic and ticketing records were cleaned, standardized, and enriched to prepare the dataset for downstream relational database modeling and SQL-driven exploratory analysis.

---

## 1. Data Cleaning & Transformation Steps

### Step 1: Standardize Column Naming Convention
To establish consistent naming conventions across SQL databases, all column headers were converted from TitleCase/PascalCase to `snake_case`:
- `PassengerId` $\rightarrow$ `p_id`
- `Survived` $\rightarrow$ `is_survived`
- `Pclass` $\rightarrow$ `p_class`
- `SibSp` $\rightarrow$ `sib_sp`
- `Parch` $\rightarrow$ `par_ch`
- `Name`, `Sex`, `Age`, `Ticket`, `Fare`, `Cabin`, `Embarked` were converted to lowercase: `name`, `sex`, `age`, `ticket`, `fare`, `cabin`, `embarked`.

---

### Step 2: Extracted `surname` and `title`
The original `name` column follows a standard format: `Surname, Title. Firstname Middlename`. 
Using **Column From Examples** and conditional transformations in Power Query:
1. Extracted `surname` (all characters preceding the comma).
2. Extracted `title` (the salutation preceding the period).
3. The dataset initially contained 18 unique titles. To reduce cardinality and standardize categories, titles were grouped into 5 categories:
   - **Mr:** Standard male title.
   - **Miss:** Combined `Miss`, `Mlle`, and `Ms`.
   - **Mrs:** Combined `Mrs` and `Mme`.
   - **Master:** Young boys / male children.
   - **Rare:** Combined infrequent noble, professional, and military titles (`Dr`, `Rev`, `Col`, `Major`, `Capt`, `Sir`, `Lady`, `Don`, `Jonkheer`, `the Countess`).

---

### Step 3: New Column Created  `family_size`
Created a calculated column `family_size` by summing sibling/spouse count and parent/child count, plus the passenger themselves:
$$\text{family\_size} = \text{sib\_sp} + \text{par\_ch} + 1$$
*(Note: A `family_size` of 1 indicates the passenger was traveling alone.)*

---

### Step 4: Missing Value Imputation (`embarked`)
- The `embarked` column had 2 missing (NULL) values.
- These were imputed using the dataset's mode (most frequent port): `'S'` (Southampton).

---

### Step 5: Handling Remaining Missing Values
- **`age` (177 NULLs):** Preserved as NULL in Excel; left for statistical/SQL-based imputation in subsequent analysis stages.
- **`cabin` (687 NULLs):** Retained as NULL due to high sparsity (~77% missing).

---

## 2. Data Dictionary / Metadata

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