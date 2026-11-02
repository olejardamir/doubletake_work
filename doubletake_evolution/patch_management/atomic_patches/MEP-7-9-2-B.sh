#!/usr/bin/env bash
# MEP-7-9-2-B; 7.9.2 receipt-chain acceptance unit
# Goal: Use one current-main strict-continuity code patch; do not reapply obsolete BPE-002.
# Actual implementation belongs to BPE-010, not this read-only unit.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 20
test -f tools/doubletake_evolve/claim_receipt/receipts.py || exit 21
test -f tools/doubletake_evolve/claim_receipt/test_claim_receipt.py || exit 22
echo "UNIT=7.9.2-B SOURCE=$(git rev-parse HEAD)"
echo 'PENDING: strict chain patch and independent focused negatives not yet accepted.'
exit 78
