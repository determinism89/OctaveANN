OctaveANN
================

A basic neural network class for Octave suporting stochastic and batch gradient descent.

Originally written for use in the [Kaggle Digit Recognition Challenge](http://www.kaggle.com/c/digit-recognizer).



Author: John Alexander III

Contact: johnaudleyalexanderiii at gmail dot com

Directory
---------

`@ann\`   - Class directory of the ann feed forward neural network.

Methods
-------

`@ann\ann`      - Constructor method for the ann class.

`@ann\get`      - Returns ann class properties.

`@ann\set`      - Sets ann class properties.

`@ann\train`    - Trains the ann class instance via either stochastic or batch gradient descent for a specified number of epochs.

`@ann\test`     - Returns the percentage of correct classifications in the training set.

`@ann\classify` - Classifies a data set (Specific to the Kaggle Digit Challenge)


Troubleshooting
---------------

Accessing the help string from the command prompt:

```matlab

>>help @ann\[METHOD]

```

Where [METHOD] may be any class method, including the constructor method 'ann'.


Usage
------

```matlab

>>% Creating an ann instance with two hidden layers. Here the input dimension is 784, and
>>% classification dimension is 10. The hidden layers contain 200 and 20 nodes respectively.

>>A = ann([784,200,20,10])

```



