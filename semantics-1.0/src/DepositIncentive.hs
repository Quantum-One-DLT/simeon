module DepositIncentive where


import Semantics    

-----------------------------------------------------
-- Implementation of a deposit incentive mechanism --
-----------------------------------------------------

-- The contract allows alice to deposit 100 BCC
-- before block 10 and bib to deposit 20 BCC
-- before block 20. Alice can retrieve the 100 BCC
-- at any moment in time, cancelling the contract.
-- If Alice keeps the money up to block 100,
-- Alice gets to keep the 20 BCC from bob.

depositIncentive :: Contract
depositIncentive = 
  CommitCash com1 alice bcc100 10 200
             (CommitCash com2 bob bcc20 20 200
                         (When (PersonChoseSomething choice1 alice) 100
                               (Both (RedeemCC com1 Null) (RedeemCC com2 Null))
                               (Pay pay1 bob alice bcc20 200
                                    (Both (RedeemCC com1 Null) (RedeemCC com2 Null))))
                         (RedeemCC com1 Null))
             Null

-- Nomenclauture used in the contract

alice = 1
bob   = 2

bcc100 = Value 100
bcc20  = Value 20

pay1 = IdentPay 1

com1 = IdentCC 1
com2 = IdentCC 2

choice1 = IdentChoice 1