{-# LANGUAGE OverloadedStrings #-}
module Language.Simeon.Examples.ExpRent where

import Language.Simeon

expanded =
  When [Case (Deposit "tenantDeposit" "tenant" bcc (Constant 200))
    (When [Case (Deposit "tenant" "tenant" bcc (Constant 120))
      (Pay "tenant" (Party "landlord") bcc (AvailableMoney "tenant" bcc)
        (When [Case (Deposit "tenant" "tenant" bcc (Constant 120))
          (Pay "tenant" (Party "landlord") bcc (AvailableMoney "tenant" bcc)
            (When [Case (Deposit "tenant" "tenant" bcc (Constant 120))
              (Pay "tenant" (Party "landlord") bcc (AvailableMoney "tenant" bcc) Close)]
            100 (Pay "tenantDeposit" (Party "landlord") bcc (AvailableMoney "tenantDeposit" bcc) Close)))]
        70 (Pay "tenantDeposit" (Party "landlord") bcc (AvailableMoney "tenantDeposit" bcc) Close)))]
    40 (Pay "tenantDeposit" (Party "landlord") bcc (AvailableMoney "tenantDeposit" bcc) Close))]
  10 Close


