# Association Rule Analysis

**Tl;dr**: The pipeline for association rule mining can be inspected and adjusted to user needs in `Apriori.ipynb`. The functions involved therein are thoroughly documented for ease of use. The visualisation of mined rules can be done via `Association-Rule-Visualisation.R`, although changes in the notebook may require manual tweaks in the R script.

* [Introduction](https://github.com/AlfaBetaBeta/Association-Rules#introduction)
* [Scope and definitions](https://github.com/AlfaBetaBeta/Association-Rules#scope-and-definitions)
* [Rule mining](https://github.com/AlfaBetaBeta/Association-Rules#rule-mining)
* [Visualisation and rule analysis](https://github.com/AlfaBetaBeta/Association-Rules#visualisation-and-rule-analysis)
* [Conclusions](https://github.com/AlfaBetaBeta/Association-Rules#conclusions)
* [Appendix](https://github.com/AlfaBetaBeta/Association-Rules#appendix)


## Introduction

Within the current educational framework, with proliferation of free online resources and market needs for specialised profiles in ever growing technological fields, this repository presents an example of rule-based analysis on a fictitious online teaching platform. The aim of the analysis is to elucidate correlations (rules) between the courses currently delivered, in order to tailor the offers and packages to prospective trainees over the upcoming academic year.


## Scope and definitions

The present study constitutes, in essence, an association rule analysis (ARA) performed on a synthetic sample of 'historical' data (`Training_courses_2019.xlsx`). This sample dataset comprises 349 entries (tickets) in tabular format, describing enrolment by ticket on each of the 18 courses currently offered in as many columns via a binary indicator (`0` = not enrolled, `1` = enrolled).

The notation followed for any rule throughout the study is {**A**} => {**C**}, whereby **A** and **C** stand for *antecedent* and *consequent*, respectively. A rule is meant to be conceptually understood as *‘if {**A**} then {**C**}’* of probabilistic rather than logical nature. Although in general **A** and **C** may constitute itemsets (sets of courses) of arbitrary size within the boundaries of the available items, it is decided here to restrict the ARA to single consequents and limit the size of **A** for convenience, i.e. rules of the type *‘if {up to five courses} then {one course}’*.

Within the scope of this study, reference is frequently made to some indicators and metrics quantifying the relevance of a rule. These are concisely summarised here for ease of readability, whereby more thorough definitions and additional nuances can be found in the [Appendix](https://github.com/AlfaBetaBeta/Association-Rules#appendix):

* Support(**X**):number of enrolments on course(s) **X** with respect to the total amount of tickets. When **X**=**A**, **X** might represent an itemset. When **X**=**C**, **X** signifies the support of a single consequent in the present context. This is called *prior* confidence.

* Confidence({**A**} => {**C**}): number of enrolments on courses **A** and **C** with respect to the number of enrolments on course(s) **A**. This is called *posterior* confidence.

* Lift({**A**} => {**C**}): ratio of *posterior* to *prior* confidence.

* Confidence difference({**A**} => {**C**}): subtraction of *prior* from *posterior confidence*, in absolute value.

* Confidence ratio({**A**} => {**C**}): 1 – (ratio of min(*prior*, *posterior*) to max(*prior*, *posterior*)).


## Rule mining

As elaborated in the [Appendix](https://github.com/AlfaBetaBeta/Association-Rules#appendix), the total number of possible itemsets for the given item range (18) is 262,143 (excluding empty sets) and the total number of rules associating all these itemsets is 386,896,202. Handling over 386 million rules is evidently impractical and also unnecessary, as many of these rules are trivial, absurd, inactionable or a combination thereof. In order to mine sensible and practical rules, the implementation of the *apriori* algorithm embedded in `Apriori.ipynb` is used on the synthetic dataset. The functions defined in the notebook are largely based on the [mlxtend](https://github.com/rasbt/mlxtend/tree/master/mlxtend/frequent_patterns) python library, though modified to accommodate the following intended features:

* *Confidence difference* and *confidence ratio* are included amongst the controlling metrics in the relevant metric dictionary, in lieu of *leverage* and *conviction*.

* Additional keyword arguments are included in the function responsible for mining rules, enabling the user to impose restraints in the size of the antecedent and/or consequent set (as is the case here). These additional arguments are clearly related with the argument controlling the maximum itemset size when searching for frequent itemsets, and sanity checks are in place to ensure that these arguments are defined consistently. Further details can be found in the notebook documentation.

* Support and (*posterior*) confidence thresholds are included as arguments to filter rules, alongside the main controlling metric (typically one of lift, confidence ratio or confidence difference).

The optimisation strategies from [mlxtend](https://github.com/rasbt/mlxtend/tree/master/mlxtend/frequent_patterns) (accounting for potentially very large and sparse datasets) are not incorporated here, however, and it remains a prospective update to be developed in due course. 

In this case, the following combinations of controlling metrics and thresholds are used for rule mining:

| &nbsp;&nbsp;&nbsp;Metric&nbsp;&nbsp; | Metric threshold | Min. rule support | Min. support | Min. confidence | CombinationID |
| :----------------------------------: | :--------------: | :---------------: | :----------: | :-------------: | :-----------: |
|    lift                              |       1.0        |         0.        |      0.2     |       0.5       |       c1      |
|    lift                              |       1.0        |         0.        |      0.2     |       0.4       |       c2      |
|    lift                              |       1.0        |         0.        |      0.2     |       0.3       |       c3      |
|    lift                              |       1.0        |         0.        |      0.1     |       0.5       |       c4      |
|    lift                              |       1.0        |         0.        |      0.1     |       0.4       |       c5      |
|    lift                              |       1.0        |         0.        |      0.1     |       0.3       |       c6      |
|    lift                              |       0.5        |         0.        |      0.2     |       0.5       |       c7      |
|    lift                              |       0.5        |         0.        |      0.2     |       0.4       |       c8      |
|    lift                              |       0.5        |         0.        |      0.2     |       0.3       |       c9      |
|    lift                              |       0.5        |         0.        |      0.1     |       0.5       |       c10     |
|    lift                              |       0.5        |         0.        |      0.1     |       0.4       |       c11     |
|    lift                              |       0.5        |         0.        |      0.1     |       0.3       |       c12     |


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

The script `Association-Rule-Visualisation.R` reads in the synthetic dataset as well as the `csv` files stemming from `Apriori.ipynb`, generates a series of plots and stores them locally as per the path settings defined in the script. Same as with the notebook, it is meant to be executed sequentially to facilitate inspection by the user. In its current version, the script may need some manual adjusting should anything change in the notebook (e.g. the metric-threshold combinations) or if resorting to a different dataset for rule mining. Hence, the script requires careful inspection in such cases. Integrating the rule mining and the visualisation parts consistently to allow for a fully automated pipeline remains a desirable prospective development.

As a preliminary step, the figures below show the distribution of courses over the ticket sample and the total count of courses per ticket, respectively. As the bars in the course histogram are normalised by the total number of tickets, they directly represent supports.

<p align="middle">
  <img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/support-distribution.png" width=100% height=100%>
</p>
  <br/>
  <br/>
<p align="middle">
  <img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/courses-per-ticket.png" width=50% height=50%>
</p>

A salient feature of these figures, if the sample is assumed to be representative, is that the vast majority of trainees enrol in 2 or 3 courses, with these mostly being introductory to intermediate level (as inferred by the course name in the absence of syllabus information). There is no distinct clustering scheme in the course histogram, although the main approximate trend is for more specialised courses to have lower support. Minimum and maximum support roughly correspond to 0.04 and 0.4, respectively. Benchmark minimum thresholds of 0.1 and 0.2 for support conveniently split the course set into subsets in proportion 2:1, which is used when setting lift as the controlling metric.

In this regard, the figure below summarises the number of rules arising from various combinations of minimum threshold values for confidence and support, for a minimum lift threshold of 1.0 and 0.5, respectively. From its definition, lift has no interest for values just around 1.0, as this implies independence between the probabilities of occurrence of {**A**} and {**C**}, and hence no rule can sensibly associate them. Lift values notably above or below 1.0 bear greater interest because they are indicative of rules, by {**A**} being either reinforcing or detrimental in the occurrence of {**C**}, respectively.

<p align="middle">
  <img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/rules_vs_thresholds1_metric_lift.png" width=45% height=45%>
  <img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/rules_vs_thresholds2_metric_lift.png" width=45% height=45%>
</p>

The bottom left point in the right figure (minimum support 0.1, minimum confidence 0.3; in short, combination c12) agglomerates 38 rules, which are unfolded below for all antecedents and consequents. A suitable mapping of colour by (*posterior*) confidence and size by lift has been applied to facilitate visual interpretation, and points with a red boundary represent rules with a lift below 1.0.

<img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/lift_c12.png" width=100% height=100%>

The rules with the most favourable combination of confidence and lift (i.e. darker and larger points in the grid) are the following:

* {Building Predictive Models, Intro to CHAID} => {Market Segmentation}
* {Classification and Clustering} => {Building Predictive Models}
* {Market Segmentation} => {Building Predictive Models}
* {Market Segmentation} => {Intro to CHAID}
* {Tables} => {Intermediate Techniques}

Detrimental rules have almost exclusively {Intro to Statistic platform} as consequent, although the one with the largest lift points to {Intermediate Techniques}. This is partially expected since these are the two courses with the largest support and might therefore display the greatest tendency to ‘leak’ into rules. It is somewhat surprising, however, that they are both popular and yet detrimental to each other, given that (by name) they would not necessarily be considered mutually substitutive. This could point to syllabus overlaps that were not anticipated and would need addressing. The antecedent itemsets are mostly made of one course, hence leading to 1:1 rules of significant support, which is characteristic when resorting to lift as metric.

In order to assess rules with lower *prior* confidences and greater antecedent itemset size, it is convenient to change metric. In this case, the confidence ratio is favoured as it is well suited for such cases. The figure below shows a compact summary of the 508 rules found for the minimum thresholds corresponding to combination c6. All rules focus on 12 consequents, each represented by a point of size and brightness proportional to the number of rules linked to it. The coordinates of each point are the average confidence and lift over all rules associating to that consequent. {Market Segmentation} and {Classification and Clustering} clearly gather rules the most (239 combined), averaging an antecedent itemset size of 3 with roughly 0.02 support. Their average confidence is approximately 0.8 and 0.7, respectively, and their average lift is above 5 in both cases. This pair of 'agglomerated' rules are deemed of value, as they are representative of a variety of learning paths that ultimately intersect in a common field of interest (machine learning).

<img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/confidence_ratio_lift_vs_confidence_c6.png" width=100% height=100%>

As anticipated, when resorting to confidence ratio as a metric, a large number of rules applied on low supports is found. For comparison with the figure above, additional visualisations arising from different threshold settings are shown below, illustrating in any case the same general pattern.

<img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/confidence_ratio_lift_vs_confidence_c4.png" width=100% height=100%>
<br/>
<img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/confidence_ratio_lift_vs_confidence_c7.png" width=100% height=100%>
<br/>
<img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/confidence_ratio_lift_vs_confidence_c13.png" width=100% height=100%>
<br/>
<img src="https://github.com/AlfaBetaBeta/Association-Rules/blob/main/plots/confidence_ratio_lift_vs_confidence_c9.png" width=100% height=100%>


## Conclusions

Based on the preliminary results of ARA presented so far, and subject to further analysis stages, the following conclusions and recommendations can be drawn:

* Most trainees progress by taking part in 2 or 3 courses at a time, with introductory to intermediate courses being the most demanded. These courses with high support should be complementary and not substitutive, which calls for careful planning of each syllabus and better course naming.
* Once redefined and differentiated, {Intro to Statistic Platform} and {Intermediate Techniques} could be offered as a joint package, to ensure trainees actually partake in the most popular courses.
* {Tables} seems to lead to {Intermediate Techniques} with reasonable confidence and yet has a much lower support, which means that trainees do not perceive it as a prerequisite. This needs to be addressed, either by rebranding the course or by merging both into a course of wider scope.
* {Market segmentation} and {Classification and Clustering} seem to have the potential of constituting common crossroads in the learning path of many trainees. This intuitively calls for 'path offers' with suggested course sequences, using these two names as attractors, not just for the introductory courses leading to them but also for the ensuing specialisations with less support (e.g. {Neural Networks}).


## Appendix

### Explicit expressions of exponential number of rules and the powerset over all transactions

Given a total number of items *N*, the set of all possible itemsets is the power set over *N*, i.e. the number of itemsets (excluding empty sets) follows the exponential rule:

<img src="https://render.githubusercontent.com/render/math?math=2^{N}-1">

The number of rules over all itemsets in the power set over *N* also follows an exponential rule, as per below:

<img src="https://render.githubusercontent.com/render/math?math=3^{N}-2^{N%2B1}%2B1">

Substitution of <img src="https://render.githubusercontent.com/render/math?math=N=18"> in the expressions above directly yields the results mentioned in the [rule mining](https://github.com/AlfaBetaBeta/Association-Rules#rule-mining) section.

### Detailed definitions and probabilistic interpretation of association parameters

More formally, an association rule is defined as <img src="https://render.githubusercontent.com/render/math?math=\begin{aligned}[b]\{\boldsymbol{A}\} \implies \{\boldsymbol{C}\}\end{aligned}">, where <img src="https://render.githubusercontent.com/render/math?math=(\{\boldsymbol{A}\},\{\boldsymbol{C}\}) \subseteq \{\boldsymbol{I}\}">. That is, <img src="https://render.githubusercontent.com/render/math?math=\{\boldsymbol{A}\}"> and <img src="https://render.githubusercontent.com/render/math?math=\{\boldsymbol{C}\}"> are disjoint itemsets containing part or at most the entire population of items <img src="https://render.githubusercontent.com/render/math?math=\{\boldsymbol{I}\}">.

Items are in general subject to transactions (in the present context items being courses and transactions being enrolments). Based on this, support can be defined as:

<img src="https://render.githubusercontent.com/render/math?math=\text{Support}(\boldsymbol{X})=\frac{\text{transactions}\enspace t/ \boldsymbol{X} \subseteq t}{T}">

where <img src="https://render.githubusercontent.com/render/math?math=\{\boldsymbol{X}\}"> is an arbitrary itemset contained in <img src="https://render.githubusercontent.com/render/math?math=\{\boldsymbol{I}\}"> and *T* is the set of all transactions. Support can hence be interpreted as a marginal probability estimator, i.e. in the present context it estimates the probability that a randomly selected enrolment will contain all courses in <img src="https://render.githubusercontent.com/render/math?math=\{\boldsymbol{X}\}">.

Similarly, confidence can be rewritten as:

<img src="https://render.githubusercontent.com/render/math?math=\text{Confidence}(\{\boldsymbol{A}\} \implies \{\boldsymbol{C}\})=\frac{\text{Support}(\boldsymbol{A}\cup \boldsymbol{C})}{\text{Support}(\boldsymbol{A})}">

