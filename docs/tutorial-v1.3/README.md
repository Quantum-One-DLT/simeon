
<p align="center">
  <img width="266" height="185" src="pix/logo.png">
</p>


# Simeon 1.3 tutorials


This document gives an overview of a set of Simeon tutorials.

> __Important note:__ these tutorials address Simeon 1.3, which 
> is the version implemented in the current version of Meadow,
> and is covered in the ISoLA paper. This version is tagged as **v1.3**
> and is available here: [https://github.com/The-Blockchain-Company/simeon/tree/v1.3](https://github.com/The-Blockchain-Company/simeon/tree/v1.3).
>
> These tutorials are [also available for Simeon 2.0](../tutorial-v2.0/README.md), which irons out
> a number of infelicities in 1.3, and the Simeon Playground (as Meadow is now called).

##  [Introducing Simeon](./introducing-simeon.md)

This tutorial gives an overview of the ideas behind Simeon, as a domain-specific languages embedded in Haskell. It also introduces commitments and timeouts, which are central to how Simeon works in a blockchain context. 

## [A first example: the escrow contract](./escrow-ex.md)

This tutorial introduces a simple financial contract in pseudocode, before explaining how it is modified to work in Simeon, giving the first example of a Simeon contract.

## [Simeon as a Haskell data type](./simeon-data.md)

This tutorial formally introduces Simeon as a Haskell data type, building on the escrow example in the previous tutorial. It also describes the different types used by the model, as well as discussing a number of assumptions about the infrastructure in which contracts will be run.

## [Understanding the semantics](./simeon-semantics.md)

This tutorial gives a formal semantics for Simeon by presenting a Haskell definition of the semantic `step` function, so that we have a _semantics that we can execute_. 

## [Embedded Simeon](./embedded-simeon.md)

This tutorial shows how to use some simple features of Haskell to write Simeon contracts that are more readable, maintainable and reusable, by revisiting the  escrow contract.

## [Using Simeon](./using-simeon.md)

This tutorial shows you how to use Simeon from within Haskell, and in particular shows how to exercise a contract using the semantics given in the [earlier tutorial](./simeon-semantics.md).

## [Meadow overview](./meadow-overview.md) 

This tutorial introduces Meadow, and is accompanied by a video. Once you have followed this video you will be able to use Meadow to interact with the escrow and other Meadow contracts.

<!--
## [Other functions in Simeon: analysis](./analysis.md)

This tutorial shows how Simeon contracts can be analysed _without_ having to be executed. This made much easier because Simeon is a special-purpose DSL, rather than a general-purpose language like Zerepoch.
-->

## [ACTUS and Simeon](./actus-simeon.md)

This tutorial gives an introduction to the general idea of the ACTUS taxonomy, plus examples implemented in Simeon (including the PAM contract).

## [Implementing Simeon in Zerepoch](./simeon-zerepoch.md)

So far these tutorials have dealt with Simeon as a “stand alone” artefact; this tutorial describes how Simeon is implemented on blockchain, using the “mockchain” that provides a high-fidelity simulation of the Bcc SL layer.

