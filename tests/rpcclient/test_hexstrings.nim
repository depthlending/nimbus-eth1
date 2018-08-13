# Separated from main tests for brevity

import unittest, ../../nimbus/rpc/hexstrings, json

proc doHexStrTests* =
  suite "[RPC] Hex quantity":
    test "Zero values":
      expect ValueError:
        let
          source = ""
          x = hexQuantityStr source
        check %x == %source
      expect ValueError:
        # must have '0' for zero quantities
        let
          source = "0x"
          x = hexQuantityStr source
        check %x == %source
      let
        source = "0x0"
        x = hexQuantityStr source
      check %x == %source
    test "Even length":
      let
        source = "0x1234"
        x = hexQuantityStr source
      check %x == %source
    test "Odd length":
      let
        source = "0x123"
        x = hexQuantityStr source
      check %x == %source
    test "\"0x\" header":
      expect ValueError:
        let
          source = "1234"
          x = hexQuantityStr source
        check %x != %source
      expect ValueError:
        let
          source = "01234"
          x = hexQuantityStr source
        check %x != %source
      expect ValueError:
        # leading zeros not allowed
        let
          source = "0x0123"
          x = hexQuantityStr source
        check %x != %source
      
  suite "[RPC] Hex data":
    test "Zero value":
      expect ValueError:
        let
          source = ""
          x = hexDataStr source
        check %x != %source
      expect ValueError:
        # not even length
        let
          source = "0x0"
          x = hexDataStr source
        check %x == %source
      let
        source = "0x"
        x = hexDataStr source
      check %x == %source
    test "Even length":
      let
        source = "0x1234"
        x = hexDataStr source
      check %x == %source
    test "Odd length":
      expect ValueError:
        let
          source = "0x123"
          x = hexDataStr source
        check %x != %source
    test "\"0x\" header":
      expect ValueError:
        let
          source = "1234"
          x = hexDataStr source
        check %x != %source
      expect ValueError:
        let
          source = "01234"
          x = hexDataStr source
        check %x != %source
      expect ValueError:
        let
          source = "x1234"
          x = hexDataStr source
        check %x != %source
      let
        # leading zeros allowed
        source = "0x0123"
        x = hexDataStr source
      check %x == %source

  suite "[RPC] Eth address strings":
    test "Valid address":
      let
        e = "0x0f572e5295c57f15886f9b263e2f6d2d6c7b5ec6"
        e_addr = e.ethAddressStr
      check e == e_addr.string
      let
        short_e = "0x0f572e5295c57f"
        short_e_addr = short_e.ethAddressStr
      check short_e == short_e_addr.string
    test "Too long":
      expect ValueError:
        let
          # too long
          e = "0x0f572e5295c57f15886f9b263e2f6d2d6c7b5ec66"
          e_addr = e.ethAddressStr
        check e == e_addr.string
    test "Wrong format":
      expect ValueError:
        let
          # too long
          e = "000f572e5295c57f15886f9b263e2f6d2d6c7b5ec6"
          e_addr = e.ethAddressStr
        check e == e_addr.string
