TEST_TARGETS := \
	basic_briefing \
	basic_bulls-eye \
	basic_gearing-up \
	basic_isolated \
	basic_peek-a-slot \
	common_bar \
	common_casino-vault \
	common_cheap-glitch \
	common_entry-point \
	common_gorengan \
	common_inju-bank \
	common_master-of-blackjack \
	common_roulette \
	common_silent-dealer \
	common_singular-identity \
	common_symbol-of-noble \
	common_take-my-money\
	common_unlimited-credit-line \
	common_voting-frenzy \
	common_vvvip-member \
	advance_casino-bankbuster \
	advance_double-dipping \
	advance_false-hope \
	vip_bank-of-people \
	vip_executive-problems \
	vip_inju-gambit \
	vip_ipwd \
	vip_pupol-nft

# Default: Verbose Forge test
VERBOSE ?= 1

# Only add -vvv when VERBOSE=1
VFLAG :=
ifeq ($(VERBOSE),1)
VFLAG := -vvv
endif

# Solve checker
TEST_ARGS := --mt testIfSolved $(VFLAG)

.PHONY: $(TEST_TARGETS) test-all

test-all:
	@$(MAKE) -k VERBOSE=0 $(TEST_TARGETS)

# Basic
basic_briefing:
	SECRET_PHRASE=0x$$(openssl rand -hex 32) forge test --mp test/Briefing.t.sol $(TEST_ARGS)

basic_bulls-eye:
	forge test --mp test/BullsEye.t.sol $(TEST_ARGS)

basic_gearing-up:
	forge test --mp test/GearingUp.t.sol $(TEST_ARGS)

basic_isolated:
	forge test --mp test/Isolated.t.sol $(TEST_ARGS)

basic_peek-a-slot:
	SEED=0x$$(openssl rand -hex 32) \
	DARRAY=0x$$(openssl rand -hex 32) \
	TDARRAY=0x$$(openssl rand -hex 32) \
	forge test --mp test/PeekASlot.t.sol $(TEST_ARGS)

# Common
common_bar:
	forge test --mp test/Bar.t.sol $(TEST_ARGS)

common_casino-vault:
	forge test --mp test/CasinoVault.t.sol $(TEST_ARGS)

common_cheap-glitch:
	forge test --mp test/CheapGlitch.t.sol $(TEST_ARGS)

common_entry-point:
	forge test --mp test/EntryPoint.t.sol $(TEST_ARGS)

common_gorengan:
	forge test --mp test/Gorengan.t.sol ${TEST_ARGS}

common_inju-bank:
	forge test --mp test/InjuBank.t.sol $(TEST_ARGS)

common_master-of-blackjack:
	forge test --mp test/MasterOfBlackjack.t.sol $(TEST_ARGS)

common_roulette:
	forge test --mp test/Roulette.t.sol $(TEST_ARGS)

common_silent-dealer:
	forge test --mp test/SilentDealer.t.sol $(TEST_ARGS)

common_singular-identity:
	forge test --mp test/SingularIdentity.t.sol $(TEST_ARGS)

common_symbol-of-noble:
	forge test --mp test/SymbolOfNoble.t.sol $(TEST_ARGS)

common_take-my-money:
	FOUNDRY_PROFILE=shanghai forge test --mp test/TakeMyMoney.t.sol $(TEST_ARGS)

common_unlimited-credit-line:
	forge test --mp test/UnlimitedCreditLine.t.sol $(TEST_ARGS)

common_voting-frenzy:
	forge test --mp test/VotingFrenzy.t.sol $(TEST_ARGS)

common_vvvip-member:
	forge test --mp test/VVVIPMember.t.sol $(TEST_ARGS)

# Advance
advance_casino-bankbuster:
	forge test --mp test/CasinoBankbuster.t.sol $(TEST_ARGS)

advance_double-dipping:
	forge test --mp test/DoubleDipping.t.sol $(TEST_ARGS)

advance_false-hope:
	forge test --mp test/FalseHope.t.sol $(TEST_ARGS)

# VIP
vip_bank-of-people:
	FOUNDRY_PROFILE=prague forge test --mp test/BankOfPeople.t.sol $(TEST_ARGS)

vip_executive-problems:
	forge test --mp test/ExecutiveProblems.t.sol $(TEST_ARGS)

vip_inju-gambit:
	forge test --mp test/InjuGambit.t.sol $(TEST_ARGS)

vip_ipwd:
	REF1=0x$$(openssl rand -hex 32) \
	REF2=0x$$(openssl rand -hex 32) \
	REF3=0x$$(openssl rand -hex 32) \
	REF4=0x$$(openssl rand -hex 32) \
	REF5=0x$$(openssl rand -hex 32) \
	forge test --mp test/IPWD.t.sol $(TEST_ARGS)

vip_pupol-nft:
	forge test --mp test/pupolNFT.t.sol $(TEST_ARGS)
