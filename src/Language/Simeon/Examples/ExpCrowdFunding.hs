{-# LANGUAGE OverloadedStrings #-}
module Language.Simeon.Examples.ExpCrowdFunding where

import           Language.Simeon

contract :: Contract
contract = crowdfunding 1000 100

-- Limited crowdfunding example using embedding
crowdfunding :: Integer -> Timeout -> Contract
crowdfunding target tim =
  multiState [("2",False),("3",False),("4",False),("5",False)] cont tim cont
  where cont = If (ValueGE (AddValue (AddValue (AvailableMoney "2" bcc)
                                               (AvailableMoney "3" bcc))
                                     (AddValue (AvailableMoney "4" bcc)
                                               (AvailableMoney "5" bcc)))
                           (Constant target))
                  (Pay "2" (Account creatorAcc) bcc (AvailableMoney "2" bcc)
                       (Pay "3" (Account creatorAcc) bcc (AvailableMoney "3" bcc)
                            (Pay "4" (Account creatorAcc) bcc (AvailableMoney "4" bcc)
                                 (Pay "5" (Account creatorAcc) bcc (AvailableMoney "5" bcc)
                                      Close))))
                  Close
        creatorAcc = "1"

-- Defines a state machine for each contributor:
-- (party, False) - Has not chosen the amount to contribute
-- (party, True) - Has chosen the amount and is ready to make the deposit
type ContributionState = (Party, Bool)

multiState :: [ContributionState] -> Contract -> Timeout -> Contract -> Contract
multiState [("2",False),("3",False),("4",False),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("3",False),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("3",False),("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",False),("4",False),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("3",False),("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False),("3",False),("4",False)] fc t tc)
       ] t tc
multiState [("2",False),("3",False),("4",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("3",False),("4",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",False),("4",True),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",True),("5",False)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False),("3",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("3",False),("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",False),("4",True),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",True),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False),("3",False),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False),("3",False),("4",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",False),("4",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False),("3",False)] fc t tc)
       ] t tc
multiState [("2",False),("3",False),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("3",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",False),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False),("3",False)] fc t tc)
       ] t tc
multiState [("2",False),("3",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",False),("3",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",True),("4",False),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",False),("5",False)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False),("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",True),("4",False),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",False),("5",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False),("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False),("3",True),("4",False)] fc t tc)
       ] t tc
multiState [("2",False),("3",True),("4",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",False)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False),("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",True),("4",True),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True),("5",False)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False),("4",True),("5",False)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False),("3",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("3",True),("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",True),("4",True),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False),("4",True),("5",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False),("3",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False),("3",True),("4",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",True),("4",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False),("4",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False),("3",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",True),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True),("5",False)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("3",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",True),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True),("5",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False),("3",True)] fc t tc)
       ] t tc
multiState [("2",False),("3",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("3",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",False)] fc t tc)
       ] t tc
multiState [("2",False),("4",False),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("4",False),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False),("4",False)] fc t tc)
       ] t tc
multiState [("2",False),("4",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",False),("4",True)] fc t tc)
       ] t tc
multiState [("2",False),("4",True),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("4",True),("5",False)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("4",True),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False),("4",True)] fc t tc)
       ] t tc
multiState [("2",False),("4",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("4",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",False)] fc t tc)
       ] t tc
multiState [("2",False),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",False),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",False)] fc t tc)
       ] t tc
multiState [("2",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "2") [Bound 0 10000]) (multiState [("2",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",False),("4",False),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False),("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",False),("4",False),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False),("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True),("3",False),("4",False)] fc t tc)
       ] t tc
multiState [("2",True),("3",False),("4",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False),("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",False),("4",True),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True),("5",False)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True),("3",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("3",False),("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",False),("4",True),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False),("4",True),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True),("3",False),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True),("3",False),("4",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",False),("4",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False),("4",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True),("3",False)] fc t tc)
       ] t tc
multiState [("2",True),("3",False),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("3",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",False),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True),("3",False)] fc t tc)
       ] t tc
multiState [("2",True),("3",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("2",True),("3",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",True),("4",False),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True),("4",False),("5",False)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True),("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",True),("4",False),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True),("4",False),("5",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True),("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True),("3",True),("4",False)] fc t tc)
       ] t tc
multiState [("2",True),("3",True),("4",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True),("4",False)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True),("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",True),("4",True),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True),("4",True),("5",False)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True),("4",True),("5",False)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True),("3",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("3",True),("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",True),("4",True),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True),("3",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True),("3",True),("4",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",True),("4",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True),("4",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True),("4",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True),("3",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",True),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True),("5",False)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("3",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",True),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True),("5",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True),("3",True)] fc t tc)
       ] t tc
multiState [("2",True),("3",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("3",True)] fc t tc)
       , Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("2",True)] fc t tc)
       ] t tc
multiState [("2",True),("4",False),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("4",False),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True),("4",False)] fc t tc)
       ] t tc
multiState [("2",True),("4",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("2",True),("4",True)] fc t tc)
       ] t tc
multiState [("2",True),("4",True),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("4",True),("5",False)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("4",True),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("4",True),("5",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True),("4",True)] fc t tc)
       ] t tc
multiState [("2",True),("4",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("4",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("2",True)] fc t tc)
       ] t tc
multiState [("2",True),("5",False)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("2",True),("5",True)] fc t tc)
       ] t tc
multiState [("2",True),("5",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("2",True)] fc t tc)
       ] t tc
multiState [("2",True)] fc t tc =
  When [ Case (Deposit "2" "2" bcc (ChoiceValue (ChoiceId "1" "2"))) (multiState [] fc t tc)
       ] t tc
multiState [("3",False),("4",False),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True),("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("3",False),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("3",False),("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("3",False),("4",False),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True),("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("3",False),("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("3",False),("4",False)] fc t tc)
       ] t tc
multiState [("3",False),("4",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True),("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("3",False),("4",True)] fc t tc)
       ] t tc
multiState [("3",False),("4",True),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True),("4",True),("5",False)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("3",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("3",False),("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("3",False),("4",True),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("3",False),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("3",False),("4",True)] fc t tc)
       ] t tc
multiState [("3",False),("4",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True),("4",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("3",False)] fc t tc)
       ] t tc
multiState [("3",False),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("3",False),("5",True)] fc t tc)
       ] t tc
multiState [("3",False),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("3",False)] fc t tc)
       ] t tc
multiState [("3",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "3") [Bound 0 10000]) (multiState [("3",True)] fc t tc)
       ] t tc
multiState [("3",True),("4",False),("5",False)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("4",False),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("3",True),("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("3",True),("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("3",True),("4",False),("5",True)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("4",False),("5",True)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("3",True),("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("3",True),("4",False)] fc t tc)
       ] t tc
multiState [("3",True),("4",False)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("4",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("3",True),("4",True)] fc t tc)
       ] t tc
multiState [("3",True),("4",True),("5",False)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("4",True),("5",False)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("3",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("3",True),("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("3",True),("4",True),("5",True)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("4",True),("5",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("3",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("3",True),("4",True)] fc t tc)
       ] t tc
multiState [("3",True),("4",True)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("4",True)] fc t tc)
       , Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("3",True)] fc t tc)
       ] t tc
multiState [("3",True),("5",False)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("3",True),("5",True)] fc t tc)
       ] t tc
multiState [("3",True),("5",True)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("3",True)] fc t tc)
       ] t tc
multiState [("3",True)] fc t tc =
  When [ Case (Deposit "3" "3" bcc (ChoiceValue (ChoiceId "1" "3"))) (multiState [] fc t tc)
       ] t tc
multiState [("4",False),("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("4",True),("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("4",False),("5",True)] fc t tc)
       ] t tc
multiState [("4",False),("5",True)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("4",True),("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("4",False)] fc t tc)
       ] t tc
multiState [("4",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "4") [Bound 0 10000]) (multiState [("4",True)] fc t tc)
       ] t tc
multiState [("4",True),("5",False)] fc t tc =
  When [ Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("5",False)] fc t tc)
       , Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("4",True),("5",True)] fc t tc)
       ] t tc
multiState [("4",True),("5",True)] fc t tc =
  When [ Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [("5",True)] fc t tc)
       , Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [("4",True)] fc t tc)
       ] t tc
multiState [("4",True)] fc t tc =
  When [ Case (Deposit "4" "4" bcc (ChoiceValue (ChoiceId "1" "4"))) (multiState [] fc t tc)
       ] t tc
multiState [("5",False)] fc t tc =
  When [ Case (Choice (ChoiceId "1" "5") [Bound 0 10000]) (multiState [("5",True)] fc t tc)
       ] t tc
multiState [("5",True)] fc t tc =
  When [ Case (Deposit "5" "5" bcc (ChoiceValue (ChoiceId "1" "5"))) (multiState [] fc t tc)
       ] t tc
multiState [] fc t tc = fc

