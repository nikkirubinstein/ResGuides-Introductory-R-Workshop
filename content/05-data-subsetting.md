


# Subsetting data



<!--sec data-title="Learning Objectives" data-id="obj" data-show=true data-collapse=false ces-->

* To be able to subset vectors, factors, matrices, lists, and data frames
* To be able to extract individual and multiple elements:
    * by index,
    * by name,
    * using comparison operations
* To be able to skip and remove elements from various data structures.

<!--endsec-->

<br>

---

**Table of Contents**

<!-- toc -->

<br>

---

R has many powerful subset operators and mastering them will allow you to
easily perform complex operations on any kind of dataset.

There are six different ways we can subset any kind of object, and three
different subsetting operators for the different data structures.

Let's start with the workhorse of R: atomic vectors.


~~~sourcecode
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
x
~~~



~~~output
  a   b   c   d   e 
5.4 6.2 7.1 4.8 7.5 

~~~

So now that we've created a dummy vector to play with, how do we get at its
contents?

<br>

---

## Accessing elements using their indices

To extract elements of a vector we can give their corresponding index, starting
from one:


~~~sourcecode
x[1]
~~~



~~~output
  a 
5.4 

~~~


~~~sourcecode
x[4]
~~~



~~~output
  d 
4.8 

~~~

The square brackets operator is just like any other function. For atomic vectors
(and matrices), it means "get me the nth element".

We can ask for multiple elements at once:


~~~sourcecode
x[c(1, 3)]
~~~



~~~output
  a   c 
5.4 7.1 

~~~

Or slices of the vector:


~~~sourcecode
x[1:4]
~~~



~~~output
  a   b   c   d 
5.4 6.2 7.1 4.8 

~~~

the `:` operator just creates a sequence of numbers from the left element to the right.
I.e. `x[1:4]` is equivalent to `x[c(1,2,3,4)]`.

We can ask for the same element multiple times:


~~~sourcecode
x[c(1,1,3)]
~~~



~~~output
  a   a   c 
5.4 5.4 7.1 

~~~

If we ask for a number outside of the vector, R will return missing values:


~~~sourcecode
x[6]
~~~



~~~output
<NA> 
  NA 

~~~

This is a vector of length one containing an `NA`, whose name is also `NA`.

If we ask for the 0th element, we get an empty vector:


~~~sourcecode
x[0]
~~~



~~~output
named numeric(0)

~~~

<!--sec data-title="Tip: Vector numbering in R starts at 1" data-id="tip1" data-show=true data-collapse=true ces-->

In many programming languages (C and python, for example), the first element of a vector has an index of 0. In R, the first element is 1.

<!--endsec-->

<br>

---

## Skipping and removing elements

If we use a negative number as the index of a vector, R will return
every element *except* for the one specified:


~~~sourcecode
x[-2]
~~~



~~~output
  a   c   d   e 
5.4 7.1 4.8 7.5 

~~~


We can skip multiple elements:


~~~sourcecode
x[c(-1, -5)]  # or x[-c(1,5)]
~~~



~~~output
  b   c   d 
6.2 7.1 4.8 

~~~

<!--sec data-title="Tip: Order of operations" data-id="tip2" data-show=true data-collapse=true ces-->

A common trip up for novices occurs when trying to skip slices of a vector. Most people first try to negate a sequence like so:


~~~sourcecode
x[-1:3]
~~~



~~~err
Error in x[-1:3]: only 0's may be mixed with negative subscripts

~~~

This gives a somewhat cryptic error:

But remember the order of operations. `:` is really a function, so what happens is it takes its first argument as -1, and second as 3, so generates the sequence of numbers: `c(-1, 0, 1, 2, 3)`.

The correct solution is to wrap that function call in brackets, so that the `-` operator applies to the results:


~~~sourcecode
x[-(1:3)]
~~~



~~~output
  d   e 
4.8 7.5 

~~~

<!--endsec-->

To remove elements from a vector, we need to assign the results back
into the variable:


~~~sourcecode
x <- x[-4]
x
~~~



~~~output
  a   b   c   e 
5.4 6.2 7.1 7.5 

~~~

<!--sec data-title="Challenge 1" data-id="ch1" data-show=true data-collapse=false ces-->

Given the following code:


~~~sourcecode
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
print(x)
~~~



~~~output
  a   b   c   d   e 
5.4 6.2 7.1 4.8 7.5 

~~~

1. Come up with at least 3 different commands that will produce the following output:
    
    ~~~output
      b   c   d 
    6.2 7.1 4.8 
    
    ~~~

2. Compare notes with your neighbour. Did you have different strategies?

<!--endsec-->

<br>

---

## Subsetting by name

We can extract elements by using their name, instead of index:


~~~sourcecode
x[c("a", "c")]
~~~



~~~output
  a   c 
5.4 7.1 

~~~

This is usually a much more reliable way to subset objects: the
position of various elements can often change when chaining together
subsetting operations, but the names will always remain the same!

Unfortunately we can't skip or remove elements so easily.

To skip (or remove) a single named element:


~~~sourcecode
x[-which(names(x) == "a")]
~~~



~~~output
  b   c   d   e 
6.2 7.1 4.8 7.5 

~~~

The `which` function returns the indices of all `TRUE` elements of its argument.
Remember that expressions evaluate before being passed to functions. Let's break
this down so that its clearer what's happening.

First this happens:


~~~sourcecode
names(x) == "a"
~~~



~~~output
[1]  TRUE FALSE FALSE FALSE FALSE

~~~

The condition operator is applied to every name of the vector `x`. Only the
first name is "a" so that element is TRUE.

`which` then converts this to an index:


~~~sourcecode
which(names(x) == "a")
~~~



~~~output
[1] 1

~~~



Only the first element is `TRUE`, so `which` returns 1. Now that we have indices
the skipping works because we have a negative index!

Skipping multiple named indices is similar, but uses a different comparison
operator:


~~~sourcecode
x[-which(names(x) %in% c("a", "c"))]
~~~



~~~output
  b   d   e 
6.2 4.8 7.5 

~~~

The `%in%` goes through each element of its left argument, in this case the
names of `x`, and asks, "Does this element occur in the second argument?".

<!--sec data-title="Challenge 2" data-id="ch2" data-show=true data-collapse=false ces-->

Run the following code to define vector `x` as above:


~~~sourcecode
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
print(x)
~~~



~~~output
  a   b   c   d   e 
5.4 6.2 7.1 4.8 7.5 

~~~

Given this vector `x`, what would you expect the following to do?

~~~sourcecode
x[-which(names(x) == "g")]
~~~

Try out this command and see what you get. Did this match your expectation? Why did we get this result? (Tip: test out each part of the command on it's own like we just did above - this is a useful debugging strategy)

Which of the following are true:

* A) if there are no `TRUE` values passed to `which`, an empty vector is returned
* B) if there are no `TRUE` values passed to `which`, an error message is shown
* C) `integer()` is an empty vector
* D) making an empty vector negative produces an "everything" vector
* E) `x[]` gives the same result as `x[integer()]`

<!--endsec-->

<!--sec data-title="Tip: Non-unique names" data-id="tip3" data-show=true data-collapse=true ces-->

You should be aware that it is possible for multiple elements in a vector to have the same name. (For a data frame, columns can have the same name --- although R tries to avoid this --- but row names must be unique.) Consider these examples:


~~~sourcecode
x <- 1:3
x
~~~



~~~output
[1] 1 2 3

~~~



~~~sourcecode
names(x) <- c('a', 'a', 'a')  
x
~~~



~~~output
a a a 
1 2 3 

~~~



~~~sourcecode
x['a']  # only returns first value
~~~



~~~output
a 
1 

~~~



~~~sourcecode
x[which(names(x) == 'a')]  # returns all three values
~~~



~~~output
a a a 
1 2 3 

~~~

<!--endsec-->

<!--sec data-title="Tip: Getting help for operators" data-id="tip4" data-show=true data-collapse=true ces-->

Remember you can search for help on operators by wrapping them in quotes: `help("%in%")` or `?"%in%"`.

<!--endsec-->

So why can't we use `==` like before? That's an excellent question.

Let's take a look at just the comparison component:


~~~sourcecode
names(x) == c('a', 'c')
~~~



~~~err
Warning in names(x) == c("a", "c"): longer object length is not a multiple
of shorter object length

~~~



~~~output
[1]  TRUE FALSE  TRUE

~~~

Obviously "c" is in the names of `x`, so why didn't this work? `==` works
slightly differently than `%in%`. It will compare each element of its left argument
to the corresponding element of its right argument.

Here's a mock illustration:


~~~sourcecode
c("a", "b", "c", "e")  # names of x
   |    |    |    |    # The elements == is comparing
c("a", "c")
~~~

When one vector is shorter than the other, it gets *recycled*:


~~~sourcecode
c("a", "b", "c", "e")  # names of x
   |    |    |    |    # The elements == is comparing
c("a", "c", "a", "c")
~~~

In this case R simply repeats `c("a", "c")` twice. If the longer
vector length isn't a multiple of the shorter vector length, then
R will also print out a warning message:


~~~sourcecode
names(x) == c('a', 'c', 'e')
~~~



~~~output
[1]  TRUE FALSE FALSE

~~~

This difference between `==` and `%in%` is important to remember,
because it can introduce hard to find and subtle bugs!

<br>

---

## Subsetting through other logical operations

We can also more simply subset through logical operations:


~~~sourcecode
x[c(TRUE, TRUE, FALSE, FALSE)]
~~~



~~~output
a a 
1 2 

~~~

Note that in this case, the logical vector is also recycled to the
length of the vector we're subsetting!


~~~sourcecode
x[c(TRUE, FALSE)]
~~~



~~~output
a a 
1 3 

~~~

Since comparison operators evaluate to logical vectors, we can also
use them to succinctly subset vectors:


~~~sourcecode
x[x > 7]
~~~



~~~output
named integer(0)

~~~


<!--sec data-title="Tip: Combining logical conditions" data-id="tip5" data-show=true data-collapse=true ces-->

There are many situations in which you will wish to combine multiple logical criteria. For example, we might want to find all the countries that are located in Asia **or** Europe **and** have life expectancies within a certain range. Several operations for combining logical vectors exist in R:

 * `&`, the "logical AND" operator: returns `TRUE` if both the left and right are `TRUE`. * `|`, the "logical OR" operator: returns `TRUE`, if either the left or right (or both) are `TRUE`.

The recycling rule applies with both of these, so `TRUE & c(TRUE, FALSE, TRUE)` will compare the first `TRUE` on the left of the `&` sign with each of the three conditions on the right.

You may sometimes see `&&` and `||` instead of `&` and `|`. These operators do not use the recycling rule: they only look at the first element of each vector and ignore the remaining elements. The longer operators are mainly used in programming, rather than data analysis.

 * `!`, the "logical NOT" operator: converts `TRUE` to `FALSE` and `FALSE` to `TRUE`. It can negate a single logical condition (eg `!TRUE` becomes `FALSE`), or a whole vector of conditions(eg `!c(TRUE, FALSE)` becomes `c(FALSE, TRUE)`).

Additionally, you can compare the elements within a single vector using the `all` function (which returns `TRUE` if every element of the vector is `TRUE`) and the `any` function (which returns `TRUE` if one or more elements of the vector are `TRUE`).

<!--endsec-->

<!--sec data-title="Challenge 3" data-id="ch3" data-show=true data-collapse=false ces-->

Given the following code:


~~~sourcecode
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
print(x)
~~~



~~~output
  a   b   c   d   e 
5.4 6.2 7.1 4.8 7.5 

~~~

Write a subsetting command to return the values in x that are greater than 4 and less than 7.

<!--endsec-->

<br>

---

## Handling special values

At some point you will encounter functions in R which cannot handle missing, infinite,
or undefined data.

There are a number of special functions you can use to filter out this data:

 * `is.na` will return all positions in a vector, matrix, or data.frame
   containing `NA`.
 * likewise, `is.nan`, and `is.infinite` will do the same for `NaN` and `Inf`.
 * `is.finite` will return all positions in a vector, matrix, or data.frame
   that do not contain `NA`, `NaN` or `Inf`.
 * `na.omit` will filter out all missing values from a vector

<br>

---

## Factor subsetting

Now that we've explored the different ways to subset vectors, how
do we subset the other data structures?

Factor subsetting works the same way as vector subsetting.


~~~sourcecode
f <- factor(c("a", "a", "b", "c", "c", "d"))
f[f == "a"]
~~~



~~~output
[1] a a
Levels: a b c d

~~~



~~~sourcecode
f[f %in% c("b", "c")]
~~~



~~~output
[1] b c c
Levels: a b c d

~~~



~~~sourcecode
f[1:3]
~~~



~~~output
[1] a a b
Levels: a b c d

~~~

An important note is that skipping elements will not remove the level
even if no more of that category exists in the factor:


~~~sourcecode
f[-3]
~~~



~~~output
[1] a a c c d
Levels: a b c d

~~~

<br>

---

## Matrix subsetting

Matrices are also subsetted using the `[` function. In this case
it takes two arguments: the first applying to the rows, the second
to its columns:


~~~sourcecode
set.seed(1)
m <- matrix(rnorm(6*4), ncol=4, nrow=6)
m[3:4, c(3,1)]
~~~



~~~output
            [,1]       [,2]
[1,]  1.12493092 -0.8356286
[2,] -0.04493361  1.5952808

~~~

You can leave the first or second arguments blank to retrieve all the
rows or columns respectively:


~~~sourcecode
m[, c(3,4)]
~~~



~~~output
            [,1]        [,2]
[1,] -0.62124058  0.82122120
[2,] -2.21469989  0.59390132
[3,]  1.12493092  0.91897737
[4,] -0.04493361  0.78213630
[5,] -0.01619026  0.07456498
[6,]  0.94383621 -1.98935170

~~~

If we only access one row or column, R will automatically convert the result
to a vector:


~~~sourcecode
m[3,]
~~~



~~~output
[1] -0.8356286  0.5757814  1.1249309  0.9189774

~~~

If you want to keep the output as a matrix, you need to specify a *third* argument;
`drop = FALSE`:


~~~sourcecode
m[3, , drop=FALSE]
~~~



~~~output
           [,1]      [,2]     [,3]      [,4]
[1,] -0.8356286 0.5757814 1.124931 0.9189774

~~~

Unlike vectors, if we try to access a row or column outside of the matrix,
R will throw an error:


~~~sourcecode
m[, c(3,6)]
~~~


<!--sec data-title="Tip: Higher dimensional arrays" data-id="tip6" data-show=true data-collapse=true ces-->

When dealing with multi-dimensional arrays, each argument to `[` corresponds to a dimension. For example, a 3D array, the first three arguments correspond to the rows, columns, and depth dimension.

<!--endsec-->

Because matrices are really just vectors underneath the hood, we can
also subset using only one argument:


~~~sourcecode
m[5]
~~~



~~~output
[1] 0.3295078

~~~


This usually isn't useful. However it is useful to note that matrices
are laid out in *column-major format* by default. That is the elements of the
vector are arranged column-wise:


~~~sourcecode
matrix(1:6, nrow=2, ncol=3)
~~~



~~~output
     [,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6

~~~

If you wish to populate the matrix by row, use `byrow=TRUE`:


~~~sourcecode
matrix(1:6, nrow=2, ncol=3, byrow=TRUE)
~~~



~~~output
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6

~~~

Matrices can also be subsetted using their rownames and column names
instead of their row and column indices.

<!--sec data-title="Challenge 4" data-id="ch4" data-show=true data-collapse=false ces-->

Given the following code:


~~~sourcecode
m <- matrix(1:18, nrow=3, ncol=6)
print(m)
~~~



~~~output
     [,1] [,2] [,3] [,4] [,5] [,6]
[1,]    1    4    7   10   13   16
[2,]    2    5    8   11   14   17
[3,]    3    6    9   12   15   18

~~~

1. Which of the following commands will extract the values 11 and 14?

A. `m[2,4,2,5]`

B. `m[2:5]`

C. `m[4:5,2]`

D. `m[2,c(4,5)]`

<!--endsec-->

<br>

---

## List subsetting

Now we'll introduce some new subsetting operators. There are three functions
used to subset lists. `[`, as we've seen for atomic vectors and matrices,
as well as `[[` and `$`.

Using `[` will always return a list. If you want to *subset* a list, but not
*extract* an element, then you will likely use `[`.


~~~sourcecode
xlist <- list(a = "Research Bazaar", b = 1:10, data = head(iris))
xlist[1]
~~~



~~~output
$a
[1] "Research Bazaar"

~~~

This returns a *list with one element*.

We can subset elements of a list exactly the same was as atomic
vectors using `[`. Comparison operations however won't work as
they're not recursive, they will try to condition on the data structures
in each element of the list, not the individual elements within those
data structures.


~~~sourcecode
xlist[1:2]
~~~



~~~output
$a
[1] "Research Bazaar"

$b
 [1]  1  2  3  4  5  6  7  8  9 10

~~~

To extract individual elements of a list, you need to use the double-square
bracket function: `[[`.


~~~sourcecode
xlist[[1]]
~~~



~~~output
[1] "Research Bazaar"

~~~

Notice that now the result is a vector, not a list.

You can't extract more than one element at once:


~~~sourcecode
xlist[[1:2]]
~~~



~~~err
Error in xlist[[1:2]]: subscript out of bounds

~~~

Nor use it to skip elements:


~~~sourcecode
xlist[[-1]]
~~~



~~~err
Error in xlist[[-1]]: attempt to select more than one element in get1index <real>

~~~

But you can use names to both subset and extract elements:


~~~sourcecode
xlist[["a"]]
~~~



~~~output
[1] "Research Bazaar"

~~~

The `$` function is a shorthand way for extracting elements by name:


~~~sourcecode
xlist$data
~~~



~~~output
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa

~~~

<!--sec data-title="Challenge 5" data-id="ch5" data-show=true data-collapse=false ces-->


~~~sourcecode
xlist <- list(a = "Research Bazaar", b = 1:10, data = head(iris))
~~~

Using your knowledge of both list and vector subsetting, extract the number 2 from xlist.  Hint: the number 2 is contained within the "b" item in the list.

<!--endsec-->

<!--sec data-title="Challenge 6" data-id="ch6" data-show=true data-collapse=false ces-->

Given a linear model:


~~~sourcecode
mod <- aov(intellect ~ education, data=titanic)
~~~

Extract the residual degrees of freedom (hint: `attributes()` will help you)

<!--endsec-->

<br>

---

## Data frames

Remember the data frames are lists underneath the hood, so similar rules
apply. However they are also two dimensional objects:

`[` with one argument will act the same was as for lists, where each list
element corresponds to a column. The resulting object will be a data frame:


~~~sourcecode
head(healthData[3])
~~~



~~~output
                                          Name
1                             Kelly, Mr. James
2             Wilkes, Mrs. James (Ellen Needs)
3                    Myles, Mr. Thomas Francis
4                             Wirz, Mr. Albert
5 Hirvonen, Mrs. Alexander (Helga E Lindqvist)
6                   Svensson, Mr. Johan Cervin

~~~

Similarly, `[[` will act to extract *a single column*:


~~~sourcecode
head(healthData[["health"]])
~~~



~~~output
NULL

~~~

And `$` provides a convenient shorthand to extract columns by name:


~~~sourcecode
head(healthData$birthYear)
~~~



~~~output
NULL

~~~

With two arguments, `[` behaves the same way as for matrices:


~~~sourcecode
healthData[1:3,]
~~~



~~~output
  PassengerId Pclass                             Name    Sex  Age SibSp
1         892      3                 Kelly, Mr. James   male 34.5     0
2         893      3 Wilkes, Mrs. James (Ellen Needs) female 47.0     1
3         894      2        Myles, Mr. Thomas Francis   male 62.0     0
  Parch Ticket   Fare Cabin Embarked
1     0 330911 7.8292              Q
2     0 363272 7.0000              S
3     0 240276 9.6875              Q

~~~

If we subset a single row, the result will be a data frame (because
the elements are mixed types):


~~~sourcecode
healthData[3,]
~~~



~~~output
  PassengerId Pclass                      Name  Sex Age SibSp Parch Ticket
3         894      2 Myles, Mr. Thomas Francis male  62     0     0 240276
    Fare Cabin Embarked
3 9.6875              Q

~~~

But for a single column the result will be a vector (this can
be changed with the third argument, `drop = FALSE`).

<!--sec data-title="Challenge 7" data-id="ch7" data-show=true data-collapse=false ces-->

Fix each of the following common data frame subsetting errors:

1. Extract observations collected for birth year = 1909
    
    ~~~sourcecode
    healthData[healthData$birthYear = 1909,]
    ~~~

2. Extract all columns except 1 through to 4
    
    ~~~sourcecode
    healthData[,-1:4]
    ~~~

3. Extract the rows where the health metric is greater than 7
    
    ~~~sourcecode
    healthData[healthData$health > 7]
    ~~~

4. Extract the first row, and the fourth and fifth columns (`intellect` and `agreeableness`).
    
    ~~~sourcecode
    healthData[1, 4, 5]
    ~~~

5. Advanced: extract rows that contain information for those in education level 7 and 9
    
    ~~~sourcecode
    healthData[healthData$education == 7 | 9,]
    ~~~

<!--endsec-->

<!--sec data-title="Challenge 8" data-id="ch8" data-show=true data-collapse=false ces-->

1. Why does `healthData[1:20]` return an error? How does it differ from `healthData[1:20, ]`?

2. Create a new `data.frame` called `healthData_small` that only contains rows 1 through 9 and 19 through 23. You can do this in one or two steps.

<!--endsec-->

---

<br>

## Challenge solutions

<!--sec data-title="Solution to Challenge 1" data-id="ch1sol" data-show=true data-collapse=true ces-->

Given the following code:


~~~sourcecode
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
print(x)
~~~



~~~output
  a   b   c   d   e 
5.4 6.2 7.1 4.8 7.5 

~~~

1. Come up with at least 3 different commands that will produce the following output:


~~~output
  b   c   d 
6.2 7.1 4.8 

~~~


~~~sourcecode
x[2:4] 
x[-c(1,5)]
x[c("b", "c", "d")]
x[c(2,3,4)]
~~~

<!--endsec-->

<!--sec data-title="Solution to Challenge 2" data-id="ch2sol" data-show=true data-collapse=true ces-->

Run the following code to define vector `x` as above:


~~~sourcecode
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c('a', 'b', 'c', 'd', 'e')
print(x)
~~~



~~~output
  a   b   c   d   e 
5.4 6.2 7.1 4.8 7.5 

~~~

Given this vector `x`, what would you expect the following to do?

~~~sourcecode
x[-which(names(x) == "g")]
~~~

Try out this command and see what you get. Did this match your expectation?

Why did we get this result? (Tip: test out each part of the command on it's own like we just did above - this is a useful debugging strategy)

Which of the following are true:

* A) if there are no `TRUE` values passed to "which", an empty vector is returned
* B) if there are no `TRUE` values passed to "which", an error message is shown
* C) `integer()` is an empty vector
* D) making an empty vector negative produces an "everything" vector
* E) `x[]` gives the same result as `x[integer()]`

Answer: A and C are correct.

The `which` command returns the index of every `TRUE` value in its input. The `names(x) == "g"` command didn't return any `TRUE` values. Because there were no `TRUE` values passed to the `which` command, it returned an empty vector. Negating this vector with the minus sign didn't change its meaning. Because we used this empty vector to retrieve values from `x`, it produced an empty numeric vector. It was a `named numeric` empty vector because the vector type of x is "named numeric" since we assigned names to the values (try `str(x)` ).

<!--endsec-->

<!--sec data-title="Solution to Challenge 4" data-id="ch4sol" data-show=true data-collapse=true ces-->

Given the following code:


~~~sourcecode
m <- matrix(1:18, nrow=3, ncol=6)
print(m)
~~~



~~~output
     [,1] [,2] [,3] [,4] [,5] [,6]
[1,]    1    4    7   10   13   16
[2,]    2    5    8   11   14   17
[3,]    3    6    9   12   15   18

~~~

1. Which of the following commands will extract the values 11 and 14?

A. `m[2,4,2,5]`

B. `m[2:5]`

C. `m[4:5,2]`

D. `m[2,c(4,5)]`

Answer: D

<!--endsec-->

<!--sec data-title="Solution to Challenge 5" data-id="ch5sol" data-show=true data-collapse=true ces-->

Given the following list:


~~~sourcecode
xlist <- list(a = "Research Bazaar", b = 1:10, data = head(iris))
~~~

Using your knowledge of both list and vector subsetting, extract the number 2 from xlist. Hint: the number 2 is contained within the "b" item in the list.


~~~sourcecode
xlist$b[2]
xlist[[2]][2]
xlist[["b"]][2]
~~~

<!--endsec-->

<!--sec data-title="Solution to Challenge 6" data-id="ch6sol" data-show=true data-collapse=true ces-->

Given a linear model:


~~~sourcecode
mod <- aov(intellect ~ education, data=healthData)
~~~



~~~err
Error in eval(expr, envir, enclos): object 'intellect' not found

~~~

Extract the residual degrees of freedom (hint: `attributes()` will help you)


~~~sourcecode
attributes(mod) ## `df.residual` is one of the names of `mod`
mod$df.residual
~~~

<!--endsec-->

<!--sec data-title="Solution to Challenge 7" data-id="ch7sol" data-show=true data-collapse=true ces-->

Fix each of the following common data frame subsetting errors:

1. Extract observations collected for birth year = 1909
    
    ~~~sourcecode
    # healthData[healthData$birthYear = 1909,]
    healthData[healthData$birthYear == 1909,]
    ~~~

2. Extract all columns except 1 through to 4
    
    ~~~sourcecode
    # healthData[,-1:4]
    healthData[,-c(1:4)]
    ~~~

3. Extract the rows where the health metric is greater than 7
    
    ~~~sourcecode
    # healthData[healthData$health > 7]
    healthData[healthData$health > 7,]
    ~~~

4. Extract the first row, and the fourth and fifth columns (`intellect` and `agreeableness`).
    
    ~~~sourcecode
    # healthData[1, 4, 5]
    healthData[1, c(4, 5)]
    ~~~

5. Advanced: extract rows that contain information for those in education level 7 and 9
    
    ~~~sourcecode
    # healthData[healthData$education == 7 | 9,]
    healthData[healthData$education == 7 | healthData$education == 9,]
    healthData[healthData$education %in% c(7, 9),]
    ~~~

<!--endsec-->

<!--sec data-title="Solution to Challenge 8" data-id="ch8sol" data-show=true data-collapse=true ces-->

1. Why does `healthData[1:20]` return an error? How does it differ from `healthData[1:20, ]`?

    Answer: `healthData` is a data.frame so needs to be subsetted on two dimensions. `healthData[1:20, ]` subsets the data to give the first 20 rows and all columns.

2. Create a new `data.frame` called `healthData_small` that only contains rows 1 through 9 and 19 through 23. You can do this in one or two steps.


~~~sourcecode
healthData_small <- healthData[c(1:9, 19:23),]
~~~

<!--endsec-->
