# Creating your own lessons

Follow these instructions to create you own `ResGuides` lesson using this book as a template. 

##Step 1: github

Create a __copy__ of this repository in using the github [importer](https://github.com/new/import). Make sure to give your new lesson a new name, e.g. `ResGuides: Data Science with Python`


##Step 2: gitbook.

Go to [gitbook.com](gitbook.com), and then click `new book`. This bit is __important__: in the new book window cmake sure you choose the github option in the top menu. Now scroll down and select the new github repository you set up.

Nice work. This should have set up the webhooks needed to update your gitbook from github. Let's check that by adding some content.


##Step 3: Adding content

 From your gitbook.com dashboard (e.e. https://www.gitbook.com/@dansand/dashboard) click on you newly created book. This takes you to the book's `detail`s page: (e.g. https://www.gitbook.com/book/dansand/gitbookgitbook/details).
 
 There is an edit icon, which will allow you to edit content. 

##Step 4: Marking it Down

[Markdown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)



__Maths__

{% math %}
 {\partial{\bf u}\over{\partial t}} + ({\bf u} \cdot \nabla) {\bf u} = - {1\over\rho} \nabla p + \gamma\nabla^2{\bf u} + {1\over\rho}{\bf F} 
{% endmath %}


__code__

Render different languages with eg. 

<div>
```python 

your code here...

```
</div>

```python
def FFT(x):
    """A recursive implementation of the 1D Cooley-Tukey FFT"""
    x = np.asarray(x, dtype=float)
    N = x.shape[0]
    
    if N % 2 > 0:
        raise ValueError("size of x must be a power of 2")
    elif N <= 32:  # this cutoff should be optimized
        return DFT_slow(x)
    else:
        X_even = FFT(x[::2])
        X_odd = FFT(x[1::2])
        factor = np.exp(-2j * np.pi * np.arange(N) / N)
        return np.concatenate([X_even + factor[:N / 2] * X_odd,
                               X_even + factor[N / 2:] * X_odd])

```

##Step 5: Book layout 

Your book will automatically have file called SUMMARY.md and place it in the docs directory. This is what dictates the contents tree of the book (or autogenerate). It looks a bit like this:

```
# Table of content 
* [Getting Started](docs/getting-started.md)
* [API Reference](docs/api-reference.md)
```



##Step 6: Configuration and plugins

When you are in the online editor on gitbook.com, there is a dropdown icon at thefar riht of the screen. Click on this an then on `plugins store`. Selecting a plugins will have two effects: First it will create a book.json in the project’s root. This is used by Gitbook for its settings. Second it will add the plugin you selected by pasting the required json snippet into the book.json file. 


```json
{
    "plugins": ["mathjax"]
}

```

##Step 7: When builds go wrong


###Links, blogs, resources

[](https://medium.com/@gpbl/how-to-use-gitbook-to-publish-docs-for-your-open-source-npm-packages-465dd8d5bfba#.acdr3enfr)



[download this file](https://raw.githubusercontent.com/dansand/Python/master/data/europe-seasonal.txt)

