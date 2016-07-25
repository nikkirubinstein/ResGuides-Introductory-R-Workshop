


# Exploring data frames 

<!--sec data-title="Learning Objectives" data-id="obj" data-show=true data-collapse=false ces-->

- To learn how to manipulate a data.frame in memory
- To tour some best practices of exploring and understanding a data.frame when it is first loaded.

<!--endsec-->

<br>

---

**Table of Contents**

<!-- toc -->

<br>

--- 


At this point, you've see it all - in the last lesson, we toured all the basic data types and data structures in R. Everything you do will be a manipulation of those tools. But a whole lot of the time, the star of the show is going to be the data.frame - that table that we started with that information from a CSV gets dumped into when we load it. In this lesson, we'll learn a few more things about working with data.frame.

We learned last time that the columns in a data.frame were vectors, so that our data are consistent in type throughout the column. As such, if we want to add a new column, we need to start by making a new vector:




~~~sourcecode
newCol <- c(2,3,5,12)
cats
~~~



~~~output
    coat weight likes_string
1 calico    2.1         TRUE
2  black    5.0        FALSE
3  tabby    3.2         TRUE

~~~

We can then add this as a column via:


~~~sourcecode
cats <- cbind(cats,  newCol)
~~~



~~~err
Error in data.frame(..., check.names = FALSE): arguments imply differing number of rows: 3, 4

~~~




Why didn't this work? Of course, R wants to see one element in our new column for every row in the table:


~~~sourcecode
cats
~~~



~~~output
    coat weight likes_string
1 calico    2.1         TRUE
2  black    5.0        FALSE
3  tabby    3.2         TRUE

~~~



~~~sourcecode
newCol <- c(4,5,8)
cats <- cbind(cats, newCol)
cats
~~~



~~~output
    coat weight likes_string newCol
1 calico    2.1         TRUE      4
2  black    5.0        FALSE      5
3  tabby    3.2         TRUE      8

~~~

Our new column has appeared, but it's got that ugly name at the top; let's give it something a little easier to understand:


~~~sourcecode
names(cats)[4] <- 'age'
~~~

Now how about adding rows - in this case, we saw last time that the rows of a data.frame are made of lists:


~~~sourcecode
newRow <- list("tortoiseshell", 3.3, TRUE, 9)
cats <- rbind(cats, newRow)
~~~



~~~err
Warning in `[<-.factor`(`*tmp*`, ri, value = "tortoiseshell"): invalid
factor level, NA generated

~~~

Another thing to look out for has emerged - when R creates a factor, it only allows whatever is originally there when our data was first loaded, which was 'black', 'calico' and 'tabby' in our case. Anything new that doesn't fit into one of its categories is rejected as nonsense, until we explicitly add that as a *level* in the factor:


~~~sourcecode
levels(cats$coat)
~~~



~~~output
[1] "black"  "calico" "tabby" 

~~~



~~~sourcecode
levels(cats$coat) <- c(levels(cats$coat), 'tortoiseshell')
cats <- rbind(cats, list("tortoiseshell", 3.3, TRUE, 9))
~~~

Alternatively, we can change a factor column to a character vector; we lose the handy categories of the factor, but can subsequently add any word we want to the column without babysitting the factor levels:


~~~sourcecode
str(cats)
~~~



~~~output
'data.frame':	5 obs. of  4 variables:
 $ coat        : Factor w/ 4 levels "black","calico",..: 2 1 3 NA 4
 $ weight      : num  2.1 5 3.2 3.3 3.3
 $ likes_string: logi  TRUE FALSE TRUE TRUE TRUE
 $ age         : num  4 5 8 9 9

~~~



~~~sourcecode
cats$coat <- as.character(cats$coat)
str(cats)
~~~



~~~output
'data.frame':	5 obs. of  4 variables:
 $ coat        : chr  "calico" "black" "tabby" NA ...
 $ weight      : num  2.1 5 3.2 3.3 3.3
 $ likes_string: logi  TRUE FALSE TRUE TRUE TRUE
 $ age         : num  4 5 8 9 9

~~~

We now know how to add rows and columns to our data.frame in R - but in our work we've accidentally added a garbage row. We can ask for a data.frame minus this offender:


~~~sourcecode
cats[-4,]
~~~



~~~output
           coat weight likes_string age
1        calico    2.1         TRUE   4
2         black    5.0        FALSE   5
3         tabby    3.2         TRUE   8
5 tortoiseshell    3.3         TRUE   9

~~~

Notice the comma with nothing after it to indicate we want to drop the entire fourth row. 
Alternatively, we can drop all rows with `NA` values:


~~~sourcecode
na.omit(cats)
~~~



~~~output
           coat weight likes_string age
1        calico    2.1         TRUE   4
2         black    5.0        FALSE   5
3         tabby    3.2         TRUE   8
5 tortoiseshell    3.3         TRUE   9

~~~

In either case, we need to reassign our variable to persist the changes:


~~~sourcecode
cats <- na.omit(cats)
~~~

<!--sec data-title="Discussion 1" data-id="disc1" data-show=true data-collapse=false ces-->

What do you think
```
> cats$weight[4]
```
will print at this point?

<!--endsec-->

The key to remember when adding data to a data.frame is that *columns are vectors or factors, and rows are lists.*
We can also glue two dataframes together with `rbind`:


~~~sourcecode
cats <- rbind(cats, cats)
cats
~~~



~~~output
            coat weight likes_string age
1         calico    2.1         TRUE   4
2          black    5.0        FALSE   5
3          tabby    3.2         TRUE   8
5  tortoiseshell    3.3         TRUE   9
11        calico    2.1         TRUE   4
21         black    5.0        FALSE   5
31         tabby    3.2         TRUE   8
51 tortoiseshell    3.3         TRUE   9

~~~
But now the row names are unnecessarily complicated. We can ask R to re-name everything sequentially:


~~~sourcecode
rownames(cats) <- NULL
cats
~~~



~~~output
           coat weight likes_string age
1        calico    2.1         TRUE   4
2         black    5.0        FALSE   5
3         tabby    3.2         TRUE   8
4 tortoiseshell    3.3         TRUE   9
5        calico    2.1         TRUE   4
6         black    5.0        FALSE   5
7         tabby    3.2         TRUE   8
8 tortoiseshell    3.3         TRUE   9

~~~

<!--sec data-title="Challenge 1" data-id="ch1" data-show=true data-collapse=false ces-->

You can create a new data.frame right from within R with the following syntax:

~~~sourcecode
df <- data.frame(id = c('a', 'b', 'c'), x = 1:3, y = c(TRUE, TRUE, FALSE), stringsAsFactors = FALSE)
~~~
Make a data.frame that holds the following information for yourself:

- first name
- last name
- lucky number

Then use `rbind` to add an entry for the people sitting beside you.  Finally, use `cbind` to add a column with each person's answer to the question, "Is it time for coffee break?"

<!--endsec-->

So far, you've seen the basics of manipulating data.frames with our cat data; now, let's use those skills to digest a more realistic dataset. Lets read in some real data now. For the remainder of the workshop we will play with some data which contains details of the passengers aboard the Titanic when it sunk, which was sourced from the data science competition website Kaggle:

https://www.kaggle.com/c/titanic

The data is stored in a CSV on the GitHub repository used for these training materials, and R can read the file directly from there:


~~~sourcecode
titanic <- read.csv("https://goo.gl/4Gqsnz")
~~~


<!--sec data-title="Miscellaneous Tips" data-id="tip1" data-show=true data-collapse=true ces-->

1. Another type of file you might encounter is tab-separated format. To specify a tab as a separator, use `"\t"`.

2. You can also read in files from the Internet using a web address, or from a local file using the local directory.

3. You can read directly from excel spreadsheets without converting them to plain text first by using the `xlsx` package.

<!--endsec-->

Let's investigate titanic data a bit; the first thing we should always do is check out what the data looks like with `str`:


~~~sourcecode
str(titanic)
~~~



~~~output
'data.frame':	891 obs. of  12 variables:
 $ PassengerId: int  1 2 3 4 5 6 7 8 9 10 ...
 $ Survived   : int  0 1 1 1 0 0 0 0 1 1 ...
 $ Pclass     : int  3 1 3 1 3 3 1 3 3 2 ...
 $ Name       : Factor w/ 891 levels "Abbing, Mr. Anthony",..: 109 191 354 273 16 555 516 625 413 577 ...
 $ Sex        : Factor w/ 2 levels "female","male": 2 1 1 1 2 2 2 2 1 1 ...
 $ Age        : num  22 38 26 35 35 NA 54 2 27 14 ...
 $ SibSp      : int  1 1 0 1 0 0 0 3 0 1 ...
 $ Parch      : int  0 0 0 0 0 0 0 1 2 0 ...
 $ Ticket     : Factor w/ 681 levels "110152","110413",..: 524 597 670 50 473 276 86 396 345 133 ...
 $ Fare       : num  7.25 71.28 7.92 53.1 8.05 ...
 $ Cabin      : Factor w/ 148 levels "","A10","A14",..: 1 83 1 57 1 1 131 1 1 1 ...
 $ Embarked   : Factor w/ 4 levels "","C","Q","S": 4 2 4 4 4 3 4 4 4 2 ...

~~~

We can also examine individual columns of the data.frame with our `typeof` function:


~~~sourcecode
typeof(titanic$PassengerId)
~~~



~~~output
[1] "integer"

~~~



~~~sourcecode
typeof(titanic$Name)
~~~



~~~output
[1] "integer"

~~~



~~~sourcecode
typeof(titanic$Age)
~~~



~~~output
[1] "double"

~~~



~~~sourcecode
str(titanic$Pclass)
~~~



~~~output
 int [1:891] 3 1 3 1 3 3 1 3 3 2 ...

~~~

We can also interrogate the data.frame for information about its dimensions; remembering that `str(titanic)` said there were 418 observations of 11 variables in the titanic data, what do you think the following will produce, and why?


~~~sourcecode
length(titanic)
~~~



~~~output
[1] 12

~~~

A fair guess would have been to say that the length of a data.frame would be the number of rows it has (418), but this is not the case; remember, a data.frame is a *list of vectors and factors*:


~~~sourcecode
typeof(titanic)
~~~



~~~output
[1] "list"

~~~

When `length` gave us 11, it's because the titanic data is built out of a list of 11 columns. To get the number of rows and columns in our dataset, try:


~~~sourcecode
nrow(titanic)
~~~



~~~output
[1] 891

~~~



~~~sourcecode
ncol(titanic)
~~~



~~~output
[1] 12

~~~

Or, both at once:


~~~sourcecode
dim(titanic)
~~~



~~~output
[1] 891  12

~~~

We'll also likely want to know what the titles of all the columns are, so we can ask for them later:

~~~sourcecode
colnames(titanic)
~~~



~~~output
 [1] "PassengerId" "Survived"    "Pclass"      "Name"        "Sex"        
 [6] "Age"         "SibSp"       "Parch"       "Ticket"      "Fare"       
[11] "Cabin"       "Embarked"   

~~~

At this stage, it's important to ask ourselves if the structure R is reporting matches our intuition or expectations; do the basic data types reported for each column make sense? If not, we need to sort any problems out now before they turn into bad surprises down the road, using what we've learned about how R interprets data, and the importance of *strict consistency* in how we record our data.

Once we're happy that the data types and structures seem reasonable, it's time to start digging into our data proper. Check out the first few lines:


~~~sourcecode
head(titanic)
~~~



~~~output
  PassengerId Survived Pclass
1           1        0      3
2           2        1      1
3           3        1      3
4           4        1      1
5           5        0      3
6           6        0      3
                                                 Name    Sex Age SibSp
1                             Braund, Mr. Owen Harris   male  22     1
2 Cumings, Mrs. John Bradley (Florence Briggs Thayer) female  38     1
3                              Heikkinen, Miss. Laina female  26     0
4        Futrelle, Mrs. Jacques Heath (Lily May Peel) female  35     1
5                            Allen, Mr. William Henry   male  35     0
6                                    Moran, Mr. James   male  NA     0
  Parch           Ticket    Fare Cabin Embarked
1     0        A/5 21171  7.2500              S
2     0         PC 17599 71.2833   C85        C
3     0 STON/O2. 3101282  7.9250              S
4     0           113803 53.1000  C123        S
5     0           373450  8.0500              S
6     0           330877  8.4583              Q

~~~

To make sure our analysis is reproducible, we should put the code
into a script file so we can come back to it later.

<!--sec data-title="Challenge 2" data-id="ch2" data-show=true data-collapse=false ces-->

Go to file -> new file -> R script, and write an R script to load in the titanic dataset. Put it in the `scripts/` directory.

Run the script using the `source` function, using the file path as its argument (or by pressing the "source" button in RStudio).

<!--endsec-->

<!--sec data-title="Challenge 3" data-id="ch3" data-show=true data-collapse=false ces-->

Read the output of `str(titanic)` again;  this time, use what you've learned about factors, lists and vectors, as well as the output of functions like `colnames` and `dim` to explain what everything that `str` prints out for titanic means. If there are any parts you can't interpret, discuss with your neighbors!

<!--endsec-->

## Challenge solutions

<!--sec data-title="Solution to Discussion 1" data-id="disc1sol" data-show=true data-collapse=true ces-->

Note the difference between row indices, and default row names; even though there's no more row named '4', cats[4,] is still well-defined (and pointing at the row named '5').

<!--endsec-->

<!--sec data-title="Solution to Challenge 1" data-id="ch1sol" data-show=true data-collapse=true ces-->


~~~sourcecode
df <- data.frame(first = c('Grace'), last = c('Hopper'), lucky_number = c(0), stringsAsFactors = FALSE)
df <- rbind(df, list('Marie', 'Curie', 238) )
df <- cbind(df, c(TRUE,TRUE))
names(df)[4] <- 'coffeetime'
~~~

<!--endsec-->

<!--sec data-title="Solution to Challenge 2" data-id="ch2sol" data-show=true data-collapse=true ces-->

The contents of `script/load-titanic.R`:

~~~sourcecode
titanic <- read.csv("https://goo.gl/4Gqsnz")
~~~
To run the script and load the data into the `titanic` variable:

~~~sourcecode
source(file = "scripts/load-titanic.R")
~~~

<!--endsec-->
