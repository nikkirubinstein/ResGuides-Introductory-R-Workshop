
```{r include = FALSE}
source("../tools/chunk-options.R")
```

# Creating functions

```{r, include=FALSE}
# Silently load in the data so the rest of the lesson works
titanic <- read.csv("https://goo.gl/4Gqsnz", header=TRUE)
```

<!--sec data-title="Learning Objectives" data-id="obj" data-show=true data-collapse=false ces-->

* Define a function that takes arguments.
* Return a value from a function.
* Test a function.
* Set default values for function arguments.
* Explain why we should divide programs into small, single-purpose functions.

<!--endsec-->

<br>

---

**Table of Contents**

<!-- toc -->

<br>

---

If we only had one data set to analyze, it would probably be faster to load the file into a spreadsheet and use that to plot simple statistics. However, data 
may be updated periodically, and we may want to pull in that new
information later and re-run our analysis again. We may also obtain similar data
from a different source in the future.

In this lesson, we'll learn how to write a function so that we can repeat
several operations with a single command.

<br>

---

## What is a function? 

Functions gather a sequence of operations into a whole, preserving it for ongoing use. Functions provide:

* a name we can remember and invoke it by
* relief from the need to remember the individual operations
* a defined set of inputs and expected outputs
* rich connections to the larger programming environment

As the basic building block of most programming languages, user-defined functions constitute "programming" as much as any single abstraction can. If you have written a function, you are a computer programmer.

<br>

---

## Defining a function

Let's open a new R script file in the `functions/` directory and call it functions-lesson.R.

```{r}
my_sum <- function(a, b) {
  the_sum <- a + b
  return(the_sum)
}
```

Let’s define a function fahr_to_kelvin that converts temperatures from Fahrenheit to Kelvin:

<!-- all of the boredom-->
```{r}
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
```

We define `fahr_to_kelvin` by assigning it to the output of `function`.
The list of argument names are contained within parentheses.
Next, the body of the function--the statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces.
This makes the code easier to read but does not affect how the code operates.

When we call the function, the values we pass to it are assigned to those variables so that we can use them inside the function.
Inside the function, we use a return statement to send a result back to whoever asked for it.

<!--sec data-title="Tip: The return statement" data-id="tip1" data-show=true data-collapse=true ces-->

One feature unique to R is that the return statement is not required. R automatically returns whichever variable is on the last line of the body of the function. Since we are just learning, we will explicitly define the return statement.

<!--endsec-->

Let's try running our function.
Calling our own function is no different from calling any other function:

```{r}
# freezing point of water
fahr_to_kelvin(32)
```

```{r}
# boiling point of water
fahr_to_kelvin(212)
```

<!--sec data-title="Challenge 1" data-id="ch1" data-show=true data-collapse=false ces-->

Write a function called `kelvin_to_celsius` that takes a temperature in Kelvin and returns that temperature in Celsius

Hint: To convert from Kelvin to Celsius you minus 273.15

<!--endsec-->

<br>

---

## Combining functions

The real power of functions comes from mixing, matching and combining them
into ever large chunks to get the effect we want.

Let's define two functions that will convert temperature from Fahrenheit to
Kelvin, and Kelvin to Celsius:

```{r}
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}

kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}
```

<!--sec data-title="Challenge 2" data-id="ch2" data-show=true data-collapse=false ces-->

Define the function to convert directly from Fahrenheit to Celsius, by reusing the two functions above (or using your own functions if you prefer).

<!--endsec-->

<br>

---

## Applying functions to datasets

We're going to define
a function that calculates the average age in our titanic dataset:

```{r}
# Takes a dataset and calculates the average year of birth
calcAgeAverage <- function(dat) {
  ageAverage <- mean(dat$Age, na.rm = TRUE)
  return(ageAverage)
}
```

Note, that because there are missing values in the dataset (`NA`s), we need to set the argument `na.rm=TRUE`, when calculating the mean.

We define `calcAgeAverage` by assigning it to the output of `function`.
The list of argument names are contained within parentheses.
Next, the body of the function -- the statements executed when you
call the function -- is contained within curly braces (`{}`).

We've indented the statements in the body by two spaces. This makes
the code easier to read but does not affect how it operates.

When we call the function, the values we pass to it are assigned
to the arguments, which become variables inside the body of the
function.

Inside the function, we use the `return` function to send back the
result. This return function is optional: R will automatically
return the results of whatever command is executed on the last line
of the function.


```{r}
calcAgeAverage(titanic)
```

Now, let's add another argument so we can calculate the average age for a particular gender.

```{r}
# Takes a dataset and calculates the average age for a
# specified gender
calcAgeAverage <- function(dat, sex = "female") {
  ageAverage <- mean(dat[dat$Sex == sex, ]$Age, na.rm = TRUE)
  return(ageAverage)
}
```

If you've been writing these functions down into a separate R script
(a good idea!), you can load in the functions into our R session by using the
`source` function:

```{r, eval=FALSE}
source("functions/functions-lesson.R")
```

The function now subsets the provided data by sex before taking the average age. A default value of "female" is given for sex, so that if no value is specified when you call the function, the result of the function will be for females. You need to be careful when setting default values; sometimes you can get some unexpected behaviour from functions if you don't realise that an argument has a default value.

Let's take a look at what happens when we specify the gender:

```{r}
calcAgeAverage(titanic,"female")
calcAgeAverage(titanic,"male")
calcAgeAverage(titanic)
```

What if we want to look at the average age for specific passenger classes?

<!--sec data-title="Challenge 3" data-id="ch3" data-show=true data-collapse=false ces-->

Define the function to calculate the average age for specific classes of a single sex. Hint: Look up the function %in%, which will allow you to subset by multiple classes.
 
 <!--endsec-->

<!--sec data-title="Tip: Pass by value" data-id="tip2" data-show=true data-collapse=true ces-->

Functions in R almost always make copies of the data to operate on inside of a function body. If we were to modify `dat` inside the function we are modifying the copy of the titanic dataset stored in `dat`, not the original variable we gave as the first argument.

This is called "pass-by-value" and it makes writing code much safer: you can always be sure that whatever changes you make within the body of the function, stay inside the body of the function.

<!--endsec-->

<!--sec data-title="Tip: Function scope" data-id="tip3" data-show=true data-collapse=true ces-->

Another important concept is scoping: any variables (or functions!) you create or modify inside the body of a function only exist for the lifetime of the function's execution. When we call `calcAgeAverage`, the variables `dat`, `sex` and `ageAverage` only exist inside the body of the function. Even if we have variables of the same name in our interactive R session, they are not modified in any way when executing a function.

<!--endsec-->

<!--sec data-title="Challenge 4" data-id="ch4" data-show=true data-collapse=false ces-->

The `paste` function can be used to combine text together, e.g:

```{r}
best_practice <- c("Write", "programs", "for", "people", "not", "computers")
paste(best_practice, collapse=" ")
```

Write a function called `fence` that takes two vectors as arguments, called `text` and `wrapper`, and prints out the text wrapped with the `wrapper`:

```{r, eval=FALSE}
fence(text=best_practice, wrapper="***")
```

*Note:* the `paste` function has an argument called `sep`, which specifies thevseparator between text. The default is a space: " ". The default for `paste0` is no space "".

<!--endsec-->

<!--sec data-title="Tip: R environments" data-id="tip4" data-show=true data-collapse=true ces-->

R has some unique aspects that can be exploited when performing more complicated operations. We will not be writing anything that requires knowledge of these more advanced concepts. In the future when you are comfortable writing functions in R, you can learn more by reading the [R Language Manual][man] or this [chapter][] from [Advanced R Programming][adv-r] by Hadley Wickham. For context, R uses the terminology "environments" instead of frames.

[man]: http://cran.r-project.org/doc/manuals/r-release/R-lang.html#Environment-objects
[chapter]: http://adv-r.had.co.nz/Environments.html
[adv-r]: http://adv-r.had.co.nz/

<!--endsec-->

<!--sec data-title="Tip: Testing and documenting" data-id="tip5" data-show=true data-collapse=true ces-->

It's important to both test functions and document them:
Documentation helps you, and others, understand what the
purpose of your function is, and how to use it, and its
important to make sure that your function actually does
what you think.

When you first start out, your workflow will probably look a lot
like this:

  1. Write a function
  2. Comment parts of the function to document its behaviour
  3. Load in the source file
  4. Experiment with it in the console to make sure it behaves
     as you expect
  5. Make any necessary bug fixes
  6. Rinse and repeat.

Formal documentation for functions, written in separate `.Rd` files, gets turned into the documentation you see in help files. The [roxygen2][] package allows R coders to write documentation alongside the function code and then process it into the appropriate `.Rd` files. You will want to switch to this more formal method of writing documentation when you start writing more complicated R projects.

Formal automated tests can be written using the [testthat][] package.

[roxygen2]: http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html
[testthat]: http://r-pkgs.had.co.nz/tests.html

<!--endsec-->

<br>

---

## Challenge solutions

<!--sec data-title="Solution to Challenge 1" data-id="ch1sol" data-show=true data-collapse=true ces-->

Write a function called `kelvin_to_celsius` that takes a temperature in Kelvin and returns that temperature in Celsius

```{r}
kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}
```

<!--endsec-->

<!--sec data-title="Solution to Challenge 2" data-id="ch2sol" data-show=true data-collapse=true ces-->

Define the function to convert directly from Fahrenheit to Celsius, by reusing these two functions above

```{r}
fahr_to_celsius <- function(temp) {
   temp_k <- fahr_to_kelvin(temp)
   result <- kelvin_to_celsius(temp_k)
   return(result)
}
```

<!--endsec-->

<!--sec data-title="Solution to Challenge 3" data-id="ch3sol" data-show=true data-collapse=true ces-->

Define the function to calculate the average year of birth for specific year  levels of a single study group. Hint: Look up the function %in%, which will allow you to subset by multiple  year levels

```{r}
calcAgeAverage <- function(dat, sex, class) {
   ageAverage <- mean(dat[dat$Sex == sex & dat$Pclass %in% class, ]$Age, na.rm = TRUE)
   return(ageAverage)
}
```

<!--endsec-->

<!--sec data-title="Solution to Challenge 4" data-id="ch4sol" data-show=true data-collapse=true ces-->

 Write a function called `fence` that takes two vectors as arguments, called `text` and `wrapper`, and prints out the text wrapped with the `wrapper`:

```{r}
fence <- function(text, wrapper){
   text <- c(wrapper, text, wrapper)
   result <- paste(text, collapse = " ")
   return(result)
}
best_practice <- c("Write", "programs", "for", "people", "not", "computers")
fence(text=best_practice, wrapper="***")
```

<!--endsec-->