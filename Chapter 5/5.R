# EXPLORATORY DATA ANALYSIS



#INTRODUCTION

#here we are going to use visualisation and transofrmation to explore our data in a systematic way, a task that statisticians call EDA

#Few steps to follow:

#1. Generate questions about your data
#2. Search for answers by visualising, transofrimng, and modeling your data
#3. Use what you learn to refine your questions and/or generate new questions

#EDA is not a process with a strict set of rules, is more a state of mind.
#when starting EDA, you should feel free to investigate every idea that occurs to you
#data cleaning is just one applications of EDA, to do data cleaning you'll need to deploy all the tools of EDA: visualisation, transformation and modeling.

#QUESTIONS

# " There are no routine statistical questions, only questionable statistical routines "
#   - Sir David Cox

# " Far better an approximate answer to the right questions, which is often vague, than an exact answer to the wrong question, which can always be made precise. "
#   - John Tukey

# your goal during EDA is to develop an understanding of your data., you can do this using questions as tools to guide your investigation.
#when asking a question, the question focuses your attention on a specific part of your dataset and helps you decide which tools to use

#EDA is fundamentally a creative process, the key to asking 'quality' questions is to generate a large quantity of questions.

#if you start with the right question ( although is hard at the start of your analysis as you don't know any insights about the data )
#on the other hand, each question, will take you to a new aspect of your data and increase your chance of making a discovery, you can quickly drill down into the most intereting parts of your data and develop new interesting questions, dominoes rule I'll say

#there is no rule about which questions you should ask to guide your EDA, but here's an example of two types of questions to help your EDA:
#1. What type of variation occurs within my variables?
#2. What type of covariation occurs between my variables?

#the book will help us define some terms:
# - A 'variable' is a quantity, quality, or property that you can measure.
# - A 'value' is the state of a vairable when you measure it. The value of a variable may change from measurement to measurement.
# - An 'observation', or a 'case', is a set of measurements made under similar conditions ( you usually make all of the measurements in an observation at the same time and on the same object). An observation will contain several values, each assciated with a different variable. I'll sometimes refer to an observation as a data point.
# - Tabular data is a set of values, each assciated with a variable and an observation. Tabular data is tidy if each value is places in its own "cell", each variable in its own column, and each observation in its own row. (in real life most data isn't tidy)
# - Variation is the tendency of values of a variable to change from measurement to measurement. ( you can see variation easily in real life: for exp if you measure any continuous variable twice, you'll get two different results). Categorical variables can aslo vary if you measure across different subjects (the eye colour of different people), or different times (the energy levels of an electron at different moments). Every variable has its own pattern of variation, which can reveal interesting information. The best way to understand that pattern is to visualise the distribution of variables values.


