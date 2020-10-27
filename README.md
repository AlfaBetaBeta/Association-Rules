# Association Rule Analysis

**Tl;dr**: The pipeline for association rule mining can be inspected and adjusted to user needs in `Apriori.ipynb`. The functions involved therein are thoroughly documented for ease of use. The visualisation of mined rules can be done via `Association-Rule-Visualisation.R`, although changes in the notebook may require manual tweaks in the R script.

(TODO: ToC)


## Introduction

Within the current educational framework, with proliferation of free online resources and market needs for specialised profiles in ever growing technological fields, this repository presents an example of rule-based analysis on a fictitious online teaching platform. The aim of the analysis is to elucidate correlations (rules) between the courses currently delivered, in order to tailor the offers and packages to prospective trainees over the upcoming academic year.


## Scope and definitions

The present study constitutes, in essence, an association rule analysis (ARA) performed on a synthetic sample of 'historical' data. This sample dataset comprises 349 entries (tickets) in tabular format, describing enrolment by ticket on each of the 18 courses currently offered in as many columns via a binary indicator (`0` = not enrolled, `1` = enrolled).

The notation followed for any rule throughout the study is {**A**} => {**C**}, whereby **A** and **C** stand for *antecedent* and *consequent*, respectively. A rule is meant to be conceptually understood as *‘if {**A**} then {**C**}’* of probabilistic rather than logical nature. Although in general **A** and **C** may constitute itemsets (sets of courses) of arbitrary size within the boundaries of the available items, it is decided here to restrict the ARA to single consequents and limit the size of **A** for convenience, i.e. rules of the type *‘if {up to five courses} then {one course}’*.

Within the scope of this study, reference is frequently made to some indicators and metrics quantifying the relevance of a rule. These are concisely summarised here for ease of readability, whereby more thorough definitions and additional nuances can be found in the Appendix:

* Support(**X**):number of enrolments on course(s) **X** with respect to the total amount of tickets. When **X**=**A**, **X** might represent an itemset. When **X**=**C**, **X** signifies the support of a single consequent in the present context. This is called *prior* confidence.

* Confidence({**A**} => {**C**}): number of enrolments on courses **A** and **C** with respect to the number of enrolments on course(s) **A**. This is called *posterior* confidence.

* Lift({**A**} => {**C**}): ratio of *posterior* to *prior* confidence.

* Confidence difference({**A**} => {**C**}): subtraction of *prior* from *posterior confidence*, in absolute value.

* Confidence ratio({**A**} => {**C**}): 1 – (ratio of min(*prior*, *posterior*) to max(*prior*, *posterior*)).


## Rule mining

As elaborated in the Appendix, the total number of possible itemsets for the given item range (18) is 262,143 (excluding empty sets) and the total number of rules associating all these itemsets is 386,896,202. Handling over 386 million rules is evidently impractical and also unnecessary, as many of these rules are trivial, absurd, inactionable or a combination thereof. In order to mine sensible and practical rules, the implementation of the *apriori* algorithm embedded in `Apriori.ipynb` is used on the synthetic dataset. The functions defined in the notebook are largely based on the [mlxtend](https://github.com/rasbt/mlxtend/tree/master/mlxtend/frequent_patterns) python library, though modified to accommodate the following intended features:

* *Confidence difference* and *confidence ratio* are included amongst the controlling metrics in the relevant metric dictionary, in lieu of *leverage* and *conviction*.

* Additional keyword arguments are included in the function responsible for mining rules, enabling the user to impose restraints in the size of the antecedent and/or consequent set (as is the case here). These additional arguments are clearly related with the argument controlling the maximum itemset size when searching for frequent itemsets, and sanity checks are in place to ensure that these arguments are defined consistently. Further details can be found in the notebook documentation.

* Support and (*posterior*) confidence thresholds are included as arguments to filter rules, alongside the main controlling metric (typically one of lift, confidence ratio or confidence difference).

The optimisation strategies from [mlxtend](https://github.com/rasbt/mlxtend/tree/master/mlxtend/frequent_patterns) (accounting for potentially very large and sparse datasets) are not incorporated here, however, and it remains a prospective update to be developed in due course. 

In this case, the following combinations of controlling metrics and thresholds are used for rule mining:

|    Metric.   | Metric threshold | Min. rule support | Min. support | Min. confidence | CombinationID |
| :----------: | :--------------: | :---------------: | :----------: | :-------------: | :-----------: |
|    lift      |       1.0        |         0.        |      0.2     |       0.5       |       c1      |
|    lift      |       1.0        |         0.        |      0.2     |       0.4       |       c2      |
|    lift      |       1.0        |         0.        |      0.2     |       0.3       |       c3      |
|    lift      |       1.0        |         0.        |      0.1     |       0.5       |       c4      |
|    lift      |       1.0        |         0.        |      0.1     |       0.4       |       c5      |
|    lift      |       1.0        |         0.        |      0.1     |       0.3       |       c6      |
|    lift      |       0.5        |         0.        |      0.2     |       0.5       |       c7      |
|    lift      |       0.5        |         0.        |      0.2     |       0.4       |       c8      |
|    lift      |       0.5        |         0.        |      0.2     |       0.3       |       c9      |
|    lift      |       0.5        |         0.        |      0.1     |       0.5       |       c10     |
|    lift      |       0.5        |         0.        |      0.1     |       0.4       |       c11     |
|    lift      |       0.5        |         0.        |      0.1     |       0.3       |       c12     |


|   Metric   | Metric threshold | Min. rule support | Min. support | Min. confidence | CombinationID |
| :--------: | :--------------: | :---------------: | :----------: | :-------------: | :-----------: |
| conf.ratio |       0.5        |       0.01        |       0.     |       0.5       |       c1      |
| conf.ratio |       0.5        |       0.01        |       0.     |       0.4       |       c2      |
| conf.ratio |       0.5        |       0.01        |       0.     |       0.3       |       c3      |
| conf.ratio |       0.7        |       0.01        |       0.     |       0.5       |       c4      |
| conf.ratio |       0.7        |       0.01        |       0.     |       0.4       |       c5      |
| conf.ratio |       0.7        |       0.01        |       0.     |       0.3       |       c6      |
| conf.ratio |       0.8        |       0.01        |       0.     |       0.5       |       c7      |
| conf.ratio |       0.8        |       0.01        |       0.     |       0.4       |       c8      |
| conf.ratio |       0.8        |       0.01        |       0.     |       0.3       |       c9      |
| conf.ratio |       0.9        |       0.01        |       0.     |       0.5       |       c10     |
| conf.ratio |       0.9        |       0.01        |       0.     |       0.4       |       c11     |
| conf.ratio |       0.9        |       0.01        |       0.     |       0.3       |       c12     |
| conf.ratio |       0.7        |       0.02        |       0.     |       0.6       |       c13     |
| conf.ratio |       0.7        |       0.03        |       0.     |       0.6       |       c14     |

The resulting pandas DataFrames with the rules for each combination are stored locally as per the path settings specified in `Apriori.ipynb`, with the naming convention *`metric_combination.csv`* (e.g. the first combination of each metric is stored as `lift_c1.csv` and `confidence_ratio_c1.csv`, respectively). 


## Visualisation and rule analysis

Under construction...







