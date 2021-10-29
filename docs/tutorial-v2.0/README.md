
<p align="center">
  <img width="266" height="185" src="pix/logo.png">
</p>


# Simeon 2.0 tutorials


This document gives an overview of a set of Simeon tutorials.

> __Important note:__ these tutorials address the current version of Simeon,  2.0, which irons out
> a number of infelicities in earlier versions. Simeon 2.0 is implemented in the _Simeon Playground_, available [here](https://prod.meadow.simeon.tbcodev.io).
>
> The version covered in the ISoLA paper, and supported in the original version of Meadow that includes Blockly, is tagged as **v1.3**
> and is available [here](https://github.com/The-Blockchain-Company/simeon/tree/v1.3). 
>


##  [Introducing Simeon](./introducing-simeon.md)

This tutorial gives an overview of the ideas behind Simeon, as a domain-specific language embedded in Haskell. It also introduces commitments and timeouts, which are central to how Simeon works in a blockchain context. 

## [A first example: the escrow contract](./escrow-ex.md)

This tutorial introduces a simple financial contract in pseudocode, before explaining how it is modified to work in Simeon, giving the first example of a Simeon contract.


## [Simeon as a Haskell data type](./simeon-data.md)

This tutorial formally introduces Simeon as a Haskell data type, building on the escrow example in the previous tutorial. It also describes the different types used by the model, as well as discussing a number of assumptions about the infrastructure in which contracts will be run.

## [Understanding the semantics](./simeon-semantics.md)

This tutorial gives an introduction to the formal semantics of Simeon by presenting an overview of the key Haskell definitions that interpret inputs and transactions, as well as fitting those into a schematic overview of how the components of the semantics work together.

## [Embedded Simeon](./embedded-simeon.md)

This tutorial shows how to use some simple features of Haskell to write Simeon contracts that are more readable, maintainable and reusable, by revisiting the  escrow contract.


## [Using Simeon](./using-simeon.md)

This tutorial shows you how to use Simeon from within Haskell, and in particular shows how to exercise a contract using the semantics given in the [earlier tutorial](./simeon-semantics.md).


## [The Simeon Playground](./playground-overview.md) 

This tutorial introduces the Simeon Playground, an online tool for creating embedded Simeon contracts and interactively stepping through their execution.

<!--
## [Other functions in Simeon: analysis](./analysis.md)

This tutorial shows how Simeon contracts can be analysed _without_ having to be executed. This made much easier because Simeon is a special-purpose DSL, rather than a general-purpose language like Zerepoch.
-->

## [ACTUS and Simeon](./actus-simeon.md)

This tutorial gives an introduction to the general idea of the ACTUS taxonomy, plus examples implemented in Simeon.

## [Implementing Simeon in Zerepoch](./simeon-zerepoch.md)

So far these tutorials have dealt with Simeon as a “stand alone” artefact; this tutorial describes how Simeon is implemented on blockchain, using the “mockchain” that provides a high-fidelity simulation of the Bcc SL layer.

