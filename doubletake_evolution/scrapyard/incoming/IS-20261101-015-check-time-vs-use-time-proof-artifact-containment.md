# IS-20261101-015 — Check-time versus use-time containment of proof-artifact writes

**Date:** 2026-11-01 UTC  
**Owner/status:** Borg Internet Scout; **UNTRIAGED_INTELLIGENCE**, not an approved patch, verified DT defect, or Ground result.  
**Target:** Public mission 7.9.1's proof-artifact containment acceptance and B7 trustworthy evidence. This does **not** resolve B1 owner authorization, 7.8.1 local mission consumption, or natural autonomous completion.

## Primary evidence directly examined

1. Linux **openat2(2)** manual, https://man7.org/linux/man-pages/man2/openat2.2.html (directly read DESCRIPTION, resolution flags, errors and portability). It documents directory-relative resolution restrictions such as `RESOLVE_BENEATH`, `RESOLVE_NO_MAGICLINKS`, and `RESOLVE_NO_SYMLINKS`. `O_NOFOLLOW` applies to the **last** path component, whereas `RESOLVE_NO_SYMLINKS` covers **all** components. The kernel can return `EAGAIN` when it cannot establish safe resolution during a race. Linux-specific, available since kernel 5.6; the manual notes no glibc wrapper.
2. Linux **open(2)** manual, https://man7.org/linux/man-pages/man2/open.2.html (directly read open-file-description semantics): an opened file descriptor continues referring to its file even when its pathname later changes.
3. Python **tempfile** documentation, https://docs.python.org/3/library/tempfile.html (directly read `mkstemp`): secure exclusive *creation* assumes correct `O_EXCL` support, but this alone is **not** a guarantee that a separately validated arbitrary destination remains within an allowed directory.
4. Independent curiosity frontier (abstract and evaluation framing only): Deb et al., *Active Causal Discovery Benchmark: Evaluating LLM Agents Under Budgeted Interventions*, https://arxiv.org/abs/2609.31675. Its intervention-budget / abstention baselines could inform future agent evaluation, but **no qualified DT fixture or incremental value** was established; no separate candidate is proposed.

These are upstream documented mechanisms, not independently replicated DT tests. No upstream code or copyrighted full text is reproduced.

## Distinct finding and uncertainty

A path-containment check and a later write are **two separate events** unless the write uses an appropriate atomic, descriptor-relative resolution contract. A static pre-existing-symlink test can pass while an intervening pathname change remains untested. This is a **general test-design risk**, **not a public claim that DT is exploitable**. No private source, file paths, patch contents, credentials or host information are disclosed.

**Nonduplicate delta:** Existing IS-010/011 address state acknowledgement/consistency; IS-012 addresses provenance through tool arguments. Public mission 7.9.1 already asks for static redirected-proof-artifact negatives. This lead adds a **deterministic interleaving** discriminator, including intermediate path components, to evaluate whether a prepared containment fix is sufficient. Repository code search for this precise discriminator returned no match; absence of a search hit does not prove absence of a test.

## Falsifiable DT-specific transfer hypothesis

**H:** In an **owner-authorized disposable fixture only**, a path check that is not coupled to safe write-time resolution may allow a deliberately interleaved path change to affect an outside sentinel. A containment implementation with an adequate use-time boundary should preserve the sentinel, refuse/contain the redirected operation and still allow benign output. If the existing implementation already passes the interleaving controls, classify `ALREADY_PRESENT / NO_DELTA`.

**OUTWARD:** Freeze a synthetic temporary directory, an unrelated outside sentinel, a benign artifact and an explicit synchronization point between *check* and *open*. Test (A) normal contained write; (B) pre-existing final-component redirect; (C) intermediate-component redirect; (D) a controlled change between validation and opening; (E) unsupported-platform or unresolved-resolution refusal. Check sentinel bytes before and after, write location, failure verdict, and cleanup. Use no protected or production files.

**INWARD (conditional):** Only the canonical authorized DT owner may compare these tests against the already-prepared 7.9.1 package in an isolated compatible checkout. Pin exact source/patch/test revisions privately, run existing tests first, and do not install new native bindings or change permissions. If the owner cannot establish a safe platform-compatible contract, report `OWNER_UNAVAILABLE / PLATFORM_UNSUPPORTED`; do not silently fall back to a check-then-open sequence.

**GROUND:** An independent test observer must verify unchanged outside bytes and no unintended file creation for all negatives, successful normal output, bounded execution, and no regression on restart/replay where applicable. A synthetic test pass is **FIXTURE_ONLY**; it does not establish natural DT mission consumption, production repair, full external assimilation or full Borg. Reject the lead if existing tests already cover the same interleavings or the additional control yields no distinct failure.

**Risks/constraints:** Linux-only syscall behavior, cross-platform Python support, permitted symlinks, mount/bind-mount semantics, filesystem behavior and test hook reliability all need explicit review. `RESOLVE_NO_SYMLINKS` can reject legitimate paths; `O_NOFOLLOW` alone does not protect intermediate components. This note is a research/test hypothesis, **not a mandated implementation technique**. Keep any sensitive implementation comparison in private DT.

**Pointers:** Public mission 7.9.1; IS-20261101-010 (history consistency), IS-20261101-011 (acknowledgement semantics), IS-20261101-012 (tool-argument provenance). Scrapyard Scout should promote only if a distinct current failing parity case or missing negative control is independently demonstrated; otherwise record `ALREADY_PRESENT / NO_DELTA` and avoid another generic proposal.
