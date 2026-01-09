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
	advance_salt-and-steel \
	advance_the-waltz \
	vip_bank-of-people \
	vip_executive-problems \
	vip_inju-gambit \
	vip_ipwd \
	vip_pupol-nft

TEST_DEPLOYED_SOLVE := \
	solve_advance_salt-and-steel

HELPER := \
	_ensure_dirs \
	_anvil_start \
	_anvil_stop \
	_script_solver 
	
# Default: Verbose Forge test
VERBOSE ?= 1

# Only add -vvv when VERBOSE=1
VFLAG :=
ifeq ($(VERBOSE),1)
VFLAG := -vvv
endif

# ----- Anvil Config -----
ANVIL_PORT ?= 8545
RPC_URL := http://127.0.0.1:${ANVIL_PORT}

ANVIL_DIR := .anvil
ANVIL_PID := ${ANVIL_DIR}/anvil.pid
ANVIL_LOG := ${ANVIL_DIR}/anvil.log

ANVIL_CHAIN_ID ?= 31337
ANVIL_HARDFORK ?= prague
MANUAL_MINING ?= false

# ----- SHELL -----
SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

# ----- Solve checker -----
TEST_ARGS := --mt testIfSolved $(VFLAG)

# ----- Make List -----
.PHONY: $(TEST_TARGETS) ${HELPER} ${TEST_DEPLOYED_SOLVE} test-all

test-all:
	@$(MAKE) -k VERBOSE=0 $(TEST_TARGETS)

# ----- HELPER -----
_ensure_dirs:
	mkdir -p "${ANVIL_DIR}"

_anvil_start: _ensure_dirs
	@echo "[!] Checking for existing Anvil processes..."
	@-pkill anvil 2>/dev/null || true
	@-lsof -ti tcp:$(ANVIL_PORT) 2>/dev/null | xargs kill 2>/dev/null || true
	@sleep 1
	@echo "[!] Starting Anvil on $(RPC_URL) (hardfork=$(ANVIL_HARDFORK), manual_mining=$(MANUAL_MINING))..."
	@if [ "$(MANUAL_MINING)" = "true" ]; then \
		anvil \
			--port $(ANVIL_PORT) \
			--hardfork $(ANVIL_HARDFORK) \
			--chain-id $(ANVIL_CHAIN_ID) \
			--no-mining \
			> $(ANVIL_LOG) 2>&1 & \
		echo $$! > $(ANVIL_PID); \
	else \
		anvil \
			--port $(ANVIL_PORT) \
			--hardfork $(ANVIL_HARDFORK) \
			--chain-id $(ANVIL_CHAIN_ID) \
			> $(ANVIL_LOG) 2>&1 & \
		echo $$! > $(ANVIL_PID); \
	fi
	@echo "[!] Waiting for Anvil to be ready..."
	@sleep 2
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		if cast chain-id --rpc-url $(RPC_URL) >/dev/null 2>&1; then \
			echo "[!] Anvil ready (pid=$$(cat $(ANVIL_PID)))"; \
			if [ "$(MANUAL_MINING)" = "true" ]; then \
				echo "[!] Manual mining enabled. Use 'cast rpc anvil_mine' to mine blocks"; \
			fi; \
			exit 0; \
		fi; \
		sleep 1; \
	done; \
	echo "[!] ERROR: Anvil failed to start. Logs:"; \
	cat $(ANVIL_LOG); \
	exit 1

_anvil_stop:
	@echo "[!] Stopping Anvil..."
	@if [ -f "$(ANVIL_PID)" ]; then \
		if kill -0 $$(cat $(ANVIL_PID)) 2>/dev/null; then \
			echo "[!] Killing Anvil (pid=$$(cat $(ANVIL_PID)))..."; \
			kill $$(cat $(ANVIL_PID)) 2>/dev/null || true; \
		fi; \
		rm -f $(ANVIL_PID); \
	fi
	@-lsof -ti tcp:$(ANVIL_PORT) 2>/dev/null | xargs kill 2>/dev/null || true
	@-pkill anvil 2>/dev/null || true
	@rm -f $(ANVIL_LOG)
	@echo "[o] Anvil stopped."

_script_solver:
	@if [ -z "$(CHALLENGE)" ]; then \
		echo "[!] ERROR: CHALLENGE variable not set"; \
		exit 1; \
	fi
	@echo "[*] Checking solution for $(CHALLENGE)..."
	@RESULT=$$(forge script script/$(CHALLENGE)/SolveChecker.s.sol --rpc-url $(RPC_URL) 2>&1); \
	echo "$$RESULT"; \
	if echo "$$RESULT" | grep -q "STATUS: SOLVED!"; then \
		echo "✓ Challenge completed successfully!"; \
		rm -rf .anvil/*; \
		echo "[*] Cleaned up .anvil directory"; \
		$(MAKE) _anvil_stop; \
	else \
		echo "✗ Challenge not solved yet"; \
		echo "Anvil still running at $(RPC_URL)"; \
		echo "Run 'make _anvil_stop' when done"; \
	fi

# ----- Deployed Solve -----
solve_advance_salt-and-steel: CHALLENGE=salt-and-steel
solve_advance_salt-and-steel: _script_solver

# ----- Basic Challenge -----
basic_briefing:
	SECRET_PHRASE=0x$$(openssl rand -hex 32) \
	forge test --mp test/Briefing.t.sol $(TEST_ARGS)

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

# ---- Common Challenge -----
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
	FOUNDRY_PROFILE=shanghai \
	forge test --mp test/TakeMyMoney.t.sol $(TEST_ARGS)

common_unlimited-credit-line:
	forge test --mp test/UnlimitedCreditLine.t.sol $(TEST_ARGS)

common_voting-frenzy:
	forge test --mp test/VotingFrenzy.t.sol $(TEST_ARGS)

common_vvvip-member:
	forge test --mp test/VVVIPMember.t.sol $(TEST_ARGS)

# ----- Advance Challenge -----
advance_casino-bankbuster:
	forge test --mp test/CasinoBankbuster.t.sol $(TEST_ARGS)

advance_double-dipping:
	forge test --mp test/DoubleDipping.t.sol $(TEST_ARGS)

advance_false-hope:
	forge test --mp test/FalseHope.t.sol $(TEST_ARGS)

advance_guardian:
	FOUNDRY_PROFILE=prague \
	forge test --mp test/Guardian.t.sol ${TEST_ARGS}

advance_salt-and-steel: ANVIL_HARDFORK=shanghai
advance_salt-and-steel: _anvil_start
	@echo "[*] Anvil is running on $(RPC_URL) with Shanghai hardfork"
	@echo "[*] Use 'make solve_advance_salt-and-steel' to stop Anvil when done"
	@forge script script/salt-and-steel/Deploy.s.sol:DeployScript \
		--rpc-url ${RPC_URL} \
		--broadcast \
		|| (echo "[-] Deployment Failed" && $(MAKE) _anvil_stop && exit 1)

advance_the-waltz:
	forge test --mp test/TheWaltz.t.sol ${TEST_ARGS}

# ----- VIP Challenge -----
vip_bank-of-people:
	FOUNDRY_PROFILE=prague \
	forge test --mp test/BankOfPeople.t.sol $(TEST_ARGS)

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

