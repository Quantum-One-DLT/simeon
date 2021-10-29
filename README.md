<p align="center">
  <img width="266" height="185" src="docs/tutorial-v1.3/pix/logo.png">
</p>

# Simeon
# All Credit for Simeon goes to IOHK and the dedicated developers of Marlowe. Simeon is an exact replica of IOHK's Marlowe Language, its just renamed to Simeon for purposes of The Blockchain Co.'s (TBCO) blockchain ecosystem demo. TBCO demo chain is dervived from IOHK's Cardano Haskell blockchain and contains added features specific to TBCO's demo. Hat tip to IOHK, Emurgo, and every single member of the Cardano development community for your brilliant work and tireless effort to make Cardano what it is today.
This repository contains Simeon, a domain-specific language (DSL) for describing financial smart contracts that can be enforced by scripts deployed on a blockchain, as well as some tools for analysing and simulating the execution of contracts written in the DSL.

## Learning about Simeon and Simeon Playground

The [Simeon tutorials](https://david.simeon.tbcodev.io/tutorial/) introduce Simeon and the Simeon Playground.

## Versions of Simeon

The `master` branch contains the latest version of Simeon, version `3.0`.

An earlier version of Simeon is described in a [paper](https://tbco.io/research/papers/#2WHKDRA8) that was presented at ISoLA 2018. This versin is tagged `v1.3` and a minor update on this is taggedn `v1.3.1`.
Versions `1.x`, and `2.0` can also be found in the `master` branch under `semantics-1.0`, and `semantics-2.0`, respectively.

## Build on MacOS


Requirements: Homebrew, Haskell Stack 1.6 or later.

Install Haskell Stack if you haven't already

    $ brew install haskell-stack

    $ brew install glpk
    $ stack setup
    $ stack build
    
## Build Isabelle proofs

Requirements: Isabelle CLI

    $ cd isabelle
    $ isabelle build -d. Test
