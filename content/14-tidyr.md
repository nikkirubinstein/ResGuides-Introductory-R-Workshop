Dataframe manipulation with tidyr
=================================

<!--sec data-title="Learning Objective" data-id="obj" data-show=true data-collapse=false ces-->
-   To be understand the concepts of 'long' and 'wide' data formats and
    be able to convert between them with `tidyr`

<!--endsec-->
<br>

------------------------------------------------------------------------

**Table of Contents**

<!-- toc -->
<br>

------------------------------------------------------------------------

Researchers often want to manipulate their data from the 'wide' to the
'long' format, or vice-versa. The 'long' format is where:

-   each column is a variable
-   each row is an observation

In the 'long' format, you usually have 1 column for the observed
variable and the other columns are ID variables.

For the 'wide' format each row is often a site/subject/patient and you
have multiple observation variables containing the same type of data.
These can be either repeated observations over time, or observation of
multiple variables (or a mix of both). You may find data input may be
simpler or some other applications may prefer the 'wide' format.
However, many of `R`'s functions have been designed assuming you have
'long' format data. This tutorial will help you efficiently transform
your data regardless of original format.

![](fig/14-tidyr-fig1.png)

These data formats mainly affect readability. For humans, the wide
format is often more intuitive since we can often see more of the data
on the screen due to it's shape. However, the long format is more
machine readable and is closer to the formating of databases. The ID
variables in our dataframes are similar to the fields in a database and
observed variables are like the database values.

<br>

------------------------------------------------------------------------

Getting started
---------------

First install the packages if you haven't already done so (you probably
installed dplyr in the previous lesson):

    #install.packages("tidyr")
    #install.packages("dplyr")

Load the packages

    library("tidyr")
    library("dplyr")

First, lets look at the structure of our original healthData dataframe:

    str(healthData)

    ## 'data.frame':    2034 obs. of  15 variables:
    ##  $ id                        : int  3 4 7 8 10 12 15 17 18 20 ...
    ##  $ conscientiousness         : num  5.83 7.73 6.5 5.88 4.25 ...
    ##  $ extraversion              : num  3.99 7.02 2.7 2.5 5.15 ...
    ##  $ intellect                 : num  6.04 6.82 5.53 4.23 4.75 ...
    ##  $ agreeableness             : num  4.61 6.65 3.09 4.61 3.85 ...
    ##  $ neuroticism               : num  3.65 6.3 4.09 3.65 3.21 ...
    ##  $ sex                       : chr  "Male" "Male" "Male" "Male" ...
    ##  $ selfRatedHealth           : int  4 5 3 3 4 4 4 4 5 4 ...
    ##  $ mentalAdjustment          : int  2 3 3 2 2 2 3 1 3 3 ...
    ##  $ illnessReversed           : int  3 5 4 4 3 5 2 4 5 4 ...
    ##  $ health                    : num  6.74 11.96 8.05 6.48 6.74 ...
    ##  $ alcoholUseInYoungAdulthood: int  2 3 2 1 2 2 1 1 1 2 ...
    ##  $ education                 : int  9 8 6 8 9 4 6 7 9 9 ...
    ##  $ birthYear                 : int  1909 1905 1910 1905 1910 1911 1903 1908 1909 1911 ...
    ##  $ HIGroup                   : chr  "Group 1" "Group 1" "Group 1" "Group 1" ...

<!--sec data-title="Challenge 1" data-id="ch1" data-show=true data-collapse=false ces-->
Is healthData a purely long, purely wide, or some intermediate format?

<!--endsec-->
Sometimes, we have multiple types of observed data. It is somewhere in
between the purely 'long' and 'wide' data formats. We have 2 "ID
variables" (`id`,`HIGroup`) and 13 "Observation variables". I usually
prefer my data in this intermediate format in most cases despite not
having ALL observations in 1 column given that all observation variables
have different units. There are few operations that would need us to
stretch out this dataframe any longer (i.e. 3 ID variables and 1
Observation variable).

While using many of the functions in R, which are often vector based,
you usually do not want to do mathematical operations on values with
different units. For example, using the purely long format, a single
mean for all of the values of intellect, conscientiousness and health
would not be meaningful since it would return the mean of values with 3
incompatible units. The solution is that we first manipulate the data
either by grouping (see the lesson on `dplyr`), or we change the
structure of the dataframe. **Note:** Some plotting functions in R
actually work better in the wide format data.

<br>

------------------------------------------------------------------------

From intermediate to long format with gather()
----------------------------------------------

Until now, we've been using the nicely formatted original healthData
dataset, but 'real' data (i.e. our own research data) may not be so well
organized. To demonstrate, let's engineer a less usefully structure
dataset using tidyr's `gather()` function.

    str(healthData)

    ## 'data.frame':    2034 obs. of  15 variables:
    ##  $ id                        : int  3 4 7 8 10 12 15 17 18 20 ...
    ##  $ conscientiousness         : num  5.83 7.73 6.5 5.88 4.25 ...
    ##  $ extraversion              : num  3.99 7.02 2.7 2.5 5.15 ...
    ##  $ intellect                 : num  6.04 6.82 5.53 4.23 4.75 ...
    ##  $ agreeableness             : num  4.61 6.65 3.09 4.61 3.85 ...
    ##  $ neuroticism               : num  3.65 6.3 4.09 3.65 3.21 ...
    ##  $ sex                       : chr  "Male" "Male" "Male" "Male" ...
    ##  $ selfRatedHealth           : int  4 5 3 3 4 4 4 4 5 4 ...
    ##  $ mentalAdjustment          : int  2 3 3 2 2 2 3 1 3 3 ...
    ##  $ illnessReversed           : int  3 5 4 4 3 5 2 4 5 4 ...
    ##  $ health                    : num  6.74 11.96 8.05 6.48 6.74 ...
    ##  $ alcoholUseInYoungAdulthood: int  2 3 2 1 2 2 1 1 1 2 ...
    ##  $ education                 : int  9 8 6 8 9 4 6 7 9 9 ...
    ##  $ birthYear                 : int  1909 1905 1910 1905 1910 1911 1903 1908 1909 1911 ...
    ##  $ HIGroup                   : chr  "Group 1" "Group 1" "Group 1" "Group 1" ...

The `tidyr` function `gather()` can 'gather' your observation variables
into a single variable.

    healthData_long <- healthData %>% gather(obsType,obsValues,-id,-HIGroup)
    # OR
    # healthData_long <- healthData %>% gather(obsType,obsValues,conscientiousness,extraversion,intellect,
    #                        agreeableness,neuroticism,sex,selfRatedHealth,mentalAdjustment,illnessReversed,
    #                        health,alcoholIseInYoungAdulthood,education,birthYear)
    str(healthData_long)

    ## 'data.frame':    26442 obs. of  4 variables:
    ##  $ id       : int  3 4 7 8 10 12 15 17 18 20 ...
    ##  $ HIGroup  : chr  "Group 1" "Group 1" "Group 1" "Group 1" ...
    ##  $ obsType  : chr  "conscientiousness" "conscientiousness" "conscientiousness" "conscientiousness" ...
    ##  $ obsValues: chr  "5.825" "7.732" "6.498" "5.881" ...

Here we have used piping syntax which is similar to what we were doing
in the previous lesson with dplyr. In fact, these are compatible and you
can use a mix of tidyr and dplyr functions by piping them together.

Inside `gather()` we first name the new column for the new ID variable
(`obsType`), the name for the new amalgamated observation variable
(`obsValue`), then the names of the old observation variable. We could
have typed out all the observation variables, but gather also allows the
alternative syntax of using the `-` symbol to identify which variables
are not to be gathered (i.e. ID variables).

That may seem trivial with this particular dataframe, but sometimes you
have 1 ID variable and 40 Observation variables with irregular variables
names. The flexibility is a huge time saver!

Now `obsType` actually contains the observation type
(`conscientiousness`,`intellect`, `health` etc), and `obsValue` contains
the values for that observation for that particular id. Due to the
coersion rules we introduced earlier, since some of the observation
variables where character data types, all the observations are now
represented as strings. As a result of the structure change, we now have
many rows per id, where before we had only one row per id. The resulting
data.frame is much longer.

<br>

------------------------------------------------------------------------

From long to intermediate format with spread()
----------------------------------------------

Now just to double-check our work, let's use the opposite of `gather()`
to spread our observation variables back out with the aptly named
`spread()`. We can then spread our `healthData_long` to the original
intermediate format or the widest format. Let's start with the
intermediate format.

    healthData_normal <- healthData_long %>% spread(obsType,obsValues)
    dim(healthData_normal)

    ## [1] 2034   15

    dim(healthData)

    ## [1] 2034   15

    names(healthData_normal)

    ##  [1] "id"                         "HIGroup"                   
    ##  [3] "agreeableness"              "alcoholUseInYoungAdulthood"
    ##  [5] "birthYear"                  "conscientiousness"         
    ##  [7] "education"                  "extraversion"              
    ##  [9] "health"                     "illnessReversed"           
    ## [11] "intellect"                  "mentalAdjustment"          
    ## [13] "neuroticism"                "selfRatedHealth"           
    ## [15] "sex"

    names(healthData)

    ##  [1] "id"                         "conscientiousness"         
    ##  [3] "extraversion"               "intellect"                 
    ##  [5] "agreeableness"              "neuroticism"               
    ##  [7] "sex"                        "selfRatedHealth"           
    ##  [9] "mentalAdjustment"           "illnessReversed"           
    ## [11] "health"                     "alcoholUseInYoungAdulthood"
    ## [13] "education"                  "birthYear"                 
    ## [15] "HIGroup"

Now we've got an intermediate dataframe `healthData_normal` with the
same dimensions as the original `healthData`, but the order of the
variables is different. Let's fix that before checking if they are
`all.equal()`.

    healthData_normal <- healthData_normal[,names(healthData)]
    all.equal(healthData_normal,healthData)

    ##  [1] "Component \"id\": Mean relative difference: 0.5614796"                            
    ##  [2] "Component \"conscientiousness\": Modes: character, numeric"                       
    ##  [3] "Component \"conscientiousness\": target is character, current is numeric"         
    ##  [4] "Component \"extraversion\": Modes: character, numeric"                            
    ##  [5] "Component \"extraversion\": target is character, current is numeric"              
    ##  [6] "Component \"intellect\": Modes: character, numeric"                               
    ##  [7] "Component \"intellect\": target is character, current is numeric"                 
    ##  [8] "Component \"agreeableness\": Modes: character, numeric"                           
    ##  [9] "Component \"agreeableness\": target is character, current is numeric"             
    ## [10] "Component \"neuroticism\": Modes: character, numeric"                             
    ## [11] "Component \"neuroticism\": target is character, current is numeric"               
    ## [12] "Component \"sex\": 972 string mismatches"                                         
    ## [13] "Component \"selfRatedHealth\": Modes: character, numeric"                         
    ## [14] "Component \"selfRatedHealth\": target is character, current is numeric"           
    ## [15] "Component \"mentalAdjustment\": Modes: character, numeric"                        
    ## [16] "Component \"mentalAdjustment\": target is character, current is numeric"          
    ## [17] "Component \"illnessReversed\": Modes: character, numeric"                         
    ## [18] "Component \"illnessReversed\": target is character, current is numeric"           
    ## [19] "Component \"health\": Modes: character, numeric"                                  
    ## [20] "Component \"health\": target is character, current is numeric"                    
    ## [21] "Component \"alcoholUseInYoungAdulthood\": Modes: character, numeric"              
    ## [22] "Component \"alcoholUseInYoungAdulthood\": target is character, current is numeric"
    ## [23] "Component \"education\": Modes: character, numeric"                               
    ## [24] "Component \"education\": target is character, current is numeric"                 
    ## [25] "Component \"birthYear\": Modes: character, numeric"                               
    ## [26] "Component \"birthYear\": target is character, current is numeric"                 
    ## [27] "Component \"HIGroup\": 896 string mismatches"

    head(healthData_normal)

    ##   id conscientiousness extraversion intellect agreeableness neuroticism
    ## 1  1             4.815        3.342     3.587         3.087       4.091
    ## 2  3             5.825        3.986     6.044         4.613       3.649
    ## 3  4             7.732        7.016     6.821         6.649       6.299
    ## 4  7             6.498        2.697     5.527         3.087       4.091
    ## 5  8             5.881        2.504     4.234         4.613       3.649
    ## 6 10             4.254        5.147     4.751          3.85       3.208
    ##      sex selfRatedHealth mentalAdjustment illnessReversed health
    ## 1 Female               4                3               3   8.31
    ## 2   Male               4                2               3   6.74
    ## 3   Male               5                3               5  11.96
    ## 4   Male               3                3               4   8.05
    ## 5   Male               3                2               4   6.48
    ## 6   Male               4                2               3   6.74
    ##   alcoholUseInYoungAdulthood education birthYear HIGroup
    ## 1                          1         5      1913 Group 1
    ## 2                          2         9      1909 Group 1
    ## 3                          3         8      1905 Group 1
    ## 4                          2         6      1910 Group 1
    ## 5                          1         8      1905 Group 1
    ## 6                          2         9      1910 Group 1

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

We're almost there, but the data doesn't match quite. The output of the
`head()` function shows that each data.frame is sorted differently. To
ensure consistent sorting, we can use the `arrange()` function from the
dplyr package.

    healthData_normal <- healthData_normal %>% arrange(id)
    healthData <- healthData %>% arrange(id)
    str(healthData_normal)

    ## 'data.frame':    2034 obs. of  15 variables:
    ##  $ id                        : int  1 3 4 7 8 10 12 14 15 16 ...
    ##  $ conscientiousness         : chr  "4.815" "5.825" "7.732" "6.498" ...
    ##  $ extraversion              : chr  "3.342" "3.986" "7.016" "2.697" ...
    ##  $ intellect                 : chr  "3.587" "6.044" "6.821" "5.527" ...
    ##  $ agreeableness             : chr  "3.087" "4.613" "6.649" "3.087" ...
    ##  $ neuroticism               : chr  "4.091" "3.649" "6.299" "4.091" ...
    ##  $ sex                       : chr  "Female" "Male" "Male" "Male" ...
    ##  $ selfRatedHealth           : chr  "4" "4" "5" "3" ...
    ##  $ mentalAdjustment          : chr  "3" "2" "3" "3" ...
    ##  $ illnessReversed           : chr  "3" "3" "5" "4" ...
    ##  $ health                    : chr  "8.31" "6.74" "11.96" "8.05" ...
    ##  $ alcoholUseInYoungAdulthood: chr  "1" "2" "3" "2" ...
    ##  $ education                 : chr  "5" "9" "8" "6" ...
    ##  $ birthYear                 : chr  "1913" "1909" "1905" "1910" ...
    ##  $ HIGroup                   : chr  "Group 1" "Group 1" "Group 1" "Group 1" ...

    str(healthData)

    ## 'data.frame':    2034 obs. of  15 variables:
    ##  $ id                        : int  1 3 4 7 8 10 12 14 15 16 ...
    ##  $ conscientiousness         : num  4.82 5.83 7.73 6.5 5.88 ...
    ##  $ extraversion              : num  3.34 3.99 7.02 2.7 2.5 ...
    ##  $ intellect                 : num  3.59 6.04 6.82 5.53 4.23 ...
    ##  $ agreeableness             : num  3.09 4.61 6.65 3.09 4.61 ...
    ##  $ neuroticism               : num  4.09 3.65 6.3 4.09 3.65 ...
    ##  $ sex                       : chr  "Female" "Male" "Male" "Male" ...
    ##  $ selfRatedHealth           : int  4 4 5 3 3 4 4 4 4 4 ...
    ##  $ mentalAdjustment          : int  3 2 3 3 2 2 2 3 3 3 ...
    ##  $ illnessReversed           : int  3 3 5 4 4 3 5 5 2 4 ...
    ##  $ health                    : num  8.31 6.74 11.96 8.05 6.48 ...
    ##  $ alcoholUseInYoungAdulthood: int  1 2 3 2 1 2 2 1 1 2 ...
    ##  $ education                 : int  5 9 8 6 8 9 4 6 6 8 ...
    ##  $ birthYear                 : int  1913 1909 1905 1910 1905 1910 1911 1904 1903 1908 ...
    ##  $ HIGroup                   : chr  "Group 1" "Group 1" "Group 1" "Group 1" ...

Now we can see that the data matches, but the datatypes are different
for some columns due to the coersion that occured earlier.

    healthData_normal$conscientiousness <- as.numeric(healthData_normal$conscientiousness)
    healthData_normal$intellect <- as.numeric(healthData_normal$intellect)
    healthData_normal$selfRatedHealth <- as.integer(healthData_normal$selfRatedHealth)
    healthData_normal$mentalAdjustment <- as.integer(healthData_normal$mentalAdjustment)
    healthData_normal$illnessReversed <- as.integer(healthData_normal$illnessReversed)
    healthData_normal$health <- as.numeric(healthData_normal$health)
    healthData_normal$alcoholUseInYoungAdulthood <- as.integer(healthData_normal$alcoholUseInYoungAdulthood)
    healthData_normal$education <- as.integer(healthData_normal$education)
    healthData_normal$birthYear <- as.integer(healthData_normal$birthYear)

    all.equal(healthData_normal,healthData)

    ## [1] "Component \"extraversion\": Modes: character, numeric"               
    ## [2] "Component \"extraversion\": target is character, current is numeric" 
    ## [3] "Component \"agreeableness\": Modes: character, numeric"              
    ## [4] "Component \"agreeableness\": target is character, current is numeric"
    ## [5] "Component \"neuroticism\": Modes: character, numeric"                
    ## [6] "Component \"neuroticism\": target is character, current is numeric"

That's great! We've gone from the longest format back to the
intermediate and we didn't introduce any errors in our code.

<!--sec data-title="Challenge 2" data-id="ch2" data-show=true data-collapse=false ces-->
Convert the original healthData data.frame to a wide format which has
the 2 original id columns (`id` and `HIGroup`), as well as columns for
`education`, `birthYear` and `sex`. Combine all other observation
columns (`conscientiousness`,`extraversion`,`intellect` etc) into a
single pair of columns - one which hold observation type, and one with
the observation value.

<!--endsec-->
<br>

------------------------------------------------------------------------

Challenge solutions
-------------------

<!--sec data-title="Solution to Challenge 1" data-id="ch1sol" data-show=true data-collapse=true ces-->
The original gapminder data.frame is in an intermediate format. It is
not purely long since it had multiple observation variables
(`pop`,`lifeExp`,`gdpPercap`).

<!--endsec-->
<!--sec data-title="Solution to Challenge 2" data-id="ch2sol" data-show=true data-collapse=true ces-->
    healthData_longish <- healthData %>% gather(obsType,obsValues,-id,-HIGroup,-education,-birthYear,-sex)

<!--endsec-->
<br>

------------------------------------------------------------------------

Other great resources
---------------------

[Data Wrangling Cheat
sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
[Introduction to
tidyr](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html)
