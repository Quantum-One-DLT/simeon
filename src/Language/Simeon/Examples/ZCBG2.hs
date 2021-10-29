
module Language.Simeon.Examples.ZCBG2 where

import Language.Simeon


zeroCouponBondGuaranteed :: Party -> Party -> Party -> Integer -> Integer -> Timeout
                         -> Timeout -> Contract
zeroCouponBondGuaranteed issuer investor guarantor notional discount startDate maturityDate =
  When [ Case (Deposit guarantorAcc guarantor bcc (Constant notional))
              (When [Case (Deposit investorAcc investor bcc (Constant (notional - discount)))
                          continuation]
                    startDate
                    Close)
       , Case (Deposit investorAcc investor bcc (Constant (notional - discount)))
              (When [Case (Deposit guarantorAcc guarantor bcc (Constant notional))
                          continuation]
                    startDate
                    Close)
       ]
       startDate
       Close
  where continuation = When []
                            startDate
                            (Pay investorAcc (Party issuer) bcc (AvailableMoney investorAcc bcc)
                                    (When [ Case (Deposit investorAcc issuer bcc (Constant notional))
                                                 Close
                                          ]
                                          maturityDate
                                          (Pay guarantorAcc (Account investorAcc) bcc (AvailableMoney guarantorAcc bcc)
                                               Close)
                                    )
                           )
        guarantorAcc = guarantor
        investorAcc = investor


