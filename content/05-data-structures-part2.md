Exploring data frames
=====================

<!--sec data-title="Learning Objectives" data-id="obj" data-show=true data-collapse=false ces-->
-   To learn how to manipulate a data.frame in memory
-   To tour some best practices of exploring and understanding a
    data.frame when it is first loaded.

<!--endsec-->
<br>

------------------------------------------------------------------------

**Table of Contents**

<!-- toc -->
<br>

------------------------------------------------------------------------

At this point, you've see it all - in the last lesson, we toured all the
basic data types and data structures in R. Everything you do will be a
manipulation of those tools. But a whole lot of the time, the star of
the show is going to be the data.frame - that table that we started with
that information from a CSV gets dumped into when we load it. In this
lesson, we'll learn a few more things about working with data.frame.

We learned last time that the columns in a data.frame were vectors, so
that our data are consistent in type throughout the column. As such, if
we want to add a new column, we need to start by making a new vector:

    newCol <- c(2,3,5,12)
    cats

    ##     coat weight likes_string
    ## 1 calico    2.1         TRUE
    ## 2  black    5.0        FALSE
    ## 3  tabby    3.2         TRUE

We can then add this as a column via:

    cats <- cbind(cats,  newCol)

    ## Error in data.frame(..., check.names = FALSE): arguments imply differing number of rows: 3, 4

Why didn't this work? Of course, R wants to see one element in our new
column for every row in the table:

    cats

    ##     coat weight likes_string
    ## 1 calico    2.1         TRUE
    ## 2  black    5.0        FALSE
    ## 3  tabby    3.2         TRUE

    newCol <- c(4,5,8)
    cats <- cbind(cats, newCol)
    cats

    ##     coat weight likes_string newCol
    ## 1 calico    2.1         TRUE      4
    ## 2  black    5.0        FALSE      5
    ## 3  tabby    3.2         TRUE      8

Our new column has appeared, but it's got that ugly name at the top;
let's give it something a little easier to understand:

    names(cats)[4] <- 'age'

Now how about adding rows - in this case, we saw last time that the rows
of a data.frame are made of lists:

    newRow <- list("tortoiseshell", 3.3, TRUE, 9)
    cats <- rbind(cats, newRow)

    ## Warning in `[<-.factor`(`*tmp*`, ri, value = "tortoiseshell"): invalid
    ## factor level, NA generated

Another thing to look out for has emerged - when R creates a factor, it
only allows whatever is originally there when our data was first loaded,
which was 'black', 'calico' and 'tabby' in our case. Anything new that
doesn't fit into one of its categories is rejected as nonsense, until we
explicitly add that as a *level* in the factor:

    levels(cats$coat)

    ## [1] "black"  "calico" "tabby"

    levels(cats$coat) <- c(levels(cats$coat), 'tortoiseshell')
    cats <- rbind(cats, list("tortoiseshell", 3.3, TRUE, 9))

Alternatively, we can change a factor column to a character vector; we
lose the handy categories of the factor, but can subsequently add any
word we want to the column without babysitting the factor levels:

    str(cats)

    ## 'data.frame':    5 obs. of  4 variables:
    ##  $ coat        : Factor w/ 4 levels "black","calico",..: 2 1 3 NA 4
    ##  $ weight      : num  2.1 5 3.2 3.3 3.3
    ##  $ likes_string: logi  TRUE FALSE TRUE TRUE TRUE
    ##  $ age         : num  4 5 8 9 9

    cats$coat <- as.character(cats$coat)
    str(cats)

    ## 'data.frame':    5 obs. of  4 variables:
    ##  $ coat        : chr  "calico" "black" "tabby" NA ...
    ##  $ weight      : num  2.1 5 3.2 3.3 3.3
    ##  $ likes_string: logi  TRUE FALSE TRUE TRUE TRUE
    ##  $ age         : num  4 5 8 9 9

We now know how to add rows and columns to our data.frame in R - but in
our work we've accidentally added a garbage row. We can ask for a
data.frame minus this offender:

    cats[-4,]

    ##            coat weight likes_string age
    ## 1        calico    2.1         TRUE   4
    ## 2         black    5.0        FALSE   5
    ## 3         tabby    3.2         TRUE   8
    ## 5 tortoiseshell    3.3         TRUE   9

Notice the comma with nothing after it to indicate we want to drop the
entire fourth row. Alternatively, we can drop all rows with `NA` values:

    na.omit(cats)

    ##            coat weight likes_string age
    ## 1        calico    2.1         TRUE   4
    ## 2         black    5.0        FALSE   5
    ## 3         tabby    3.2         TRUE   8
    ## 5 tortoiseshell    3.3         TRUE   9

In either case, we need to reassign our variable to persist the changes:

    cats <- na.omit(cats)

<!--sec data-title="Discussion 1" data-id="disc1" data-show=true data-collapse=false ces-->
What do you think

    > cats$weight[4]

will print at this point?

<!--endsec-->
The key to remember when adding data to a data.frame is that *columns
are vectors or factors, and rows are lists.* We can also glue two
dataframes together with `rbind`:

    cats <- rbind(cats, cats)
    cats

    ##             coat weight likes_string age
    ## 1         calico    2.1         TRUE   4
    ## 2          black    5.0        FALSE   5
    ## 3          tabby    3.2         TRUE   8
    ## 5  tortoiseshell    3.3         TRUE   9
    ## 11        calico    2.1         TRUE   4
    ## 21         black    5.0        FALSE   5
    ## 31         tabby    3.2         TRUE   8
    ## 51 tortoiseshell    3.3         TRUE   9

But now the row names are unnecessarily complicated. We can ask R to
re-name everything sequentially:

    rownames(cats) <- NULL
    cats

    ##            coat weight likes_string age
    ## 1        calico    2.1         TRUE   4
    ## 2         black    5.0        FALSE   5
    ## 3         tabby    3.2         TRUE   8
    ## 4 tortoiseshell    3.3         TRUE   9
    ## 5        calico    2.1         TRUE   4
    ## 6         black    5.0        FALSE   5
    ## 7         tabby    3.2         TRUE   8
    ## 8 tortoiseshell    3.3         TRUE   9

<!--sec data-title="Challenge 1" data-id="ch1" data-show=true data-collapse=false ces-->
You can create a new data.frame right from within R with the following
syntax:

    df <- data.frame(id = c('a', 'b', 'c'), x = 1:3, y = c(TRUE, TRUE, FALSE), stringsAsFactors = FALSE)

Make a data.frame that holds the following information for yourself:

-   first name
-   last name
-   lucky number

Then use `rbind` to add an entry for the people sitting beside you.
Finally, use `cbind` to add a column with each person's answer to the
question, "Is it time for coffee break?"

<!--endsec-->
So far, you've seen the basics of manipulating data.frames with our cat
data; now, let's use those skills to digest a more realistic dataset.
Lets read in some real data now. For the remainder of the workshop we
will play with some child health data from positive psychology, supplied
by Dr Peggy Kern:

Kern, M. L., Hampson, S. E., Goldberg, L. R., & Friedman, H. S. (2014).
Integrating Prospective Longitudinal Data: Modeling Personality and
Health in the Terman Life Cycle and Hawaii Longitudinal Studies.
Developmental Psychology, 50(5), 1390–1406.
<http://doi.org/10.1037/a0030874>.

The data is stored on the GitHub repository used for these training
materials, and R can read the file directly from there:

    healthData <- read.csv("https://goo.gl/oqQGKF")

<!--sec data-title="Miscellaneous Tips" data-id="tip1" data-show=true data-collapse=true ces-->
1.  Another type of file you might encounter are tab-separated format.
    To specify a tab as a separator, use `"\t"`.

2.  You can also read in files from the Internet by replacing the file
    paths with a web address.

3.  You can read directly from excel spreadsheets without converting
    them to plain text first by using the `xlsx` package.

<!--endsec-->
Let's investigate healthData a bit; the first thing we should always do
is check out what the data looks like with `str`:

    str(healthData)

    ## 'data.frame':    2034 obs. of  15 variables:
    ##  $ id                        : int  3 4 7 8 10 12 15 17 18 20 ...
    ##  $ conscientiousness         : num  5.83 7.73 6.5 5.88 4.25 ...
    ##  $ extraversion              : num  3.99 7.02 2.7 2.5 5.15 ...
    ##  $ intellect                 : num  6.04 6.82 5.53 4.23 4.75 ...
    ##  $ agreeableness             : num  4.61 6.65 3.09 4.61 3.85 ...
    ##  $ neuroticism               : num  3.65 6.3 4.09 3.65 3.21 ...
    ##  $ sex                       : Factor w/ 2 levels "Female","Male": 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ selfRatedHealth           : int  4 5 3 3 4 4 4 4 5 4 ...
    ##  $ mentalAdjustment          : int  2 3 3 2 2 2 3 1 3 3 ...
    ##  $ illnessReversed           : int  3 5 4 4 3 5 2 4 5 4 ...
    ##  $ health                    : num  6.74 11.96 8.05 6.48 6.74 ...
    ##  $ alcoholUseInYoungAdulthood: int  2 3 2 1 2 2 1 1 1 2 ...
    ##  $ education                 : int  9 8 6 8 9 4 6 7 9 9 ...
    ##  $ birthYear                 : int  1909 1905 1910 1905 1910 1911 1903 1908 1909 1911 ...
    ##  $ HIGroup                   : Factor w/ 2 levels "Group 1","Group 2": 1 1 1 1 1 1 1 1 1 1 ...

We can also examine individual columns of the data.frame with our
`typeof` function:

    typeof(healthData$id)

    ## [1] "integer"

    typeof(healthData$conscientiousness)

    ## [1] "double"

    typeof(healthData$sex)

    ## [1] "integer"

    str(healthData$health)

    ##  num [1:2034] 6.74 11.96 8.05 6.48 6.74 ...

We can also interrogate the data.frame for information about its
dimensions; remembering that `str(healthData)` said there were 2255
observations of 15 variables in healthData, what do you think the
following will produce, and why?

    length(healthData)

    ## [1] 15

A fair guess would have been to say that the length of a data.frame
would be the number of rows it has (2255), but this is not the case;
remember, a data.frame is a *list of vectors and factors*:

    typeof(healthData)

    ## [1] "list"

When `length` gave us 15, it's because healthData is built out of a list
of 15 columns. To get the number of rows and columns in our dataset,
try:

    nrow(healthData)

    ## [1] 2034

    ncol(healthData)

    ## [1] 15

Or, both at once:

    dim(healthData)

    ## [1] 2034   15

We'll also likely want to know what the titles of all the columns are,
so we can ask for them later:

    colnames(healthData)

    ##  [1] "id"                         "conscientiousness"         
    ##  [3] "extraversion"               "intellect"                 
    ##  [5] "agreeableness"              "neuroticism"               
    ##  [7] "sex"                        "selfRatedHealth"           
    ##  [9] "mentalAdjustment"           "illnessReversed"           
    ## [11] "health"                     "alcoholUseInYoungAdulthood"
    ## [13] "education"                  "birthYear"                 
    ## [15] "HIGroup"

At this stage, it's important to ask ourselves if the structure R is
reporting matches our intuition or expectations; do the basic data types
reported for each column make sense? If not, we need to sort any
problems out now before they turn into bad surprises down the road,
using what we've learned about how R interprets data, and the importance
of *strict consistency* in how we record our data.

Once we're happy that the data types and structures seem reasonable,
it's time to start digging into our data proper. Check out the first few
lines:

    head(healthData)

    ##   id conscientiousness extraversion intellect agreeableness neuroticism
    ## 1  3             5.825        3.986     6.044         4.613       3.649
    ## 2  4             7.732        7.016     6.821         6.649       6.299
    ## 3  7             6.498        2.697     5.527         3.087       4.091
    ## 4  8             5.881        2.504     4.234         4.613       3.649
    ## 5 10             4.254        5.147     4.751         3.850       3.208
    ## 6 12             7.508        3.535     6.821         4.613       5.415
    ##    sex selfRatedHealth mentalAdjustment illnessReversed health
    ## 1 Male               4                2               3   6.74
    ## 2 Male               5                3               5  11.96
    ## 3 Male               3                3               4   8.05
    ## 4 Male               3                2               4   6.48
    ## 5 Male               4                2               3   6.74
    ## 6 Male               4                2               5   9.01
    ##   alcoholUseInYoungAdulthood education birthYear HIGroup
    ## 1                          2         9      1909 Group 1
    ## 2                          3         8      1905 Group 1
    ## 3                          2         6      1910 Group 1
    ## 4                          1         8      1905 Group 1
    ## 5                          2         9      1910 Group 1
    ## 6                          2         4      1911 Group 1

To make sure our analysis is reproducible, we should put the code into a
script file so we can come back to it later.

<!--sec data-title="Challenge 2" data-id="ch2" data-show=true data-collapse=false ces-->
Go to file -&gt; new file -&gt; R script, and write an R script to load
in the healthData dataset. Put it in the `scripts/` directory and add it
to version control.

Run the script using the `source` function, using the file path as its
argument (or by pressing the "source" button in RStudio).

<!--endsec-->
<!--sec data-title="Challenge 3" data-id="ch3" data-show=true data-collapse=false ces-->
Read the output of `str(healthData)` again; this time, use what you've
learned about factors, lists and vectors, as well as the output of
functions like `colnames` and `dim` to explain what everything that
`str` prints out for healthData means. If there are any parts you can't
interpret, discuss with your neighbors!

<!--endsec-->
Challenge solutions
-------------------

<!--sec data-title="Solution to Discussion 1" data-id="disc1sol" data-show=true data-collapse=true ces-->
Note the difference between row indices, and default row names; even
though there's no more row named '4', cats\[4,\] is still well-defined
(and pointing at the row named '5').

<!--endsec-->
<!--sec data-title="Solution to Challenge 1" data-id="ch1sol" data-show=true data-collapse=true ces-->
    df <- data.frame(first = c('Grace'), last = c('Hopper'), lucky_number = c(0), stringsAsFactors = FALSE)
    df <- rbind(df, list('Marie', 'Curie', 238) )
    df <- cbind(df, c(TRUE,TRUE))
    names(df)[4] <- 'coffeetime'

<!--endsec-->
<!--sec data-title="Solution to Challenge 2" data-id="ch2sol" data-show=true data-collapse=true ces-->
The contents of `script/load-healthData.R`:

    healthData <- read.csv(file = "../data/THCombo051311.csv")

To run the script and load the data into the `healthData` variable:

    source(file = "scripts/load-healthData.R")

<!--endsec-->
