
# Learning about Simeon and the Simeon Playground

Simeon is a domain-specific language (DSL) for writing financial contracts that run on blockchain. 

The best place to go to learn about Simeon and to try it out is the [Simeon Playground](https://david.simeon.tbcodev.io/), which also contains a [tutorial](https://david.simeon.tbcodev.io/tutorial/) about Simeon.

## Earlier versions of Simeon

This document describes the different materials available for learning about Simeon and the online tool that accompanies it: the Simeon Playground. originally called Meadow. It also advises you where to begin, depending on what you want to learn, and where you are starting from.

Simeon is realised as DSL embedded in Haskell, but it is possible to use Simeon without being a Haskell expert. Simeon is a live project, and the materials here describe two versions of Simeon: the earlier [version 1.3]( https://github.com/The-Blockchain-Company/simeon/tree/v1.3), and the [current version](https://github.com/The-Blockchain-Company/simeon/tree/master/semantics-2.0), 2.0.

The Simeon Playground is also available in two versions:

* It was originally called [Meadow](https://The-Blockchain-Company.github.io/simeon/) supports v1.3, and this version supports contract development using Blockly, a visual programming environment. It also supports the development of “embedded” contracts using aspects of Haskell, but because this runs a Haskell environment in the browser, it has a substantial latency.

* The latest version, the [Simeon Playground](https://prod.meadow.simeon.tbcodev.io), supports development of embedded contracts is a much more efficient way, as well as presenting a substantially cleaner interface, but doesn't currently support visual program development.

## Where should I start?

I want to learn the ideas behind Simeon, but not to write Simeon contracts myself.

* The first parts of the [tutorial](./tutorial-v1.3/README.md) and the [Udemy course](https://www.udemy.com/simeon-programming-language/) will give you this introduction.

I want to learn how to write simple Simeon contracts, and to run them in the Meadow tool.

* The [Udemy course](https://www.udemy.com/simeon-programming-language/)  and [tutorial](./tutorial-v1.3/README.md) will give you an introduction to building contracts using Blockly.
* If you are not a Haskell programmer, then you can skip the tutorial sections on [Understanding the semantics](./tutorial-v1.3/simeon-semantics.md) and [Using Simeon](./tutorial-v1.3/using-simeon.md).

I have learned about Simeon 1.3, and written contracts there, but I want to convert to v2.0 and use the Simeon Playground.

* You can find out about the [differences between v1.3 and v2.0](./tutorial-v1.3/differences.md), and [this checklist](./tutorial-v1.3/checklist.md) will help you to convert contracts from v1.3 to v2.0.

I am a Haskell programmer, and I want to get started developing Simeon contracts embedded in Haskell and to run them in Haskell and the Simeon Playground.

* To do this, follow the [tutorial](./tutorial-v2.0/README.md) on the current version of Simeon and develop your programs in the [Simeon Playground](https://prod.meadow.simeon.tbcodev.io).

## Miami Hackathon

The [challenge](./challenge.md) for the Hackathon at the Miami summit.

The [Simeon slides](./SummitSimeon.pdf) (PDF) from the hackathon.

## Materials available

This section lists all the learning resources for Simeon, the Simeon Playground and Meadow.

* [Tutorial](./tutorial-v1.3/README.md) for version 1.3 of Simeon and the first version of the Meadow tool.
* [Tutorial](./tutorial-v2.0/README.md) for version 2.0 of Simeon and the Simeon Playground.
* An [overview](./tutorial-v1.3/differences.md) of the differences between v1.3 and v2.0.
* A [checklist](./tutorial-v1.3/checklist.md) for converting a v1.3 contract to v2.0.
* [Udemy course](https://www.udemy.com/simeon-programming-language/) on Simeon (v1.3) and Meadow.
* [Paper](https://tbco.io/research/papers/#2WHKDRA8) on Simeon, describing v1.3 and  Meadow.
* [Video](https://youtu.be/_loz70XkHM8) run-through of the original Meadow.

