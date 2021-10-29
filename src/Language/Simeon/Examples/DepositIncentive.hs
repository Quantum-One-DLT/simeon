{-# LANGUAGE OverloadedStrings #-}
module Language.Simeon.Examples.DepositIncentive where

import Language.Simeon

payAll :: Party -> Payee -> Contract -> Contract
payAll acId payee = Pay acId payee bcc (AvailableMoney acId bcc)

contract :: Contract
contract =
  When [ Case (Deposit incentiveAcc incentiviser bcc incentiveAmt)
              (When [ Case (Deposit depositAcc depositer bcc depositAmt)
                           (When [ Case (Choice (ChoiceId "refund" depositer) [Bound 1 1])
                                        Close
                                 ]
                                 200
                                 (payAll incentiveAcc (Account depositAcc)
                                         Close))
                    ]
                    20
                    Close)
       ]
       10
       Close

depositAmt, incentiveAmt :: Value
depositAmt = Constant 100
incentiveAmt = Constant 20

depositAcc, incentiveAcc :: Party
depositAcc = depositer
incentiveAcc = incentiviser

depositer, incentiviser :: Party
depositer = "depositer"
incentiviser = "incentiviser"

