


# Vectorisation



<!--sec data-title="Learning Objective" data-id="obj" data-show=true data-collapse=false ces-->

* To understand vectorised operations in R.

<!--endsec-->

<br>

---

**Table of Contents**

<!-- toc -->

<br>

---

Most of R's functions are vectorised, meaning that the function will
operate on all elements of a vector without needing to loop through
and act on each element one at a time. This makes writing code more
concise, easy to read, and less error prone.



~~~sourcecode
x <- 1:4
x * 2
~~~



~~~output
[1] 2 4 6 8

~~~

The multiplication happened to each element of the vector.

We can also add two vectors together:


~~~sourcecode
y <- 6:9
x + y
~~~



~~~output
[1]  7  9 11 13

~~~

Each element of `x` was added to its corresponding element of `y`:


~~~sourcecode
x:  1  2  3  4
    +  +  +  +
y:  6  7  8  9
---------------
    7  9 11 13
~~~


<!--sec data-title="Challenge 1" data-id="ch1" data-show=true data-collapse=false ces-->

Let's try this on the `Fare` column of the `titanic` dataset.

Make a new column in the `titanic` data frame that contains `Fare` rounded to the nearest integer. Check the head or tail of the data frame to make sure it worked.

**Hint**: R has a round() function

<!--endsec-->

Comparison operators, logical operators, and many functions are also
vectorised:


**Comparison operators**


~~~sourcecode
x > 2
~~~



~~~output
[1] FALSE FALSE  TRUE  TRUE

~~~

**Logical operators** 

~~~sourcecode
a <- x > 3  # or, for clarity, a <- (x > 3)
a
~~~



~~~output
[1] FALSE FALSE FALSE  TRUE

~~~

<!--sec data-title="Tip: Some useful functions forlogical vectors" data-id="tip1" data-show=true data-collapse=true ces-->

`any()` will return `TRUE` if *any* element of a vector is `TRUE` `all()` will return `TRUE` if *all* elements of a vector are `TRUE`

<!--endsec-->

Most functions also operate element-wise on vectors:

**Functions**

~~~sourcecode
x <- 1:4
log(x)
~~~



~~~output
[1] 0.0000000 0.6931472 1.0986123 1.3862944

~~~

Vectorised operations work element-wise on matrices:


~~~sourcecode
m <- matrix(1:12, nrow=3, ncol=4)
m * -1  
~~~



~~~output
     [,1] [,2] [,3] [,4]
[1,]   -1   -4   -7  -10
[2,]   -2   -5   -8  -11
[3,]   -3   -6   -9  -12

~~~
 
<!--sec data-title="Tip: Element-wise vs. matrix multiplication" data-id="tip2" data-show=true data-collapse=true ces-->

Very important: the operator `*` gives you element-wise multiplication!
To do matrix multiplication, we need to use the `%*%` operator:
 

~~~sourcecode
m %*% matrix(1, nrow=4, ncol=1)
~~~



~~~output
     [,1]
[1,]   22
[2,]   26
[3,]   30

~~~



~~~sourcecode
matrix(1:4, nrow=1) %*% matrix(1:4, ncol=1)
~~~



~~~output
     [,1]
[1,]   30

~~~

For more on matrix algebra, see the [Quick-R reference guide](http://www.statmethods.net/advstats/matrix.html)

<!--endsec-->

<!--sec data-title="Challenge 2" data-id="ch2" data-show=true data-collapse=false ces-->

Given the following matrix:


~~~sourcecode
m <- matrix(1:12, nrow=3, ncol=4)
m
~~~



~~~output
     [,1] [,2] [,3] [,4]
[1,]    1    4    7   10
[2,]    2    5    8   11
[3,]    3    6    9   12

~~~

Write down what you think will happen when you run:

1. `m ^ -1`
2. `m * c(1, 0, -1)`
3. `m > c(0, 20)`
4. `m * c(1, 0, -1, 2)`

Did you get the output you expected? If not, ask a helper!

<!--endsec-->

<!--sec data-title="Challenge 3" data-id="ch3" data-show=true data-collapse=false ces-->

We're interested in looking at the sum of the following sequence of fractions:


~~~sourcecode
x = 1/(1^2) + 1/(2^2) + 1/(3^2) + ... + 1/(n^2)
~~~

This would be tedious to type out, and impossible for high values of
n.  Use vectorisation to compute x when n=100. What is the sum when n=10,000?

<!--endsec-->

<br>

---

## Challenge solutions

<!--sec data-title="Solution to Challenge 1" data-id="ch1sol" data-show=true data-collapse=true ces-->

Let's try this on the `Fare` column of the `titanic` dataset.

Make a new column in the `titanic` data frame that contains `Fare` rounded to the nearest integer. Check the head or tail of the data frame to make sure it worked.

Hint: R has a round() function


~~~sourcecode
titanic$FareInteger <- round(titanic$Fare)
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
  Parch           Ticket    Fare Cabin Embarked FareInteger
1     0        A/5 21171  7.2500              S           7
2     0         PC 17599 71.2833   C85        C          71
3     0 STON/O2. 3101282  7.9250              S           8
4     0           113803 53.1000  C123        S          53
5     0           373450  8.0500              S           8
6     0           330877  8.4583              Q           8

~~~

<!--endsec-->

<!--sec data-title="Solution to Challenge 2" data-id="ch2sol" data-show=true data-collapse=true ces-->

Given the following matrix:


~~~sourcecode
m <- matrix(1:12, nrow=3, ncol=4)
m
~~~



~~~output
     [,1] [,2] [,3] [,4]
[1,]    1    4    7   10
[2,]    2    5    8   11
[3,]    3    6    9   12

~~~

Write down what you think will happen when you run:

1. `m ^ -1`
    
    ~~~output
              [,1]      [,2]      [,3]       [,4]
    [1,] 1.0000000 0.2500000 0.1428571 0.10000000
    [2,] 0.5000000 0.2000000 0.1250000 0.09090909
    [3,] 0.3333333 0.1666667 0.1111111 0.08333333
    
    ~~~

2. `m * c(1, 0, -1)`
    
    ~~~output
         [,1] [,2] [,3] [,4]
    [1,]    1    4    7   10
    [2,]    0    0    0    0
    [3,]   -3   -6   -9  -12
    
    ~~~

3. `m > c(0, 20)`
    
    ~~~output
          [,1]  [,2]  [,3]  [,4]
    [1,]  TRUE FALSE  TRUE FALSE
    [2,] FALSE  TRUE FALSE  TRUE
    [3,]  TRUE FALSE  TRUE FALSE
    
    ~~~

<!--endsec-->

<!--sec data-title="Solution to Challenge 3" data-id="ch3sol" data-show=true data-collapse=true ces-->

We're interested in looking at the sum of the following sequence of fractions:


~~~sourcecode
x = 1/(1^2) + 1/(2^2) + 1/(3^2) + ... + 1/(n^2)
~~~

This would be tedious to type out, and impossible for high values of n. Can you use vectorisation to compute x, when n=100? How about when n=10,000?


~~~sourcecode
sum(1/(1:100)^2)
~~~



~~~output
[1] 1.634984

~~~



~~~sourcecode
sum(1/(1:1e04)^2)
~~~



~~~output
[1] 1.644834

~~~



~~~sourcecode
n <- 10000
sum(1/(1:n)^2)
~~~



~~~output
[1] 1.644834

~~~

We can also obtain the same results using a function:

~~~sourcecode
inverse_sum_of_squares <- function(n) {
   sum(1/(1:n)^2)
}
inverse_sum_of_squares(100)
~~~



~~~output
[1] 1.634984

~~~



~~~sourcecode
inverse_sum_of_squares(10000)
~~~



~~~output
[1] 1.644834

~~~



~~~sourcecode
n <- 10000
inverse_sum_of_squares(n)
~~~



~~~output
[1] 1.644834

~~~

<!--endsec-->
