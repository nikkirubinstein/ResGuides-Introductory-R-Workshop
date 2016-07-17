


# Seeking help

<!--sec data-title="Learning Objectives" data-id="obj" data-show=true data-collapse=false ces-->

* To be able read R help files for functions and special operators.
* To be able to use CRAN task views to identify packages to solve a problem.
* To be able to seek help from your peers

<!--endsec-->

<br>

---

**Table of Contents**

<!-- toc -->

<br>

---


## Reading Help files

R, and every package, provide help files for functions. To search for help on a
function from a specific function that is in a package loaded into your
namespace (your interactive R session):


~~~sourcecode
?function_name
help(function_name)
~~~

This will load up a help page in RStudio (or as plain text in R by itself).

Each help page is broken down into sections:

 - Description: An extended description of what the function does.
 - Usage: The arguments of the function and their default values.
 - Arguments: An explanation of the data each argument is expecting.
 - Details: Any important details to be aware of.
 - Value: The data the function returns.
 - See Also: Any related functions you might find useful.
 - Examples: Some examples for how to use the function.

Different functions might have different sections, but these are the main ones you should be aware of.

<!--sec data-title="Tip: Reading help files" data-id="tip1" data-show=true data-collapse=true ces-->

One of the most daunting aspects of R is the large number of functions available. It would be prohibitive, if not impossible to remember the correct usage for every function you use. Luckily, the help files mean you don't have to!

<!--endsec-->

<br>

---

## Special Operators

To seek help on special operators, use quotes:


~~~sourcecode
?"+"
~~~

<br>

---

## Getting help on packages

Many packages come with "vignettes": tutorials and extended example documentation.
Without any arguments, `vignette()` will list all vignettes for all installed packages;
`vignette(package="package-name")` will list all available vignettes for
`package-name`, and `vignette("vignette-name")` will open the specified vignette.

If a package doesn't have any vignettes, you can usually find help by typing
`help("package-name")`.

<br>

---

## When you kind of remember the function

If you're not sure what package a function is in, or how it's specifically spelled you can do a fuzzy search:


~~~sourcecode
??function_name
~~~

<br>

---

## When you have no idea where to begin

If you don't know what function or package you need to use
[CRAN Task Views](http://cran.at.r-project.org/web/views)
is a specially maintained list of packages grouped into
fields. This can be a good starting point.

<br>

---

## When your code doesn't work: seeking help from your peers

If you're having trouble using a function, 9 times out of 10,
the answers you are seeking have already been answered on
[Stack Overflow](http://stackoverflow.com/). You can search using
the `[r]` tag.

If you can't find the answer, there are a few useful functions to
help you ask a question from your peers:


~~~sourcecode
?dput
~~~

Will dump the data you're working with into a format so that it can
be copy and pasted by anyone else into their R session.


~~~sourcecode
sessionInfo()
~~~



~~~output
R version 3.3.1 (2016-06-21)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Debian GNU/Linux 8 (jessie)

locale:
 [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
 [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
 [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
[10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

attached base packages:
[1] stats     graphics  grDevices utils     datasets  base     

other attached packages:
[1] knitr_1.13

loaded via a namespace (and not attached):
[1] magrittr_1.5  formatR_1.4   tools_3.3.1   stringi_1.1.1 methods_3.3.1
[6] stringr_1.0.0 evaluate_0.9 

~~~

Will print out your current version of R, as well as any packages you
have loaded. This can be useful for others to help reproduce and debug
your issue.

<!--sec data-title="Challenge 1" data-id="ch1" data-show=true data-collapse=false ces-->

Look at the help for the `c` function. What kind of vector do you expect you will create if you evaluate the following: 

~~~sourcecode
> c(1, 2, 3)
> c('d', 'e', 'f')
> c(1, 2, 'f')`
~~~

<!--endsec-->

<!--sec data-title="Challenge 2" data-id="ch2" data-show=true data-collapse=false ces-->

Look at the help for the `paste` function. You'll need to use this later.  What is the difference between the `sep` and `collapse` arguments?

<!--endsec--> 

<!--sec data-title="Challenge 3" data-id="ch3" data-show=true data-collapse=false ces-->

Use help to find a function (and its associated parameters) that you could use to load data from a csv file in which columns are delimited with "\t" (tab) and the decimal point is a "." (period). This check for decimal separator is important, especially if you are working with international colleagues, because different countries have different conventions for the decimal point (i.e. comma vs period).
hint: use `??csv` to lookup csv related functions.

<!--endsec-->

<br>

---

## Other ports of call

* [Quick R](http://www.statmethods.net/)
* [RStudio cheat sheets](http://www.rstudio.com/resources/cheatsheets/)
* [Cookbook for R](http://www.cookbook-r.com/)

<br>

---

## Challenge solutions

<!--sec data-title="Solution to Challenge 1" data-id="ch1sol" data-show=true data-collapse=true ces-->

The `c()` function creates a vector, in which all elements are the same type. In the first case, the elements are numeric, in the second, they are characters, and in the third they are characters: the numeric values "coerced" to be characters.

<!--endsec-->

<!--sec data-title="Solution to Challenge 2" data-id="ch2sol" data-show=true data-collapse=true ces-->

Look at the help for the `paste` function. You'll need to use this later. 
 

~~~sourcecode
> help("paste")
> ?paste
~~~

<!--endsec-->

