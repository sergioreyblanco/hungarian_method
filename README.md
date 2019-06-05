# Implementation of the Hungarian Method in R language

Here is a very simple implementation of the Hungarian Method in R language. It is used to solve assignment problems where a set of elements have to be asigned to an amount of other elements. An example of this type of problem can be found in the following image (which corresponds to the `example1`, in the terminology of the code developed):

![alt text](https://github.com/sergioreyblanco/hungarian_method/blob/master/example1.PNG)

The whole algorithm is implementated in the function `assignmentSolver`. It is divided in four well diferenced steps: caculation of the reduced matrix, the strikethrough crossed out of zeros, the update of the reduced matrix and the final gathering of the solution found. Moreover, this main function named `assignmentSolver` uses one auxiliary function called `solutionChecking`. Its usefulness is that of checking that the solution gathered is valid.

An instance of this function execution with `example1` (using the terminology of the code) as input data is shown here: 

![alt text](https://github.com/sergioreyblanco/hungarian_method/blob/master/execution.PNG)

The function takes as an input parameter a representation of a graph in the way of a matrix where each row is one element of the first set and each column represents one element of the second set. Thus, no assignment between elements of the same set or one with itself can be made. The introduced matrix must be a square one, so the method of the big `M` is used when there are less elements in the first set than in the second one, or viceversa. Each cell represents the profit (or cost) of assigning the corresponding element of the first set with other in the second one. Again, if one assingment between elements is not possible because of circumstances of the problem itself, an `M` is put in the corresponding cell. The function gives a return value consisting of a list with two components in which the first is the optimal assignment found and the other is the profit/cost of that assignment.

Example matrices are given (located in the last part of the code after the functions). Thus, you can test the function and create new ones. The first example matrix will result in a graph like this one: 

![alt text](https://github.com/sergioreyblanco/dijkstra_algorithm/blob/master/example1.png)

The code does not need any additional libraries to run, besides the classical R environment.
