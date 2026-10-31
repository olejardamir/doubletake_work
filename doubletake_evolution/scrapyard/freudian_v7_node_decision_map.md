# Freudian Id–Ego–Superego V7 as Nodes and Decision Points

## Scope

This document converts the V7 flow-corrected Freudian id–ego–superego pseudocode into a node-and-decision architecture.

A **node** means a functional processing unit in the V7 mechanism. It may correspond to one procedure, one cluster of procedures, or one state-owning subsystem.

A **decision point** means a branching rule where information is evaluated and routed to one or more next nodes.

The V7 mechanism is treated as a dynamic graph:

```text
Inputs
  external reality + bodily signals + internal pressure + memory traces
      ↓
Id / body / memory / developmental / cultural activation
      ↓
topographic routing + representation linking
      ↓
ego reality testing + superego judgment
      ↓
pleasure/reality arbitration + negation/judgment + ego split detection
      ↓
conflict computation + anxiety
      ↓
defense/output selection
      ↓
action / symptom / dream / parapraxis / inhibition / fantasy / sublimation / repair
      ↓
feedback into id, ego, superego, memory, repression, repetition, and energy economy
```

---

# Part I — Node Catalogue

## A. Core State / Agency Nodes

| Node ID | Node | Accepts | Real-world behaviour represented | Output |
|---|---|---|---|---|
| S01 | Id state | Bodily needs, libido, aggression, dependency, narcissistic pressure, repressed wish pressure, repetition pressure | The pressure-system of wishes, drives, urgency, unbound excitation, and primary-process demand. It does not test reality directly. | Drive pressure, raw wishes, urgent demands, primary-process material |
| S02 | Ego state | Perception, body-boundary signals, ego capacity, fatigue, anxiety, reality constraints, moral pressure, unconscious pressure | Mediating organization. It tests reality, binds affect, delays discharge, selects defenses, forms action plans, and tries to synthesize conflict. | Reality reports, conflict reports, anxiety signal, defense/output selection |
| S03 | Superego state | Internalized authority, conscience, ego ideal, guilt, shame, punishment need, approval rules | Internal judge and ideal-system. It prohibits, demands repair/renunciation/perfection, punishes, approves, and generates moral anxiety. | Superego judgment, guilt/shame/punishment pressure, approval/reward |
| S04 | External reality | Current situation, people/objects, physical limits, social/legal/resource constraints, danger, opportunity | The outside world as perceived by the ego. Supplies feasibility, risk, object availability, timing, and consequences. | ExternalRealityInput and RealityReport |
| S05 | Topographic regions | Unconscious, preconscious, conscious content | Routes mental content according to accessibility, censorship, word-linking, and affect tolerance. | TopographicPacket with current region and access status |
| S06 | Energy economy | Free energy, bound energy, cathexis, anticathexis, discharged energy, symptom-bound energy, sublimated energy | Economic layer of the model: tracks pressure, binding, repression cost, symptom-binding, sublimation, and discharge. | Updated energy distribution and pressure values |
| S07 | Memory system | Event traces, affect charge, integration status, repression status, repetition pressure | Stores experiences, unresolved scenes, repressed traces, trauma residues, and integrated memories. | Reactivated memories, repetition pressure, memory traces |
| S08 | Repression network | Repression nodes, primal cores, derivatives, return channels | Stores primally repressed cores, repression proper, derivatives, and routes for return of the repressed. | RepressionNode, derivatives, dream/slip/symptom/preconscious return channels |
| S09 | Body-ego boundary | Pain, surface perception, motility, body image, internal/external discrimination | Represents the ego as rooted in the body: boundary, pain, inside/outside distinction, and somatic symbolization. | BodyEgoBoundary and BodilyEgoMainLoopInfluence |
| S10 | Libido distribution | Ego-libido, object-libido, withdrawn object libido, narcissistic accumulation | Tracks whether libido is invested in objects, withdrawn into ego, dammed up, or available for reinvestment. | Updated object investment, mourning/melancholia/withdrawal risk |
| S11 | Cultural superego | Cultural ideals, ethical commands, group guilt, civilization renunciation demands | Social/cultural layer of the superego. Adds group ideals, collective guilt, conformity and sublimation pressure. | Cultural pressure, superego intensification, defense bias |
| S12 | Developmental system | Psychosexual stages, fixation, regression pull, Oedipal configuration, later authority | Developmental residue layer. Shapes later conflict, symptom choice, superego formation, and regression. | Fixation records, Oedipal residues, developmental anxiety |
| S13 | Clinical pattern state | Active pattern, defense cluster, symptom choice, ego split level, reality relation | Classifies broad formations such as hysteria, phobia, obsession, melancholia, paranoia, psychosis, moral masochism. | ClinicalFormationType and handler-specific response |
| S14 | Analytic field | Free association, analyst representation, resistance, transference, interpretation readiness | Therapy/reversal layer. Represents transference, resistance, repetition in the session, and working-through. | Interpretation, working-through steps, reduced repression/repetition |

---

## B. Main Operating Loop Nodes

| Node ID | Node | Procedure(s) | Accepts | Real-world behaviour represented | Output |
|---|---|---|---|---|---|
| N01 | Initialize complete system | `Initialize_Complete_System_V7`, `Initialize_System` | Baseline agency capacities, default energy, empty memory/repression/clinical/analytic fields | Sets the initial psychic architecture before any cycle begins. | `CompleteSystemStateV7` |
| N02 | External reality perception | `PERCEIVE_EXTERNAL_REALITY` | Current outside situation, objects, risks, opportunities, constraints | Perceiving the world as the ego-facing outside environment. | `ExternalRealityInput` |
| N03 | Internal stimulus detection | `DETECT_INTERNAL_STIMULI` | Body needs, affective tension, unresolved drive pressure, superego pressure, ego fatigue | Detects internal need, tension, guilt, shame, fatigue, and unresolved pressure. | `internal_stimuli` |
| N04 | Body-ego boundary update | `UPDATE_BODY_EGO_BOUNDARY` | Internal stimuli, external input, pain, surface contact, motility | Updates bodily ego: pain, body image, internal/external discrimination, conversion risk. | `BodyEgoBoundary` |
| N05 | Bodily ego main-loop influence | `INTEGRATE_BODILY_EGO_IN_MAIN_LOOP` | Body-ego boundary, internal stimuli, external input | Converts bodily signals into drive pressure, anxiety, defense bias, conversion risk, motility inhibition risk. | `BodilyEgoMainLoopInfluence`, modified base state |
| N06 | Memory reactivation | `DETECT_MEMORY_REACTIVATION` | External situation, affective tension, memory traces | Reactivates old traces when current reality or affect resembles past scenes. | `reactivated_memories` |
| N07 | Object/libido update | `EXTRACT_OBJECT_EVENTS`, `UPDATE_LIBIDO_DISTRIBUTION` | Object availability/loss/disappointment, current state, memory/object events | Moves libido between ego and objects; detects withdrawal, mourning, melancholic risk, narcissistic accumulation. | Updated `LibidoDistribution`; risk signals |
| N08 | Cultural background pressure | `EXTRACT_CULTURAL_CONTEXT`, `APPLY_CULTURAL_SUPEREGO_PRESSURE` | Social norms, group ideals, cultural prohibitions, collective guilt | Adds background cultural/group superego pressure before individual conflict evaluation. | Updated `CulturalSuperego`, superego pressure, defense bias |
| N09 | Safe prior conflict capture | `SAFE_CURRENT_CONFLICT_FOR_INSTINCT_UPDATE` | Existing conflict report or null | Avoids stale/null conflict failure while updating instinct mixture early in loop. | Safe empty or previous conflict |
| N10 | Instinct mixture update | `UPDATE_INSTINCT_MIXTURE` | Internal stimuli, safe conflict, Eros/destructive tendencies | Updates fusion/defusion of Eros and destructive instinct, outward/inward aggression, repetition force. | Updated `InstinctMixture` |
| N11 | Instinct defusion handler | `HANDLE_INSTINCT_DEFUSION` | Instinct mixture, ego binding capacity | If destructive instinct is defused, routes aggression outward or inward into superego punishment/masochism. | Aggressive demand or intensified superego punishment |
| N12 | Developmental event extraction | `DEVELOPMENTAL_EVENT_PRESENT`, `EXTRACT_DEVELOPMENTAL_EVENT` | External/internal event data | Detects whether the current event acts developmentally: frustration, trauma, renunciation, punishment, etc. | `DevelopmentalEvent` or none |
| N13 | Psychosexual development update | `PSYCHOSEXUAL_DEVELOPMENT_UPDATE` | Developmental event, age phase, fixation records | Updates oral/anal/phallic/latency/genital residues, fixation, regression pull, symptom choice bias. | Updated fixation records |
| N14 | Oedipal/superego formation update | `OEDIPAL_CONFIGURATION_UPDATE`, `DISSOLVE_OEDIPUS_AND_FORM_SUPEREGO` | Developmental event, family/authority matrix, Oedipal configuration | Builds Oedipal residues, identification, conscience, ego ideal, prohibitions, guilt sources. | Updated `OedipalConfiguration`, `SuperegoFormationRecord`, superego state |
| N15 | Later authority and renunciation update | `LATER_SUPEREGO_MODIFICATION`, `SUPEREGO_RENUNCIATION_FEEDBACK_LOOP` | Later authority events, renounced impulses | Adds teachers/culture/law/authority to superego; renunciation may strengthen conscience and severity. | Superego intensification or flexibility; repression/guilt changes |
| N16 | Id demand generation | `ID_GENERATE_DRIVE_DEMANDS` | Internal stimuli, reactivated memories, id state | Converts bodily need, libido, aggression, dependency, narcissism, repetition into raw drive demands. | List of `DriveDemand` |
| N17 | Structural routing from id | `ROUTE_ID_MATERIAL_TO_EGO` | Drive demand, forbidden/danger/idealizable flags | Routes id material directly to ego, through ego ideal, or through superego guilt. | Structural routes and topographic packets |
| N18 | Primary-process transformation | `ID_PRIMARY_PROCESS_TRANSFORMATION`, `APPLY_DISPLACEMENT`, `APPLY_CONDENSATION`, `APPLY_SYMBOLIZATION` | Drive demands, intensity, memory links, forbidden status | Applies primary-process transformations: displacement, condensation, symbolization, wish disguise, repetition scene. | Primary-process `TopographicPacket`s |
| N19 | Packet merge | `MERGE(primary_packets, active_packets)` | Primary packets and structural route packets | Combines direct id material, transformed material, and routed packets before censorship. | `all_packets` |
| N20 | Primal repression gate | `SHOULD_ESTABLISH_PRIMAL_REPRESSION`, `ESTABLISH_PRIMAL_REPRESSION` | Packets, existing primal cores, developmental/trauma/infantile status | Establishes foundational repression only for first-fixation/traumatic/infantile cases. | New primal `RepressionNode` or none |
| N21 | Repression proper gate | `SHOULD_APPLY_REPRESSION_PROPER`, `APPLY_REPRESSION_PROPER` | Packets, existing primal core links, censorship danger | Represses later derivatives connected to primal cores; adds anticathexis and repressed wish pressure. | New repression-proper node or none |
| N22 | Derivative generation | `GENERATE_DERIVATIVES_OF_REPRESSED` | Repression network | Creates distorted derivatives that may pass censorship as dreams, slips, symptoms, or preconscious thoughts. | Derivative `RepressionNode`s with return channels |
| N23 | Return of the repressed routing | `RETURN_OF_THE_REPRESSED_ROUTING` | Repression network, current state, conflict | Routes returning derivatives into dream image, parapraxis, symptom compromise, or preconscious thought. | Dream/parapraxis/symptom/preconscious packet activation |
| N24 | Sleep/dream work | `SLEEP_MODE_DREAM_LOOP` | Day residues, latent thoughts, infantile/forbidden wishes, censorship | In sleep, transforms latent material into manifest dream by censorship, regression, condensation, displacement, symbolization, secondary revision. | `DreamWorkPacket` |
| N25 | Dream economic feedback | `DREAM_ECONOMIC_FEEDBACK_UPDATE` | Dream packet, energy economy, censorship intensity | Dream-work economically binds/discharges disguised wish-pressure or increases anxiety/repetition if it fails. | Updated free/bound/discharged energy, repression load, anxiety |
| N26 | Topographic routing and censorship | `TOPOGRAPHIC_ROUTING_AND_CENSORSHIP`, `CENSORSHIP_GATE` | All packets, ego capacity, danger, guilt, forbiddenness, affect | Determines whether material becomes conscious, preconscious, disguised, kept unconscious, anxiety, or symptom seed. | Routed packets |
| N27 | Ego reception and translation | `EGO_RECEIVE_AND_TRANSLATE`, `EGO_SYNTHESIS`, `EGO_PARTIAL_SYNTHESIS`, `EGO_REGISTER_AS_PRESSURE_ONLY` | Routed packets | Ego receives material fully, partially, or only as pressure; binds affect when possible. | `ego_material` |
| N28 | Representation and word-linking | `LINK_EGO_MATERIAL_THROUGH_WORD_PRESENTATIONS`, `LINK_THING_PRESENTATION_TO_WORD_PRESENTATION` | Ego material, thing-presentation, word-presentation, affect quota | Links unconscious thing-presentation to words so material can enter preconscious/conscious thought. | Linked ego material and `RepresentationPacket`s |
| N29 | Ego reality testing | `EGO_REALITY_TESTING` | Ego material, external input | Tests feasibility, danger, social/legal/resource cost, opportunity, safe and unsafe channels. | `RealityReport` |
| N30 | Cultural delta update | `UPDATE_CULTURAL_CONTEXT_FROM_REALITY_REPORT`, `APPLY_CULTURAL_SUPEREGO_PRESSURE_DELTA_ONLY` | Reality report, prior cultural context | Applies only newly discovered cultural pressure after reality-testing, preventing double-counting. | Updated cultural/superego pressure only if delta exists |
| N31 | Superego evaluation | `SUPEREGO_EVALUATION` | Ego material, reality report, superego state | Judges wishes/actions against prohibitions, ideals, guilt, shame, repair demands, approval. | `SuperegoJudgment` |
| N32 | Pleasure/reality arbitration | `PLEASURE_REALITY_PRINCIPLE_ARBITRATION` | Ego material, reality report, superego judgment, ego capacities | Ego arbitrates between immediate discharge and delay, thought, sublimation, fantasy, renunciation, repression. | `PleasureRealityArbitrationRecord`, pending defense bias |
| N33 | Negation and judgment | `HANDLE_NEGATION_AND_JUDGMENT` | Ego material, reality report, superego judgment, repression network | Handles “I do not think/want/feel X” as partial lifting of repression; separates intellectual admission from affective acceptance. | `NegationJudgmentRecord`, partial repression changes |
| N34 | Ego split detection | `HANDLE_EGO_SPLIT_AS_PARALLEL_ATTITUDES` | Ego material, reality report, superego judgment, body-boundary confusion | Detects persistent parallel ego currents: reality-accepting, wish-preserving/disavowing, superego-obedient, observing ego. | `EgoSplitState`, defense biases, clinical risk |
| N35 | Threat and developmental anxiety | `BUILD_THREAT_PROFILE`, `COMPUTE_DEVELOPMENTAL_ANXIETY` | External input, ego material, superego judgment, developmental residues | Computes object-loss, loss-of-love, castration, authority-punishment, superego-condemnation, traumatic helplessness anxiety. | Developmental anxiety map |
| N36 | Conflict computation | `EGO_COMPUTE_CONFLICT` | Ego material, reality report, superego judgment, ego capacities | Computes id/reality/superego pressure minus ego capacity; classifies conflict type. | `ConflictReport` |
| N37 | Apply arbitration to conflict | `APPLY_PLEASURE_REALITY_ARBITRATION_TO_CONFLICT` | Arbitration record, current conflict | Adds unresolved pleasure pressure and arbitration failure risk into current conflict before anxiety generation. | Updated `ConflictReport` |
| N38 | Apply ego split to conflict | `APPLY_EGO_SPLIT_TO_CONFLICT` | Ego split state, current conflict | Adds split-based symptom, reality distortion, self-punishment, and psychotic reconstruction risk to current conflict. | Updated `ConflictReport` |
| N39 | Map developmental anxiety to structural anxiety | `MAP_DEVELOPMENTAL_ANXIETY_TO_STRUCTURAL_ANXIETY` | Developmental anxiety map, conflict report | Converts developmental danger forms into structural anxiety labels and intensity. | Updated `ConflictReport` |
| N40 | Anxiety signal generation | `EGO_GENERATE_ANXIETY_SIGNAL` | Conflict report, ego thresholds | Converts conflict into realistic, neurotic, moral, traumatic, or mixed anxiety. | Anxiety type and level |
| N41 | Regression if overwhelmed | `APPLY_REGRESSION_IF_EGO_OVERWHELMED` | Conflict, fixation records, ego integration capacity | If ego is overwhelmed, selects fixation target and adds stage-specific defenses/pressures. | Updated fixation/clinical state and defense bias |
| N42 | Defense and output selection | `EGO_DEFENSE_AND_OUTPUT_SELECTION`, `SELECT_COMPROMISE_DEFENSES`, `HANDLE_ID_SUPEREGO_ALLIANCE`, `HANDLE_REALITY_CONFLICT_PATH` | Ego material, reality report, superego judgment, conflict, pending defense biases | Selects direct action, delay, sublimation, compromise, repression, symptom, compulsion, inhibition, self-punishment, reality conflict response, fantasy. | `EgoResponse` |
| N43 | Clinical pattern classification and handling | `CLASSIFY_CLINICAL_PATTERN_V7` plus clinical handlers | Ego response, conflict, fixation, repression, Oedipal residue, libido distribution | Converts broad response into clinical formation patterns: hysteria, phobia, obsession, melancholia, mourning, paranoia, psychosis, masochism. | Updated `ClinicalFormationType` and possibly overridden `EgoResponse` |
| N44 | Slips/everyday formation | `GENERATE_PARAPRAXIS_OR_EVERYDAY_FORMATION`, `GENERATE_JOKE_OR_WIT_FORMATION` | Intended speech/action, unconscious counter-intention, social context | Allows unconscious counter-intention to interfere as slip, forgetting, bungled action, joke, wit. | Parapraxis/joke packet or output override |
| N45 | Execute output | `EXECUTE_OUTPUT` | Ego response, external input | Performs action, delay, symptom, compulsion, inhibition, fantasy, dream, repair, self-punishment, withdrawal, reconstruction, no-action. | `output_result` |
| N46 | Feedback update | `FEEDBACK_UPDATE` | Ego response, output result, conflict, reality, judgment | Updates id discharge/residual pressure, ego fatigue/strength, superego guilt, reality learning, history. | Updated base state |
| N47 | Memory/repression/repetition update | `MEMORY_REPRESSION_REPETITION_UPDATE` | Current cycle, output result, ego response | Stores cycle as integrated, repressed, symptom-linked, distorted, or partial memory; updates repetition/repression. | New/updated `MemoryTrace`s |
| N48 | Homeostatic normalization | `HOMEOSTATIC_NORMALIZATION` | Current anxiety/guilt/shame, id/ego/superego/energy state | Clamps values, prevents negative pressures, recomputes total excitation. | Stabilized base state |

---

## C. Therapeutic Reversal Nodes

| Node ID | Node | Procedure(s) | Accepts | Real-world behaviour represented | Output |
|---|---|---|---|---|---|
| T01 | Therapeutic reversal controller | `COMPLETE_THERAPEUTIC_REVERSAL_V7` | Target symptom/conflict/pattern | Runs therapy loop until symptom/repetition/unconscious guilt drop and ego integration is sufficient. | Modified state; target resolved or still active |
| T02 | Analytic session input | `RECEIVE_ANALYTIC_SESSION_INPUT`, `ANALYTIC_SESSION_LOOP` | Free association, dream report, analyst relation, affect, session behaviour | Opens analytic field where transference and resistance appear. | Association stream and analytic field updates |
| T03 | Resistance detection | `DETECT_RESISTANCE` | Association stream, repression load, transference intensity, secondary gain, repetition force, punishment need | Detects silence, intellectualization, acting out, repression resistance, transference resistance, secondary gain, id repetition, superego guilt. | `ResistanceType` |
| T04 | Resistance handling | `HANDLE_RESISTANCE` | Resistance type, analytic field, current state | Makes resistance visible; increases interpretation readiness or marks negative therapeutic risk. | Updated analytic field, anxiety/guilt/repetition |
| T05 | Transference detection | `DETECT_TRANSFERENCE` | Affect toward analyst, hostility, eroticization, parental/judicial projections, repeated scene | Detects affectionate, eroticized, hostile, parental, authority, superego, or repetition transference. | `TransferenceType` |
| T06 | Transference handling | `HANDLE_TRANSFERENCE` | Transference type, analytic field, Oedipal residues, instinct mixture | Updates alliance, transference neurosis, hostility, Oedipal reactivation, projected judge intensity. | Updated analytic field and state pressures |
| T07 | Repetition to remembering | `TRANSFORM_REPETITION_INTO_REMEMBERING` | Repetition scene, memory traces | Links acted repetition to memory, words, time, and reality. | Memory becomes preconscious/linked; repetition falls |
| T08 | Interpretation and working-through | `BUILD_INTERPRETATION`, `APPLY_INTERPRETATION`, `WORK_THROUGH_RESISTANCE_ITERATIVELY` | Association stream, resistance source, readiness, analytic field | Interprets repeated resistance/transference and iterates until resistance reduces. | Linked affect-memory-words-reality; lower repression/repetition |
| T09 | Negative therapeutic reaction | `HANDLE_NEGATIVE_THERAPEUTIC_REACTION` | Improvement, unconscious guilt, punishment need | Improvement activates guilt and self-punishment; therapy must interpret superego resistance. | Self-punishment/inhibition bias; guilt visibility |
| T10 | Dream/parapraxis interpretation | `INTERPRET_DREAM_BACKWARD`, `APPLY_DREAM_INTERPRETATION_TO_REPRESSION_NETWORK`, `APPLY_PARAPRAXIS_INTERPRETATION` | Dream packet, parapraxis packet, associations | Traces manifest formation back to latent wish, repression nodes, infantile sources. | Updated repression network and insight path |
| T11 | Reduce repression/repetition | `REDUCE_REPRESSION_AND_REPETITION` | Repression node or source with repetition pressure | Partial lifting, lower affect quota, lower anticathexis, higher censorship tolerance. | Repression phase moves toward worked-through |
| T12 | Soften superego | `SOFTEN_SUPEREGO_WHEN_GUILT_IS_INTERPRETED` | Source related to Oedipal guilt or ambivalence | Interpreted guilt reduces sadistic punishment, rigidity, unconscious punishment need. | More flexible superego; higher guilt tolerance |
| T13 | Increase ego capacity | `INCREASE_EGO_CAPACITY_AFTER_SUCCESSFUL_INTEGRATION` | Successful integration | Ego strengthens through binding, symbolization, reality testing, integration, flexible defense. | Stronger ego, lower repression load |
| T14 | Target reevaluation | `REEVALUATE_TARGET_PATTERN` | Target pattern, symptom intensity, repetition pressure, unconscious guilt, ego integration | Decides whether therapeutic target remains active. | Continue therapy or terminate target loop |

---

# Part II — Decision Point Catalogue

## A. Main-Loop Decision Points

| Decision ID | Decision point | Information source | Information type | How decision is made | Can lead to | Output information |
|---|---|---|---|---|---|---|
| D01 | Sleep vs waking branch | `CURRENT_STATE` | State condition | If `CURRENT_STATE == SLEEP`, dream branch runs and waking route is skipped. | N24 → N25 → N47 → N48, or waking N26 | Dream packet/economic update or waking routed packets |
| D02 | Body signal threshold | Body-ego boundary | Pain intensity, body image coherence, inside/outside discrimination, somatic risk | If pain/instability/conversion risk exceed thresholds, add anxiety, drive pressure, somatic conversion, inhibition bias. | N05 modifies later N16, N40, N42 | Drive pressure increment, anxiety increment, defense bias |
| D03 | Memory reactivation | Current external situation + affective tension + memory traces | Similarity scores and affect charge | If similarity exceeds reactivation threshold, memory is reactivated and repetition/affect increase. | N06 → N16 | Reactivated memory list |
| D04 | Object/libido event type | Object events from reality/internal state | Object found, loved, lost, disappointing, forbidden, ambivalently lost | Event kind determines investment, withdrawal, mourning work, melancholic risk, narcissistic accumulation. | N07 → N43 possible mourning/melancholia/withdrawal | Updated libido distribution and clinical risks |
| D05 | Cultural context present | External input | Cultural ideals, prohibitions, group guilt, conformity demands | If cultural context exists, apply background cultural superego pressure. | N08 → N31/N42 | Superego pressure, guilt, defense bias |
| D06 | Instinct fusion state | Instinct mixture and ego binding capacity | Eros, death instinct, binding, unbinding, outward/inward aggression | If Eros and binding dominate, fuse; if death/unbinding dominate, defuse; otherwise partially fused. | N10 → N11 | Fusion state and aggression direction |
| D07 | Defused aggression direction | Instinct mixture | Outward vs inward destructive level | If outward aggression dominates, add aggressive drive demand; if inward dominates, intensify superego punishment and masochism. | N11 → N16 or N31/N42 | Aggressive demand or punitive superego pressure |
| D08 | Developmental event present | External/internal event stream | Frustration, satisfaction, loss, prohibition, punishment, praise, trauma, renunciation | If developmental event exists, update stage, Oedipus, authority, renunciation feedback. | N12 → N13/N14/N15 | Developmental residue and superego update |
| D09 | Psychosexual event-stage effect | Developmental event + age phase | Active stage, event type, intensity | Event affects fixation/regression differently by oral/anal/phallic/latency/genital stage. | N13 → N41/N43 | Fixation level, regression pull, symptom choice bias |
| D10 | Oedipal dissolution threshold | Oedipal configuration | Love, hostility, punishment fear, castration anxiety, loss-of-love anxiety | If castration + loss-of-love anxiety exceeds threshold, dissolve Oedipus and form superego residues. | N14 | Identification, ego ideal, conscience, repression load |
| D11 | Later authority kind | Later authority event | Teacher/culture/law/religion/ideal, humane correction, humiliation, renunciation demand | Source/kind determines social authority, ego ideal, conscience, rigidity, guilt, flexibility, or cultural pressure. | N15/N08 | Superego modification, cultural pressure, renunciation effects |
| D12 | Id demand class selection | Internal stimuli + id state + reactivated memories | Bodily need, libido, aggression, dependency, narcissism, repetition | Each pressure type above threshold creates a corresponding DriveDemand. | N16 | DriveDemand list |
| D13 | Structural route from id | DriveDemand | Forbidden status, danger status, idealizable/sublimatable status, aggression | Safe material routes directly; idealizable material routes via ego ideal; forbidden/aggressive material routes via superego guilt. | N17 | Topographic packets and structural routes |
| D14 | Primary-process distortion required | DriveDemand intensity and ego tolerance | Affect/drive intensity, memory links, forbiddenness, repetition | If demand exceeds ego tolerance or is forbidden/repetition-based, apply displacement/condensation/symbolization/disguise. | N18 | Distorted symbolic packet |
| D15 | Primal repression vs repression proper | Packet + repression network + developmental/trauma context | Existing primal core, first fixation, trauma, infantile no-word-link status, censorship danger | Foundational first-fixation/trauma/no-word-link with no core creates primal repression; derivatives use repression proper. | N20 or N21 or no repression | Repression node or pass-through packet |
| D16 | Return-of-repressed channel | Repression node + current state + conflict | Return channels, sleep/waking/action/conflict state | Dream channel runs in sleep; parapraxis in waking speech/action; symptom if high conflict; preconscious if allowed. | N23 → N24/N44/N42/N26 | Dream/parapraxis/symptom/preconscious material |
| D17 | Censorship gate | Packet + ego capacity | Affect charge, guilt threat, forbiddenness, reality danger, distortion, ego capacity, anticathexis budget | Low danger allows consciousness; moderate danger preconscious; disguisable danger routed disguised; forbidden with budget kept unconscious; overwhelming affect becomes anxiety or symptom seed. | N26 → N27 | Routed packet status |
| D18 | Ego reception mode | Routed packet region | Conscious, preconscious, unconscious | Conscious packets get synthesis; preconscious packets partial synthesis; unconscious packets registered as pressure only. | N27 | Ego material |
| D19 | Ego synthesis capacity | Ego material + ego binding capacity | Affect charge, binding capacity, word-linking/time/reality links | If binding capacity is enough, material becomes organized thought; otherwise partial binding and anxiety. | N27/N28 | Bound material or anxiety/defense marker |
| D20 | Word-linking sufficiency | Representation packet | Thing-presentation, word-presentation, affect quota, preconscious link strength | If word link exists or can be created, access to preconscious/conscious increases; if split remains high, symbolization/anxiety bias is added. | N28 | Linked material or symbolization bias |
| D21 | Reality action feasibility | Ego material + external input | Danger, social/legal/physical/resource cost, opportunity, safe/unsafe channels | If total cost exceeds threshold, direct action blocked/delay required; otherwise action possible. | N29 → N32/N36/N42 | RealityReport |
| D22 | Cultural delta exists | Reality report + prior cultural context | Newly discovered cultural pressure | If delta is new/unapplied, apply only delta; otherwise skip. | N30 → N31/N36 | Delta-based cultural pressure |
| D23 | Superego moral judgment | Ego material + reality report + superego state | Prohibition, ideal gap, aggression, harm, repair, sublimation potential | Violations increase guilt/prohibition/punishment; ideal failures increase shame; repair/sublimation can reduce or reward. | N31 → N32/N36/N42 | SuperegoJudgment |
| D24 | Pleasure/reality arbitration mode | Ego material + reality report + superego judgment + ego capacities | Raw pleasure demand, immediate pleasure, delay cost, reality danger, superego danger, sublimation/fantasy capacity | Select immediate discharge, delayed satisfaction, thought trial action, sublimation, fantasy, renunciation, or repression/defensive blocking. | N32 → N37/N42 | Arbitration record and defense bias |
| D25 | Negation vs judgment | Ego material + repression network | Negated content, intellectual recognition, affective acceptance, reality/moral acceptance | Negated repressed content is accepted only under denial; ordinary material gets judgment outcome; unresolved contradiction marked for working-through. | N33 → T08/T11 possible | NegationJudgmentRecord |
| D26 | Ego split active | Ego material + reality report + superego judgment + body confusion | Wish/reality contradiction, wish/superego contradiction, inside/outside confusion | If contradiction exceeds threshold, create parallel ego currents and select dominant current. | N34 → N38/N42/N43 | EgoSplitState and defense bias |
| D27 | Conflict type | Id/reality/superego pressure + ego capacity | Pressure totals and ego capacity | Dominant pressure determines conflict type: none, ego vs id, ego vs superego, ego vs reality, id+superego vs ego, split, multidirectional. | N36 → N37/N38/N39/N40 | ConflictReport |
| D28 | Arbitration conflict effect | Arbitration record + current conflict | Unresolved pleasure pressure, failure risk, fantasy/repression/renunciation mode | Adds unresolved pleasure pressure, symptom/compulsion risk, reality distortion risk, or after-pressure into current conflict. | N37 → N38/N40 | Updated conflict |
| D29 | Ego-split conflict effect | EgoSplitState + current conflict | Disavowal, neurotic compromise risk, psychotic reconstruction risk, dominant current | Adds reality distortion, symptom, self-punishment risk; may set conflict to split type. | N38 → N40 | Updated conflict |
| D30 | Developmental anxiety mapping | Developmental anxiety map + conflict | Object loss, loss of love, castration, authority punishment, superego condemnation, traumatic helplessness | Maps developmental danger to neurotic, moral, traumatic, or mixed anxiety. | N39 → N40 | Updated anxiety type/level |
| D31 | Anxiety type | Conflict + ego thresholds | Dominant danger source, total conflict, anxiety threshold, tolerance for tension, guilt tolerance | External danger → realistic anxiety; id danger → neurotic anxiety; superego danger → moral anxiety; overwhelm → traumatic; mixed pressure → mixed anxiety. | N40 → N41/N42 | Anxiety signal |
| D32 | Regression trigger | Conflict + ego tolerance + fixation records | Total conflict, ego tolerance, fixation/regression pull | If conflict exceeds ego tolerance, select strongest fixation target and add stage-specific pressure/defense bias. | N41 → N42/N43 | Regression pressure and defense bias |
| D33 | Defense/output path | Conflict + reality report + superego judgment + ego capacities + defense bias | Conflict type, action feasibility, moral permission, sublimation capacity, repression budget, symptom risk, compulsion risk, inhibition risk | Chooses direct action, delayed action, sublimation, modified action, repression, secondary defense, id+superego alliance handler, symptom, compulsion, inhibition, self-punishment, reality conflict path, fantasy. | N42 → N43/N45 | EgoResponse |
| D34 | Id+superego alliance subdecision | Conflict + superego judgment + ego capacities | Sublimation capacity, repair capacity, anticathexis budget, guilt/punishment | Sublimation if possible; repair if possible; repression if budget exists; otherwise punitive symptom. | N42 | Specialized EgoResponse |
| D35 | Reality conflict subdecision | Conflict + reality pressure + ego reality testing/self-coherence | Reality pressure, reality testing capacity, coherence, split capacity | Delay/adapt if reality testing adequate; avoid if coherence preserved; disavow if two attitudes possible; otherwise reality reconstruction. | N42 | Specialized EgoResponse |
| D36 | Clinical pattern classifier | Response + conflict + fixation + libido + instinct mixture | Defense cluster, output type, symptom content, reality relation, object loss, superego attack | Maps current output to hysteria, phobia, obsession, melancholia, mourning, paranoia, psychosis, moral masochism, character formation, ordinary conflict. | N43 | Clinical pattern and handler override |
| D37 | Parapraxis override | Current intended act + unconscious counter-intention | Speech/writing/memory/action intention, counter-intention affect | If counter-intention exists above threshold, it may override output as slip/parapraxis. | N44 → N45 | Parapraxis packet/output type |
| D38 | Output execution switch | EgoResponse output type | Output type and relevant plan | Each output type invokes matching action: action, delay, symptom, compulsion, inhibition, fantasy, self-punishment, withdrawal, reconstruction, no-action. | N45 → N46 | OutputResult |
| D39 | Feedback update branch | Output result + EgoResponse + conflict + judgment | Reality success/failure, harm, type of output, expected discharge, guilt, shame, energy cost | Success strengthens ego; repression consumes anticathexis; symptoms increase repetition; self-punishment gives temporary guilt relief but reinforces punishment need; harm increases realistic anxiety. | N46 → N47 | Updated id/ego/superego/reality history |
| D40 | Memory outcome branch | EgoResponse + output result | Integration potential, reality success, defenses, output type | Integrated success becomes accessible memory; repression creates repressed trace; symptom creates disguised partial trace; reconstruction creates distorted trace; otherwise partial integration. | N47 → N48 | MemoryTrace and repetition/repression updates |
| D41 | Normalization bounds | Updated system state | Anxiety, guilt, shame, id pressures, ego strength/fatigue, superego severity, energy | Clamp values, prevent negatives, recompute total excitation. | N48 → next cycle N02 | Stabilized state |

---

## B. Therapeutic Decision Points

| Decision ID | Decision point | Information source | Information type | How decision is made | Can lead to | Output information |
|---|---|---|---|---|---|---|
| TD01 | Target active? | Target pattern | Symptom intensity, repetition pressure, unconscious guilt, ego integration | If target remains active, continue therapy loop; if below thresholds and ego integration sufficient, stop. | T01 continues or terminates | Active/inactive target state |
| TD02 | Resistance type | Association stream + current state | Silence, intellectualization, acting out, repression load, transference intensity, secondary gain, repetition, punishment need | Pattern of session behaviour and state pressure determines resistance type. | T03 → T04 | ResistanceType |
| TD03 | Transference type | Analytic input | Affection, eroticization, hostility, parental authority projection, judge projection, repeated scene | Affect toward analyst determines transference class. | T05 → T06 | TransferenceType |
| TD04 | Repetition in session? | Analytic input + history | Repeated scene, acted-out pattern, old relationship configuration | If current session repeats old scene, convert repetition into remembering. | T02/T06 → T07 | Repetition scene |
| TD05 | Interpretation readiness | Analytic field | Alliance strength, resistance visibility, transference interpretability, readiness threshold | If readiness exceeds threshold, interpretation is applied; otherwise working-through waits/iterates. | T08 | Interpretation or continued iteration |
| TD06 | Resistance reduced? | Working-through loop | Source resistance intensity after interpretation | If reduced, clear resistance; otherwise continue iterations until phase max. | T08 loop | Reduced or persistent resistance |
| TD07 | Negative therapeutic reaction? | Analytic field + improvement | Improvement-triggered guilt, punishment need | If risk exceeds threshold, improvement activates self-punishment/inhibition and superego resistance. | T09 | Self-punishment bias and guilt visibility |
| TD08 | Dream available for interpretation? | Active dream packet | Dream report and associations | If dream packet exists, interpret backward from manifest content to latent/repressed/infantile sources. | T10 | Dream interpretation path |
| TD09 | Parapraxis available for interpretation? | Active parapraxis packet | Slip, bungled action, forgetting, joke, counter-intention | If packet exists, trace manifest mistake to hidden motive. | T10 | Parapraxis interpretation |
| TD10 | Hidden conflict found? | Target pattern + memory/repression network | Symptom source, wish, memory, repression node | If found, run working-through pipeline and reduction modules; if not found, continue analytic loop. | T11/T12/T13 or T01 loop | Reduced repression/repetition, softened superego, strengthened ego |
| TD11 | Superego guilt interpretable? | Source material | Oedipal guilt, ambivalence, punishment need | If source relates to guilt/ambivalence, soften superego. | T12 | Reduced punishment need and rigidity |
| TD12 | Successful integration? | Working-through result | Word-linking, affect tolerance, reality-linking, lower repetition | If successful, increase ego capacity and reduce repression load. | T13 | Ego strengthening |

---

# Part III — Node-to-Decision Graph

## Main cycle graph

```text
N01 Initialize
  → N02 External reality perception
  → N03 Internal stimulus detection
  → N04 Body-ego boundary update
  → D02 Body signal threshold
  → N05 Bodily ego main-loop influence
  → D03 Memory reactivation
  → N06 Memory reactivation
  → D04 Object/libido event type
  → N07 Libido distribution
  → D05 Cultural context
  → N08 Cultural pressure
  → N09 Safe conflict capture
  → D06 Instinct fusion
  → N10 Instinct mixture
  → D07 Defusion direction
  → N11 Instinct defusion
  → D08 Developmental event present
      yes → N12 → D09/N13 → D10/N14 → D11/N15
      no  → N16
  → D12 Id demand class selection
  → N16 Id demand generation
  → D13 Structural route
  → N17 Structural routing
  → D14 Primary process distortion
  → N18 Primary process
  → N19 Packet merge
  → D15 Primal repression / repression proper
      primal → N20
      proper → N21
      none   → N22
  → N22 Derivatives
  → D16 Return channel
  → N23 Return of repressed
  → D01 Sleep vs waking
      sleep → N24 Dream work → N25 Dream economic feedback → N47 → N48 → next cycle
      waking → N26 Censorship
  → D17 Censorship gate
  → N26 Topographic routing
  → D18 Ego reception mode
  → N27 Ego reception/synthesis
  → D19 Synthesis capacity
  → D20 Word-linking sufficiency
  → N28 Representation linking
  → D21 Reality feasibility
  → N29 Reality testing
  → D22 Cultural delta
  → N30 Cultural delta update
  → D23 Superego judgment
  → N31 Superego evaluation
  → D24 Pleasure/reality arbitration
  → N32 Arbitration
  → D25 Negation/judgment
  → N33 Negation and judgment
  → D26 Ego split
  → N34 Ego split detection
  → N35 Developmental anxiety
  → D27 Conflict type
  → N36 Conflict computation
  → D28 Arbitration conflict effect
  → N37 Apply arbitration
  → D29 Split conflict effect
  → N38 Apply split
  → D30 Developmental anxiety mapping
  → N39 Map developmental anxiety
  → D31 Anxiety type
  → N40 Anxiety signal
  → D32 Regression trigger
  → N41 Regression
  → D33 Defense/output path
  → N42 Defense and output selection
  → D36 Clinical classifier
  → N43 Clinical handling
  → D37 Parapraxis override
  → N44 Slips/everyday formation
  → D38 Output execution
  → N45 Execute output
  → D39 Feedback branch
  → N46 Feedback update
  → D40 Memory outcome branch
  → N47 Memory/repression/repetition update
  → D41 Normalization
  → N48 Homeostatic normalization
  → next cycle
```

## Therapeutic graph

```text
T01 Therapeutic target active?
  → T02 Analytic session input
  → TD02 Resistance type
  → T03 Resistance detection
  → T04 Resistance handling
  → TD03 Transference type
  → T05 Transference detection
  → T06 Transference handling
  → TD04 Repetition in session?
      yes → T07 Repetition to remembering
      no  → TD05
  → TD05 Interpretation readiness
      ready → T08 Interpretation and working-through
      not ready → continue iteration
  → TD07 Negative therapeutic reaction?
      yes → T09 Handle negative therapeutic reaction
      no  → TD08
  → TD08 Dream available?
      yes → T10 Dream interpretation
  → TD09 Parapraxis available?
      yes → T10 Parapraxis interpretation
  → TD10 Hidden conflict found?
      yes → T11 Reduce repression/repetition → TD11/T12 → T12 Soften superego → TD12/T13 → T13 Increase ego capacity
      no  → T01
  → TD01 Target resolved?
      yes → exit
      no  → T01
```

---

# Part IV — Output Types as Terminal or Semi-Terminal Nodes

These are not always final endpoints because every output feeds back into memory, energy, ego strength, superego pressure, and repetition.

| Output node | Generated by | Real-world behaviour represented | Feeds back into |
|---|---|---|---|
| O01 Direct action | Low conflict, action possible, moral permission | Direct satisfaction/action without major defense | Id discharge, ego mastery, reality learning |
| O02 Delayed action | Reality requires delay and ego can delay | Postponed satisfaction under reality principle | Bound energy, ego strength, future action plan |
| O03 Modified action | Moderate conflict and flexible defenses | Compromise action with acceptable form | Partial discharge, partial superego relief |
| O04 Sublimated action | Sublimation capacity and opportunity | Drive transformed into work, art, learning, socially valued action | Sublimated energy, ego strength, superego approval |
| O05 Fantasy output | Direct action blocked, imaginary satisfaction available | Private wish satisfaction or daydream | Partial discharge, possible repetition |
| O06 Dream output | Sleep branch | Disguised wish handling during sleep | Dream economic feedback, memory/repression update |
| O07 Slip/parapraxis | Counter-intention interferes with intended act | Slip, forgetting, bungled action, joke | Interpretation path, return of repressed |
| O08 Symptom output | High symptom risk, repression/compromise | Disguised wish-expression plus suffering/anxiety-binding | Symptom-bound energy, repetition, ego cost |
| O09 Compulsive action | High repetition/compulsion risk | Repeated act to bind, undo, or master anxiety | Temporary relief, stronger repetition |
| O10 Inhibition output | High inhibition risk | Blocking function to avoid conflict | Reduced motor/function capacity, unresolved pressure |
| O11 Avoidance output | Reality/internal danger displaced outward | Avoid trigger or reality field | Temporary anxiety reduction, repetition/avoidance learning |
| O12 Rationalized action | Repression failure with secondary defense | Action with acceptable explanation masking motive | Partial discharge, low integration |
| O13 Repair action | Superego repair demand and ego repair capacity | Apology, restitution, undoing, moral repair | Guilt relief, ego integration if realistic |
| O14 Confession/appeasement | Superego pressure and appeasement route | Confession or submission to reduce guilt | Temporary superego relief |
| O15 Self-punishment | Superego punishment/moral masochism | Failure, suffering, self-attack, deprivation | Temporary guilt relief, punishment reinforcement |
| O16 Withdrawal from reality | Reality conflict, low adaptation | Avoidance or withdrawal from shared reality | Reality-testing cost, possible reconstruction risk |
| O17 Disavowed action | Split ego attitudes | Action while both knowing and not-knowing reality | Disavowal reinforcement, split persistence |
| O18 Reality reconstruction | Severe reality conflict | Substitute reality built around wish | Reality-testing damage, high repetition |
| O19 No action | Repression/inhibition route | Wish held outside action/consciousness | Anticathexis cost, repressed pressure |

---

# Part V — Minimal Implementation Schema

If this is converted into a computational graph, each node can be represented as:

```json
{
  "node_id": "N32",
  "name": "Pleasure/reality arbitration",
  "accepts": ["ego_material", "reality_report", "superego_judgment", "ego_capacity"],
  "state_reads": ["id.free_drive_energy", "id.repressed_wish_pressure", "ego.capacity_to_delay", "ego.sublimation_capacity"],
  "state_writes": ["pleasure_reality_arbitration", "base_state.pending_defense_biases", "energy.bound_energy"],
  "real_world_behavior": "The ego decides whether immediate satisfaction can be allowed, delayed, transformed, fantasized, renounced, or repressed.",
  "outputs": ["PleasureRealityArbitrationRecord", "defense_biases"],
  "next_decisions": ["D28"]
}
```

Each decision point can be represented as:

```json
{
  "decision_id": "D24",
  "name": "Pleasure/reality arbitration mode",
  "input_sources": ["N29 Reality testing", "N31 Superego judgment", "N27/N28 Ego material"],
  "information_type": ["pleasure demand", "reality danger", "superego danger", "delay/sublimation capacity"],
  "rule": "Choose immediate discharge, delayed satisfaction, thought trial action, sublimation, fantasy, renunciation, or repression based on danger and capacity thresholds.",
  "possible_leads": ["N37 Apply arbitration to conflict", "N42 Defense/output selection"],
  "output_information": ["arbitration mode", "unresolved pleasure pressure", "repression required flag", "fantasy/sublimation channel", "defense bias"]
}
```
