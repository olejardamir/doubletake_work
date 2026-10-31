# Full Freudian Id–Ego–Superego Mechanism — V6 Complete Canonical Pseudocode

## Canonical status

This is the cleaned V6 file. It makes `Full_Freudian_Id_Ego_Superego_Mechanism_V6_Complete()` the single authoritative complete model.

V6 preserves the full V5 Freudian mechanism and adds the remaining high-value mechanism coverage identified in review:

1. keeps all V5 structural, topographic, economic, developmental, clinical, and therapeutic coverage,
2. adds explicit pleasure-principle / reality-principle arbitration,
3. adds negation and judgment as a partial lifting of repression without full affective acceptance,
4. upgrades ego-splitting from a conflict label into persistent parallel ego attitudes,
5. integrates bodily-ego signals directly into id pressure, ego anxiety, defense selection, conversion risk, and reality testing,
6. updates the main operating loop and coverage checklist so these mechanisms are canonical rather than appendices.

Canonical rule: the only authoritative complete entry point is `Full_Freudian_Id_Ego_Superego_Mechanism_V6_Complete()`. The earlier base procedure, base operating loop, and V5 loop are retained only as module-library scaffolding, not as the final model loop.

---

# Full Freudian Id–Ego–Superego Mechanism — End-to-End Pseudocode

## Status

This is a conceptual pseudocode model of the full mechanism of interaction between id, ego, superego, external reality, unconscious/preconscious/conscious routing, energy economy, defenses, symptom formation, repetition, development, and therapeutic reversal.

It is not a clinical diagnosis tool and not a literal computational implementation of Freud. It is a functional reconstruction of the mechanism.

---

# BASE MODULE LIBRARY: Base_Freudian_Module_Library()

```text
PROCEDURE Base_Freudian_Module_Library()

################################################################
# 0. MODEL PURPOSE
################################################################

DEFINE purpose =
    "Represent the functioning of Freud's id, ego, and superego as a
     dynamic system involving drive pressure, reality-testing, moral
     judgment, unconscious routing, censorship, energy investment,
     anxiety, defense, symptom formation, repetition, development,
     and working-through."

DEFINE model_kind = "conceptual pseudocode"
DEFINE not_medical_diagnosis = true
DEFINE not_literal_neuroscience = true
DEFINE not_cleanly_modular = true

# Important:
# Freud's agencies are not clean software modules with hard borders.
# They overlap, merge, and shift. This pseudocode uses modules only
# to clarify function.


################################################################
# 1. FUNDAMENTAL REGIONS AND AGENCIES
################################################################

ENUM PsychicAgency:
    ID
    EGO
    SUPEREGO
    EXTERNAL_REALITY

ENUM TopographicRegion:
    UNCONSCIOUS
    PRECONSCIOUS
    CONSCIOUS

ENUM ProcessMode:
    PRIMARY_PROCESS
    SECONDARY_PROCESS
    MIXED_PROCESS

ENUM EnergyState:
    FREE_ENERGY
    BOUND_ENERGY
    DISCHARGED_ENERGY
    REPRESSED_ENERGY
    SUBLIMATED_ENERGY
    SYMPTOM_BOUND_ENERGY

ENUM DriveClass:
    LIBIDINAL
    AGGRESSIVE
    SELF_PRESERVATIVE
    DEPENDENCY
    NARCISSISTIC
    REPETITION_BASED
    MIXED_DRIVE

ENUM AnxietyType:
    NONE
    REALISTIC_ANXIETY
    NEUROTIC_ANXIETY
    MORAL_ANXIETY
    TRAUMATIC_AUTOMATIC_ANXIETY
    MIXED_ANXIETY

ENUM ConflictType:
    NONE
    EGO_VS_ID
    EGO_VS_SUPEREGO
    EGO_VS_REALITY
    ID_VS_SUPEREGO
    ID_PLUS_SUPEREGO_VS_EGO
    EGO_SPLIT_BETWEEN_REALITY_AND_WISH
    MULTI_DIRECTIONAL_CONFLICT

ENUM DefenseType:
    NONE
    REPRESSION
    DISPLACEMENT
    CONDENSATION
    SYMBOLIZATION
    PROJECTION
    INTROJECTION
    IDENTIFICATION
    REACTION_FORMATION
    RATIONALIZATION
    ISOLATION_OF_AFFECT
    UNDOING
    DENIAL
    DISAVOWAL
    REGRESSION
    FANTASY_WITHDRAWAL
    TURNING_AGAINST_SELF
    INHIBITION
    AVOIDANCE
    SUBLIMATION
    COMPROMISE_FORMATION
    SOMATIC_CONVERSION
    COMPULSIVE_REPETITION
    REALITY_RECONSTRUCTION

ENUM OutputType:
    DIRECT_ACTION
    DELAYED_ACTION
    MODIFIED_ACTION
    SUBLIMATED_ACTION
    FANTASY_OUTPUT
    DREAM_OUTPUT
    SLIP_OR_PARAPRAXIS
    SYMPTOM_OUTPUT
    COMPULSIVE_ACTION
    INHIBITION_OUTPUT
    AVOIDANCE_OUTPUT
    RATIONALIZED_ACTION
    REPAIR_ACTION
    CONFESSION_OR_APPEASEMENT
    SELF_PUNISHMENT
    WITHDRAWAL_FROM_REALITY
    DISAVOWED_ACTION
    REALITY_RECONSTRUCTION
    NO_ACTION

ENUM DevelopmentalEventType:
    FRUSTRATION
    SATISFACTION
    LOSS_OF_OBJECT
    AUTHORITY_PROHIBITION
    PUNISHMENT
    PRAISE
    IDENTIFICATION_EVENT
    TRAUMA
    SOCIALIZATION
    IDEALIZATION
    RIVALRY
    RENUNCIATION
    REPAIR


################################################################
# 2. CORE DATA STRUCTURES
################################################################

STRUCT DriveDemand:
    id: text
    drive_class: DriveClass
    source_agency: PsychicAgency = ID
    raw_wish: text
    object_target: text
    aim: text
    intensity: number
    urgency: number
    pleasure_expected: number
    unpleasure_if_blocked: number
    aggression_component: number
    libido_component: number
    dependency_component: number
    narcissistic_component: number
    repetition_component: number
    source_memory_ids: list
    forbidden_status: boolean
    danger_status: boolean
    current_region: TopographicRegion
    process_mode: ProcessMode
    symbolic_forms: list
    affect_charge: number
    cathexis_level: number

STRUCT ExternalRealityInput:
    current_situation: text
    available_objects: list
    opportunities: list
    physical_limits: list
    social_rules: list
    social_costs: list
    legal_costs: list
    resource_constraints: list
    immediate_danger: number
    long_term_danger: number
    feasibility_of_action: number
    possibility_of_delay: boolean
    possibility_of_sublimation: boolean
    possibility_of_repair: boolean

STRUCT RealityReport:
    action_possible: boolean
    delay_required: boolean
    external_danger: number
    social_cost: number
    physical_cost: number
    legal_cost: number
    resource_cost: number
    opportunity_value: number
    predicted_consequences: list
    reality_distortion_risk: number
    safe_channels: list
    unsafe_channels: list

STRUCT SuperegoJudgment:
    prohibition_level: number
    guilt_threat: number
    shame_threat: number
    inferiority_threat: number
    punishment_demand: number
    ideal_gap: number
    approval_reward: number
    moral_permission: boolean
    demand_for_repair: number
    demand_for_renunciation: number
    demand_for_perfection: number
    command_text: text
    unconscious_guilt_component: number
    harshness: number

STRUCT IdState:
    free_drive_energy: number
    libido_pool: number
    aggression_pool: number
    bodily_need_pressure: number
    dependency_pressure: number
    narcissistic_pressure: number
    repetition_pressure: number
    primary_process_activity: number
    repressed_wish_pressure: number
    unresolved_affect_pressure: number
    pleasure_principle_dominance: number

STRUCT EgoState:
    strength: number
    fatigue: number
    reality_testing_capacity: number
    perception_capacity: number
    planning_capacity: number
    motor_control_capacity: number
    tolerance_for_tension: number
    binding_capacity: number
    symbolization_capacity: number
    word_linking_capacity: number
    defense_flexibility: number
    repression_load: number
    anticathexis_budget: number
    sublimation_capacity: number
    integration_capacity: number
    self_coherence: number
    anxiety_threshold: number
    guilt_tolerance: number
    capacity_to_delay: number
    capacity_for_repair: number
    capacity_for_working_through: number

STRUCT SuperegoState:
    conscience_strength: number
    ego_ideal_demand: number
    internalized_authority_strength: number
    parental_agency_strength: number
    social_authority_strength: number
    severity: number
    rigidity: number
    sadistic_punishment_force: number
    approval_reward_strength: number
    shame_generation: number
    guilt_generation: number
    moral_flexibility: number
    unconscious_punishment_need: number
    prohibition_against_aggression: number
    prohibition_against_libidinal_wish: number
    prohibition_against_dependency_wish: number
    prohibition_against_narcissistic_grandiosity: number

STRUCT EnergyEconomy:
    total_excitation: number
    free_energy: number
    bound_energy: number
    discharged_energy: number
    cathexes: map              # object/wish/memory/ideal -> energy invested
    anticathexes: map          # repressed material -> energy spent holding back
    symptom_bound_energy: map  # symptom -> energy temporarily bound
    sublimated_energy: map     # activity/work/art/thought -> transformed energy
    available_discharge_capacity: number
    available_binding_capacity: number

STRUCT MemoryTrace:
    id: text
    event_content: text
    event_type: DevelopmentalEventType
    affect_charge: number
    cathexis_level: number
    current_region: TopographicRegion
    integrated: boolean
    repressed: boolean
    symbolized: boolean
    linked_to_words: boolean
    linked_to_time: boolean
    linked_to_reality_context: boolean
    accessible_to_ego: boolean
    pathogenic_potential: number
    repetition_pressure: number
    associated_wishes: list
    associated_defenses: list
    associated_symptoms: list

STRUCT TopographicPacket:
    content: text
    source: PsychicAgency
    target_region: TopographicRegion
    current_region: TopographicRegion
    process_mode: ProcessMode
    affect_charge: number
    forbidden: boolean
    reality_dangerous: boolean
    guilt_threat: number
    distortion_level: number
    symbolic_form: text
    word_linked: boolean
    allowed_to_consciousness: boolean

STRUCT ConflictReport:
    conflict_type: ConflictType
    id_pressure: number
    reality_pressure: number
    superego_pressure: number
    ego_capacity: number
    total_conflict: number
    dominant_danger_source: text
    anxiety_type: AnxietyType
    anxiety_level: number
    guilt_level: number
    shame_level: number
    risk_of_symptom: number
    risk_of_compulsion: number
    risk_of_inhibition: number
    risk_of_reality_distortion: number
    risk_of_self_punishment: number
    recommended_defense_intensity: number

STRUCT EgoResponse:
    output_type: OutputType
    selected_defenses: list
    conscious_explanation: text
    unconscious_motive: text
    action_plan: text
    fantasy_plan: text
    symptom_plan: text
    sublimation_plan: text
    repair_plan: text
    self_punishment_plan: text
    reality_reconstruction_plan: text
    anxiety_level: number
    guilt_level: number
    energy_cost: number
    anticathexis_required: number
    expected_id_discharge: number
    expected_superego_relief: number
    expected_reality_success: number
    expected_ego_strength_change: number
    repetition_risk: number
    integration_potential: number

STRUCT SystemState:
    id: IdState
    ego: EgoState
    superego: SuperegoState
    energy: EnergyEconomy
    memories: list of MemoryTrace
    active_packets: list of TopographicPacket
    active_drive_demands: list of DriveDemand
    active_reality_report: RealityReport
    active_superego_judgment: SuperegoJudgment
    active_conflict_report: ConflictReport
    active_ego_response: EgoResponse
    pending_defense_biases: list
    symptom_history: list
    repetition_history: list
    sublimation_history: list
    defense_history: list
    developmental_history: list
    current_anxiety: number
    current_guilt: number
    current_shame: number


################################################################
# 3. INITIALIZATION
################################################################

PROCEDURE Initialize_System():

    CREATE state = SystemState()

    state.id.free_drive_energy = BASELINE_FREE_DRIVE_ENERGY
    state.id.libido_pool = BASELINE_LIBIDO
    state.id.aggression_pool = BASELINE_AGGRESSION
    state.id.bodily_need_pressure = 0
    state.id.dependency_pressure = BASELINE_DEPENDENCY
    state.id.narcissistic_pressure = BASELINE_NARCISSISTIC_PRESSURE
    state.id.repetition_pressure = 0
    state.id.primary_process_activity = BASELINE_PRIMARY_PROCESS_ACTIVITY
    state.id.repressed_wish_pressure = 0
    state.id.unresolved_affect_pressure = 0
    state.id.pleasure_principle_dominance = HIGH

    state.ego.strength = DEVELOPMENTALLY_ACQUIRED_EGO_STRENGTH
    state.ego.fatigue = 0
    state.ego.reality_testing_capacity = BASELINE_REALITY_TESTING
    state.ego.perception_capacity = BASELINE_PERCEPTION
    state.ego.planning_capacity = BASELINE_PLANNING
    state.ego.motor_control_capacity = BASELINE_MOTOR_CONTROL
    state.ego.tolerance_for_tension = BASELINE_TENSION_TOLERANCE
    state.ego.binding_capacity = BASELINE_BINDING_CAPACITY
    state.ego.symbolization_capacity = BASELINE_SYMBOLIZATION
    state.ego.word_linking_capacity = BASELINE_WORD_LINKING
    state.ego.defense_flexibility = BASELINE_DEFENSE_FLEXIBILITY
    state.ego.repression_load = 0
    state.ego.anticathexis_budget = BASELINE_ANTICATHEXIS_BUDGET
    state.ego.sublimation_capacity = BASELINE_SUBLIMATION
    state.ego.integration_capacity = BASELINE_INTEGRATION
    state.ego.self_coherence = BASELINE_SELF_COHERENCE
    state.ego.anxiety_threshold = BASELINE_ANXIETY_THRESHOLD
    state.ego.guilt_tolerance = BASELINE_GUILT_TOLERANCE
    state.ego.capacity_to_delay = BASELINE_DELAY_CAPACITY
    state.ego.capacity_for_repair = BASELINE_REPAIR_CAPACITY
    state.ego.capacity_for_working_through = BASELINE_WORKING_THROUGH_CAPACITY

    state.superego.conscience_strength = BASELINE_CONSCIENCE
    state.superego.ego_ideal_demand = BASELINE_EGO_IDEAL
    state.superego.internalized_authority_strength = BASELINE_AUTHORITY_INTERNALIZATION
    state.superego.parental_agency_strength = BASELINE_PARENTAL_AUTHORITY
    state.superego.social_authority_strength = BASELINE_SOCIAL_AUTHORITY
    state.superego.severity = BASELINE_SEVERITY
    state.superego.rigidity = BASELINE_RIGIDITY
    state.superego.sadistic_punishment_force = BASELINE_SUPEREGO_AGGRESSION
    state.superego.approval_reward_strength = BASELINE_APPROVAL_REWARD
    state.superego.shame_generation = BASELINE_SHAME_GENERATION
    state.superego.guilt_generation = BASELINE_GUILT_GENERATION
    state.superego.moral_flexibility = BASELINE_MORAL_FLEXIBILITY
    state.superego.unconscious_punishment_need = 0
    state.superego.prohibition_against_aggression = BASELINE_AGGRESSION_PROHIBITION
    state.superego.prohibition_against_libidinal_wish = BASELINE_LIBIDINAL_PROHIBITION
    state.superego.prohibition_against_dependency_wish = BASELINE_DEPENDENCY_PROHIBITION
    state.superego.prohibition_against_narcissistic_grandiosity = BASELINE_NARCISSISTIC_PROHIBITION

    state.energy.total_excitation = BASELINE_TOTAL_EXCITATION
    state.energy.free_energy = BASELINE_FREE_ENERGY
    state.energy.bound_energy = BASELINE_BOUND_ENERGY
    state.energy.discharged_energy = 0
    state.energy.cathexes = EMPTY_MAP
    state.energy.anticathexes = EMPTY_MAP
    state.energy.symptom_bound_energy = EMPTY_MAP
    state.energy.sublimated_energy = EMPTY_MAP
    state.energy.available_discharge_capacity = BASELINE_DISCHARGE_CAPACITY
    state.energy.available_binding_capacity = BASELINE_BINDING_CAPACITY

    state.memories = []
    state.active_packets = []
    state.active_drive_demands = []
    state.pending_defense_biases = []
    state.symptom_history = []
    state.repetition_history = []
    state.sublimation_history = []
    state.defense_history = []
    state.developmental_history = []
    state.current_anxiety = 0
    state.current_guilt = 0
    state.current_shame = 0

    RETURN state


################################################################
# 4. DEVELOPMENTAL CONSTRUCTION
################################################################

PROCEDURE Developmental_Construction_Update(state, event, object_person):

    # This procedure explains how ego and superego are built over time.
    # The id is treated as the original drive reservoir.
    # The ego differentiates through repeated contact with reality.
    # The superego forms through identification, prohibition, authority,
    # loss, rivalry, idealization, and internalization.

    memory_trace = CREATE_MEMORY_TRACE_FROM_EVENT(event, object_person)

    IF event.type == SATISFACTION:
        state.id.free_drive_energy -= event.satisfaction_amount
        state.ego.self_coherence += SMALL_INCREMENT
        memory_trace.integrated = true
        memory_trace.linked_to_reality_context = true

    IF event.type == FRUSTRATION:
        state.ego.capacity_to_delay += SMALL_INCREMENT_IF_TOLERABLE(event)
        state.ego.reality_testing_capacity += SMALL_INCREMENT_IF_TOLERABLE(event)
        state.id.unresolved_affect_pressure += INCREMENT_IF_NOT_TOLERABLE(event)

    IF event.type == AUTHORITY_PROHIBITION:
        state.superego.conscience_strength += event.authority_intensity
        state.superego.internalized_authority_strength += event.authority_intensity
        state.superego.rigidity += INCREMENT_IF_PROHIBITION_HARSH(event)
        state.superego.moral_flexibility -= DECREMENT_IF_PROHIBITION_ABSOLUTE(event)

    IF event.type == PUNISHMENT:
        state.superego.severity += event.punishment_intensity
        state.superego.sadistic_punishment_force += event.punishment_intensity
        state.ego.anxiety_threshold -= SMALL_DECREMENT_IF_TRAUMATIC(event)
        memory_trace.affect_charge += event.punishment_intensity

    IF event.type == PRAISE:
        state.superego.approval_reward_strength += event.praise_intensity
        state.ego.self_coherence += SMALL_INCREMENT
        state.ego.sublimation_capacity += SMALL_INCREMENT_IF_PRAISE_FOR_WORK_OR_RENUNCIATION(event)

    IF event.type == LOSS_OF_OBJECT:
        identification = CREATE_IDENTIFICATION_WITH_LOST_OBJECT(object_person)
        INSTALL_IDENTIFICATION_IN_EGO(state, identification)
        state.id.dependency_pressure += event.loss_intensity
        memory_trace.affect_charge += event.loss_intensity

    IF event.type == IDENTIFICATION_EVENT:
        identification = CREATE_IDENTIFICATION(object_person, event)
        INSTALL_IDENTIFICATION_IN_EGO(state, identification)

        IF object_person.represents_authority:
            INSTALL_AUTHORITY_FRAGMENT_IN_SUPEREGO(state, identification)

        IF object_person.represents_ideal:
            state.superego.ego_ideal_demand += event.idealization_intensity

    IF event.type == RIVALRY:
        state.id.aggression_pool += event.rivalry_intensity
        state.superego.prohibition_against_aggression += event.prohibition_intensity
        memory_trace.affect_charge += event.rivalry_intensity

    IF event.type == RENUNCIATION:
        IF event.renunciation_is_supported_by_love_or_meaning:
            state.ego.tolerance_for_tension += MEDIUM_INCREMENT
            state.superego.approval_reward_strength += SMALL_INCREMENT
        ELSE:
            state.id.repressed_wish_pressure += event.renounced_wish_intensity
            state.ego.repression_load += event.renounced_wish_intensity

    IF event.type == TRAUMA:
        PROCESS_TRAUMA_DEVELOPMENTALLY(state, event, memory_trace)

    ADD memory_trace TO state.memories
    ADD event TO state.developmental_history

    RETURN state


PROCEDURE PROCESS_TRAUMA_DEVELOPMENTALLY(state, event, memory_trace):

    # Trauma occurs when affect/excitation exceeds ego binding capacity
    # and cannot be discharged, symbolized, associated, or integrated.

    IF event.affect_intensity > state.ego.binding_capacity:
        memory_trace.integrated = false
        memory_trace.repressed = MAYBE_TRUE
        memory_trace.symbolized = false
        memory_trace.linked_to_words = false
        memory_trace.linked_to_time = false
        memory_trace.linked_to_reality_context = false
        memory_trace.accessible_to_ego = false
        memory_trace.pathogenic_potential = HIGH
        memory_trace.repetition_pressure = HIGH

        state.id.unresolved_affect_pressure += event.affect_intensity
        state.id.repetition_pressure += event.affect_intensity
        state.energy.free_energy += event.affect_intensity
        state.ego.self_coherence -= TRAUMA_FRAGMENTATION_COST

    ELSE:
        memory_trace.integrated = true
        memory_trace.symbolized = true
        memory_trace.linked_to_words = true
        memory_trace.linked_to_time = true
        memory_trace.linked_to_reality_context = true
        memory_trace.accessible_to_ego = true
        memory_trace.pathogenic_potential = LOW
        memory_trace.repetition_pressure = LOW

    RETURN state


################################################################
# 5. BASE MAIN OPERATING LOOP — LIBRARY / EXAMPLE ONLY
################################################################

# This loop is retained only to document the simpler base-module flow.
# It is not the authoritative complete model.
# The canonical full mechanism is `COMPLETE_MAIN_OPERATING_LOOP_V6(state_v5)`.

PROCEDURE Main_Operating_Loop(state):

    WHILE subject_is_alive:

        external_input =
            PERCEIVE_EXTERNAL_REALITY()

        internal_stimuli =
            DETECT_INTERNAL_STIMULI(state)

        reactivated_memories =
            DETECT_MEMORY_REACTIVATION(state, external_input, internal_stimuli)

        state.active_drive_demands =
            ID_GENERATE_DRIVE_DEMANDS(state, internal_stimuli, reactivated_memories)

        primary_packets =
            ID_PRIMARY_PROCESS_TRANSFORMATION(state, state.active_drive_demands)

        routed_packets =
            TOPOGRAPHIC_ROUTING_AND_CENSORSHIP(state, primary_packets)

        ego_material =
            EGO_RECEIVE_AND_TRANSLATE(state, routed_packets)

        state.active_reality_report =
            EGO_REALITY_TESTING(state, ego_material, external_input)

        state.active_superego_judgment =
            SUPEREGO_EVALUATION(state, ego_material, state.active_reality_report)

        state.active_conflict_report =
            EGO_COMPUTE_CONFLICT(state, ego_material,
                                 state.active_reality_report,
                                 state.active_superego_judgment)

        state.active_conflict_report =
            EGO_GENERATE_ANXIETY_SIGNAL(state, state.active_conflict_report)

        state.active_ego_response =
            EGO_DEFENSE_AND_OUTPUT_SELECTION(state, ego_material,
                                             state.active_reality_report,
                                             state.active_superego_judgment,
                                             state.active_conflict_report)

        output_result =
            EXECUTE_OUTPUT(state, state.active_ego_response, external_input)

        state =
            FEEDBACK_UPDATE(state, output_result)

        state =
            MEMORY_REPRESSION_REPETITION_UPDATE(state, output_result)

        state =
            HOMEOSTATIC_NORMALIZATION(state)

    END WHILE


################################################################
# 6. INTERNAL STIMULUS AND MEMORY REACTIVATION
################################################################

PROCEDURE DETECT_INTERNAL_STIMULI(state):

    stimuli = {}

    stimuli.bodily_need = SCAN_BODY_NEEDS()
    stimuli.affective_tension = SCAN_AFFECTIVE_TENSION()
    stimuli.unresolved_drive_pressure =
        state.id.free_drive_energy
        + state.id.repressed_wish_pressure
        + state.id.unresolved_affect_pressure

    stimuli.superego_pressure =
        state.superego.unconscious_punishment_need
        + state.current_guilt
        + state.current_shame

    stimuli.ego_fatigue = state.ego.fatigue

    RETURN stimuli


PROCEDURE DETECT_MEMORY_REACTIVATION(state, external_input, internal_stimuli):

    reactivated = []

    FOR EACH memory IN state.memories:

        similarity =
            SIMILARITY(external_input.current_situation, memory.event_content)
            + SIMILARITY(internal_stimuli.affective_tension, memory.affect_charge)

        IF similarity > REACTIVATION_THRESHOLD:
            memory.repetition_pressure += REACTIVATION_INCREMENT
            memory.affect_charge += REACTIVATION_AFFECT_INCREMENT
            ADD memory TO reactivated

    RETURN reactivated


################################################################
# 7. ID DRIVE GENERATION
################################################################

PROCEDURE ID_GENERATE_DRIVE_DEMANDS(state, internal_stimuli, reactivated_memories):

    demands = []

    IF internal_stimuli.bodily_need > BODY_NEED_THRESHOLD:
        ADD CREATE_DRIVE_DEMAND(
            drive_class = SELF_PRESERVATIVE,
            raw_wish = "remove bodily tension immediately",
            intensity = internal_stimuli.bodily_need,
            urgency = HIGH,
            pleasure_expected = MEDIUM,
            unpleasure_if_blocked = HIGH
        ) TO demands

    IF state.id.libido_pool > LIBIDINAL_THRESHOLD:
        ADD CREATE_DRIVE_DEMAND(
            drive_class = LIBIDINAL,
            raw_wish = "obtain pleasure, attachment, union, possession, love, recognition, or satisfaction",
            intensity = state.id.libido_pool,
            urgency = CALCULATE_URGENCY(state.id.libido_pool),
            pleasure_expected = HIGH,
            unpleasure_if_blocked = MEDIUM_TO_HIGH,
            libido_component = state.id.libido_pool
        ) TO demands

    IF state.id.aggression_pool > AGGRESSION_THRESHOLD:
        ADD CREATE_DRIVE_DEMAND(
            drive_class = AGGRESSIVE,
            raw_wish = "attack, remove obstacle, dominate, retaliate, punish, destroy, or discharge rage",
            intensity = state.id.aggression_pool,
            urgency = CALCULATE_URGENCY(state.id.aggression_pool),
            pleasure_expected = VARIABLE,
            unpleasure_if_blocked = HIGH,
            aggression_component = state.id.aggression_pool
        ) TO demands

    IF state.id.dependency_pressure > DEPENDENCY_THRESHOLD:
        ADD CREATE_DRIVE_DEMAND(
            drive_class = DEPENDENCY,
            raw_wish = "obtain care, protection, closeness, rescue, or reassurance",
            intensity = state.id.dependency_pressure,
            urgency = MEDIUM_TO_HIGH,
            pleasure_expected = HIGH,
            unpleasure_if_blocked = HIGH
        ) TO demands

    IF state.id.narcissistic_pressure > NARCISSISTIC_THRESHOLD:
        ADD CREATE_DRIVE_DEMAND(
            drive_class = NARCISSISTIC,
            raw_wish = "restore self-regard, admiration, superiority, recognition, or invulnerability",
            intensity = state.id.narcissistic_pressure,
            urgency = MEDIUM_TO_HIGH,
            pleasure_expected = HIGH,
            unpleasure_if_blocked = HIGH
        ) TO demands

    FOR EACH memory IN reactivated_memories:
        IF memory.repetition_pressure > REPETITION_THRESHOLD:
            ADD CREATE_DRIVE_DEMAND(
                drive_class = REPETITION_BASED,
                raw_wish = "repeat unresolved scene until mastered, discharged, or bound",
                intensity = memory.repetition_pressure,
                urgency = MEDIUM_TO_HIGH,
                pleasure_expected = LOW_OR_NEGATIVE,
                unpleasure_if_blocked = HIGH,
                repetition_component = memory.repetition_pressure,
                source_memory_ids = [memory.id]
            ) TO demands

    FOR EACH demand IN demands:
        demand.current_region = UNCONSCIOUS
        demand.process_mode = PRIMARY_PROCESS
        demand.cathexis_level = demand.intensity
        state.energy.cathexes[demand.id] = demand.cathexis_level

    RETURN demands


################################################################
# 8. ID PRIMARY-PROCESS TRANSFORMATION
################################################################

PROCEDURE ID_PRIMARY_PROCESS_TRANSFORMATION(state, demands):

    packets = []

    FOR EACH demand IN demands:

        packet = CREATE_TOPOGRAPHIC_PACKET_FROM_DEMAND(demand)

        # Primary process does not obey ordinary logic.
        # It transforms pressure through displacement, condensation,
        # symbolization, and wish-fulfilling fantasy.

        IF demand.intensity > state.ego.tolerance_for_tension:
            packet = APPLY_DISPLACEMENT(packet)
            packet = APPLY_CONDENSATION(packet)
            packet = APPLY_SYMBOLIZATION(packet)

        IF demand.source_memory_ids NOT EMPTY:
            packet = ATTACH_MEMORY_IMAGES(packet, state.memories)
            packet = ATTACH_UNDISCHARGED_AFFECT(packet, state.memories)

        IF demand.forbidden_status == true:
            packet.symbolic_form = DISGUISE_FORBIDDEN_WISH(packet)

        IF demand.drive_class == REPETITION_BASED:
            packet.symbolic_form = BUILD_REPETITION_SCENE(packet)

        packet.process_mode = PRIMARY_PROCESS
        packet.current_region = UNCONSCIOUS
        packet.word_linked = false

        ADD packet TO packets

    RETURN packets


PROCEDURE APPLY_DISPLACEMENT(packet):

    # Move affect/energy from dangerous object to safer substitute.

    packet.symbolic_form =
        "substitute object or substitute concern carrying displaced affect"

    packet.distortion_level += DISPLACEMENT_DISTORTION_AMOUNT

    RETURN packet


PROCEDURE APPLY_CONDENSATION(packet):

    # Combine multiple wishes, memories, figures, or affects into one representation.

    packet.symbolic_form =
        "compressed representation containing multiple meanings"

    packet.distortion_level += CONDENSATION_DISTORTION_AMOUNT

    RETURN packet


PROCEDURE APPLY_SYMBOLIZATION(packet):

    # Convert wish/affect into symbol, image, body sensation, dream image, or symptom seed.

    packet.symbolic_form =
        "symbolic representation of drive, affect, or memory"

    packet.distortion_level += SYMBOLIZATION_DISTORTION_AMOUNT

    RETURN packet


################################################################
# 9. TOPOGRAPHIC ROUTING AND CENSORSHIP
################################################################

PROCEDURE TOPOGRAPHIC_ROUTING_AND_CENSORSHIP(state, packets):

    routed = []

    FOR EACH packet IN packets:

        censorship_result =
            CENSORSHIP_GATE(state, packet)

        IF censorship_result == "ALLOW_TO_PRECONSCIOUS":
            packet.current_region = PRECONSCIOUS
            packet.word_linked = TRY_WORD_LINKING(state, packet)
            packet.allowed_to_consciousness = false

        ELSE IF censorship_result == "ALLOW_TO_CONSCIOUS":
            packet.current_region = CONSCIOUS
            packet.word_linked = true
            packet.allowed_to_consciousness = true

        ELSE IF censorship_result == "DISGUISE_AND_ROUTE":
            packet = INCREASE_DISTORTION(packet)
            packet.current_region = PRECONSCIOUS
            packet.word_linked = PARTIAL_WORD_LINKING(packet)
            packet.allowed_to_consciousness = MAYBE

        ELSE IF censorship_result == "KEEP_UNCONSCIOUS":
            packet.current_region = UNCONSCIOUS
            packet.allowed_to_consciousness = false
            state.energy.anticathexes[packet.content] += REQUIRED_ANTICATHEXIS(packet)

        ELSE IF censorship_result == "CONVERT_TO_SYMPTOM_SEED":
            packet.current_region = UNCONSCIOUS
            packet.symbolic_form = "symptom seed"
            packet.allowed_to_consciousness = false
            packet.distortion_level += HIGH

        ELSE IF censorship_result == "CONVERT_TO_ANXIETY":
            packet.current_region = CONSCIOUS
            packet.symbolic_form = "felt anxiety without clear idea"
            packet.allowed_to_consciousness = true

        ADD packet TO routed

    RETURN routed


PROCEDURE CENSORSHIP_GATE(state, packet):

    danger_score =
        packet.affect_charge
        + packet.guilt_threat
        + IF packet.forbidden THEN HIGH ELSE LOW
        + IF packet.reality_dangerous THEN HIGH ELSE LOW
        + packet.distortion_level

    ego_capacity =
        state.ego.strength
        + state.ego.symbolization_capacity
        + state.ego.word_linking_capacity
        + state.ego.tolerance_for_tension
        - state.ego.fatigue
        - state.ego.repression_load

    IF danger_score < ego_capacity * LOW_DANGER_RATIO:
        RETURN "ALLOW_TO_CONSCIOUS"

    IF danger_score < ego_capacity:
        RETURN "ALLOW_TO_PRECONSCIOUS"

    IF danger_score >= ego_capacity
       AND packet.can_be_disguised == true:
        RETURN "DISGUISE_AND_ROUTE"

    IF packet.affect_charge > state.ego.binding_capacity
       AND packet.word_linked == false:
        RETURN "CONVERT_TO_ANXIETY"

    IF packet.forbidden == true
       AND state.ego.anticathexis_budget >= REQUIRED_ANTICATHEXIS(packet):
        RETURN "KEEP_UNCONSCIOUS"

    RETURN "CONVERT_TO_SYMPTOM_SEED"


################################################################
# 10. EGO RECEPTION, BINDING, AND SYNTHESIS
################################################################

PROCEDURE EGO_RECEIVE_AND_TRANSLATE(state, routed_packets):

    ego_material = []

    FOR EACH packet IN routed_packets:

        IF packet.current_region == CONSCIOUS:
            translated = EGO_SYNTHESIS(state, packet)
            ADD translated TO ego_material

        ELSE IF packet.current_region == PRECONSCIOUS:
            translated = EGO_PARTIAL_SYNTHESIS(state, packet)
            ADD translated TO ego_material

        ELSE IF packet.current_region == UNCONSCIOUS:
            # Ego may still defend against unconscious material.
            translated = EGO_REGISTER_AS_PRESSURE_ONLY(state, packet)
            ADD translated TO ego_material

    RETURN ego_material


PROCEDURE EGO_SYNTHESIS(state, packet):

    # Ego tries to bind drive pressure into organized thought.

    material = packet

    material.process_mode = SECONDARY_PROCESS

    IF state.ego.binding_capacity >= material.affect_charge:
        material = BIND_AFFECT_TO_IDEA(material)
        material = LINK_IDEA_TO_WORDS(material)
        material = LINK_IDEA_TO_TIME(material)
        material = LINK_IDEA_TO_REALITY_CONTEXT(material)
        material = LINK_IMPULSE_TO_CONSEQUENCE(material)
        material = LINK_WISH_TO_PLAN_OR_RENUNCIATION(material)
        state.energy.free_energy -= material.affect_charge
        state.energy.bound_energy += material.affect_charge

    ELSE:
        material = PARTIALLY_BIND(material)
        state.current_anxiety += material.affect_charge - state.ego.binding_capacity

    RETURN material


PROCEDURE EGO_PARTIAL_SYNTHESIS(state, packet):

    material = packet
    material.process_mode = MIXED_PROCESS

    IF packet.word_linked == false:
        material = TRY_WORD_LINKING(state, material)

    IF material.affect_charge > state.ego.tolerance_for_tension:
        material = MARK_AS_REQUIRING_DEFENSE(material)

    RETURN material


PROCEDURE EGO_REGISTER_AS_PRESSURE_ONLY(state, packet):

    material = packet
    material.process_mode = PRIMARY_PROCESS
    material.visible_to_ego_as = SELECT_FROM([
        "tension",
        "anxiety",
        "bodily sensation",
        "compulsion",
        "mood",
        "fantasy pressure",
        "unexplained inhibition",
        "irritability",
        "guilt without clear cause"
    ])

    RETURN material


################################################################
# 11. EGO REALITY TESTING
################################################################

PROCEDURE EGO_REALITY_TESTING(state, ego_material, external_input):

    report = RealityReport()

    report.external_danger =
        external_input.immediate_danger
        + external_input.long_term_danger

    report.social_cost =
        ESTIMATE_SOCIAL_COST(ego_material, external_input.social_rules)

    report.physical_cost =
        ESTIMATE_PHYSICAL_COST(ego_material, external_input.physical_limits)

    report.legal_cost =
        ESTIMATE_LEGAL_COST(ego_material, external_input.legal_costs)

    report.resource_cost =
        ESTIMATE_RESOURCE_COST(ego_material, external_input.resource_constraints)

    report.opportunity_value =
        ESTIMATE_OPPORTUNITY_VALUE(ego_material, external_input.opportunities)

    report.predicted_consequences =
        SIMULATE_CONSEQUENCES(ego_material, external_input)

    IF report.external_danger
       + report.social_cost
       + report.physical_cost
       + report.legal_cost
       + report.resource_cost > REALITY_DANGER_THRESHOLD:
        report.action_possible = false
        report.delay_required = true
    ELSE:
        report.action_possible = true
        report.delay_required = false

    report.safe_channels =
        FIND_SAFE_CHANNELS(ego_material, external_input)

    report.unsafe_channels =
        FIND_UNSAFE_CHANNELS(ego_material, external_input)

    report.reality_distortion_risk =
        CALCULATE_REALITY_DISTORTION_RISK(state, report)

    RETURN report


################################################################
# 12. SUPEREGO EVALUATION
################################################################

PROCEDURE SUPEREGO_EVALUATION(state, ego_material, reality_report):

    judgment = SuperegoJudgment()

    judgment.prohibition_level = 0
    judgment.guilt_threat = 0
    judgment.shame_threat = 0
    judgment.inferiority_threat = 0
    judgment.punishment_demand = 0
    judgment.ideal_gap = 0
    judgment.approval_reward = 0
    judgment.moral_permission = true
    judgment.demand_for_repair = 0
    judgment.demand_for_renunciation = 0
    judgment.demand_for_perfection = 0
    judgment.command_text = ""
    judgment.unconscious_guilt_component = state.superego.unconscious_punishment_need
    judgment.harshness = state.superego.severity + state.superego.rigidity

    FOR EACH material IN ego_material:

        IF WISH_VIOLATES_PROHIBITION(material):
            judgment.prohibition_level += state.superego.conscience_strength
            judgment.guilt_threat += state.superego.guilt_generation
            judgment.moral_permission = false
            judgment.command_text += "Forbidden wish. "

        IF ACTION_OR_WISH_FALLS_SHORT_OF_IDEAL(material):
            judgment.ideal_gap += state.superego.ego_ideal_demand
            judgment.shame_threat += state.superego.shame_generation
            judgment.inferiority_threat += state.superego.ego_ideal_demand

        IF MATERIAL_CONTAINS_AGGRESSION(material)
           AND AGGRESSION_IS_PROHIBITED(material):
            judgment.punishment_demand += state.superego.sadistic_punishment_force
            judgment.guilt_threat += state.superego.severity

        IF MATERIAL_CONTAINS_SEXUAL_OR_DEPENDENCY_WISH(material)
           AND WISH_IS_FORBIDDEN_BY_INTERNAL_AUTHORITY(material):
            judgment.prohibition_level += state.superego.parental_agency_strength
            judgment.guilt_threat += state.superego.guilt_generation

        IF reality_report.predicted_consequences include harm_to_object:
            judgment.demand_for_repair += state.superego.conscience_strength

        IF material.can_be_sublimated:
            judgment.approval_reward += state.superego.approval_reward_strength

        IF material.represents_achievement_of_ideal:
            judgment.approval_reward += state.superego.approval_reward_strength
            judgment.shame_threat -= SMALL_RELIEF

    judgment.guilt_threat += judgment.unconscious_guilt_component
    judgment.punishment_demand += state.superego.unconscious_punishment_need

    judgment.guilt_threat = MAX(0, judgment.guilt_threat)
    judgment.shame_threat = MAX(0, judgment.shame_threat)

    RETURN judgment


################################################################
# 13. CONFLICT COMPUTATION
################################################################

PROCEDURE EGO_COMPUTE_CONFLICT(state, ego_material, reality_report, superego_judgment):

    conflict = ConflictReport()

    conflict.id_pressure =
        SUM_AFFECT_AND_DRIVE_PRESSURE(ego_material)
        + state.id.repressed_wish_pressure
        + state.id.repetition_pressure

    conflict.reality_pressure =
        reality_report.external_danger
        + reality_report.social_cost
        + reality_report.physical_cost
        + reality_report.legal_cost
        + reality_report.resource_cost

    conflict.superego_pressure =
        superego_judgment.prohibition_level
        + superego_judgment.guilt_threat
        + superego_judgment.shame_threat
        + superego_judgment.inferiority_threat
        + superego_judgment.punishment_demand
        + superego_judgment.ideal_gap
        - superego_judgment.approval_reward

    conflict.ego_capacity =
        state.ego.strength
        + state.ego.reality_testing_capacity
        + state.ego.tolerance_for_tension
        + state.ego.binding_capacity
        + state.ego.symbolization_capacity
        + state.ego.defense_flexibility
        + state.ego.sublimation_capacity
        + state.ego.capacity_for_repair
        - state.ego.fatigue
        - state.ego.repression_load

    conflict.total_conflict =
        conflict.id_pressure
        + conflict.reality_pressure
        + conflict.superego_pressure
        - conflict.ego_capacity

    IF conflict.total_conflict <= 0:
        conflict.conflict_type = NONE
        conflict.dominant_danger_source = "none"

    ELSE IF conflict.id_pressure > conflict.reality_pressure
        AND conflict.id_pressure > conflict.superego_pressure:
        conflict.conflict_type = EGO_VS_ID
        conflict.dominant_danger_source = "id"

    ELSE IF conflict.superego_pressure > conflict.id_pressure
        AND conflict.superego_pressure > conflict.reality_pressure:
        conflict.conflict_type = EGO_VS_SUPEREGO
        conflict.dominant_danger_source = "superego"

    ELSE IF conflict.reality_pressure > conflict.id_pressure
        AND conflict.reality_pressure > conflict.superego_pressure:
        conflict.conflict_type = EGO_VS_REALITY
        conflict.dominant_danger_source = "external reality"

    ELSE IF conflict.id_pressure > HIGH
        AND conflict.superego_pressure > HIGH
        AND conflict.reality_pressure <= MEDIUM:
        conflict.conflict_type = ID_PLUS_SUPEREGO_VS_EGO
        conflict.dominant_danger_source = "id and superego together"

    ELSE IF conflict.id_pressure > HIGH
        AND conflict.reality_pressure > HIGH
        AND state.ego.self_coherence < SELF_COHERENCE_THRESHOLD:
        conflict.conflict_type = EGO_SPLIT_BETWEEN_REALITY_AND_WISH
        conflict.dominant_danger_source = "wish and reality split"

    ELSE:
        conflict.conflict_type = MULTI_DIRECTIONAL_CONFLICT
        conflict.dominant_danger_source = "multiple"

    conflict.risk_of_symptom =
        CALCULATE_SYMPTOM_RISK(state, conflict)

    conflict.risk_of_compulsion =
        CALCULATE_COMPULSION_RISK(state, conflict)

    conflict.risk_of_inhibition =
        CALCULATE_INHIBITION_RISK(state, conflict)

    conflict.risk_of_reality_distortion =
        CALCULATE_REALITY_DISTORTION_RISK(state, reality_report)

    conflict.risk_of_self_punishment =
        CALCULATE_SELF_PUNISHMENT_RISK(state, superego_judgment)

    conflict.recommended_defense_intensity =
        CALCULATE_DEFENSE_INTENSITY(conflict)

    RETURN conflict


################################################################
# 14. ANXIETY SIGNAL
################################################################

PROCEDURE EGO_GENERATE_ANXIETY_SIGNAL(state, conflict):

    IF conflict.total_conflict <= state.ego.anxiety_threshold:
        conflict.anxiety_type = NONE
        conflict.anxiety_level = 0
        RETURN conflict

    IF conflict.dominant_danger_source == "external reality":
        conflict.anxiety_type = REALISTIC_ANXIETY
        conflict.anxiety_level =
            conflict.reality_pressure - state.ego.anxiety_threshold

    ELSE IF conflict.dominant_danger_source == "id":
        conflict.anxiety_type = NEUROTIC_ANXIETY
        conflict.anxiety_level =
            conflict.id_pressure - state.ego.tolerance_for_tension

    ELSE IF conflict.dominant_danger_source == "superego":
        conflict.anxiety_type = MORAL_ANXIETY
        conflict.anxiety_level =
            conflict.superego_pressure - state.ego.guilt_tolerance

    ELSE IF conflict.dominant_danger_source == "id and superego together":
        conflict.anxiety_type = MIXED_ANXIETY
        conflict.anxiety_level =
            conflict.id_pressure + conflict.superego_pressure - state.ego.strength

    ELSE IF conflict.total_conflict > TRAUMATIC_OVERWHELM_THRESHOLD:
        conflict.anxiety_type = TRAUMATIC_AUTOMATIC_ANXIETY
        conflict.anxiety_level = VERY_HIGH

    ELSE:
        conflict.anxiety_type = MIXED_ANXIETY
        conflict.anxiety_level = conflict.total_conflict

    state.current_anxiety = CLAMP(conflict.anxiety_level, 0, MAX_ANXIETY)

    RETURN conflict


################################################################
# 15. DEFENSE CASCADE AND OUTPUT SELECTION
################################################################

PROCEDURE EGO_DEFENSE_AND_OUTPUT_SELECTION(state,
                                           ego_material,
                                           reality_report,
                                           superego_judgment,
                                           conflict):

    response = EgoResponse()

    response.selected_defenses = COPY(state.pending_defense_biases)
    response.anxiety_level = conflict.anxiety_level
    response.guilt_level = superego_judgment.guilt_threat
    response.energy_cost = 0
    response.anticathexis_required = 0
    response.expected_id_discharge = 0
    response.expected_superego_relief = 0
    response.expected_reality_success = 0
    response.repetition_risk = 0
    response.integration_potential = 0

    ################################################################
    # 15.1 Low conflict: direct or delayed action
    ################################################################

    IF conflict.conflict_type == NONE
       AND reality_report.action_possible == true
       AND superego_judgment.moral_permission == true:

        response.output_type = DIRECT_ACTION
        response.action_plan = BUILD_DIRECT_ACTION_PLAN(ego_material)
        response.selected_defenses = [NONE]
        response.expected_id_discharge = HIGH
        response.expected_superego_relief = NEUTRAL
        response.expected_reality_success = HIGH
        response.energy_cost = LOW
        response.integration_potential = HIGH

        RETURN response


    IF reality_report.delay_required == true
       AND superego_judgment.moral_permission == true
       AND state.ego.capacity_to_delay > DELAY_THRESHOLD:

        response.output_type = DELAYED_ACTION
        response.action_plan = BUILD_DELAYED_ACTION_PLAN(ego_material, reality_report)
        response.selected_defenses = [NONE]
        response.expected_id_discharge = MEDIUM_LATER
        response.expected_superego_relief = NEUTRAL
        response.expected_reality_success = HIGH
        response.energy_cost = LOW_TO_MEDIUM
        response.integration_potential = HIGH

        RETURN response


    ################################################################
    # 15.2 Sublimation path
    ################################################################

    IF state.ego.sublimation_capacity > SUBLIMATION_THRESHOLD
       AND reality_report.opportunity_value > OPPORTUNITY_THRESHOLD
       AND superego_judgment.approval_reward > APPROVAL_THRESHOLD:

        response.output_type = SUBLIMATED_ACTION
        response.selected_defenses = [SUBLIMATION, SYMBOLIZATION]
        response.sublimation_plan = BUILD_SUBLIMATION_PLAN(ego_material, reality_report)
        response.expected_id_discharge = MEDIUM_TO_HIGH
        response.expected_superego_relief = HIGH
        response.expected_reality_success = HIGH
        response.energy_cost = MEDIUM
        response.repetition_risk = LOW
        response.integration_potential = HIGH

        RETURN response


    ################################################################
    # 15.3 Ordinary compromise path
    ################################################################

    IF conflict.total_conflict <= HIGH_CONFLICT
       AND state.ego.defense_flexibility > DEFENSE_FLEXIBILITY_THRESHOLD:

        response.output_type = MODIFIED_ACTION
        response.selected_defenses =
            SELECT_COMPROMISE_DEFENSES(state, ego_material,
                                       reality_report, superego_judgment, conflict)

        response.action_plan =
            BUILD_COMPROMISE_ACTION_PLAN(ego_material, response.selected_defenses)

        response.conscious_explanation =
            BUILD_ACCEPTABLE_CONSCIOUS_EXPLANATION(response.action_plan)

        response.unconscious_motive =
            EXTRACT_UNCONSCIOUS_MOTIVE(ego_material)

        response.expected_id_discharge = MEDIUM
        response.expected_superego_relief = MEDIUM
        response.expected_reality_success = MEDIUM_TO_HIGH
        response.energy_cost = MEDIUM
        response.repetition_risk = MEDIUM
        response.integration_potential = MEDIUM

        RETURN response


    ################################################################
    # 15.4 Repression path
    ################################################################

    IF superego_judgment.prohibition_level > PROHIBITION_THRESHOLD
       AND state.ego.anticathexis_budget >= REQUIRED_REPRESSION_COST(ego_material):

        response.output_type = NO_ACTION
        response.selected_defenses = [REPRESSION]
        response.anticathexis_required = REQUIRED_REPRESSION_COST(ego_material)
        response.conscious_explanation = "Nothing is consciously desired."
        response.unconscious_motive = EXTRACT_UNCONSCIOUS_MOTIVE(ego_material)
        response.action_plan = "Hold wish outside consciousness and action."
        response.expected_id_discharge = LOW
        response.expected_superego_relief = MEDIUM
        response.expected_reality_success = MEDIUM
        response.energy_cost = response.anticathexis_required
        response.repetition_risk = HIGH
        response.integration_potential = LOW

        RETURN response


    ################################################################
    # 15.5 Repression failure: secondary defenses
    ################################################################

    IF superego_judgment.prohibition_level > PROHIBITION_THRESHOLD
       AND state.ego.anticathexis_budget < REQUIRED_REPRESSION_COST(ego_material)
       AND state.ego.defense_flexibility > LOW:

        response.output_type = RATIONALIZED_ACTION
        response.selected_defenses =
            SELECT_FROM([
                REPRESSION,
                DISPLACEMENT,
                REACTION_FORMATION,
                RATIONALIZATION,
                ISOLATION_OF_AFFECT,
                UNDOING,
                PROJECTION,
                INHIBITION
            ])

        response.action_plan =
            BUILD_DEFENSIVE_COMPROMISE(ego_material, response.selected_defenses)

        response.conscious_explanation =
            BUILD_RATIONALIZATION(response.action_plan)

        response.unconscious_motive =
            EXTRACT_UNCONSCIOUS_MOTIVE(ego_material)

        response.expected_id_discharge = LOW_TO_MEDIUM
        response.expected_superego_relief = LOW_TO_MEDIUM
        response.expected_reality_success = VARIABLE
        response.energy_cost = HIGH
        response.repetition_risk = HIGH
        response.integration_potential = LOW_TO_MEDIUM

        RETURN response


    ################################################################
    # 15.6 Id + superego alliance against ego
    ################################################################

    IF conflict.conflict_type == ID_PLUS_SUPEREGO_VS_EGO:

        response =
            HANDLE_ID_SUPEREGO_ALLIANCE(state, ego_material,
                                        reality_report, superego_judgment, conflict)

        RETURN response


    ################################################################
    # 15.7 Symptom formation
    ################################################################

    IF conflict.risk_of_symptom > SYMPTOM_THRESHOLD:

        response.output_type = SYMPTOM_OUTPUT
        response.selected_defenses =
            [REPRESSION, SYMBOLIZATION, COMPROMISE_FORMATION]

        IF MATERIAL_IS_SOMATICALLY_EXPRESSIBLE(ego_material):
            ADD SOMATIC_CONVERSION TO response.selected_defenses

        response.symptom_plan =
            BUILD_SYMPTOM_FORMATION(ego_material, reality_report, superego_judgment)

        response.conscious_explanation =
            "The symptom is experienced as distressing or involuntary, not as chosen."

        response.unconscious_motive =
            EXTRACT_UNCONSCIOUS_MOTIVE(ego_material)

        response.expected_id_discharge = PARTIAL_AND_DISGUISED
        response.expected_superego_relief = PARTIAL_THROUGH_SUFFERING
        response.expected_reality_success = LOW_TO_MEDIUM
        response.energy_cost = HIGH
        response.repetition_risk = HIGH
        response.integration_potential = LOW

        RETURN response


    ################################################################
    # 15.8 Compulsion / repetition
    ################################################################

    IF conflict.risk_of_compulsion > COMPULSION_THRESHOLD:

        response.output_type = COMPULSIVE_ACTION
        response.selected_defenses =
            [COMPULSIVE_REPETITION, UNDOING, ISOLATION_OF_AFFECT]

        response.action_plan =
            BUILD_COMPULSIVE_REPETITION_OUTPUT(ego_material)

        response.conscious_explanation =
            "The action feels necessary, urgent, or anxiety-reducing."

        response.unconscious_motive =
            "Attempt to bind, undo, repeat, or master unresolved conflict."

        response.expected_id_discharge = LOW_TEMPORARY
        response.expected_superego_relief = LOW_TEMPORARY
        response.expected_reality_success = LOW
        response.energy_cost = HIGH
        response.repetition_risk = VERY_HIGH
        response.integration_potential = LOW

        RETURN response


    ################################################################
    # 15.9 Inhibition
    ################################################################

    IF conflict.risk_of_inhibition > INHIBITION_THRESHOLD:

        response.output_type = INHIBITION_OUTPUT
        response.selected_defenses = [INHIBITION, REPRESSION]

        response.action_plan =
            "Reduce or block a function in order to avoid conflict."

        response.conscious_explanation =
            "I cannot do this / I do not feel able / I have no energy / I avoid it."

        response.unconscious_motive =
            EXTRACT_UNCONSCIOUS_MOTIVE(ego_material)

        response.expected_id_discharge = LOW
        response.expected_superego_relief = MEDIUM
        response.expected_reality_success = LOW_TO_MEDIUM
        response.energy_cost = MEDIUM_TO_HIGH
        response.repetition_risk = HIGH
        response.integration_potential = LOW

        RETURN response


    ################################################################
    # 15.10 Superego punishment / moral masochism path
    ################################################################

    IF conflict.risk_of_self_punishment > SELF_PUNISHMENT_THRESHOLD:

        response.output_type = SELF_PUNISHMENT
        response.selected_defenses =
            [TURNING_AGAINST_SELF, UNDOING, INHIBITION]

        response.self_punishment_plan =
            BUILD_SELF_PUNISHMENT_OUTPUT(superego_judgment)

        response.conscious_explanation =
            "I deserve this / I must pay / I failed / I must suffer or repair."

        response.unconscious_motive =
            "Appease superego punishment demand and reduce unconscious guilt."

        response.expected_id_discharge = LOW
        response.expected_superego_relief = MEDIUM_TEMPORARY
        response.expected_reality_success = LOW
        response.energy_cost = HIGH
        response.repetition_risk = HIGH
        response.integration_potential = LOW

        RETURN response


    ################################################################
    # 15.11 Reality pressure path: denial, disavowal, withdrawal, reconstruction
    ################################################################

    IF conflict.conflict_type == EGO_VS_REALITY
       OR conflict.conflict_type == EGO_SPLIT_BETWEEN_REALITY_AND_WISH:

        response =
            HANDLE_REALITY_CONFLICT_PATH(state, ego_material,
                                         reality_report, superego_judgment, conflict)

        RETURN response


    ################################################################
    # 15.12 Fantasy fallback
    ################################################################

    response.output_type = FANTASY_OUTPUT
    response.selected_defenses = [FANTASY_WITHDRAWAL, SYMBOLIZATION]
    response.fantasy_plan =
        "Provide imaginary satisfaction when direct action, compromise, or sublimation is unavailable."

    response.conscious_explanation =
        "Private fantasy, daydream, wishful scenario, or imagined reversal."

    response.unconscious_motive =
        EXTRACT_UNCONSCIOUS_MOTIVE(ego_material)

    response.expected_id_discharge = LOW_TO_MEDIUM
    response.expected_superego_relief = VARIABLE
    response.expected_reality_success = NEUTRAL
    response.energy_cost = MEDIUM
    response.repetition_risk = MEDIUM_TO_HIGH
    response.integration_potential = LOW_TO_MEDIUM

    RETURN response


################################################################
# 16. COMPROMISE DEFENSE SELECTION
################################################################

PROCEDURE SELECT_COMPROMISE_DEFENSES(state, ego_material,
                                     reality_report, superego_judgment, conflict):

    defenses = []

    IF reality_report.action_possible == false:
        ADD DISPLACEMENT TO defenses

    IF superego_judgment.prohibition_level > MEDIUM:
        ADD REACTION_FORMATION TO defenses

    IF superego_judgment.guilt_threat > MEDIUM:
        ADD UNDOING TO defenses

    IF AFFECT_TOO_INTENSE_FOR_CONSCIOUSNESS(ego_material, state):
        ADD ISOLATION_OF_AFFECT TO defenses

    IF MOTIVE_UNACCEPTABLE_TO_SELF_IMAGE(ego_material, state):
        ADD RATIONALIZATION TO defenses

    IF OWN_IMPULSE_TOO_THREATENING(ego_material):
        ADD PROJECTION TO defenses

    IF OBJECT_LOSS_OR_AUTHORITY_CONFLICT_ACTIVE(ego_material):
        ADD IDENTIFICATION TO defenses

    IF DRIVE_CAN_BE_PRODUCTIVELY_TRANSFORMED(state, ego_material):
        ADD SUBLIMATION TO defenses

    IF defenses EMPTY:
        ADD COMPROMISE_FORMATION TO defenses

    RETURN defenses


################################################################
# 17. ID + SUPEREGO ALLIANCE HANDLER
################################################################

PROCEDURE HANDLE_ID_SUPEREGO_ALLIANCE(state, ego_material,
                                      reality_report, superego_judgment, conflict):

    response = EgoResponse()

    # Id demands satisfaction.
    # Superego attacks ego for having the demand.
    # Ego is pressured from below and above simultaneously.

    IF state.ego.sublimation_capacity > HIGH
       AND reality_report.opportunity_value > MEDIUM
       AND superego_judgment.approval_reward > MEDIUM:

        response.output_type = SUBLIMATED_ACTION
        response.selected_defenses = [SUBLIMATION, SYMBOLIZATION]
        response.sublimation_plan =
            BUILD_SUBLIMATION_PLAN(ego_material, reality_report)

        response.expected_id_discharge = MEDIUM_TO_HIGH
        response.expected_superego_relief = HIGH
        response.expected_reality_success = HIGH
        response.energy_cost = MEDIUM
        response.repetition_risk = LOW
        response.integration_potential = HIGH

        RETURN response

    IF state.ego.capacity_for_repair > MEDIUM
       AND superego_judgment.demand_for_repair > MEDIUM:

        response.output_type = REPAIR_ACTION
        response.selected_defenses = [UNDOING, SYMBOLIZATION]
        response.repair_plan =
            BUILD_REPAIR_PLAN(ego_material, superego_judgment)

        response.expected_id_discharge = LOW_TO_MEDIUM
        response.expected_superego_relief = MEDIUM_TO_HIGH
        response.expected_reality_success = MEDIUM
        response.energy_cost = MEDIUM
        response.repetition_risk = MEDIUM
        response.integration_potential = MEDIUM_TO_HIGH

        RETURN response

    IF state.ego.anticathexis_budget > MEDIUM:
        response.output_type = NO_ACTION
        response.selected_defenses = [REPRESSION, ISOLATION_OF_AFFECT]
        response.anticathexis_required = REQUIRED_REPRESSION_COST(ego_material)
        response.action_plan =
            "Hold forbidden wish down while isolating affect."

        response.expected_id_discharge = LOW
        response.expected_superego_relief = MEDIUM_TEMPORARY
        response.expected_reality_success = MEDIUM
        response.energy_cost = HIGH
        response.repetition_risk = HIGH
        response.integration_potential = LOW

        RETURN response

    response.output_type = SYMPTOM_OUTPUT
    response.selected_defenses =
        [REPRESSION, COMPROMISE_FORMATION, TURNING_AGAINST_SELF, SYMBOLIZATION]

    response.symptom_plan =
        "Produce a punitive compromise symptom: disguised wish-expression plus suffering."

    response.expected_id_discharge = PARTIAL_AND_DISGUISED
    response.expected_superego_relief = PARTIAL_THROUGH_SUFFERING
    response.expected_reality_success = LOW
    response.energy_cost = VERY_HIGH
    response.repetition_risk = VERY_HIGH
    response.integration_potential = LOW

    RETURN response


################################################################
# 18. REALITY CONFLICT HANDLER
################################################################

PROCEDURE HANDLE_REALITY_CONFLICT_PATH(state, ego_material,
                                       reality_report, superego_judgment, conflict):

    response = EgoResponse()

    IF state.ego.reality_testing_capacity > conflict.reality_pressure:
        response.output_type = DELAYED_ACTION
        response.selected_defenses = [NONE]
        response.action_plan =
            BUILD_REALITY_BASED_DELAY_OR_ADAPTATION_PLAN(ego_material, reality_report)

        response.expected_id_discharge = MEDIUM_LATER
        response.expected_superego_relief = NEUTRAL
        response.expected_reality_success = HIGH
        response.energy_cost = MEDIUM
        response.repetition_risk = MEDIUM
        response.integration_potential = HIGH

        RETURN response

    IF state.ego.self_coherence >= MEDIUM
       AND state.ego.reality_testing_capacity < conflict.reality_pressure:

        response.output_type = AVOIDANCE_OUTPUT
        response.selected_defenses = [AVOIDANCE, FANTASY_WITHDRAWAL]
        response.action_plan =
            "Avoid reality field while preserving general reality-testing."

        response.expected_id_discharge = LOW
        response.expected_superego_relief = VARIABLE
        response.expected_reality_success = LOW_TO_MEDIUM
        response.energy_cost = MEDIUM
        response.repetition_risk = HIGH
        response.integration_potential = LOW

        RETURN response

    IF EGO_CAN_MAINTAIN_TWO_ATTITUDES_SIDE_BY_SIDE(state):
        response.output_type = DISAVOWED_ACTION
        response.selected_defenses = [DISAVOWAL]
        response.action_plan =
            "Maintain one attitude that knows reality and another that refuses its implication."

        response.expected_id_discharge = MEDIUM
        response.expected_superego_relief = VARIABLE
        response.expected_reality_success = LOW_TO_MEDIUM
        response.energy_cost = HIGH
        response.repetition_risk = HIGH
        response.integration_potential = LOW

        RETURN response

    response.output_type = REALITY_RECONSTRUCTION
    response.selected_defenses =
        [DENIAL, REALITY_RECONSTRUCTION, FANTASY_WITHDRAWAL]

    response.reality_reconstruction_plan =
        "Replace or rebuild intolerable reality according to wish-pressure."

    response.expected_id_discharge = VARIABLE
    response.expected_superego_relief = VARIABLE
    response.expected_reality_success = LOW
    response.energy_cost = VERY_HIGH
    response.repetition_risk = VERY_HIGH
    response.integration_potential = VERY_LOW

    RETURN response


################################################################
# 19. SYMPTOM FORMATION BUILDER
################################################################

PROCEDURE BUILD_SYMPTOM_FORMATION(ego_material, reality_report, superego_judgment):

    hidden_wish =
        SELECT_HIGHEST_PRESSURE_FORBIDDEN_WISH(ego_material)

    defensive_disguise =
        CREATE_SYMBOLIC_OR_SOMATIC_DISGUISE(hidden_wish)

    punishment_component =
        IF superego_judgment.guilt_threat > MEDIUM
        THEN "suffering, inhibition, loss, pain, or restriction"
        ELSE "minimal punishment component"

    reality_avoidance_component =
        IF reality_report.action_possible == false
        THEN "avoid direct reality danger"
        ELSE "avoid internal danger"

    symptom_plan =
        "Create compromise output with four functions:
         1. partially express hidden wish,
         2. disguise wish from consciousness,
         3. reduce or bind anxiety,
         4. satisfy superego punishment or guilt demand through suffering.
         Components:
         hidden_wish = " + hidden_wish + ";
         disguise = " + defensive_disguise + ";
         punishment = " + punishment_component + ";
         reality_function = " + reality_avoidance_component + "."

    RETURN symptom_plan


################################################################
# 20. DREAM AND FANTASY CHANNEL
################################################################

PROCEDURE GENERATE_DREAM_OR_FANTASY(state):

    IF SLEEP_STATE == true:

        # In dreams, motility is blocked and reality-testing is reduced.
        # Unconscious wishes and residues can appear in disguised form.

        dream_material =
            SELECT_ACTIVE_UNCONSCIOUS_WISHES_AND_DAY_RESIDUES(state)

        dream_material = APPLY_DISPLACEMENT(dream_material)
        dream_material = APPLY_CONDENSATION(dream_material)
        dream_material = APPLY_SYMBOLIZATION(dream_material)
        dream_material = APPLY_SECONDARY_REVISION_IF_NEEDED(dream_material)

        RETURN CREATE_OUTPUT(
            type = DREAM_OUTPUT,
            material = dream_material,
            defenses = [DISPLACEMENT, CONDENSATION, SYMBOLIZATION]
        )

    IF DIRECT_ACTION_BLOCKED(state)
       AND IMAGINARY_SATISFACTION_AVAILABLE(state):

        fantasy_material =
            SELECT_ACTIVE_WISHES(state)

        fantasy_material =
            BUILD_IMAGINARY_SATISFACTION(fantasy_material)

        RETURN CREATE_OUTPUT(
            type = FANTASY_OUTPUT,
            material = fantasy_material,
            defenses = [FANTASY_WITHDRAWAL, SYMBOLIZATION]
        )


################################################################
# 21. EXECUTE OUTPUT
################################################################

PROCEDURE EXECUTE_OUTPUT(state, response, external_input):

    result = {}

    SWITCH response.output_type:

        CASE DIRECT_ACTION:
            result = PERFORM_DIRECT_ACTION(response.action_plan, external_input)

        CASE DELAYED_ACTION:
            result = STORE_DELAYED_ACTION_PLAN(response.action_plan)

        CASE MODIFIED_ACTION:
            result = PERFORM_MODIFIED_ACTION(response.action_plan, external_input)

        CASE SUBLIMATED_ACTION:
            result = PERFORM_SUBLIMATED_ACTIVITY(response.sublimation_plan)

        CASE FANTASY_OUTPUT:
            result = PRODUCE_FANTASY(response.fantasy_plan)

        CASE DREAM_OUTPUT:
            result = PRODUCE_DREAM(response.fantasy_plan)

        CASE SLIP_OR_PARAPRAXIS:
            result = PRODUCE_SLIP(response.action_plan)

        CASE SYMPTOM_OUTPUT:
            result = EXPRESS_SYMPTOM(response.symptom_plan)

        CASE COMPULSIVE_ACTION:
            result = PERFORM_COMPULSIVE_ACTION(response.action_plan)

        CASE INHIBITION_OUTPUT:
            result = REDUCE_OR_BLOCK_FUNCTION(response.action_plan)

        CASE AVOIDANCE_OUTPUT:
            result = AVOID_TRIGGER_OR_REALITY_FIELD(response.action_plan)

        CASE RATIONALIZED_ACTION:
            result = PERFORM_ACTION_WITH_CONSCIOUS_EXPLANATION(
                response.action_plan,
                response.conscious_explanation
            )

        CASE REPAIR_ACTION:
            result = PERFORM_REPAIR(response.repair_plan)

        CASE CONFESSION_OR_APPEASEMENT:
            result = PERFORM_CONFESSION_OR_APPEASEMENT(response.repair_plan)

        CASE SELF_PUNISHMENT:
            result = PERFORM_SELF_PUNISHMENT(response.self_punishment_plan)

        CASE WITHDRAWAL_FROM_REALITY:
            result = WITHDRAW_FROM_REALITY_FIELD(response.action_plan)

        CASE DISAVOWED_ACTION:
            result = PERFORM_ACTION_WITH_SPLIT_ATTITUDE(response.action_plan)

        CASE REALITY_RECONSTRUCTION:
            result = RECONSTRUCT_REALITY_ACCORDING_TO_WISH(response.reality_reconstruction_plan)

        CASE NO_ACTION:
            result = MAINTAIN_REPRESSION_OR_INHIBITION()

    RETURN result


################################################################
# 22. FEEDBACK UPDATE
################################################################

PROCEDURE FEEDBACK_UPDATE(state, output_result):

    response = state.active_ego_response
    conflict = state.active_conflict_report
    judgment = state.active_superego_judgment
    reality = state.active_reality_report

    ################################################################
    # 22.1 Id update
    ################################################################

    state.id.free_drive_energy -= response.expected_id_discharge
    state.id.free_drive_energy = MAX(0, state.id.free_drive_energy)

    IF response.expected_id_discharge < REQUIRED_DRIVE_DISCHARGE(conflict):
        state.id.repressed_wish_pressure += RESIDUAL_WISH_PRESSURE(conflict)

    IF response.output_type == SUBLIMATED_ACTION:
        state.energy.sublimated_energy[response.sublimation_plan] += response.expected_id_discharge
        state.energy.bound_energy += response.expected_id_discharge

    IF response.output_type == SYMPTOM_OUTPUT:
        state.energy.symptom_bound_energy[response.symptom_plan] += response.expected_id_discharge
        state.id.repetition_pressure += SYMPTOM_REPETITION_INCREMENT

    IF response.output_type == COMPULSIVE_ACTION:
        state.id.repetition_pressure += COMPULSION_REPETITION_INCREMENT

    ################################################################
    # 22.2 Ego update
    ################################################################

    state.ego.fatigue += response.energy_cost

    IF REPRESSION IN response.selected_defenses:
        state.ego.repression_load += response.anticathexis_required
        state.ego.anticathexis_budget -= response.anticathexis_required
        state.energy.anticathexes[response.unconscious_motive] += response.anticathexis_required

    IF response.output_type IN [DIRECT_ACTION, DELAYED_ACTION, MODIFIED_ACTION, SUBLIMATED_ACTION, REPAIR_ACTION]
       AND output_result.reality_success == true:
        state.ego.strength += MASTERY_INCREMENT
        state.ego.reality_testing_capacity += REALITY_TESTING_INCREMENT
        state.ego.self_coherence += SELF_COHERENCE_INCREMENT
        state.ego.integration_capacity += INTEGRATION_INCREMENT

    IF response.output_type == SYMPTOM_OUTPUT:
        state.ego.strength -= SYMPTOM_COST
        state.ego.self_coherence -= SYMPTOM_FRAGMENTATION_COST

    IF response.output_type == REALITY_RECONSTRUCTION:
        state.ego.reality_testing_capacity -= REALITY_TESTING_DAMAGE
        state.ego.self_coherence -= SELF_COHERENCE_DAMAGE

    IF response.output_type == INHIBITION_OUTPUT:
        state.ego.motor_control_capacity -= FUNCTIONAL_INHIBITION_COST

    ################################################################
    # 22.3 Superego update
    ################################################################

    IF response.output_type IN [REPAIR_ACTION, CONFESSION_OR_APPEASEMENT, SUBLIMATED_ACTION]:
        state.current_guilt -= GUILT_RELIEF_AMOUNT
        state.current_shame -= SHAME_RELIEF_AMOUNT

    IF response.output_type == SELF_PUNISHMENT:
        state.current_guilt -= TEMPORARY_GUILT_RELIEF
        state.superego.unconscious_punishment_need += REINFORCEMENT_IF_PUNISHMENT_REDUCES_TENSION

    IF response.output_type == DIRECT_ACTION
       AND judgment.moral_permission == false:
        state.current_guilt += judgment.guilt_threat
        state.current_shame += judgment.shame_threat

    IF response.output_type == SUBLIMATED_ACTION:
        state.superego.approval_reward_strength += SMALL_REINFORCEMENT

    ################################################################
    # 22.4 Reality update
    ################################################################

    IF output_result.caused_external_harm == true:
        state.current_anxiety += REALISTIC_ANXIETY_INCREMENT
        state.ego.reality_testing_capacity -= REALITY_ERROR_COST

    IF output_result.improved_external_position == true:
        state.current_anxiety -= ANXIETY_RELIEF_AMOUNT
        state.ego.strength += REALITY_MASTERY_INCREMENT

    ################################################################
    # 22.5 History update
    ################################################################

    ADD response.selected_defenses TO state.defense_history

    IF response.output_type == SYMPTOM_OUTPUT:
        ADD response.symptom_plan TO state.symptom_history

    IF response.output_type == SUBLIMATED_ACTION:
        ADD response.sublimation_plan TO state.sublimation_history

    IF response.repetition_risk > HIGH:
        ADD response TO state.repetition_history

    RETURN state


################################################################
# 23. MEMORY, REPRESSION, AND REPETITION UPDATE
################################################################

PROCEDURE MEMORY_REPRESSION_REPETITION_UPDATE(state, output_result):

    response = state.active_ego_response

    trace = CREATE_MEMORY_TRACE_FROM_CURRENT_CYCLE(state, output_result)

    IF response.integration_potential >= HIGH
       AND output_result.reality_success == true:
        trace.integrated = true
        trace.symbolized = true
        trace.linked_to_words = true
        trace.linked_to_time = true
        trace.linked_to_reality_context = true
        trace.accessible_to_ego = true
        trace.repetition_pressure = LOW
        trace.pathogenic_potential = LOW

    ELSE IF REPRESSION IN response.selected_defenses:
        trace.integrated = false
        trace.repressed = true
        trace.symbolized = false
        trace.linked_to_words = false
        trace.linked_to_time = false
        trace.linked_to_reality_context = false
        trace.accessible_to_ego = false
        trace.repetition_pressure = HIGH
        trace.pathogenic_potential = HIGH

    ELSE IF response.output_type == SYMPTOM_OUTPUT:
        trace.integrated = false
        trace.repressed = PARTIAL
        trace.symbolized = DISGUISED
        trace.linked_to_words = false
        trace.accessible_to_ego = PARTIAL
        trace.repetition_pressure = HIGH
        trace.pathogenic_potential = HIGH

    ELSE IF response.output_type == REALITY_RECONSTRUCTION:
        trace.integrated = false
        trace.linked_to_reality_context = false
        trace.accessible_to_ego = DISTORTED
        trace.repetition_pressure = VERY_HIGH
        trace.pathogenic_potential = VERY_HIGH

    ELSE:
        trace.integrated = PARTIAL
        trace.symbolized = PARTIAL
        trace.linked_to_words = PARTIAL
        trace.repetition_pressure = MEDIUM

    ADD trace TO state.memories

    FOR EACH memory IN state.memories:

        IF memory.integrated == false
           AND memory.affect_charge > AFFECT_THRESHOLD:
            state.id.repetition_pressure += memory.repetition_pressure

        IF memory.repressed == true:
            required_anticathexis = memory.cathexis_level
            state.energy.anticathexes[memory.id] = required_anticathexis
            state.ego.repression_load += required_anticathexis

        IF memory.integrated == true:
            memory.affect_charge -= ASSOCIATIVE_INTEGRATION_RELIEF
            memory.repetition_pressure -= INTEGRATION_REPETITION_RELIEF
            memory.pathogenic_potential -= INTEGRATION_PATHOGENIC_RELIEF

    RETURN state


################################################################
# 24. PATHOLOGY CLASSIFIER
################################################################

PROCEDURE CLASSIFY_CURRENT_PATTERN(state):

    conflict = state.active_conflict_report
    response = state.active_ego_response

    IF conflict.conflict_type == EGO_VS_ID:
        IF REPRESSION IN response.selected_defenses:
            RETURN "neurotic repression pattern"
        IF response.output_type == SYMPTOM_OUTPUT:
            RETURN "neurotic symptom compromise"
        IF response.output_type == COMPULSIVE_ACTION:
            RETURN "compulsive management of id pressure"

    IF conflict.conflict_type == EGO_VS_SUPEREGO:
        IF response.output_type == SELF_PUNISHMENT:
            RETURN "superego punishment / moral masochism pattern"
        IF state.current_guilt > HIGH:
            RETURN "moral anxiety pattern"

    IF conflict.conflict_type == EGO_VS_REALITY:
        IF response.output_type == WITHDRAWAL_FROM_REALITY:
            RETURN "withdrawal from reality pattern"
        IF response.output_type == REALITY_RECONSTRUCTION:
            RETURN "reality reconstruction pattern"

    IF conflict.conflict_type == EGO_SPLIT_BETWEEN_REALITY_AND_WISH:
        IF response.output_type == DISAVOWED_ACTION:
            RETURN "disavowal / split attitude pattern"
        IF response.output_type == REALITY_RECONSTRUCTION:
            RETURN "wish-led reconstruction of reality"

    IF conflict.conflict_type == ID_PLUS_SUPEREGO_VS_EGO:
        IF response.output_type == SYMPTOM_OUTPUT:
            RETURN "punitive symptom compromise"
        IF response.output_type == INHIBITION_OUTPUT:
            RETURN "inhibition under double pressure"
        IF response.output_type == SELF_PUNISHMENT:
            RETURN "id-superego alliance producing self-punishment"

    RETURN "ordinary mixed conflict-management pattern"


################################################################
# 25. WORKING-THROUGH / THERAPEUTIC REVERSAL PIPELINE
################################################################

PROCEDURE WORKING_THROUGH_PIPELINE(state, target_symptom_or_conflict):

    # Goal:
    # Convert unconscious compulsion into ego-owned representation.
    # Strengthen ego.
    # Reduce superego harshness.
    # Reduce repression cost.
    # Link affect, memory, words, time, and reality.

    hidden_trace =
        TRACE_SYMPTOM_TO_MEMORY_OR_WISH(state, target_symptom_or_conflict)

    IF hidden_trace == NOT_FOUND:
        RETURN state

    ################################################################
    # 25.1 Make unconscious material preconscious
    ################################################################

    IF hidden_trace.current_region == UNCONSCIOUS:
        hidden_trace.current_region = PRECONSCIOUS
        hidden_trace.accessible_to_ego = PARTIAL

    ################################################################
    # 25.2 Link affect to representation
    ################################################################

    IF hidden_trace.affect_charge > LOW:
        hidden_trace = LINK_AFFECT_TO_IDEA(hidden_trace)

    ################################################################
    # 25.3 Link representation to words
    ################################################################

    IF hidden_trace.linked_to_words == false:
        hidden_trace.linked_to_words = true
        state.ego.word_linking_capacity += WORD_LINKING_MASTERY_INCREMENT

    ################################################################
    # 25.4 Link memory to time and reality
    ################################################################

    IF hidden_trace.linked_to_time == false:
        hidden_trace.linked_to_time = true

    IF hidden_trace.linked_to_reality_context == false:
        hidden_trace.linked_to_reality_context = true
        state.ego.reality_testing_capacity += REALITY_LINKING_INCREMENT

    ################################################################
    # 25.5 Reduce affect charge through expression and association
    ################################################################

    hidden_trace.affect_charge -= AFFECT_WORKING_THROUGH_RELIEF
    hidden_trace.cathexis_level -= CATHEXIS_RELIEF_AMOUNT
    hidden_trace.repetition_pressure -= REPETITION_RELIEF_AMOUNT
    hidden_trace.pathogenic_potential -= PATHOGENIC_RELIEF_AMOUNT

    ################################################################
    # 25.6 Reduce repression load and free ego energy
    ################################################################

    IF hidden_trace.repressed == true:
        hidden_trace.repressed = false
        state.ego.repression_load -= RELEASED_REPRESSION_LOAD(hidden_trace)
        state.ego.anticathexis_budget += FREED_ANTICATHEXIS(hidden_trace)
        REMOVE state.energy.anticathexes[hidden_trace.id]

    ################################################################
    # 25.7 Soften superego if conflict was punitive
    ################################################################

    IF state.active_superego_judgment.punishment_demand > HIGH:
        state.superego.severity -= SUPEREGO_SOFTENING_AMOUNT
        state.superego.rigidity -= SUPEREGO_FLEXIBILITY_AMOUNT
        state.superego.unconscious_punishment_need -= PUNISHMENT_NEED_RELIEF

    ################################################################
    # 25.8 Strengthen ego
    ################################################################

    state.ego.strength += EGO_STRENGTHENING_INCREMENT
    state.ego.integration_capacity += INTEGRATION_INCREMENT
    state.ego.symbolization_capacity += SYMBOLIZATION_INCREMENT
    state.ego.binding_capacity += BINDING_INCREMENT
    state.ego.self_coherence += SELF_COHERENCE_INCREMENT
    state.ego.defense_flexibility += DEFENSE_FLEXIBILITY_INCREMENT

    ################################################################
    # 25.9 Convert repetition into memory
    ################################################################

    IF hidden_trace.repetition_pressure <= LOW:
        hidden_trace.integrated = true
        IF hidden_trace.linked_to_words == true
           AND hidden_trace.affect_charge <= state.ego.binding_capacity:
            hidden_trace.current_region = CONSCIOUS
        ELSE:
            hidden_trace.current_region = PRECONSCIOUS
        hidden_trace.accessible_to_ego = true

    UPDATE_MEMORY_TRACE(state, hidden_trace)

    RETURN state


################################################################
# 26. HOMEOSTATIC NORMALIZATION
################################################################

PROCEDURE HOMEOSTATIC_NORMALIZATION(state):

    state.current_anxiety = CLAMP(state.current_anxiety, 0, MAX_ANXIETY)
    state.current_guilt = CLAMP(state.current_guilt, 0, MAX_GUILT)
    state.current_shame = CLAMP(state.current_shame, 0, MAX_SHAME)

    state.id.free_drive_energy = MAX(0, state.id.free_drive_energy)
    state.id.libido_pool = MAX(0, state.id.libido_pool)
    state.id.aggression_pool = MAX(0, state.id.aggression_pool)
    state.id.repetition_pressure = MAX(0, state.id.repetition_pressure)

    state.ego.strength = CLAMP(state.ego.strength, MIN_EGO_STRENGTH, MAX_EGO_STRENGTH)
    state.ego.fatigue = CLAMP(state.ego.fatigue, 0, MAX_EGO_FATIGUE)
    state.ego.repression_load = MAX(0, state.ego.repression_load)
    state.ego.anticathexis_budget = CLAMP(state.ego.anticathexis_budget, 0, MAX_ANTICATHEXIS_BUDGET)

    state.superego.severity = CLAMP(state.superego.severity, MIN_SUPEREGO_SEVERITY, MAX_SUPEREGO_SEVERITY)
    state.superego.rigidity = CLAMP(state.superego.rigidity, MIN_RIGIDITY, MAX_RIGIDITY)
    state.superego.unconscious_punishment_need = MAX(0, state.superego.unconscious_punishment_need)

    state.energy.total_excitation =
        state.energy.free_energy
        + state.energy.bound_energy
        + SUM_VALUES(state.energy.cathexes)
        + SUM_VALUES(state.energy.anticathexes)
        + SUM_VALUES(state.energy.symptom_bound_energy)

    RETURN state


################################################################
# 27. FULL SYSTEM FORMULA
################################################################

DEFINE FULL_BEHAVIOR_FORMULA =

    "Behavior, symptom, inhibition, fantasy, dream, compulsion, or action
     is the ego-mediated output produced by interaction between:

        id pressure
        + unconscious memory traces
        + repetition pressure
        + external reality constraints
        + superego prohibition / ideal / punishment
        + anxiety signal
        + guilt / shame signal
        + ego strength
        + available defenses
        + cathexis / anticathexis economy
        + capacity for binding, symbolization, sublimation, and repair.

     If ego synthesis succeeds:
        drive pressure becomes thought, plan, delay, action, repair, or sublimation.

     If ego synthesis partially succeeds:
        compromise formation, rationalization, fantasy, or inhibition occurs.

     If ego synthesis fails under pressure:
        symptom, compulsion, self-punishment, traumatic repetition,
        disavowal, withdrawal, or reality reconstruction occurs.

     If working-through succeeds:
        unconscious compulsion becomes ego-owned representation,
        affect is linked to words and reality,
        repetition pressure falls,
        repression cost decreases,
        and ego organization expands."

END PROCEDURE
```

---

# Compact Structural Summary

```text
ID:
    source of drive pressure, free energy, wish, aggression, libido,
    repetition pressure, primary-process transformation.

EGO:
    mediator, reality-tester, binder, translator, planner, censor,
    defender, synthesizer, anxiety signal generator, action controller.

SUPEREGO:
    conscience, ego ideal, internalized authority, judge, prohibitor,
    guilt generator, shame generator, punishment demander, approval giver.

EXTERNAL REALITY:
    danger, limits, scarcity, opportunity, social consequence,
    physical feasibility, temporal delay.

UNCONSCIOUS:
    id material, repressed wishes, unconscious guilt, unconscious defenses,
    unresolved memory traces.

PRECONSCIOUS:
    word-linked, partially available material; rationalizations; plans.

CONSCIOUS:
    perception, felt anxiety, felt guilt, selected action, current thought.

DEFENSE:
    ego operation used when direct satisfaction would cause excessive
    danger, guilt, shame, anxiety, or collapse.

SYMPTOM:
    compromise output that partially expresses hidden wish, disguises it,
    binds anxiety, and may satisfy punishment demand.

SUBLIMATION:
    successful transformation of drive into reality-compatible and
    superego-acceptable activity.

WORKING-THROUGH:
    reverse pipeline that makes unconscious conflict representable,
    reduces repression cost, softens punitive superego pressure,
    and strengthens ego organization.
```


---

# V6 Complete Coverage Extension

## Status of this V6 file

This canonical section integrates the full end-to-end mechanism so that the model explicitly covers the major mechanisms that were implicit, compressed, or missing in earlier versions:

```text
1. Ego as mediator between id, superego, and external reality
2. Superego as heir to the Oedipus complex
3. Complete / positive / negative Oedipus complex variants
4. Identification, introjection, ego ideal, conscience, and unconscious guilt
5. Castration anxiety, loss-of-love anxiety, object-loss anxiety, and moral anxiety
6. Eros, death instinct, fusion, defusion, destruction, sadism, masochism
7. Primal repression, repression proper, derivatives, censorship, return of the repressed
8. Direct id-to-ego route and id-to-ego-ideal/superego route
9. Psychosexual stages, fixation, regression, character residues, symptom choice
10. Dream-work: day residue, latent thought, censorship, condensation, displacement, symbolization, secondary revision
11. Parapraxes, slips, forgetting, bungled actions, jokes, and everyday compromise products
12. Mourning and melancholia, including introjected lost object and superego attack on ego
13. Hysteria, phobia, obsessional neurosis, paranoia, psychosis, narcissistic formations, masochism
14. Resistance, transference, remembering, repeating, working-through
15. Therapeutic reversal by making unconscious material preconscious/conscious, binding affect, and reducing repetition
16. Bodily ego boundary: body surface, pain, motility, inside/outside distinction, somatic symbolization
17. Thing-presentation / word-presentation routing into the preconscious
18. Ego-libido / object-libido mobility, withdrawal, narcissistic accumulation, and reinvestment
19. Renunciation feedback by which instinctual renunciation can strengthen superego severity
20. Cultural/group superego pressure, collective ideals, group guilt, and civilization-level renunciation demand
21. Control-flow consistency: merged packet streams, null-safe conflict input, and corrected dream branch state update
22. Pleasure-principle / reality-principle arbitration as an explicit ego operation
23. Negation and judgment as intellectual admission without full affective acceptance
24. Persistent ego-splitting as two simultaneous ego currents: reality-accepting and wish-preserving
25. Bodily ego as a permanent input to drive pressure, anxiety, reality testing, defense selection, and conversion risk
```

The full model remains conceptual pseudocode. It is not a clinical tool and should not be used for diagnosis.

---

# PROCEDURE Full_Freudian_Id_Ego_Superego_Mechanism_V6_Complete()

```text
PROCEDURE Full_Freudian_Id_Ego_Superego_Mechanism_V6_Complete()

################################################################
# 28. V6 META-INVARIANTS
################################################################

DEFINE freudian_completeness_target =
    "Cover the interaction among id, ego, superego, reality, topographic systems,
     drive economy, repression, dream formation, symptom formation, development,
     clinical formations, and analytic working-through."

DEFINE no_single_module_is_isolated = true
DEFINE structural_and_topographic_models_coexist = true
DEFINE agencies_overlap = true
DEFINE unconscious_extent_larger_than_ego = true
DEFINE ego_is_partly_unconscious = true
DEFINE superego_is_partly_unconscious = true
DEFINE id_has_no_direct_reality_access_except_through_ego = true
DEFINE ego_serves_three_masters = [ID, SUPEREGO, EXTERNAL_REALITY]
DEFINE symptoms_are_compromise_formations = true
DEFINE development_shapes_later_conflict = true
DEFINE treatment_repeats_conflict_in_transference = true
DEFINE bodily_ego_boundary_required = true
DEFINE unconscious_material_requires_representation_route = true
DEFINE thing_presentation_reaches_preconscious_through_word_presentation = true
DEFINE libido_moves_between_ego_and_objects = true
DEFINE renunciation_can_intensify_superego = true
DEFINE cultural_superego_can_override_individual_capacity = true
DEFINE packet_routes_must_be_merged_before_censorship = true
DEFINE pleasure_principle_requires_reality_principle_arbitration = true
DEFINE negation_is_partial_lifting_not_full_resolution = true
DEFINE judgment_accepts_or_rejects_content_after_representational_entry = true
DEFINE ego_split_can_preserve_two_parallel_attitudes = true
DEFINE body_ego_signals_are_always_part_of_main_loop = true


################################################################
# 29. EXTENDED ENUMERATIONS
################################################################

ENUM StructuralRoute:
    ID_TO_EGO_DIRECT
    ID_TO_EGO_VIA_EGO_IDEAL
    ID_TO_EGO_VIA_SUPEREGO_GUILT
    ID_TO_REALITY_THROUGH_EGO
    SUPEREGO_TO_EGO_PROHIBITION
    SUPEREGO_TO_EGO_IDEAL_DEMAND
    REALITY_TO_EGO_PERCEPTION
    EGO_TO_ID_DELAY_OR_DISCHARGE
    EGO_TO_SUPEREGO_REPAIR_OR_APPEASEMENT
    EGO_TO_REALITY_ACTION_OR_WITHDRAWAL

ENUM InstinctPole:
    EROS
    DEATH_INSTINCT
    MIXED_EROS_DESTRUCTION

ENUM InstinctFusionState:
    FUSED
    PARTIALLY_FUSED
    DEFUSED
    RE_FUSED_BY_BINDING
    DESTRUCTIVE_UNBOUND

ENUM PsychosexualStage:
    PREGENITAL_UNDIFFERENTIATED
    ORAL
    ANAL
    PHALLIC
    LATENCY
    GENITAL
    MIXED_STAGE_RESIDUE

ENUM OedipusVariant:
    NONE
    POSITIVE_OEDIPUS
    NEGATIVE_OEDIPUS
    COMPLETE_OEDIPUS
    RESOLVED_OEDIPUS
    REPRESSED_OEDIPUS
    UNRESOLVED_OEDIPUS
    REACTIVATED_OEDIPUS

ENUM DevelopmentalAnxietyType:
    NONE
    OBJECT_LOSS_ANXIETY
    LOSS_OF_LOVE_ANXIETY
    CASTRATION_ANXIETY
    AUTHORITY_PUNISHMENT_ANXIETY
    SUPEREGO_CONDEMNATION_ANXIETY
    TRAUMATIC_HELPLESSNESS_ANXIETY

ENUM RepressionPhase:
    NOT_REPRESSED
    PRIMAL_REPRESSION
    REPRESSION_PROPER
    AFTER_PRESSURE_REPRESSION
    RETURN_OF_REPRESSED
    PARTIAL_LIFTING_OF_REPRESSION
    WORKED_THROUGH

ENUM DreamFormationStage:
    WAKING_DAY_RESIDUE
    LATENT_DREAM_THOUGHT
    UNCONSCIOUS_WISH_ACTIVATION
    CENSORSHIP_PRESSURE
    REGRESSION_TO_IMAGES
    CONDENSATION_WORK
    DISPLACEMENT_WORK
    SYMBOLIC_REPRESENTATION
    AFFECT_TRANSFORMATION
    SECONDARY_REVISION
    MANIFEST_DREAM
    DREAM_RECALL
    DREAM_INTERPRETATION

ENUM EverydayFormationType:
    NONE
    SLIP_OF_TONGUE
    SLIP_OF_PEN
    FORGETTING_NAME
    LOSING_OBJECT
    BUNGLED_ACTION
    MISREADING
    MISHEARING
    ACCIDENTAL_SELF_BETRAYAL
    JOKE_FORMATION
    WIT_FORMATION

ENUM ClinicalFormationType:
    ORDINARY_CONFLICT
    HYSTERICAL_CONVERSION
    HYSTERICAL_ATTACK
    PHOBIC_DISPLACEMENT
    OBSESSIONAL_NEUROSIS
    MELANCHOLIA
    MOURNING
    PARANOIA
    PSYCHOSIS_WITHDRAWAL
    PSYCHOSIS_RECONSTRUCTION
    NARCISSISTIC_REGRESSION
    MORAL_MASOCHISM
    TRAUMATIC_NEUROSIS
    ANXIETY_NEUROSIS_PATTERN
    CHARACTER_FORMATION

ENUM ResistanceType:
    NONE
    EGO_RESISTANCE_REPRESSION
    EGO_RESISTANCE_TRANSFERENCE
    EGO_RESISTANCE_GAIN_FROM_ILLNESS
    ID_RESISTANCE_REPETITION_COMPULSION
    SUPEREGO_RESISTANCE_GUILT_AND_PUNISHMENT
    INTELLECTUALIZATION_RESISTANCE
    SILENCE_RESISTANCE
    ACTING_OUT_RESISTANCE
    DREAM_RESISTANCE
    NEGATIVE_THERAPEUTIC_REACTION

ENUM TransferenceType:
    NONE
    POSITIVE_TRANSFERENCE_AFFECTIONATE
    POSITIVE_TRANSFERENCE_EROTICIZED
    NEGATIVE_TRANSFERENCE_HOSTILE
    PARENTAL_TRANSFERENCE
    SIBLING_RIVALRY_TRANSFERENCE
    AUTHORITY_TRANSFERENCE
    SUPEREGO_TRANSFERENCE
    REPETITION_TRANSFERENCE

ENUM TherapeuticOperation:
    FREE_ASSOCIATION
    DREAM_INTERPRETATION
    RESISTANCE_INTERPRETATION
    TRANSFERENCE_INTERPRETATION
    RECONSTRUCTION
    ABREACTION
    WORKING_THROUGH
    REPEAT_IN_TRANSFERENCE
    MAKE_UNCONSCIOUS_PRECONSCIOUS
    LINK_AFFECT_TO_WORDS
    STRENGTHEN_EGO_SYNTHESIS

ENUM PleasureRealityArbitrationMode:
    IMMEDIATE_PLEASURE_DISCHARGE
    DELAYED_REALITY_SATISFACTION
    THOUGHT_AS_EXPERIMENTAL_ACTION
    FANTASY_SUBSTITUTE_SATISFACTION
    SUBLIMATED_REALITY_SATISFACTION
    RENUNCIATION_WITH_SUPEREGO_REWARD
    REPRESSION_OR_DEFENSIVE_BLOCKING
    TRAUMATIC_FAILURE_OF_ARBITRATION

ENUM JudgmentDecision:
    NOT_EVALUATED
    AFFIRMED_AS_EXISTING_IN_MIND
    REJECTED_AS_REALITY_ACTION
    REJECTED_AS_MORALLY_FORBIDDEN
    ACCEPTED_FOR_THOUGHT_ONLY
    ACCEPTED_FOR_ACTION
    ACCEPTED_ONLY_UNDER_NEGATION
    DISAVOWED_WHILE_RETAINED

ENUM NegationStatus:
    NONE
    DIRECT_DENIAL_OF_REPRESSED_CONTENT
    INTELLECTUAL_ADMISSION_WITH_AFFECTIVE_REJECTION
    AFFECTLESS_RECOGNITION
    PARTIAL_SYMBOLIC_ENTRY
    REPRESSION_PARTLY_LIFTED
    READY_FOR_WORKING_THROUGH

ENUM EgoSplitCurrentType:
    NO_SPLIT
    REALITY_ACCEPTING_CURRENT
    WISH_PRESERVING_DISAVOWING_CURRENT
    SUPEREGO_OBEDIENT_CURRENT
    ID_ALLIED_CURRENT
    OBSERVING_EGO_CURRENT


################################################################
# 30. EXTENDED STRUCTURES
################################################################

STRUCT InstinctMixture:
    eros_level: number
    death_instinct_level: number
    destructive_outward_level: number
    destructive_inward_level: number
    sadism_level: number
    masochism_level: number
    fusion_state: InstinctFusionState
    binding_force: number
    unbinding_force: number
    repetition_compulsion_force: number
    object_preservation_force: number
    object_destruction_force: number

STRUCT PsychosexualFixation:
    stage: PsychosexualStage
    erotogenic_zone: text
    dominant_conflict: text
    fixation_level: number
    frustration_level: number
    overgratification_level: number
    regression_pull: number
    character_residue: text
    symptom_choice_bias: list
    associated_defenses: list
    associated_outputs: list
    associated_object_relations: list

STRUCT OedipalConfiguration:
    variant: OedipusVariant
    love_object_parent: text
    rival_parent: text
    identification_target_1: text
    identification_target_2: text
    ambivalence_level: number
    love_for_object: number
    hostility_to_rival: number
    fear_of_punishment: number
    castration_anxiety: number
    loss_of_love_anxiety: number
    renunciation_level: number
    repression_level: number
    father_identification_strength: number
    mother_identification_strength: number
    ego_ideal_precipitate_strength: number
    conscience_precipitate_strength: number
    unresolved_reactivation_risk: number

STRUCT SuperegoFormationRecord:
    source_oedipal_configuration: OedipalConfiguration
    parental_imago_strength: number
    educator_authority_strength: number
    social_authority_strength: number
    religious_or_cultural_authority_strength: number
    later_authority_strength: number
    ego_ideal_content: list
    conscience_prohibitions: list
    punitive_commands: list
    approval_conditions: list
    unconscious_guilt_sources: list
    severity_from_oedipal_repression: number
    severity_from_defused_aggression: number
    severity_from_later_authorities: number
    flexibility_from_reality_testing: number

STRUCT RepressionNode:
    id: text
    content: text
    instinct_representative: text
    affect_quota: number
    ideational_representative: text
    repression_phase: RepressionPhase
    primal_core_id: text
    distance_from_primal_core: number
    derivative_level: number
    distortion_level: number
    censorship_pass_probability: number
    attraction_from_repressed_core: number
    repulsion_from_conscious_system: number
    anticathexis_cost: number
    return_channels: list
    symptom_links: list
    dream_links: list
    slip_links: list
    transference_links: list

STRUCT DreamWorkPacket:
    day_residue: list
    latent_thoughts: list
    infantile_wish: text
    forbidden_wish: text
    censorship_intensity: number
    regression_depth: number
    condensation_map: map
    displacement_map: map
    symbols: list
    affect_transformations: list
    secondary_revision_story: text
    manifest_content: text
    remembered_fragment: text
    interpretation_path: list

STRUCT ParapraxisPacket:
    intended_action_or_phrase: text
    unconscious_counter_intention: text
    repressed_motive: text
    interference_point: text
    distortion_method: DefenseType
    everyday_output_type: EverydayFormationType
    manifest_error: text
    hidden_meaning: text
    conscious_rationalization: text
    anxiety_or_guilt_relieved: number

STRUCT ClinicalPatternState:
    active_pattern: ClinicalFormationType
    dominant_stage_fixation: PsychosexualFixation
    dominant_repression_node: RepressionNode
    dominant_oedipal_residue: OedipalConfiguration
    dominant_instinct_mixture: InstinctMixture
    dominant_defense_cluster: list
    defense_biases: list
    symptom_choice: list
    secondary_gain: number
    reality_relation_status: text
    object_relation_status: text
    ego_split_level: number
    superego_attack_level: number
    prognosis_for_integration: number

STRUCT AnalyticField:
    analyst_as_perceived_object: text
    transference_type: TransferenceType
    resistance_type: ResistanceType
    repetition_in_session: text
    avoided_memory: text
    avoided_affect: text
    interpretation_readiness: number
    insight_level: number
    working_through_iterations: number
    negative_therapeutic_reaction_risk: number
    transference_neurosis_intensity: number
    alliance_strength: number

# V6 extension structs are declared before CompleteSystemStateV6 so every field type is defined before use.

STRUCT BodyEgoBoundary:
    body_surface_map: map
    internal_perception_stream: list
    external_perception_stream: list
    pain_signals: list
    pleasure_unpleasure_gradient: map
    motility_control_map: map
    body_image_coherence: number
    ego_boundary_stability: number
    inside_outside_discrimination: number
    somatic_symbolization_risk: number
    conversion_channel_bias: list
    depersonalization_or_alienation_risk: number

STRUCT RepresentationPacket:
    source_packet: TopographicPacket
    thing_presentation: text
    word_presentation: text
    visual_residue: text
    auditory_word_residue: text
    motor_word_residue: text
    affect_quota: number
    preconscious_link_strength: number
    consciousness_access_probability: number
    hallucination_risk: number
    thing_word_split_level: number
    interpretation_readiness: number

STRUCT LibidoDistribution:
    ego_libido: number
    object_libido_map: map
    withdrawn_object_libido: number
    narcissistic_accumulation: number
    capacity_to_reinvest_objects: number
    libido_mobility: number
    pathological_damming_threshold: number
    sleep_withdrawal_level: number
    mourning_detachment_work: number
    melancholic_identification_risk: number
    psychotic_withdrawal_risk: number

STRUCT CulturalSuperego:
    cultural_ideals: list
    ethical_commands: list
    collective_guilt_pressure: number
    group_prohibition_strength: number
    impossible_demand_level: number
    cultural_punishment_fear: number
    leader_or_group_ideal: text
    civilization_renunciation_demand: number
    pressure_to_sublimate: number
    pressure_to_conform: number
    conflict_with_individual_drive_level: number


STRUCT PleasureRealityArbitrationRecord:
    active_mode: PleasureRealityArbitrationMode
    raw_pleasure_demand: number
    expected_immediate_pleasure: number
    expected_unpleasure_from_delay: number
    reality_danger: number
    superego_danger: number
    thought_substitution_level: number
    delay_capacity_used: number
    fantasy_satisfaction_level: number
    sublimation_channel_strength: number
    discharge_allowed: boolean
    discharge_deferred: boolean
    discharge_transformed: boolean
    repression_required: boolean
    selected_reality_channel: text
    selected_fantasy_channel: text
    selected_sublimation_channel: text
    arbitration_failure_risk: number

STRUCT NegationJudgmentRecord:
    source_material: text
    negation_status: NegationStatus
    judgment_decision: JudgmentDecision
    intellectual_admission_level: number
    affective_acceptance_level: number
    reality_acceptance_level: number
    moral_acceptance_level: number
    repression_lifted_amount: number
    anticathexis_remaining: number
    contradiction_marked_for_working_through: boolean
    conscious_phrase: text
    hidden_affect: text
    linked_repression_node_id: text

STRUCT EgoSplitCurrent:
    current_type: EgoSplitCurrentType
    attitude_toward_reality: text
    attitude_toward_wish: text
    attitude_toward_superego: text
    dominant_defenses: list
    action_tendency: text
    fantasy_tendency: text
    symptom_tendency: text
    affect_load: number
    reality_testing_level: number
    contradiction_tolerance: number
    persistence_strength: number

STRUCT EgoSplitState:
    split_active: boolean
    reality_accepting_current: EgoSplitCurrent
    wish_preserving_current: EgoSplitCurrent
    superego_obedient_current: EgoSplitCurrent
    observing_ego_current: EgoSplitCurrent
    contradiction_level: number
    disavowal_level: number
    fetish_or_substitute_object_risk: number
    psychotic_reconstruction_risk: number
    neurotic_compromise_risk: number
    synthesis_attempt_strength: number
    dominant_current: EgoSplitCurrentType
    integration_possible: boolean

STRUCT BodilyEgoMainLoopInfluence:
    drive_pressure_increment: number
    anxiety_increment: number
    reality_testing_modifier: number
    defense_biases_added: list
    conversion_risk_increment: number
    motility_inhibition_risk: number
    inside_outside_confusion_signal: number
    body_boundary_conflict_level: number


STRUCT CompleteSystemStateV6:
    base_state: SystemState
    instinct_mixture: InstinctMixture
    psychosexual_fixations: list of PsychosexualFixation
    oedipal_configuration: OedipalConfiguration
    superego_formation_record: SuperegoFormationRecord
    repression_network: list of RepressionNode
    active_dream_packet: DreamWorkPacket
    active_parapraxis_packet: ParapraxisPacket
    clinical_pattern_state: ClinicalPatternState
    analytic_field: AnalyticField
    developmental_anxieties: map
    structural_routes_active: list of StructuralRoute
    body_ego_boundary: BodyEgoBoundary
    active_representation_packets: list of RepresentationPacket
    libido_distribution: LibidoDistribution
    cultural_superego: CulturalSuperego
    pleasure_reality_arbitration: PleasureRealityArbitrationRecord
    negation_judgment_records: list of NegationJudgmentRecord
    ego_split_state: EgoSplitState
    bodily_ego_loop_influence: BodilyEgoMainLoopInfluence


################################################################
# 31. COMPLETE INITIALIZATION V6
################################################################

PROCEDURE Initialize_Complete_System_V6():

    state_v5 = CompleteSystemStateV6()
    state_v5.base_state = Initialize_System()

    state_v5.instinct_mixture = InstinctMixture()
    state_v5.instinct_mixture.eros_level = BASELINE_EROS
    state_v5.instinct_mixture.death_instinct_level = BASELINE_DESTRUCTIVE_TENDENCY
    state_v5.instinct_mixture.destructive_outward_level = BASELINE_OUTWARD_AGGRESSION
    state_v5.instinct_mixture.destructive_inward_level = BASELINE_INWARD_AGGRESSION
    state_v5.instinct_mixture.sadism_level = BASELINE_SADISM_COMPONENT
    state_v5.instinct_mixture.masochism_level = BASELINE_MASOCHISM_COMPONENT
    state_v5.instinct_mixture.fusion_state = PARTIALLY_FUSED
    state_v5.instinct_mixture.binding_force = BASELINE_BINDING_FORCE
    state_v5.instinct_mixture.unbinding_force = BASELINE_UNBINDING_FORCE
    state_v5.instinct_mixture.repetition_compulsion_force = BASELINE_REPETITION_FORCE
    state_v5.instinct_mixture.object_preservation_force = BASELINE_OBJECT_PRESERVATION
    state_v5.instinct_mixture.object_destruction_force = BASELINE_OBJECT_DESTRUCTION

    state_v5.psychosexual_fixations = INITIALIZE_PSYCHOSEXUAL_STAGE_RECORDS()
    state_v5.oedipal_configuration = INITIALIZE_EMPTY_OEDIPAL_CONFIGURATION()
    state_v5.superego_formation_record = INITIALIZE_SUPEREGO_FORMATION_RECORD()
    state_v5.repression_network = []
    state_v5.active_dream_packet = null
    state_v5.active_parapraxis_packet = null
    state_v5.clinical_pattern_state = INITIALIZE_CLINICAL_PATTERN_STATE()
    state_v5.analytic_field = INITIALIZE_ANALYTIC_FIELD()
    state_v5.developmental_anxieties = EMPTY_MAP
    state_v5.structural_routes_active = []
    state_v5.body_ego_boundary = INITIALIZE_BODY_EGO_BOUNDARY()
    state_v5.active_representation_packets = []
    state_v5.libido_distribution = INITIALIZE_LIBIDO_DISTRIBUTION()
    state_v5.cultural_superego = INITIALIZE_CULTURAL_SUPEREGO()
    state_v5.pleasure_reality_arbitration = INITIALIZE_PLEASURE_REALITY_ARBITRATION_RECORD()
    state_v5.negation_judgment_records = []
    state_v5.ego_split_state = INITIALIZE_EGO_SPLIT_STATE()
    state_v5.bodily_ego_loop_influence = INITIALIZE_BODILY_EGO_MAIN_LOOP_INFLUENCE()

    RETURN state_v5


PROCEDURE RUN_FULL_FREUDIAN_MECHANISM_V6():

    state_v6 = Initialize_Complete_System_V6()
    COMPLETE_MAIN_OPERATING_LOOP_V6(state_v6)

END PROCEDURE


PROCEDURE INITIALIZE_PSYCHOSEXUAL_STAGE_RECORDS():

    stages = []

    ADD PsychosexualFixation(
        stage = ORAL,
        erotogenic_zone = "mouth / feeding / incorporation",
        dominant_conflict = "taking in, dependence, loss, devouring, being fed, being abandoned",
        fixation_level = BASELINE_ORAL_FIXATION,
        character_residue = "dependency, receptivity, greed, pessimism, longing for care",
        symptom_choice_bias = [HYSTERICAL_CONVERSION, MELANCHOLIA, NARCISSISTIC_REGRESSION],
        associated_defenses = [INTROJECTION, IDENTIFICATION, DENIAL, FANTASY_WITHDRAWAL],
        associated_outputs = [SYMPTOM_OUTPUT, FANTASY_OUTPUT, SELF_PUNISHMENT]
    ) TO stages

    ADD PsychosexualFixation(
        stage = ANAL,
        erotogenic_zone = "retention / expulsion / control",
        dominant_conflict = "holding on, letting go, obedience, defiance, order, mess, control",
        fixation_level = BASELINE_ANAL_FIXATION,
        character_residue = "orderliness, obstinacy, parsimony, control, ambivalence",
        symptom_choice_bias = [OBSESSIONAL_NEUROSIS, MORAL_MASOCHISM],
        associated_defenses = [REACTION_FORMATION, UNDOING, ISOLATION_OF_AFFECT, RATIONALIZATION],
        associated_outputs = [COMPULSIVE_ACTION, SELF_PUNISHMENT, INHIBITION_OUTPUT]
    ) TO stages

    ADD PsychosexualFixation(
        stage = PHALLIC,
        erotogenic_zone = "genital interest organized by Oedipal rivalry and difference",
        dominant_conflict = "desire for parent, rivalry, prohibition, castration anxiety, identification",
        fixation_level = BASELINE_PHALLIC_FIXATION,
        character_residue = "ambition, rivalry, exhibition, shame, pride, guilt",
        symptom_choice_bias = [PHOBIC_DISPLACEMENT, HYSTERICAL_CONVERSION, PARANOIA],
        associated_defenses = [REPRESSION, DISPLACEMENT, IDENTIFICATION, PROJECTION],
        associated_outputs = [AVOIDANCE_OUTPUT, SYMPTOM_OUTPUT, REALITY_RECONSTRUCTION]
    ) TO stages

    ADD PsychosexualFixation(
        stage = LATENCY,
        erotogenic_zone = "drive inhibition, learning, social rules, sublimation",
        dominant_conflict = "renunciation, education, peer comparison, ideal formation",
        fixation_level = BASELINE_LATENCY_FIXATION,
        character_residue = "conformity, inhibition, sublimation, learning, moralization",
        symptom_choice_bias = [INHIBITION_OUTPUT, CHARACTER_FORMATION],
        associated_defenses = [SUBLIMATION, REACTION_FORMATION, RATIONALIZATION],
        associated_outputs = [INHIBITION_OUTPUT, SUBLIMATED_ACTION, MODIFIED_ACTION]
    ) TO stages

    ADD PsychosexualFixation(
        stage = GENITAL,
        erotogenic_zone = "mature object love under reality and reciprocity",
        dominant_conflict = "integration of love, sexuality, work, reality, responsibility",
        fixation_level = BASELINE_GENITAL_INTEGRATION,
        character_residue = "capacity for love, work, compromise, sublimation",
        symptom_choice_bias = [ORDINARY_CONFLICT],
        associated_defenses = [SUBLIMATION, COMPROMISE_FORMATION],
        associated_outputs = [DELAYED_ACTION, REPAIR_ACTION, DIRECT_ACTION]
    ) TO stages

    RETURN stages



################################################################
# 31A. V5 BODILY EGO, REPRESENTATION ROUTING, LIBIDO MOBILITY,
#      RENUNCIATION FEEDBACK, AND CULTURAL SUPEREGO PROCEDURES
################################################################


PROCEDURE INITIALIZE_BODY_EGO_BOUNDARY():

    boundary = BodyEgoBoundary()
    boundary.body_surface_map = EMPTY_MAP
    boundary.internal_perception_stream = []
    boundary.external_perception_stream = []
    boundary.pain_signals = []
    boundary.pleasure_unpleasure_gradient = EMPTY_MAP
    boundary.motility_control_map = EMPTY_MAP
    boundary.body_image_coherence = BASELINE_BODY_IMAGE_COHERENCE
    boundary.ego_boundary_stability = BASELINE_EGO_BOUNDARY_STABILITY
    boundary.inside_outside_discrimination = BASELINE_INSIDE_OUTSIDE_DISCRIMINATION
    boundary.somatic_symbolization_risk = LOW
    boundary.conversion_channel_bias = []
    boundary.depersonalization_or_alienation_risk = LOW
    RETURN boundary


PROCEDURE INITIALIZE_LIBIDO_DISTRIBUTION():

    distribution = LibidoDistribution()
    distribution.ego_libido = BASELINE_EGO_LIBIDO
    distribution.object_libido_map = EMPTY_MAP
    distribution.withdrawn_object_libido = 0
    distribution.narcissistic_accumulation = BASELINE_NARCISSISTIC_CATHEXIS
    distribution.capacity_to_reinvest_objects = BASELINE_OBJECT_REINVESTMENT_CAPACITY
    distribution.libido_mobility = BASELINE_LIBIDO_MOBILITY
    distribution.pathological_damming_threshold = BASELINE_LIBIDO_DAMMING_THRESHOLD
    distribution.sleep_withdrawal_level = 0
    distribution.mourning_detachment_work = 0
    distribution.melancholic_identification_risk = LOW
    distribution.psychotic_withdrawal_risk = LOW
    RETURN distribution


PROCEDURE INITIALIZE_CULTURAL_SUPEREGO():

    cultural = CulturalSuperego()
    cultural.cultural_ideals = []
    cultural.ethical_commands = []
    cultural.collective_guilt_pressure = 0
    cultural.group_prohibition_strength = BASELINE_GROUP_PROHIBITION
    cultural.impossible_demand_level = 0
    cultural.cultural_punishment_fear = 0
    cultural.leader_or_group_ideal = null
    cultural.civilization_renunciation_demand = BASELINE_CIVILIZATION_RENUNCIATION_DEMAND
    cultural.pressure_to_sublimate = BASELINE_CULTURAL_SUBLIMATION_PRESSURE
    cultural.pressure_to_conform = BASELINE_CONFORMITY_PRESSURE
    cultural.conflict_with_individual_drive_level = 0
    RETURN cultural




PROCEDURE INITIALIZE_PLEASURE_REALITY_ARBITRATION_RECORD():

    record = PleasureRealityArbitrationRecord()
    record.active_mode = THOUGHT_AS_EXPERIMENTAL_ACTION
    record.raw_pleasure_demand = 0
    record.expected_immediate_pleasure = 0
    record.expected_unpleasure_from_delay = 0
    record.reality_danger = 0
    record.superego_danger = 0
    record.thought_substitution_level = BASELINE_THOUGHT_SUBSTITUTION
    record.delay_capacity_used = 0
    record.fantasy_satisfaction_level = 0
    record.sublimation_channel_strength = 0
    record.discharge_allowed = false
    record.discharge_deferred = false
    record.discharge_transformed = false
    record.repression_required = false
    record.selected_reality_channel = null
    record.selected_fantasy_channel = null
    record.selected_sublimation_channel = null
    record.arbitration_failure_risk = LOW
    RETURN record


PROCEDURE INITIALIZE_EGO_SPLIT_CURRENT(current_type):

    current = EgoSplitCurrent()
    current.current_type = current_type
    current.attitude_toward_reality = "not yet formed"
    current.attitude_toward_wish = "not yet formed"
    current.attitude_toward_superego = "not yet formed"
    current.dominant_defenses = []
    current.action_tendency = null
    current.fantasy_tendency = null
    current.symptom_tendency = null
    current.affect_load = 0
    current.reality_testing_level = BASELINE_REALITY_TESTING
    current.contradiction_tolerance = BASELINE_CONTRADICTION_TOLERANCE
    current.persistence_strength = LOW
    RETURN current


PROCEDURE INITIALIZE_EGO_SPLIT_STATE():

    split = EgoSplitState()
    split.split_active = false
    split.reality_accepting_current = INITIALIZE_EGO_SPLIT_CURRENT(REALITY_ACCEPTING_CURRENT)
    split.wish_preserving_current = INITIALIZE_EGO_SPLIT_CURRENT(WISH_PRESERVING_DISAVOWING_CURRENT)
    split.superego_obedient_current = INITIALIZE_EGO_SPLIT_CURRENT(SUPEREGO_OBEDIENT_CURRENT)
    split.observing_ego_current = INITIALIZE_EGO_SPLIT_CURRENT(OBSERVING_EGO_CURRENT)
    split.contradiction_level = 0
    split.disavowal_level = 0
    split.fetish_or_substitute_object_risk = LOW
    split.psychotic_reconstruction_risk = LOW
    split.neurotic_compromise_risk = LOW
    split.synthesis_attempt_strength = BASELINE_EGO_SYNTHESIS
    split.dominant_current = NO_SPLIT
    split.integration_possible = true
    RETURN split


PROCEDURE INITIALIZE_BODILY_EGO_MAIN_LOOP_INFLUENCE():

    influence = BodilyEgoMainLoopInfluence()
    influence.drive_pressure_increment = 0
    influence.anxiety_increment = 0
    influence.reality_testing_modifier = 0
    influence.defense_biases_added = []
    influence.conversion_risk_increment = 0
    influence.motility_inhibition_risk = 0
    influence.inside_outside_confusion_signal = 0
    influence.body_boundary_conflict_level = 0
    RETURN influence


PROCEDURE UPDATE_BODY_EGO_BOUNDARY(state_v5, internal_stimuli, external_input):

    boundary = state_v5.body_ego_boundary

    boundary.internal_perception_stream = SCAN_INTERNAL_SENSATIONS(internal_stimuli)
    boundary.external_perception_stream = SCAN_EXTERNAL_SURFACE_CONTACT(external_input)
    boundary.pain_signals = DETECT_PAIN_AS_BOUNDARY_SIGNAL(internal_stimuli, external_input)
    boundary.pleasure_unpleasure_gradient = UPDATE_PLEASURE_UNPLEASURE_MAP(internal_stimuli, external_input)
    boundary.motility_control_map = UPDATE_MOTILITY_CONTROL_MAP(state_v5.base_state.ego.motor_control_capacity)

    boundary.inside_outside_discrimination =
        CALCULATE_INSIDE_OUTSIDE_DISCRIMINATION(
            boundary.internal_perception_stream,
            boundary.external_perception_stream,
            state_v5.base_state.ego.reality_testing_capacity
        )

    boundary.body_image_coherence =
        UPDATE_BODY_IMAGE_COHERENCE(
            boundary.body_surface_map,
            boundary.motility_control_map,
            boundary.pain_signals,
            state_v5.base_state.ego.integration_capacity
        )

    boundary.ego_boundary_stability =
        boundary.inside_outside_discrimination
        + boundary.body_image_coherence
        + state_v5.base_state.ego.self_coherence
        - state_v5.base_state.ego.fatigue
        - SUM_AFFECTIVE_INTRUSION(boundary.internal_perception_stream)

    IF SUM_INTENSITY(boundary.pain_signals) > state_v5.base_state.ego.binding_capacity:
        boundary.somatic_symbolization_risk += SOMATIC_SYMBOLIZATION_INCREMENT
        state_v5.base_state.current_anxiety += PAIN_TO_ANXIETY_SIGNAL_INCREMENT

    IF boundary.ego_boundary_stability < BODY_EGO_STABILITY_THRESHOLD:
        boundary.depersonalization_or_alienation_risk += EGO_BOUNDARY_FAILURE_INCREMENT
        state_v5.base_state.current_anxiety += BODY_BOUNDARY_ANXIETY_INCREMENT

    IF boundary.somatic_symbolization_risk > CONVERSION_RISK_THRESHOLD:
        boundary.conversion_channel_bias ADD SELECT_SOMATIC_CHANNEL(boundary.pain_signals)
        state_v5.base_state.pending_defense_biases ADD SOMATIC_CONVERSION

    state_v5.body_ego_boundary = boundary
    RETURN state_v5




PROCEDURE INTEGRATE_BODILY_EGO_IN_MAIN_LOOP(state_v5, internal_stimuli, external_input):

    # Freud's ego is rooted in the body: surface, pain, motility,
    # inside/outside discrimination, and bodily pleasure-unpleasure.
    # This procedure prevents the bodily ego from remaining an appendix.

    influence = INITIALIZE_BODILY_EGO_MAIN_LOOP_INFLUENCE()
    boundary = state_v5.body_ego_boundary
    base = state_v5.base_state

    influence.drive_pressure_increment =
        SUM_INTENSITY(boundary.internal_perception_stream)
        + SUM_INTENSITY(boundary.pain_signals)
        + UNPLEASURE_PRESSURE(boundary.pleasure_unpleasure_gradient)

    influence.anxiety_increment =
        BODY_BOUNDARY_ANXIETY(boundary)
        + PAIN_ANXIETY(boundary.pain_signals)
        + INSIDE_OUTSIDE_CONFUSION_ANXIETY(boundary.inside_outside_discrimination)

    influence.reality_testing_modifier =
        boundary.inside_outside_discrimination
        + boundary.body_image_coherence
        - SUM_INTENSITY(boundary.pain_signals)
        - boundary.depersonalization_or_alienation_risk

    influence.conversion_risk_increment =
        boundary.somatic_symbolization_risk
        + SOMATIC_CHANNEL_AVAILABILITY(boundary.conversion_channel_bias)

    influence.motility_inhibition_risk =
        MOTILITY_CONFLICT_RISK(boundary.motility_control_map, base.ego.motor_control_capacity)

    influence.inside_outside_confusion_signal =
        MAX(0, BODY_EGO_STABILITY_THRESHOLD - boundary.inside_outside_discrimination)

    influence.body_boundary_conflict_level =
        influence.drive_pressure_increment
        + influence.anxiety_increment
        + influence.conversion_risk_increment
        + influence.motility_inhibition_risk

    IF influence.drive_pressure_increment > BODY_DRIVE_PRESSURE_THRESHOLD:
        base.id.bodily_need_pressure += influence.drive_pressure_increment
        base.id.free_drive_energy += influence.drive_pressure_increment

    IF influence.anxiety_increment > BODY_ANXIETY_THRESHOLD:
        base.current_anxiety += influence.anxiety_increment

    IF influence.reality_testing_modifier < LOW:
        base.ego.reality_testing_capacity -= BODY_CONFUSION_REALITY_TESTING_COST
        base.ego.self_coherence -= BODY_CONFUSION_SELF_COHERENCE_COST

    IF influence.conversion_risk_increment > CONVERSION_RISK_THRESHOLD:
        influence.defense_biases_added ADD SOMATIC_CONVERSION
        influence.defense_biases_added ADD SYMBOLIZATION
        base.pending_defense_biases ADD SOMATIC_CONVERSION

    IF influence.motility_inhibition_risk > INHIBITION_THRESHOLD:
        influence.defense_biases_added ADD INHIBITION
        base.pending_defense_biases ADD INHIBITION

    state_v5.base_state = base
    state_v5.bodily_ego_loop_influence = influence
    RETURN state_v5


PROCEDURE PLEASURE_REALITY_PRINCIPLE_ARBITRATION(state_v5, ego_material, reality_report, superego_judgment):

    # The id presses for immediate pleasure and discharge.
    # The ego introduces reality-testing, delay, thought as trial action,
    # substitute satisfaction, sublimation, renunciation, or repression.

    record = INITIALIZE_PLEASURE_REALITY_ARBITRATION_RECORD()
    base = state_v5.base_state

    record.raw_pleasure_demand =
        SUM_AFFECT_AND_DRIVE_PRESSURE(ego_material)
        + base.id.free_drive_energy
        + base.id.repressed_wish_pressure

    record.expected_immediate_pleasure = ESTIMATE_IMMEDIATE_PLEASURE(ego_material)
    record.expected_unpleasure_from_delay = ESTIMATE_UNPLEASURE_FROM_DELAY(ego_material, base.ego.capacity_to_delay)
    record.reality_danger =
        reality_report.external_danger
        + reality_report.social_cost
        + reality_report.legal_cost
        + reality_report.physical_cost
        + reality_report.resource_cost
    record.superego_danger =
        superego_judgment.prohibition_level
        + superego_judgment.guilt_threat
        + superego_judgment.shame_threat
        + superego_judgment.punishment_demand

    IF record.raw_pleasure_demand <= LOW:
        record.active_mode = THOUGHT_AS_EXPERIMENTAL_ACTION
        record.discharge_deferred = true
        state_v5.pleasure_reality_arbitration = record
        RETURN state_v5

    IF record.reality_danger <= LOW
       AND record.superego_danger <= LOW
       AND reality_report.action_possible == true:
        record.active_mode = IMMEDIATE_PLEASURE_DISCHARGE
        record.discharge_allowed = true
        record.selected_reality_channel = SELECT_DIRECT_REALITY_CHANNEL(reality_report.safe_channels)
        state_v5.structural_routes_active ADD EGO_TO_ID_DELAY_OR_DISCHARGE
        state_v5.pleasure_reality_arbitration = record
        RETURN state_v5

    IF reality_report.delay_required == true
       AND base.ego.capacity_to_delay > DELAY_THRESHOLD:
        record.active_mode = DELAYED_REALITY_SATISFACTION
        record.discharge_deferred = true
        record.delay_capacity_used = REQUIRED_DELAY_CAPACITY(ego_material, reality_report)
        base.ego.capacity_to_delay -= record.delay_capacity_used
        base.energy.bound_energy += BINDING_REQUIRED_FOR_DELAY(ego_material)
        state_v5.structural_routes_active ADD EGO_TO_ID_DELAY_OR_DISCHARGE
        state_v5.pleasure_reality_arbitration = record
        state_v5.base_state = base
        RETURN state_v5

    IF base.ego.planning_capacity > THOUGHT_EXPERIMENT_THRESHOLD:
        record.active_mode = THOUGHT_AS_EXPERIMENTAL_ACTION
        record.discharge_deferred = true
        record.thought_substitution_level = BUILD_THOUGHT_TRIAL_ACTION(ego_material, reality_report)
        base.energy.free_energy -= THOUGHT_BINDING_AMOUNT(record.thought_substitution_level)
        base.energy.bound_energy += THOUGHT_BINDING_AMOUNT(record.thought_substitution_level)

    IF reality_report.opportunity_value > OPPORTUNITY_THRESHOLD
       AND base.ego.sublimation_capacity > SUBLIMATION_THRESHOLD:
        record.active_mode = SUBLIMATED_REALITY_SATISFACTION
        record.discharge_transformed = true
        record.selected_sublimation_channel = SELECT_SUBLIMATION_CHANNEL(ego_material, reality_report)
        record.sublimation_channel_strength = MEASURE_SUBLIMATION_STRENGTH(record.selected_sublimation_channel)
        base.pending_defense_biases ADD SUBLIMATION

    ELSE IF record.reality_danger > HIGH
       AND base.ego.symbolization_capacity > SYMBOLIZATION_THRESHOLD:
        record.active_mode = FANTASY_SUBSTITUTE_SATISFACTION
        record.discharge_transformed = true
        record.selected_fantasy_channel = BUILD_FANTASY_SUBSTITUTE_CHANNEL(ego_material)
        record.fantasy_satisfaction_level = ESTIMATE_FANTASY_SATISFACTION(record.selected_fantasy_channel)
        base.pending_defense_biases ADD FANTASY_WITHDRAWAL

    IF record.superego_danger > HIGH
       AND superego_judgment.approval_reward > APPROVAL_THRESHOLD:
        record.active_mode = RENUNCIATION_WITH_SUPEREGO_REWARD
        record.discharge_deferred = true
        IF WISH_REMAINS_ACTIVE(ego_material):
            base.pending_defense_biases ADD REACTION_FORMATION

    IF record.reality_danger > HIGH
       AND record.superego_danger > HIGH
       AND base.ego.capacity_to_delay <= LOW
       AND base.ego.sublimation_capacity <= LOW:
        record.active_mode = REPRESSION_OR_DEFENSIVE_BLOCKING
        record.repression_required = true
        base.pending_defense_biases ADD REPRESSION
        record.arbitration_failure_risk = HIGH

    state_v5.base_state = base
    state_v5.pleasure_reality_arbitration = record
    RETURN state_v5


PROCEDURE HANDLE_NEGATION_AND_JUDGMENT(state_v5, ego_material, reality_report, superego_judgment):

    # Negation lets repressed content enter thought in the form
    # "this is not what I think / want / feel". The idea has entered,
    # but affective acceptance and full lifting of repression have not yet occurred.

    FOR EACH material IN ego_material:

        IF MATERIAL_APPEARS_AS_NEGATED_REPRESSED_CONTENT(material):
            record = NegationJudgmentRecord()
            record.source_material = EXTRACT_CONTENT(material)
            record.negation_status = DIRECT_DENIAL_OF_REPRESSED_CONTENT
            record.judgment_decision = ACCEPTED_ONLY_UNDER_NEGATION
            record.intellectual_admission_level = HIGH
            record.affective_acceptance_level = LOW
            record.reality_acceptance_level = LOW_TO_MEDIUM
            record.moral_acceptance_level = LOW IF superego_judgment.prohibition_level > MEDIUM ELSE MEDIUM
            record.repression_lifted_amount = PARTIAL_REPRESSION_LIFT
            record.anticathexis_remaining = REMAINING_ANTICATHEXIS_FOR(material, state_v5.repression_network)
            record.contradiction_marked_for_working_through = true
            record.conscious_phrase = EXTRACT_NEGATING_PHRASE(material)
            record.hidden_affect = EXTRACT_AFFECT_BEHIND_NEGATION(material)
            record.linked_repression_node_id = FIND_LINKED_REPRESSION_NODE(material, state_v5.repression_network)

            state_v5.negation_judgment_records ADD record
            state_v5.base_state.ego.integration_capacity += SMALL_INCREMENT
            state_v5.base_state.ego.repression_load -= PARTIAL_REPRESSION_LIFT
            state_v5.base_state.current_anxiety += AFFECTIVE_REJECTION_ANXIETY(record)

            IF record.linked_repression_node_id != null:
                node = GET_REPRESSION_NODE(state_v5.repression_network, record.linked_repression_node_id)
                node.repression_phase = PARTIAL_LIFTING_OF_REPRESSION
                node.censorship_pass_probability += NEGATION_ACCESS_INCREMENT
                node.anticathexis_cost -= PARTIAL_REPRESSION_LIFT

        ELSE IF MATERIAL_REQUIRES_REALITY_JUDGMENT(material):
            record = NegationJudgmentRecord()
            record.source_material = EXTRACT_CONTENT(material)
            record.negation_status = NONE
            record.intellectual_admission_level = MEASURE_INTELLECTUAL_RECOGNITION(material)
            record.affective_acceptance_level = MEASURE_AFFECTIVE_ACCEPTANCE(material)
            record.reality_acceptance_level = MEASURE_REALITY_ACCEPTANCE(material, reality_report)
            record.moral_acceptance_level = MEASURE_MORAL_ACCEPTANCE(material, superego_judgment)
            record.judgment_decision = DECIDE_JUDGMENT_OUTCOME(record, reality_report, superego_judgment)
            record.contradiction_marked_for_working_through =
                record.intellectual_admission_level > MEDIUM
                AND record.affective_acceptance_level < LOW

            state_v5.negation_judgment_records ADD record

    RETURN state_v5


PROCEDURE HANDLE_EGO_SPLIT_AS_PARALLEL_ATTITUDES(state_v5, ego_material, reality_report, superego_judgment):

    # Ego-splitting is not merely a momentary conflict label.
    # It can preserve two simultaneous attitudes:
    # one accepts reality; the other preserves the wish by disavowal,
    # substitute object, symptom, fantasy, or reconstruction.

    split = state_v5.ego_split_state
    base = state_v5.base_state

    contradiction =
        MEASURE_WISH_REALITY_CONTRADICTION(ego_material, reality_report)
        + MEASURE_WISH_SUPEREGO_CONTRADICTION(ego_material, superego_judgment)
        + state_v5.bodily_ego_loop_influence.inside_outside_confusion_signal

    split.contradiction_level = contradiction

    IF contradiction <= EGO_SPLIT_THRESHOLD:
        split.split_active = false
        split.dominant_current = NO_SPLIT
        split.integration_possible = true
        state_v5.ego_split_state = split
        RETURN state_v5

    split.split_active = true

    split.reality_accepting_current.attitude_toward_reality = "reality is recognized as limiting or dangerous"
    split.reality_accepting_current.attitude_toward_wish = "wish must be delayed, transformed, or renounced"
    split.reality_accepting_current.attitude_toward_superego = "superego judgment is considered but not necessarily obeyed absolutely"
    split.reality_accepting_current.dominant_defenses = [SUBLIMATION, COMPROMISE_FORMATION]
    split.reality_accepting_current.action_tendency = "delay, reality-bound action, or sublimated action"
    split.reality_accepting_current.reality_testing_level = base.ego.reality_testing_capacity
    split.reality_accepting_current.affect_load = reality_report.external_danger + reality_report.social_cost
    split.reality_accepting_current.persistence_strength = base.ego.reality_testing_capacity + base.ego.integration_capacity

    split.wish_preserving_current.attitude_toward_reality = "reality is disavowed, minimized, replaced, or bypassed"
    split.wish_preserving_current.attitude_toward_wish = "wish is preserved as still valid"
    split.wish_preserving_current.attitude_toward_superego = "superego threat is avoided through disguise or substitute satisfaction"
    split.wish_preserving_current.dominant_defenses = [DENIAL, DISAVOWAL, FANTASY_WITHDRAWAL, SYMBOLIZATION]
    split.wish_preserving_current.fantasy_tendency = BUILD_WISH_PRESERVING_FANTASY(ego_material)
    split.wish_preserving_current.symptom_tendency = BUILD_SPLIT_COMPROMISE_SYMPTOM_IF_NEEDED(ego_material)
    split.wish_preserving_current.affect_load = SUM_AFFECT_AND_DRIVE_PRESSURE(ego_material)
    split.wish_preserving_current.reality_testing_level = base.ego.reality_testing_capacity - DISAVOWAL_REALITY_TESTING_COST
    split.wish_preserving_current.persistence_strength = split.wish_preserving_current.affect_load + base.id.repressed_wish_pressure

    split.superego_obedient_current.attitude_toward_reality = "reality matters less than punishment, guilt, or ideal obedience"
    split.superego_obedient_current.attitude_toward_wish = "wish deserves renunciation or punishment"
    split.superego_obedient_current.attitude_toward_superego = "superego command is treated as binding"
    split.superego_obedient_current.dominant_defenses = [TURNING_AGAINST_SELF, UNDOING, REACTION_FORMATION]
    split.superego_obedient_current.affect_load = superego_judgment.guilt_threat + superego_judgment.punishment_demand
    split.superego_obedient_current.persistence_strength = superego_judgment.prohibition_level + superego_judgment.punishment_demand

    split.observing_ego_current.attitude_toward_reality = "observes contradiction and can report it if anxiety is tolerable"
    split.observing_ego_current.attitude_toward_wish = "recognizes wish as mental content"
    split.observing_ego_current.attitude_toward_superego = "recognizes guilt as internal judgment"
    split.observing_ego_current.dominant_defenses = [INTELLECTUALIZATION_RESISTANCE]
    split.observing_ego_current.persistence_strength = base.ego.integration_capacity + base.ego.word_linking_capacity

    split.disavowal_level = CALCULATE_DISAVOWAL_LEVEL(split)
    split.fetish_or_substitute_object_risk = CALCULATE_SUBSTITUTE_OBJECT_RISK(split, ego_material)
    split.psychotic_reconstruction_risk = CALCULATE_PSYCHOTIC_RECONSTRUCTION_RISK(split, state_v5.libido_distribution)
    split.neurotic_compromise_risk = CALCULATE_NEUROTIC_COMPROMISE_RISK(split)
    split.synthesis_attempt_strength = base.ego.integration_capacity + base.ego.binding_capacity - base.ego.fatigue
    split.integration_possible = split.synthesis_attempt_strength > split.contradiction_level
    split.dominant_current = SELECT_DOMINANT_EGO_SPLIT_CURRENT(split)

    IF split.dominant_current == WISH_PRESERVING_DISAVOWING_CURRENT:
        base.pending_defense_biases ADD DISAVOWAL
        base.pending_defense_biases ADD FANTASY_WITHDRAWAL

    IF split.dominant_current == SUPEREGO_OBEDIENT_CURRENT:
        base.pending_defense_biases ADD TURNING_AGAINST_SELF
        base.pending_defense_biases ADD UNDOING

    IF split.psychotic_reconstruction_risk > PSYCHOSIS_RECONSTRUCTION_THRESHOLD:
        state_v5.clinical_pattern_state.active_pattern = PSYCHOSIS_RECONSTRUCTION

    IF split.neurotic_compromise_risk > SYMPTOM_THRESHOLD:
        base.active_conflict_report.risk_of_symptom += SPLIT_COMPROMISE_SYMPTOM_INCREMENT

    state_v5.base_state = base
    state_v5.ego_split_state = split
    RETURN state_v5


PROCEDURE CONVERT_TO_REPRESENTATION_PACKET(state_v5, topographic_packet):

    rep = RepresentationPacket()
    rep.source_packet = topographic_packet
    rep.thing_presentation = EXTRACT_THING_PRESENTATION(topographic_packet)
    rep.word_presentation = EXTRACT_EXISTING_WORD_PRESENTATION(topographic_packet)
    rep.visual_residue = EXTRACT_VISUAL_RESIDUE(topographic_packet)
    rep.auditory_word_residue = EXTRACT_AUDITORY_WORD_RESIDUE(topographic_packet)
    rep.motor_word_residue = EXTRACT_MOTOR_WORD_RESIDUE(topographic_packet)
    rep.affect_quota = topographic_packet.affect_charge
    rep.preconscious_link_strength = MEASURE_PRECONSCIOUS_LINK(topographic_packet)
    rep.consciousness_access_probability = MEASURE_CONSCIOUS_ACCESS(topographic_packet)
    rep.hallucination_risk = CALCULATE_HALLUCINATION_RISK(topographic_packet)
    rep.thing_word_split_level = CALCULATE_THING_WORD_SPLIT(topographic_packet)
    rep.interpretation_readiness = LOW
    RETURN rep


PROCEDURE LINK_THING_PRESENTATION_TO_WORD_PRESENTATION(state_v5, rep):

    IF rep.thing_presentation == null:
        RETURN rep

    IF rep.word_presentation == null:
        rep.word_presentation = FIND_OR_CREATE_WORD_LINK(rep.thing_presentation)
        rep.auditory_word_residue = CREATE_AUDITORY_WORD_RESIDUE(rep.word_presentation)
        rep.motor_word_residue = CREATE_MOTOR_SPEECH_RESIDUE(rep.word_presentation)

    rep.preconscious_link_strength += WORD_LINKING_INCREMENT
    rep.consciousness_access_probability += PRECONSCIOUS_ACCESS_INCREMENT
    rep.thing_word_split_level -= WORD_LINKING_REDUCES_SPLIT
    rep.hallucination_risk -= WORD_LINKING_REDUCES_IMAGE_REGRESSION
    rep.interpretation_readiness += WORD_LINKING_INTERPRETATION_INCREMENT

    IF rep.affect_quota <= state_v5.base_state.ego.tolerance_for_tension:
        rep.source_packet.current_region = PRECONSCIOUS
        rep.source_packet.word_linked = true
        rep.source_packet.allowed_to_consciousness = MAYBE

    IF rep.preconscious_link_strength > CONSCIOUS_REPORT_THRESHOLD
       AND rep.affect_quota <= state_v5.base_state.ego.binding_capacity:
        rep.source_packet.current_region = CONSCIOUS
        rep.source_packet.allowed_to_consciousness = true

    RETURN rep


PROCEDURE LINK_EGO_MATERIAL_THROUGH_WORD_PRESENTATIONS(state_v5, ego_material):

    linked_material = []

    FOR EACH material IN ego_material:
        rep = CONVERT_TO_REPRESENTATION_PACKET(state_v5, material)
        rep = LINK_THING_PRESENTATION_TO_WORD_PRESENTATION(state_v5, rep)
        ADD rep TO state_v5.active_representation_packets
        ADD rep.source_packet TO linked_material

        IF rep.thing_word_split_level > HIGH:
            state_v5.base_state.pending_defense_biases ADD SYMBOLIZATION
            state_v5.base_state.current_anxiety += UNLINKED_THING_PRESENTATION_ANXIETY

    RETURN linked_material


PROCEDURE UPDATE_LIBIDO_DISTRIBUTION(state_v5, object_events, current_state):

    distribution = state_v5.libido_distribution

    IF current_state == SLEEP:
        withdrawn = WITHDRAW_OBJECT_LIBIDO_FOR_SLEEP(distribution.object_libido_map)
        distribution.withdrawn_object_libido += withdrawn
        distribution.ego_libido += withdrawn
        distribution.sleep_withdrawal_level += withdrawn

    FOR EACH event IN object_events:

        IF event.kind IN ["object_found", "object_loved", "object_available"]:
            investment = CALCULATE_OBJECT_INVESTMENT(event, distribution.libido_mobility)
            distribution.object_libido_map[event.object_id] += investment
            distribution.ego_libido -= investment
            distribution.withdrawn_object_libido -= MIN(distribution.withdrawn_object_libido, investment)

        IF event.kind IN ["object_lost", "object_disappointing", "object_forbidden", "object_unavailable"]:
            withdrawn = WITHDRAW_LIBIDO_FROM_OBJECT(distribution.object_libido_map, event.object_id)
            distribution.withdrawn_object_libido += withdrawn
            distribution.ego_libido += withdrawn
            distribution.narcissistic_accumulation += NARCISSISTIC_RETURN_AMOUNT(withdrawn)
            distribution.mourning_detachment_work += withdrawn IF event.kind == "object_lost" ELSE 0

        IF event.kind == "object_ambivalently_lost":
            withdrawn = WITHDRAW_LIBIDO_FROM_OBJECT(distribution.object_libido_map, event.object_id)
            distribution.withdrawn_object_libido += withdrawn
            distribution.ego_libido += withdrawn
            distribution.melancholic_identification_risk += withdrawn + event.hostility_level

    IF distribution.ego_libido + distribution.withdrawn_object_libido > distribution.pathological_damming_threshold:
        distribution.narcissistic_accumulation += LIBIDO_DAMMING_INCREMENT
        state_v5.base_state.id.narcissistic_pressure += LIBIDO_DAMMING_TO_NARCISSISTIC_PRESSURE

    IF distribution.capacity_to_reinvest_objects < LOW
       AND distribution.withdrawn_object_libido > HIGH:
        distribution.psychotic_withdrawal_risk += WITHDRAWAL_FROM_OBJECT_WORLD_INCREMENT
        state_v5.clinical_pattern_state.reality_relation_status = "object libido withdrawn from shared reality"

    IF distribution.melancholic_identification_risk > MELANCHOLIA_RISK_THRESHOLD:
        state_v5.clinical_pattern_state.defense_biases ADD INTROJECTION
        state_v5.clinical_pattern_state.defense_biases ADD TURNING_AGAINST_SELF

    state_v5.libido_distribution = distribution
    RETURN state_v5


PROCEDURE SUPEREGO_RENUNCIATION_FEEDBACK_LOOP(state_v5, renounced_impulse):

    base = state_v5.base_state
    record = state_v5.superego_formation_record

    IF renounced_impulse == null:
        RETURN state_v5

    IF renounced_impulse.renunciation_due_to_external_authority:
        base.superego.internalized_authority_strength += AUTHORITY_INTERNALIZATION_INCREMENT
        record.later_authority_strength += AUTHORITY_INTERNALIZATION_INCREMENT
        record.conscience_prohibitions ADD renounced_impulse.prohibition_text

    IF renounced_impulse.renunciation_due_to_superego:
        base.superego.conscience_strength += RENUNCIATION_TO_CONSCIENCE_INCREMENT
        base.superego.severity += RENUNCIATION_SEVERITY_INCREMENT
        base.superego.rigidity += RENUNCIATION_RIGIDITY_INCREMENT
        base.superego.unconscious_punishment_need += WISH_PERSISTENCE_GUILT_INCREMENT
        record.punitive_commands ADD "renunciation proves the wish existed; punish if it returns"
        record.unconscious_guilt_sources ADD renounced_impulse.raw_wish

    IF renounced_impulse.forbidden_wish_persists_unconsciously:
        base.current_guilt += UNCONSCIOUS_WISH_GUILT_SIGNAL
        base.ego.repression_load += ADDITIONAL_ANTICATHEXIS_REQUIRED
        base.energy.anticathexes[renounced_impulse.raw_wish] += ADDITIONAL_ANTICATHEXIS_REQUIRED

    IF renounced_impulse.renunciation_supported_by_love_or_sublimation:
        base.ego.tolerance_for_tension += SUPPORTED_RENUNCIATION_EGO_GAIN
        base.ego.sublimation_capacity += SUPPORTED_RENUNCIATION_SUBLIMATION_GAIN
        base.superego.moral_flexibility += HUMANE_RENUNCIATION_FLEXIBILITY_GAIN

    state_v5.base_state = base
    state_v5.superego_formation_record = record
    RETURN state_v5


PROCEDURE APPLY_CULTURAL_SUPEREGO_PRESSURE(state_v5, cultural_context):

    IF cultural_context == null:
        RETURN state_v5

    cultural = state_v5.cultural_superego
    base = state_v5.base_state

    cultural.cultural_ideals = MERGE_UNIQUE(cultural.cultural_ideals, cultural_context.ideals)
    cultural.ethical_commands = MERGE_UNIQUE(cultural.ethical_commands, cultural_context.commands)
    cultural.collective_guilt_pressure += cultural_context.guilt_pressure
    cultural.group_prohibition_strength += cultural_context.prohibition_strength
    cultural.impossible_demand_level += cultural_context.impossible_demand_level
    cultural.cultural_punishment_fear += cultural_context.punishment_fear
    cultural.civilization_renunciation_demand += cultural_context.renunciation_demand
    cultural.pressure_to_sublimate += cultural_context.sublimation_demand
    cultural.pressure_to_conform += cultural_context.conformity_demand
    cultural.conflict_with_individual_drive_level =
        cultural.civilization_renunciation_demand
        + cultural.group_prohibition_strength
        + cultural.impossible_demand_level
        - base.ego.tolerance_for_tension
        - base.ego.sublimation_capacity

    IF cultural_context.leader_or_group_ideal != null:
        cultural.leader_or_group_ideal = cultural_context.leader_or_group_ideal
        SUBSTITUTE_GROUP_IDEAL_FOR_EGO_IDEAL(state_v5, cultural.leader_or_group_ideal)
        base.superego.ego_ideal_demand += GROUP_IDEAL_INTENSIFICATION

    base.superego.social_authority_strength += cultural.group_prohibition_strength
    base.superego.ego_ideal_demand += cultural.impossible_demand_level
    base.current_guilt += cultural.collective_guilt_pressure

    IF cultural.conflict_with_individual_drive_level > CULTURAL_CONFLICT_THRESHOLD:
        base.current_anxiety += CULTURAL_SUPEREGO_ANXIETY_INCREMENT
        base.ego.repression_load += CULTURAL_REPRESSION_LOAD_INCREMENT
        base.pending_defense_biases ADD SUBLIMATION
        base.pending_defense_biases ADD REACTION_FORMATION

    state_v5.cultural_superego = cultural
    state_v5.base_state = base
    RETURN state_v5


PROCEDURE SAFE_CURRENT_CONFLICT_FOR_INSTINCT_UPDATE(state_v5):

    IF state_v5.base_state.active_conflict_report == null:
        empty_conflict = ConflictReport()
        empty_conflict.conflict_type = NONE
        empty_conflict.id_pressure = 0
        empty_conflict.reality_pressure = 0
        empty_conflict.superego_pressure = 0
        empty_conflict.ego_capacity = state_v5.base_state.ego.strength
        empty_conflict.total_conflict = 0
        empty_conflict.dominant_danger_source = "none"
        empty_conflict.anxiety_type = NONE
        empty_conflict.anxiety_level = 0
        RETURN empty_conflict

    RETURN state_v5.base_state.active_conflict_report


################################################################
# 32. COMPLETE INSTINCT DUALISM: EROS, DEATH INSTINCT, FUSION, DEFUSION
################################################################

PROCEDURE UPDATE_INSTINCT_MIXTURE(state_v5, stimulus, conflict):

    mixture = state_v5.instinct_mixture

    IF conflict == null:
        conflict = SAFE_CURRENT_CONFLICT_FOR_INSTINCT_UPDATE(state_v5)

    mixture.eros_level += CALCULATE_BINDING_AND_OBJECT_LOVE(stimulus)
    mixture.death_instinct_level += CALCULATE_UNBINDING_AND_RETURN_TO_QUIESCENCE(stimulus)
    mixture.destructive_outward_level += CALCULATE_OUTWARD_DESTRUCTION(stimulus, conflict)
    mixture.destructive_inward_level += CALCULATE_INWARD_TURNED_AGGRESSION(stimulus, conflict)

    IF mixture.eros_level > mixture.death_instinct_level
       AND state_v5.base_state.ego.binding_capacity > mixture.unbinding_force:
        mixture.fusion_state = FUSED
        mixture.binding_force += EROS_BINDING_INCREMENT
        mixture.repetition_compulsion_force -= BINDING_REDUCES_REPETITION

    ELSE IF mixture.death_instinct_level > mixture.eros_level
        AND state_v5.base_state.ego.binding_capacity <= mixture.unbinding_force:
        mixture.fusion_state = DEFUSED
        mixture.unbinding_force += DEFUSION_INCREMENT
        mixture.repetition_compulsion_force += DEFUSION_REPETITION_INCREMENT

    ELSE:
        mixture.fusion_state = PARTIALLY_FUSED

    IF mixture.destructive_outward_level > OUTWARD_AGGRESSION_THRESHOLD:
        state_v5.base_state.id.aggression_pool += mixture.destructive_outward_level

    IF mixture.destructive_inward_level > INWARD_AGGRESSION_THRESHOLD:
        state_v5.base_state.superego.sadistic_punishment_force += mixture.destructive_inward_level
        state_v5.base_state.superego.unconscious_punishment_need += mixture.destructive_inward_level
        mixture.masochism_level += INWARD_AGGRESSION_TO_MASOCHISM(mixture)

    RETURN state_v5


PROCEDURE HANDLE_INSTINCT_DEFUSION(state_v5):

    mixture = state_v5.instinct_mixture

    IF mixture.fusion_state != DEFUSED:
        RETURN state_v5

    IF mixture.destructive_outward_level > mixture.destructive_inward_level:
        state_v5.base_state.active_drive_demands ADD CREATE_DRIVE_DEMAND(
            drive_class = AGGRESSIVE,
            raw_wish = "destroy, attack, humiliate, remove, master, or retaliate against object",
            intensity = mixture.destructive_outward_level,
            urgency = HIGH,
            aggression_component = mixture.destructive_outward_level
        )

    IF mixture.destructive_inward_level >= mixture.destructive_outward_level:
        state_v5.base_state.superego.severity += mixture.destructive_inward_level
        state_v5.base_state.superego.sadistic_punishment_force += mixture.destructive_inward_level
        state_v5.base_state.current_guilt += mixture.destructive_inward_level
        state_v5.base_state.current_shame += mixture.destructive_inward_level / 2

    IF state_v5.base_state.ego.binding_capacity > RE_FUSION_THRESHOLD:
        mixture.fusion_state = RE_FUSED_BY_BINDING
        mixture.unbinding_force -= REBINDING_AMOUNT
        mixture.binding_force += REBINDING_AMOUNT
        state_v5.base_state.ego.integration_capacity += INTEGRATION_FROM_REBINDING

    RETURN state_v5


################################################################
# 33. PSYCHOSEXUAL DEVELOPMENT, FIXATION, AND REGRESSION
################################################################

PROCEDURE PSYCHOSEXUAL_DEVELOPMENT_UPDATE(state_v5, event, age_phase):

    stage = DETERMINE_ACTIVE_STAGE(age_phase)
    fixation = GET_FIXATION_RECORD(state_v5, stage)

    IF event.type == SATISFACTION:
        fixation.overgratification_level += event.satisfaction_amount
        IF event.satisfaction_amount > TOLERABLE_SATISFACTION_RANGE:
            fixation.fixation_level += OVERGRATIFICATION_FIXATION_INCREMENT
        ELSE:
            fixation.fixation_level -= HEALTHY_SATISFACTION_INTEGRATION

    IF event.type == FRUSTRATION:
        fixation.frustration_level += event.frustration_amount
        IF event.frustration_amount > TOLERABLE_FRUSTRATION_RANGE:
            fixation.fixation_level += FRUSTRATION_FIXATION_INCREMENT
            fixation.regression_pull += FRUSTRATION_REGRESSION_INCREMENT
        ELSE:
            fixation.regression_pull -= TOLERATED_FRUSTRATION_MATURITY_INCREMENT

    IF event.type == AUTHORITY_PROHIBITION:
        IF stage == ANAL:
            fixation.associated_defenses ADD REACTION_FORMATION
            fixation.associated_defenses ADD UNDOING
        IF stage == PHALLIC:
            state_v5.oedipal_configuration.fear_of_punishment += event.authority_intensity
            state_v5.oedipal_configuration.castration_anxiety += PHALLIC_PUNISHMENT_TO_CASTRATION_ANXIETY(event)

    IF event.type == LOSS_OF_OBJECT:
        fixation.regression_pull += event.loss_intensity
        IF stage == ORAL:
            fixation.associated_defenses ADD INTROJECTION
            fixation.symptom_choice_bias ADD MELANCHOLIA

    UPDATE_FIXATION_RECORD(state_v5, fixation)
    RETURN state_v5


PROCEDURE SELECT_REGRESSION_TARGET(state_v5, current_conflict):

    best_stage = null
    best_score = -INFINITY

    FOR EACH fixation IN state_v5.psychosexual_fixations:
        score = fixation.fixation_level + fixation.regression_pull
        score += SIMILARITY(current_conflict, fixation.dominant_conflict)
        score -= state_v5.base_state.ego.integration_capacity

        IF score > best_score:
            best_score = score
            best_stage = fixation

    RETURN best_stage


PROCEDURE APPLY_REGRESSION_IF_EGO_OVERWHELMED(state_v5, conflict):

    IF conflict.total_conflict <= state_v5.base_state.ego.tolerance_for_tension:
        RETURN state_v5

    target_fixation = SELECT_REGRESSION_TARGET(state_v5, conflict)

    IF target_fixation == null:
        RETURN state_v5

    target_fixation.regression_pull += conflict.total_conflict
    state_v5.clinical_pattern_state.dominant_stage_fixation = target_fixation

    IF target_fixation.stage == ORAL:
        state_v5.base_state.pending_defense_biases ADD INTROJECTION
        state_v5.base_state.id.dependency_pressure += ORAL_REGRESSION_DEPENDENCY_INCREMENT

    IF target_fixation.stage == ANAL:
        state_v5.base_state.pending_defense_biases ADD ISOLATION_OF_AFFECT
        state_v5.base_state.pending_defense_biases ADD UNDOING
        state_v5.base_state.superego.rigidity += ANAL_REGRESSION_RIGIDITY_INCREMENT

    IF target_fixation.stage == PHALLIC:
        state_v5.base_state.pending_defense_biases ADD DISPLACEMENT
        state_v5.base_state.pending_defense_biases ADD REPRESSION
        state_v5.oedipal_configuration.unresolved_reactivation_risk += PHALLIC_REGRESSION_REACTIVATION

    RETURN state_v5


################################################################
# 34. COMPLETE OEDIPUS COMPLEX AND SUPEREGO FORMATION
################################################################

PROCEDURE OEDIPAL_CONFIGURATION_UPDATE(state_v5, developmental_event, family_matrix):

    oedipus = state_v5.oedipal_configuration

    oedipus.variant = DETERMINE_OEDIPUS_VARIANT(family_matrix, developmental_event)

    IF oedipus.variant IN [POSITIVE_OEDIPUS, COMPLETE_OEDIPUS]:
        oedipus.love_object_parent = family_matrix.primary_love_object
        oedipus.rival_parent = family_matrix.authority_or_same_sex_rival
        oedipus.love_for_object += developmental_event.libidinal_intensity
        oedipus.hostility_to_rival += developmental_event.rivalry_intensity

    IF oedipus.variant IN [NEGATIVE_OEDIPUS, COMPLETE_OEDIPUS]:
        oedipus.identification_target_1 = family_matrix.opposite_configuration_identification
        oedipus.love_for_object += developmental_event.inverted_love_intensity
        oedipus.hostility_to_rival += developmental_event.inverted_rivalry_intensity

    oedipus.ambivalence_level =
        ABS(oedipus.love_for_object) + ABS(oedipus.hostility_to_rival)

    IF developmental_event.type == AUTHORITY_PROHIBITION:
        oedipus.fear_of_punishment += developmental_event.authority_intensity
        oedipus.castration_anxiety += CALCULATE_CASTRATION_ANXIETY(oedipus, developmental_event)
        oedipus.loss_of_love_anxiety += CALCULATE_LOSS_OF_LOVE_ANXIETY(oedipus, developmental_event)

    IF oedipus.castration_anxiety + oedipus.loss_of_love_anxiety > OEDIPAL_DISSOLUTION_THRESHOLD:
        state_v5 = DISSOLVE_OEDIPUS_AND_FORM_SUPEREGO(state_v5)

    RETURN state_v5


PROCEDURE DISSOLVE_OEDIPUS_AND_FORM_SUPEREGO(state_v5):

    oedipus = state_v5.oedipal_configuration
    superego_record = state_v5.superego_formation_record
    base = state_v5.base_state

    oedipus.renunciation_level += oedipus.love_for_object + oedipus.hostility_to_rival
    oedipus.repression_level += oedipus.renunciation_level
    oedipus.variant = RESOLVED_OEDIPUS IF oedipus.renunciation_level > RESOLUTION_THRESHOLD ELSE REPRESSED_OEDIPUS

    oedipus.father_identification_strength += IDENTIFICATION_FROM_RIVAL_PARENT(oedipus)
    oedipus.mother_identification_strength += IDENTIFICATION_FROM_LOVE_OBJECT(oedipus)

    oedipus.ego_ideal_precipitate_strength +=
        oedipus.father_identification_strength
        + oedipus.mother_identification_strength
        + oedipus.love_for_object

    oedipus.conscience_precipitate_strength +=
        oedipus.fear_of_punishment
        + oedipus.castration_anxiety
        + oedipus.loss_of_love_anxiety
        + oedipus.hostility_to_rival

    superego_record.source_oedipal_configuration = oedipus
    superego_record.parental_imago_strength += oedipus.ego_ideal_precipitate_strength
    superego_record.ego_ideal_content ADD "be like the admired parental imago"
    superego_record.conscience_prohibitions ADD "do not enact the forbidden Oedipal wish"
    superego_record.conscience_prohibitions ADD "do not take the prerogative of the rival authority"
    superego_record.punitive_commands ADD "punish ego when forbidden wish returns"
    superego_record.approval_conditions ADD "gain approval through renunciation, identification, achievement, and repair"
    superego_record.unconscious_guilt_sources ADD "hostility toward loved/rival object"

    superego_record.severity_from_oedipal_repression +=
        oedipus.repression_level + oedipus.fear_of_punishment

    base.superego.conscience_strength += oedipus.conscience_precipitate_strength
    base.superego.ego_ideal_demand += oedipus.ego_ideal_precipitate_strength
    base.superego.internalized_authority_strength += superego_record.parental_imago_strength
    base.superego.severity += superego_record.severity_from_oedipal_repression
    base.superego.guilt_generation += oedipus.hostility_to_rival
    base.superego.shame_generation += oedipus.ideal_gap

    base.ego.repression_load += oedipus.repression_level
    base.ego.self_coherence += IDENTIFICATION_STABILIZATION(oedipus)

    renounced_impulse = CREATE_RENOUNCED_OEDIPAL_IMPULSE(oedipus)
    renounced_impulse.renunciation_due_to_superego = true
    renounced_impulse.forbidden_wish_persists_unconsciously = oedipus.repression_level > LOW
    renounced_impulse.renunciation_supported_by_love_or_sublimation = oedipus.variant == RESOLVED_OEDIPUS
    state_v5 = SUPEREGO_RENUNCIATION_FEEDBACK_LOOP(state_v5, renounced_impulse)
    base = state_v5.base_state

    state_v5.oedipal_configuration = oedipus
    state_v5.superego_formation_record = superego_record
    RETURN state_v5


PROCEDURE LATER_SUPEREGO_MODIFICATION(state_v5, later_authority_event):

    record = state_v5.superego_formation_record
    base = state_v5.base_state

    IF later_authority_event.source IN ["teacher", "educator", "religion", "culture", "law", "ideal model"]:
        record.educator_authority_strength += later_authority_event.intensity IF later_authority_event.source == "teacher" ELSE 0
        record.social_authority_strength += later_authority_event.intensity IF later_authority_event.source IN ["culture", "law"] ELSE 0
        record.religious_or_cultural_authority_strength += later_authority_event.intensity IF later_authority_event.source IN ["religion", "culture"] ELSE 0

        base.superego.social_authority_strength += later_authority_event.intensity
        base.superego.ego_ideal_demand += later_authority_event.idealization_intensity
        base.superego.conscience_strength += later_authority_event.prohibition_intensity

    IF later_authority_event.kind == "humane_correction":
        base.superego.moral_flexibility += later_authority_event.integration_value
        base.superego.rigidity -= later_authority_event.integration_value

    IF later_authority_event.kind == "humiliation_or_cruel_punishment":
        base.superego.severity += later_authority_event.punishment_intensity
        base.superego.sadistic_punishment_force += later_authority_event.punishment_intensity
        base.ego.guilt_tolerance -= later_authority_event.punishment_intensity / 2

    IF later_authority_event.kind == "renunciation_demand":
        renounced_impulse = EXTRACT_RENOUNCED_IMPULSE(later_authority_event)
        state_v5 = SUPEREGO_RENUNCIATION_FEEDBACK_LOOP(state_v5, renounced_impulse)

    IF later_authority_event.source IN ["culture", "law", "religion", "group", "civilization"]:
        cultural_context = EXTRACT_CULTURAL_CONTEXT_FROM_AUTHORITY_EVENT(later_authority_event)
        state_v5 = APPLY_CULTURAL_SUPEREGO_PRESSURE(state_v5, cultural_context)

    RETURN state_v5


################################################################
# 35. DEVELOPMENTAL ANXIETY LADDER
################################################################

PROCEDURE COMPUTE_DEVELOPMENTAL_ANXIETY(state_v5, threat):

    anxieties = EMPTY_MAP

    anxieties[TRAUMATIC_HELPLESSNESS_ANXIETY] =
        MAX(0, threat.excitation_level - state_v5.base_state.ego.binding_capacity)

    anxieties[OBJECT_LOSS_ANXIETY] =
        threat.loss_of_object_probability * state_v5.base_state.id.dependency_pressure

    anxieties[LOSS_OF_LOVE_ANXIETY] =
        threat.loss_of_approval_probability * state_v5.base_state.superego.approval_reward_strength

    anxieties[CASTRATION_ANXIETY] =
        threat.authority_punishment_probability
        * state_v5.oedipal_configuration.castration_anxiety

    anxieties[AUTHORITY_PUNISHMENT_ANXIETY] =
        threat.authority_punishment_probability
        * state_v5.base_state.superego.internalized_authority_strength

    anxieties[SUPEREGO_CONDEMNATION_ANXIETY] =
        state_v5.base_state.superego.conscience_strength
        + state_v5.base_state.superego.guilt_generation
        + state_v5.base_state.superego.sadistic_punishment_force

    state_v5.developmental_anxieties = anxieties
    RETURN anxieties


PROCEDURE MAP_DEVELOPMENTAL_ANXIETY_TO_STRUCTURAL_ANXIETY(state_v5):

    anxieties = state_v5.developmental_anxieties
    conflict = state_v5.base_state.active_conflict_report

    IF anxieties[TRAUMATIC_HELPLESSNESS_ANXIETY] > HIGH:
        conflict.anxiety_type = TRAUMATIC_AUTOMATIC_ANXIETY
        conflict.anxiety_level += anxieties[TRAUMATIC_HELPLESSNESS_ANXIETY]

    IF anxieties[OBJECT_LOSS_ANXIETY] > HIGH OR anxieties[LOSS_OF_LOVE_ANXIETY] > HIGH:
        conflict.anxiety_type = NEUROTIC_ANXIETY
        conflict.anxiety_level += anxieties[OBJECT_LOSS_ANXIETY] + anxieties[LOSS_OF_LOVE_ANXIETY]

    IF anxieties[CASTRATION_ANXIETY] > HIGH OR anxieties[AUTHORITY_PUNISHMENT_ANXIETY] > HIGH:
        conflict.anxiety_type = NEUROTIC_ANXIETY
        conflict.anxiety_level += anxieties[CASTRATION_ANXIETY] + anxieties[AUTHORITY_PUNISHMENT_ANXIETY]

    IF anxieties[SUPEREGO_CONDEMNATION_ANXIETY] > HIGH:
        conflict.anxiety_type = MORAL_ANXIETY
        conflict.anxiety_level += anxieties[SUPEREGO_CONDEMNATION_ANXIETY]

    state_v5.base_state.active_conflict_report = conflict
    RETURN state_v5


################################################################
# 36. PRIMAL REPRESSION, REPRESSION PROPER, DERIVATIVES, RETURN
################################################################

PROCEDURE ESTABLISH_PRIMAL_REPRESSION(state_v5, instinct_representative, affect_quota):

    node = RepressionNode()
    node.id = GENERATE_ID("primal_repression")
    node.content = instinct_representative.content
    node.instinct_representative = instinct_representative.name
    node.affect_quota = affect_quota
    node.ideational_representative = instinct_representative.idea
    node.repression_phase = PRIMAL_REPRESSION
    node.primal_core_id = node.id
    node.distance_from_primal_core = 0
    node.derivative_level = 0
    node.distortion_level = 0
    node.censorship_pass_probability = 0
    node.attraction_from_repressed_core = HIGH
    node.repulsion_from_conscious_system = HIGH
    node.anticathexis_cost = affect_quota
    node.return_channels = []
    node.symptom_links = []
    node.dream_links = []
    node.slip_links = []
    node.transference_links = []

    ADD node TO state_v5.repression_network
    state_v5.base_state.energy.anticathexes[node.id] = node.anticathexis_cost
    state_v5.base_state.ego.repression_load += node.anticathexis_cost
    state_v5.base_state.id.repressed_wish_pressure += affect_quota

    RETURN state_v5


PROCEDURE APPLY_REPRESSION_PROPER(state_v5, thought_or_wish):

    nearest_primal = FIND_NEAREST_PRIMALLY_REPRESSED_CORE(state_v5, thought_or_wish)

    node = RepressionNode()
    node.id = GENERATE_ID("repression_proper")
    node.content = thought_or_wish.content
    node.instinct_representative = thought_or_wish.instinct_source
    node.affect_quota = thought_or_wish.affect_charge
    node.ideational_representative = thought_or_wish.idea
    node.repression_phase = REPRESSION_PROPER
    node.primal_core_id = nearest_primal.id
    node.distance_from_primal_core = CALCULATE_ASSOCIATIVE_DISTANCE(thought_or_wish, nearest_primal)
    node.derivative_level = nearest_primal.derivative_level + 1
    node.distortion_level = BASELINE_DISTORTION
    node.attraction_from_repressed_core = CALCULATE_ATTRACTION_FROM_PRIMAL_CORE(node, nearest_primal)
    node.repulsion_from_conscious_system = CALCULATE_REPULSION_FROM_CONSCIOUS(node, state_v5)
    node.anticathexis_cost = node.affect_quota + node.repulsion_from_conscious_system
    node.censorship_pass_probability = CALCULATE_CENSORSHIP_PASS_BY_DISTANCE_AND_DISTORTION(node)

    ADD node TO state_v5.repression_network
    state_v5.base_state.energy.anticathexes[node.id] = node.anticathexis_cost
    state_v5.base_state.ego.repression_load += node.anticathexis_cost
    state_v5.base_state.id.repressed_wish_pressure += node.affect_quota

    RETURN state_v5


PROCEDURE GENERATE_DERIVATIVES_OF_REPRESSED(state_v5):

    derivatives = []

    FOR EACH node IN state_v5.repression_network:
        IF node.repression_phase IN [PRIMAL_REPRESSION, REPRESSION_PROPER]:
            derivative = COPY(node)
            derivative.id = GENERATE_ID("derivative")
            derivative.content = DISTORT_CONTENT(node.content)
            derivative.derivative_level = node.derivative_level + 1
            derivative.distance_from_primal_core = node.distance_from_primal_core + DERIVATIVE_DISTANCE_INCREMENT
            derivative.distortion_level = node.distortion_level + DERIVATIVE_DISTORTION_INCREMENT
            derivative.censorship_pass_probability = CALCULATE_CENSORSHIP_PASS_BY_DISTANCE_AND_DISTORTION(derivative)
            derivative.repression_phase = AFTER_PRESSURE_REPRESSION

            IF derivative.censorship_pass_probability > PRECONSCIOUS_PASS_THRESHOLD:
                derivative.return_channels ADD "preconscious thought"

            IF derivative.censorship_pass_probability > DREAM_PASS_THRESHOLD:
                derivative.return_channels ADD "dream image"
                derivative.dream_links ADD derivative.id

            IF derivative.censorship_pass_probability > SLIP_PASS_THRESHOLD:
                derivative.return_channels ADD "parapraxis"
                derivative.slip_links ADD derivative.id

            IF derivative.censorship_pass_probability > SYMPTOM_PASS_THRESHOLD:
                derivative.return_channels ADD "symptom compromise"
                derivative.symptom_links ADD derivative.id

            ADD derivative TO derivatives

    FOR EACH derivative IN derivatives:
        ADD derivative TO state_v5.repression_network

    RETURN state_v5


PROCEDURE RETURN_OF_THE_REPRESSED_ROUTING(state_v5):

    FOR EACH node IN state_v5.repression_network:

        IF node.censorship_pass_probability <= LOW:
            CONTINUE

        IF "dream image" IN node.return_channels AND CURRENT_STATE == SLEEP:
            state_v5.active_dream_packet = DREAM_WORK_FROM_REPRESSED_NODE(state_v5, node)
            node.repression_phase = RETURN_OF_REPRESSED

        IF "parapraxis" IN node.return_channels AND CURRENT_STATE == WAKING_SPEECH_OR_ACTION:
            state_v5.active_parapraxis_packet = PARAPRAXIS_FROM_REPRESSED_NODE(state_v5, node)
            node.repression_phase = RETURN_OF_REPRESSED

        IF "symptom compromise" IN node.return_channels AND state_v5.base_state.active_conflict_report.total_conflict > HIGH:
            state_v5.base_state.active_ego_response.output_type = SYMPTOM_OUTPUT
            node.repression_phase = RETURN_OF_REPRESSED

        IF "preconscious thought" IN node.return_channels:
            packet = CREATE_TOPOGRAPHIC_PACKET_FROM_REPRESSION_NODE(node)
            packet.current_region = PRECONSCIOUS
            packet.word_linked = PARTIAL_WORD_LINKING(packet)
            ADD packet TO state_v5.base_state.active_packets

    RETURN state_v5


################################################################
# 37. TWO ROUTES FROM ID INTO EGO
################################################################

PROCEDURE ROUTE_ID_MATERIAL_TO_EGO(state_v5, drive_demand):

    routes = []

    IF drive_demand.forbidden_status == false
       AND drive_demand.danger_status == false:
        ADD ID_TO_EGO_DIRECT TO routes

    IF drive_demand.can_be_idealized == true
       OR drive_demand.can_be_sublimated == true:
        ADD ID_TO_EGO_VIA_EGO_IDEAL TO routes

    IF drive_demand.forbidden_status == true
       OR drive_demand.aggression_component > MEDIUM:
        ADD ID_TO_EGO_VIA_SUPEREGO_GUILT TO routes

    state_v5.structural_routes_active = routes

    FOR EACH route IN routes:

        IF route == ID_TO_EGO_DIRECT:
            packet = CREATE_TOPOGRAPHIC_PACKET_FROM_DEMAND(drive_demand)
            packet.current_region = PRECONSCIOUS_IF_TOLERABLE_ELSE_UNCONSCIOUS(packet, state_v5)
            ADD packet TO state_v5.base_state.active_packets

        IF route == ID_TO_EGO_VIA_EGO_IDEAL:
            idealized_packet = TRANSFORM_DRIVE_INTO_IDEAL_OR_SUBLIMATION(drive_demand, state_v5)
            idealized_packet.source = SUPEREGO
            idealized_packet.current_region = PRECONSCIOUS
            ADD idealized_packet TO state_v5.base_state.active_packets
            state_v5.base_state.superego.approval_reward_strength += IDEALIZATION_REWARD_INCREMENT

        IF route == ID_TO_EGO_VIA_SUPEREGO_GUILT:
            guilt_packet = TRANSFORM_DRIVE_INTO_GUILT_SIGNAL(drive_demand, state_v5)
            guilt_packet.source = SUPEREGO
            IF guilt_packet.affect_charge <= state_v5.base_state.ego.guilt_tolerance:
                guilt_packet.current_region = CONSCIOUS
            ELSE:
                guilt_packet.current_region = PRECONSCIOUS
            ADD guilt_packet TO state_v5.base_state.active_packets
            state_v5.base_state.current_guilt += guilt_packet.affect_charge

    RETURN state_v5


################################################################
# 38. DREAM-WORK AS INTEGRATED SLEEP MODE
################################################################

PROCEDURE SLEEP_MODE_DREAM_LOOP(state_v5):

    IF CURRENT_STATE != SLEEP:
        RETURN state_v5

    dream_packet = DreamWorkPacket()
    dream_packet.day_residue = COLLECT_DAY_RESIDUES(state_v5)
    dream_packet.latent_thoughts = ACTIVATE_LATENT_THOUGHTS(dream_packet.day_residue, state_v5)
    dream_packet.infantile_wish = FIND_INFANTILE_WISH_LINK(state_v5, dream_packet.latent_thoughts)
    dream_packet.forbidden_wish = FIND_FORBIDDEN_WISH(dream_packet.latent_thoughts, state_v5)
    dream_packet.censorship_intensity = CALCULATE_SLEEP_CENSORSHIP(state_v5, dream_packet)

    IF dream_packet.forbidden_wish != null:
        dream_packet = APPLY_DREAM_CENSORSHIP(dream_packet)

    dream_packet.regression_depth = CALCULATE_REGRESSION_TO_PERCEPTION(dream_packet, state_v5)
    dream_packet = DREAM_TRANSFORM_THOUGHTS_TO_IMAGES(dream_packet)
    dream_packet = DREAM_APPLY_CONDENSATION(dream_packet)
    dream_packet = DREAM_APPLY_DISPLACEMENT(dream_packet)
    dream_packet = DREAM_APPLY_SYMBOLIZATION(dream_packet)
    dream_packet = DREAM_TRANSFORM_AFFECT(dream_packet)
    dream_packet = DREAM_APPLY_SECONDARY_REVISION(dream_packet)

    dream_packet.manifest_content = BUILD_MANIFEST_DREAM(dream_packet)
    dream_packet.remembered_fragment = FILTER_DREAM_RECALL_BY_WAKING_CENSORSHIP(dream_packet)

    state_v5.active_dream_packet = dream_packet
    RETURN state_v5


PROCEDURE DREAM_APPLY_CONDENSATION(dream_packet):

    FOR EACH thought_group IN FIND_OVERLAPPING_LATENT_THOUGHTS(dream_packet.latent_thoughts):
        condensed_image = MERGE_MULTIPLE_THOUGHTS_INTO_SINGLE_IMAGE(thought_group)
        dream_packet.condensation_map[condensed_image] = thought_group

    RETURN dream_packet


PROCEDURE DREAM_APPLY_DISPLACEMENT(dream_packet):

    FOR EACH important_thought IN dream_packet.latent_thoughts:
        IF important_thought.affect_charge > CENSORSHIP_RISK_THRESHOLD:
            indifferent_substitute = FIND_MINOR_ASSOCIATED_DETAIL(important_thought)
            dream_packet.displacement_map[indifferent_substitute] = important_thought
            MOVE_AFFECT(important_thought, indifferent_substitute)

    RETURN dream_packet


PROCEDURE DREAM_APPLY_SYMBOLIZATION(dream_packet):

    FOR EACH latent_element IN dream_packet.latent_thoughts:
        IF latent_element.abstract_or_forbidden == true:
            symbol = SELECT_DREAM_SYMBOL(latent_element)
            ADD symbol TO dream_packet.symbols

    RETURN dream_packet


PROCEDURE DREAM_APPLY_SECONDARY_REVISION(dream_packet):

    dream_packet.secondary_revision_story =
        MAKE_DREAM_APPEAR_MORE_COHERENT_TO_WAKING_EGO(
            dream_packet.condensation_map,
            dream_packet.displacement_map,
            dream_packet.symbols
        )

    RETURN dream_packet


PROCEDURE INTERPRET_DREAM_BACKWARD(state_v5, dream_packet):

    interpretation = []

    FOR EACH manifest_element IN PARSE_MANIFEST_DREAM(dream_packet.manifest_content):
        associations = FREE_ASSOCIATE_FROM_ELEMENT(manifest_element)
        latent_sources = TRACE_TO_LATENT_THOUGHTS(associations, dream_packet)
        repressed_sources = TRACE_TO_REPRESSION_NETWORK(latent_sources, state_v5.repression_network)
        infantile_sources = TRACE_TO_INFANTILE_WISH(latent_sources, state_v5.psychosexual_fixations)

        ADD {
            manifest_element: manifest_element,
            associations: associations,
            latent_sources: latent_sources,
            repressed_sources: repressed_sources,
            infantile_sources: infantile_sources
        } TO interpretation

    dream_packet.interpretation_path = interpretation
    RETURN dream_packet


################################################################
# 39. PARAPRAXES, SLIPS, FORGETTING, JOKES, EVERYDAY COMPROMISE
################################################################

PROCEDURE GENERATE_PARAPRAXIS_OR_EVERYDAY_FORMATION(state_v5, intended_act):

    counter_intention = FIND_UNCONSCIOUS_COUNTER_INTENTION(state_v5, intended_act)

    IF counter_intention == null:
        RETURN null

    IF counter_intention.affect_charge < EVERYDAY_INTERFERENCE_THRESHOLD:
        RETURN null

    packet = ParapraxisPacket()
    packet.intended_action_or_phrase = intended_act.description
    packet.unconscious_counter_intention = counter_intention.content
    packet.repressed_motive = counter_intention.instinct_source
    packet.interference_point = SELECT_INTERFERENCE_POINT(intended_act)

    IF intended_act.mode == "speech":
        packet.everyday_output_type = SLIP_OF_TONGUE
        packet.distortion_method = DISPLACEMENT
        packet.manifest_error = SUBSTITUTE_WORD_BY_ASSOCIATIVE_NEARNESS(intended_act, counter_intention)

    IF intended_act.mode == "writing":
        packet.everyday_output_type = SLIP_OF_PEN
        packet.distortion_method = CONDENSATION
        packet.manifest_error = INSERT_HIDDEN_WORD_FRAGMENT(intended_act, counter_intention)

    IF intended_act.mode == "memory_recall":
        packet.everyday_output_type = FORGETTING_NAME
        packet.distortion_method = REPRESSION
        packet.manifest_error = BLOCK_RECALL_AND_CREATE_SUBSTITUTE_NAMES(intended_act, counter_intention)

    IF intended_act.mode == "practical_action":
        packet.everyday_output_type = BUNGLED_ACTION
        packet.distortion_method = COMPROMISE_FORMATION
        packet.manifest_error = MISPERFORM_ACTION_TO_SATISFY_COUNTER_INTENTION(intended_act, counter_intention)

    packet.hidden_meaning = TRACE_PARAPRAXIS_MEANING(packet, state_v5)
    packet.conscious_rationalization = BUILD_RATIONALIZATION(packet.manifest_error)
    packet.anxiety_or_guilt_relieved = CALCULATE_RELIEF_FROM_PARAPRAXIS(packet)

    state_v5.active_parapraxis_packet = packet
    RETURN packet


PROCEDURE GENERATE_JOKE_OR_WIT_FORMATION(state_v5, forbidden_thought, social_context):

    IF forbidden_thought.censorship_pressure <= LOW:
        RETURN DIRECT_STATEMENT(forbidden_thought)

    IF social_context.permits_playful_disguise == false:
        RETURN null

    joke = ParapraxisPacket()
    joke.everyday_output_type = JOKE_FORMATION
    joke.intended_action_or_phrase = "produce socially tolerable expression"
    joke.unconscious_counter_intention = forbidden_thought.content
    joke.repressed_motive = forbidden_thought.instinct_source
    joke.distortion_method = SELECT_FROM([CONDENSATION, DISPLACEMENT, SYMBOLIZATION])
    joke.manifest_error = BUILD_JOKE_TECHNIQUE(forbidden_thought, joke.distortion_method)
    joke.hidden_meaning = forbidden_thought.content
    joke.conscious_rationalization = "It is only a joke."
    joke.anxiety_or_guilt_relieved = RELEASE_FORBIDDEN_AFFECT_THROUGH_LAUGHTER(joke)

    RETURN joke


################################################################
# 40. CLINICAL FORMATION MECHANISMS
################################################################

PROCEDURE CLASSIFY_CLINICAL_PATTERN_V5(state_v5):

    base = state_v5.base_state
    conflict = base.active_conflict_report
    response = base.active_ego_response
    fixation = state_v5.clinical_pattern_state.dominant_stage_fixation
    repression = state_v5.clinical_pattern_state.dominant_repression_node
    oedipus = state_v5.oedipal_configuration
    mixture = state_v5.instinct_mixture

    IF response.output_type == SYMPTOM_OUTPUT
       AND SOMATIC_CONVERSION IN response.selected_defenses:
        RETURN HYSTERICAL_CONVERSION

    IF response.output_type == SYMPTOM_OUTPUT
       AND response.symptom_plan CONTAINS "attack"
       AND base.id.repetition_pressure > HIGH:
        RETURN HYSTERICAL_ATTACK

    IF DISPLACEMENT IN response.selected_defenses
       AND conflict.anxiety_type == NEUROTIC_ANXIETY
       AND INTERNAL_DANGER_RELOCATED_TO_EXTERNAL_OBJECT(state_v5):
        RETURN PHOBIC_DISPLACEMENT

    IF ISOLATION_OF_AFFECT IN response.selected_defenses
       AND UNDOING IN response.selected_defenses
       AND REACTION_FORMATION IN response.selected_defenses:
        RETURN OBSESSIONAL_NEUROSIS

    IF LOST_OBJECT_INTROJECTED_INTO_EGO(state_v5)
       AND base.superego.sadistic_punishment_force > HIGH
       AND base.current_guilt > HIGH:
        RETURN MELANCHOLIA

    IF REALITY_TESTING_ACCEPTS_LOSS(state_v5)
       AND LIBIDO_WITHDRAWAL_FROM_OBJECT_IS_GRADUAL(state_v5)
       AND base.ego.self_coherence >= MEDIUM:
        RETURN MOURNING

    IF PROJECTION IN response.selected_defenses
       AND UNACCEPTABLE_WISH_RETURNED_AS_EXTERNAL_PERSECUTION(state_v5):
        RETURN PARANOIA

    IF response.output_type == WITHDRAWAL_FROM_REALITY:
        RETURN PSYCHOSIS_WITHDRAWAL

    IF response.output_type == REALITY_RECONSTRUCTION:
        RETURN PSYCHOSIS_RECONSTRUCTION

    IF mixture.destructive_inward_level > HIGH
       AND response.output_type == SELF_PUNISHMENT:
        RETURN MORAL_MASOCHISM

    IF fixation != null AND fixation.stage != GENITAL:
        RETURN CHARACTER_FORMATION

    RETURN ORDINARY_CONFLICT


PROCEDURE HANDLE_HYSTERICAL_CONVERSION(state_v5):

    hidden_conflict = FIND_REPRESSED_AFFECT_IDEA_PAIR(state_v5)
    body_pathway = SELECT_SOMATIC_SYMBOLIC_PATHWAY(hidden_conflict)

    response = EgoResponse()
    response.output_type = SYMPTOM_OUTPUT
    response.selected_defenses = [REPRESSION, SYMBOLIZATION, SOMATIC_CONVERSION, COMPROMISE_FORMATION]
    response.symptom_plan =
        "Convert unaccepted affect/idea into bodily innervation or functional disturbance."
    response.conscious_explanation =
        "The bodily symptom is experienced as involuntary and not as a wish."
    response.unconscious_motive = hidden_conflict.content
    response.expected_id_discharge = PARTIAL_AND_DISGUISED
    response.expected_superego_relief = PARTIAL_THROUGH_NOT_KNOWING
    response.energy_cost = HIGH
    response.repetition_risk = HIGH

    state_v5.base_state.active_ego_response = response
    ADD body_pathway TO state_v5.clinical_pattern_state.symptom_choice
    RETURN state_v5


PROCEDURE HANDLE_PHOBIC_DISPLACEMENT(state_v5):

    internal_danger = FIND_INTERNAL_FORBIDDEN_WISH_OR_ANXIETY(state_v5)
    external_object = SELECT_EXTERNAL_OBJECT_BY_ASSOCIATION(internal_danger)

    response = EgoResponse()
    response.output_type = AVOIDANCE_OUTPUT
    response.selected_defenses = [REPRESSION, DISPLACEMENT, PROJECTION, AVOIDANCE]
    response.action_plan = "Avoid the external object so that internal danger can be managed as external danger."
    response.conscious_explanation = "That object or situation is dangerous."
    response.unconscious_motive = internal_danger.content
    response.expected_id_discharge = LOW
    response.expected_superego_relief = MEDIUM_TEMPORARY
    response.expected_reality_success = VARIABLE
    response.repetition_risk = HIGH

    state_v5.base_state.active_ego_response = response
    state_v5.clinical_pattern_state.active_pattern = PHOBIC_DISPLACEMENT
    RETURN state_v5


PROCEDURE HANDLE_OBSESSIONAL_NEUROSIS(state_v5):

    ambivalent_wish = FIND_LOVE_HATE_AMBIVALENCE(state_v5)

    response = EgoResponse()
    response.output_type = COMPULSIVE_ACTION
    response.selected_defenses = [ISOLATION_OF_AFFECT, UNDOING, REACTION_FORMATION, RATIONALIZATION, COMPULSIVE_REPETITION]
    response.action_plan =
        "Separate thought from affect, undo the forbidden impulse, perform ritualized control, and replace hostile/sexual wish with opposite moral form."
    response.conscious_explanation =
        "This must be done correctly; otherwise something bad may happen."
    response.unconscious_motive = ambivalent_wish.content
    response.expected_id_discharge = LOW_TEMPORARY
    response.expected_superego_relief = LOW_TEMPORARY
    response.energy_cost = VERY_HIGH
    response.repetition_risk = VERY_HIGH

    state_v5.base_state.superego.rigidity += OBSESSIONAL_RIGIDITY_INCREMENT
    state_v5.base_state.active_ego_response = response
    state_v5.clinical_pattern_state.active_pattern = OBSESSIONAL_NEUROSIS
    RETURN state_v5


PROCEDURE HANDLE_MOURNING(state_v5, lost_object):

    object_event = CREATE_OBJECT_EVENT(kind = "object_lost", object_id = lost_object.id)
    state_v5 = UPDATE_LIBIDO_DISTRIBUTION(state_v5, [object_event], WAKING)

    FOR EACH memory IN MEMORIES_LINKED_TO_OBJECT(state_v5.base_state.memories, lost_object):
        memory.cathexis_level += HYPERCATHEXIS_FOR_REALITY_TESTING
        memory.affect_charge += GRIEF_AFFECT
        memory.linked_to_reality_context = true
        memory.linked_to_time = true
        memory.integrated = GRADUALLY_TRUE
        memory.cathexis_level -= GRADUAL_LIBIDO_DETACHMENT

    state_v5.base_state.ego.self_coherence -= TEMPORARY_MOURNING_INHIBITION
    state_v5.base_state.ego.self_coherence += RESTORATION_AFTER_WORK_OF_MOURNING
    state_v5.clinical_pattern_state.active_pattern = MOURNING

    RETURN state_v5


PROCEDURE HANDLE_MELANCHOLIA(state_v5, lost_or_disappointed_object):

    object_event = CREATE_OBJECT_EVENT(
        kind = "object_ambivalently_lost",
        object_id = lost_or_disappointed_object.id,
        hostility_level = HATE_TOWARD_OBJECT_TURNED_AGAINST_EGO
    )
    state_v5 = UPDATE_LIBIDO_DISTRIBUTION(state_v5, [object_event], WAKING)

    introjection = CREATE_IDENTIFICATION_WITH_LOST_OBJECT(lost_or_disappointed_object)
    INSTALL_IDENTIFICATION_IN_EGO(state_v5.base_state, introjection)

    state_v5.clinical_pattern_state.object_relation_status = "object lost outside, reinstalled inside ego"
    state_v5.clinical_pattern_state.superego_attack_level += HIGH

    state_v5.base_state.superego.sadistic_punishment_force += HATE_TOWARD_OBJECT_TURNED_AGAINST_EGO
    state_v5.base_state.current_guilt += UNCONSCIOUS_GUILT_FROM_AMBIVALENCE
    state_v5.base_state.current_shame += EGO_IMPOVERISHMENT_SIGNAL
    state_v5.base_state.ego.self_coherence -= MELANCHOLIC_EGO_IMPOVERISHMENT

    response = EgoResponse()
    response.output_type = SELF_PUNISHMENT
    response.selected_defenses = [INTROJECTION, IDENTIFICATION, TURNING_AGAINST_SELF]
    response.self_punishment_plan =
        "Superego attacks the ego as though the ego were the lost/disappointing object."
    response.conscious_explanation =
        "I am worthless, guilty, bad, and deserving of punishment."
    response.unconscious_motive =
        "Ambivalent hostility toward the object is redirected against the ego after identification with the lost object."
    response.expected_superego_relief = PARTIAL_THROUGH_SELF_ATTACK
    response.energy_cost = VERY_HIGH
    response.repetition_risk = VERY_HIGH

    state_v5.base_state.active_ego_response = response
    state_v5.clinical_pattern_state.active_pattern = MELANCHOLIA
    RETURN state_v5


PROCEDURE HANDLE_PARANOIA(state_v5):

    unacceptable_wish = FIND_UNACCEPTABLE_OBJECT_WISH(state_v5)
    reversed_wish = REVERSE_AFFECT_OR_POSITION(unacceptable_wish)
    projected_agent = PROJECT_TO_EXTERNAL_OBJECT(reversed_wish)

    response = EgoResponse()
    response.output_type = REALITY_RECONSTRUCTION
    response.selected_defenses = [PROJECTION, DENIAL, DISAVOWAL, REALITY_RECONSTRUCTION]
    response.reality_reconstruction_plan =
        "Externalize unacceptable wish as persecution, accusation, betrayal, or special reference from outside."
    response.conscious_explanation =
        "The danger comes from them, not from my own wish."
    response.unconscious_motive = unacceptable_wish.content
    response.expected_id_discharge = DISGUISED
    response.expected_superego_relief = PARTIAL_BY_EXTERNALIZING_GUILT
    response.repetition_risk = HIGH

    state_v5.base_state.active_ego_response = response
    state_v5.clinical_pattern_state.active_pattern = PARANOIA
    RETURN state_v5


PROCEDURE HANDLE_PSYCHOSIS_WITH_REALITY_RECONSTRUCTION(state_v5):

    intolerable_reality = FIND_INTOLERABLE_REALITY_DEMAND(state_v5)
    wish = FIND_DOMINANT_WISH_OPPOSED_TO_REALITY(state_v5)

    IF state_v5.base_state.ego.reality_testing_capacity > MIN_REALITY_TESTING:
        response_type = WITHDRAWAL_FROM_REALITY
    ELSE:
        response_type = REALITY_RECONSTRUCTION

    response = EgoResponse()
    response.output_type = response_type
    response.selected_defenses = [DENIAL, DISAVOWAL, FANTASY_WITHDRAWAL, REALITY_RECONSTRUCTION]
    response.reality_reconstruction_plan =
        "Withdraw cathexis from intolerable reality and build a substitute reality more compatible with wish."
    response.conscious_explanation =
        "Reality is not as others say; the substitute construction has priority."
    response.unconscious_motive = wish.content
    response.expected_id_discharge = HIGH_IN_SUBSTITUTE_REALITY
    response.expected_reality_success = LOW_IN_SHARED_REALITY
    response.energy_cost = VERY_HIGH

    state_v5.base_state.active_ego_response = response
    state_v5.clinical_pattern_state.active_pattern =
        PSYCHOSIS_RECONSTRUCTION IF response_type == REALITY_RECONSTRUCTION ELSE PSYCHOSIS_WITHDRAWAL

    RETURN state_v5


PROCEDURE HANDLE_MORAL_MASOCHISM(state_v5):

    response = EgoResponse()
    response.output_type = SELF_PUNISHMENT
    response.selected_defenses = [TURNING_AGAINST_SELF, UNDOING, INHIBITION, COMPROMISE_FORMATION]
    response.self_punishment_plan =
        "Obtain unconscious satisfaction by being punished, failing, suffering, or remaining inhibited."
    response.conscious_explanation =
        "I deserve punishment, failure, burden, or deprivation."
    response.unconscious_motive =
        "Appease sadistic superego and satisfy unconscious punishment need."
    response.expected_superego_relief = MEDIUM_TEMPORARY
    response.expected_id_discharge = MASOCHISTIC_SATISFACTION
    response.energy_cost = HIGH
    response.repetition_risk = VERY_HIGH

    state_v5.base_state.active_ego_response = response
    state_v5.clinical_pattern_state.active_pattern = MORAL_MASOCHISM
    RETURN state_v5


################################################################
# 41. RESISTANCE, TRANSFERENCE, REMEMBERING, REPEATING, WORKING-THROUGH
################################################################

PROCEDURE ANALYTIC_SESSION_LOOP(state_v5, analytic_input):

    field = state_v5.analytic_field

    association_stream = RECEIVE_FREE_ASSOCIATION(analytic_input)
    field.resistance_type = DETECT_RESISTANCE(state_v5, association_stream)
    field.transference_type = DETECT_TRANSFERENCE(state_v5, analytic_input)
    field.repetition_in_session = DETECT_REPETITION_IN_TRANSFERENCE(state_v5, analytic_input)

    IF field.resistance_type != NONE:
        state_v5 = HANDLE_RESISTANCE(state_v5, field.resistance_type)

    IF field.transference_type != NONE:
        state_v5 = HANDLE_TRANSFERENCE(state_v5, field.transference_type)

    IF field.repetition_in_session != null:
        state_v5 = TRANSFORM_REPETITION_INTO_REMEMBERING(state_v5, field.repetition_in_session)

    IF field.interpretation_readiness > INTERPRETATION_THRESHOLD:
        interpretation = BUILD_INTERPRETATION(state_v5, association_stream, field)
        state_v5 = APPLY_INTERPRETATION(state_v5, interpretation)

    state_v5 = WORK_THROUGH_RESISTANCE_ITERATIVELY(state_v5)
    RETURN state_v5


PROCEDURE DETECT_RESISTANCE(state_v5, association_stream):

    IF association_stream.suddenly_stops OR association_stream.becomes_empty:
        RETURN SILENCE_RESISTANCE

    IF association_stream.becomes_overly_logical_and_detached:
        RETURN INTELLECTUALIZATION_RESISTANCE

    IF association_stream.repeats_current_actions_instead_of_memories:
        RETURN ACTING_OUT_RESISTANCE

    IF state_v5.base_state.ego.repression_load > HIGH
       AND association_stream.approaches_repressed_node:
        RETURN EGO_RESISTANCE_REPRESSION

    IF state_v5.analytic_field.transference_neurosis_intensity > HIGH:
        RETURN EGO_RESISTANCE_TRANSFERENCE

    IF state_v5.clinical_pattern_state.secondary_gain > HIGH:
        RETURN EGO_RESISTANCE_GAIN_FROM_ILLNESS

    IF state_v5.instinct_mixture.repetition_compulsion_force > HIGH:
        RETURN ID_RESISTANCE_REPETITION_COMPULSION

    IF state_v5.base_state.superego.unconscious_punishment_need > HIGH:
        RETURN SUPEREGO_RESISTANCE_GUILT_AND_PUNISHMENT

    RETURN NONE


PROCEDURE DETECT_TRANSFERENCE(state_v5, analytic_input):

    IF analytic_input.affect_toward_analyst resembles childhood_love_object:
        RETURN POSITIVE_TRANSFERENCE_AFFECTIONATE

    IF analytic_input.eroticized_attachment_to_analyst > THRESHOLD:
        RETURN POSITIVE_TRANSFERENCE_EROTICIZED

    IF analytic_input.hostility_or_suspicion_toward_analyst > THRESHOLD:
        RETURN NEGATIVE_TRANSFERENCE_HOSTILE

    IF analytic_input.treats_analyst_as_parental_authority:
        RETURN PARENTAL_TRANSFERENCE

    IF analytic_input.treats_analyst_as_judge_or_conscience:
        RETURN SUPEREGO_TRANSFERENCE

    IF analytic_input.repeats_old_scene_with_analyst:
        RETURN REPETITION_TRANSFERENCE

    RETURN NONE


PROCEDURE HANDLE_RESISTANCE(state_v5, resistance_type):

    field = state_v5.analytic_field

    IF resistance_type == EGO_RESISTANCE_REPRESSION:
        field.avoided_memory = FIND_MEMORY_NEAR_CURRENT_ASSOCIATION(state_v5)
        field.interpretation_readiness += SMALL_INCREMENT
        state_v5.base_state.current_anxiety += RESISTANCE_ANXIETY_SIGNAL

    IF resistance_type == EGO_RESISTANCE_TRANSFERENCE:
        field.transference_neurosis_intensity += TRANSFERENCE_RESISTANCE_INCREMENT
        field.interpretation_readiness += MEDIUM_INCREMENT_IF_STABLE_ALLIANCE(field)

    IF resistance_type == EGO_RESISTANCE_GAIN_FROM_ILLNESS:
        state_v5.clinical_pattern_state.secondary_gain += SECONDARY_GAIN_VISIBILITY
        field.interpretation_readiness += SECONDARY_GAIN_WORK_INCREMENT

    IF resistance_type == ID_RESISTANCE_REPETITION_COMPULSION:
        state_v5.base_state.id.repetition_pressure += REPETITION_RESISTANCE_INCREMENT
        field.repetition_in_session = FIND_ACTED_REPETITION(state_v5)

    IF resistance_type == SUPEREGO_RESISTANCE_GUILT_AND_PUNISHMENT:
        field.negative_therapeutic_reaction_risk += HIGH
        state_v5.base_state.current_guilt += SUPEREGO_RESISTANCE_GUILT_INCREMENT

    RETURN state_v5


PROCEDURE HANDLE_TRANSFERENCE(state_v5, transference_type):

    field = state_v5.analytic_field

    IF transference_type == POSITIVE_TRANSFERENCE_AFFECTIONATE:
        field.alliance_strength += ALLIANCE_INCREMENT
        field.transference_neurosis_intensity += LOW

    IF transference_type == POSITIVE_TRANSFERENCE_EROTICIZED:
        field.transference_neurosis_intensity += HIGH
        field.resistance_type = EGO_RESISTANCE_TRANSFERENCE

    IF transference_type == NEGATIVE_TRANSFERENCE_HOSTILE:
        field.transference_neurosis_intensity += HIGH
        field.resistance_type = EGO_RESISTANCE_TRANSFERENCE
        state_v5.instinct_mixture.destructive_outward_level += HOSTILE_TRANSFERENCE_AGGRESSION

    IF transference_type == PARENTAL_TRANSFERENCE:
        state_v5.oedipal_configuration.unresolved_reactivation_risk += TRANSFERENCE_REACTIVATES_OEDIPUS
        field.interpretation_readiness += PARENTAL_TRANSFERENCE_INTERPRETABILITY

    IF transference_type == SUPEREGO_TRANSFERENCE:
        state_v5.base_state.superego.severity += PROJECTED_JUDGE_INTENSITY
        field.interpretation_readiness += SUPEREGO_TRANSFERENCE_INTERPRETABILITY

    IF transference_type == REPETITION_TRANSFERENCE:
        field.repetition_in_session = RECONSTRUCT_REPEATED_SCENE(state_v5)
        field.interpretation_readiness += REPETITION_INTERPRETABILITY

    state_v5.analytic_field = field
    RETURN state_v5


PROCEDURE TRANSFORM_REPETITION_INTO_REMEMBERING(state_v5, repetition_scene):

    memory = TRACE_REPETITION_TO_MEMORY(state_v5, repetition_scene)

    IF memory == null:
        RETURN state_v5

    memory.accessible_to_ego = PARTIAL
    memory.current_region = PRECONSCIOUS
    memory.linked_to_words = TRY_WORD_LINKING(state_v5.base_state, memory)
    memory.linked_to_time = true
    memory.linked_to_reality_context = true
    memory.affect_charge -= ABREACTION_OR_ASSOCIATION_RELIEF
    memory.repetition_pressure -= REMEMBERING_REDUCES_REPETITION

    state_v5.base_state.ego.integration_capacity += REMEMBERING_INTEGRATION_INCREMENT
    state_v5.base_state.ego.self_coherence += MEMORY_INTEGRATION_SELF_COHERENCE_INCREMENT

    UPDATE_MEMORY_TRACE(state_v5.base_state, memory)
    RETURN state_v5


PROCEDURE WORK_THROUGH_RESISTANCE_ITERATIVELY(state_v5):

    field = state_v5.analytic_field

    WHILE field.working_through_iterations < MAX_WORKING_THROUGH_ITERATIONS_PER_PHASE:

        IF field.resistance_type == NONE:
            BREAK

        resistance_source = TRACE_RESISTANCE_TO_SOURCE(state_v5, field.resistance_type)
        interpretation = BUILD_RESISTANCE_INTERPRETATION(resistance_source, field)

        IF field.interpretation_readiness < INTERPRETATION_THRESHOLD:
            field.working_through_iterations += 1
            CONTINUE

        state_v5 = APPLY_INTERPRETATION(state_v5, interpretation)
        state_v5 = LINK_AFFECT_MEMORY_WORDS_AND_REALITY(state_v5, resistance_source)
        state_v5 = REDUCE_REPRESSION_AND_REPETITION(state_v5, resistance_source)

        IF RESISTANCE_REDUCED(resistance_source):
            field.resistance_type = NONE
            BREAK

        field.working_through_iterations += 1

    state_v5.analytic_field = field
    RETURN state_v5


PROCEDURE HANDLE_NEGATIVE_THERAPEUTIC_REACTION(state_v5):

    IF state_v5.analytic_field.negative_therapeutic_reaction_risk <= THRESHOLD:
        RETURN state_v5

    # Improvement itself can activate unconscious guilt and the need for punishment.
    state_v5.base_state.superego.unconscious_punishment_need += IMPROVEMENT_TRIGGERED_GUILT
    state_v5.base_state.current_guilt += IMPROVEMENT_TRIGGERED_GUILT
    state_v5.base_state.active_ego_response.output_type = SELF_PUNISHMENT
    state_v5.base_state.active_ego_response.selected_defenses ADD TURNING_AGAINST_SELF
    state_v5.base_state.active_ego_response.selected_defenses ADD INHIBITION

    state_v5 = HANDLE_RESISTANCE(state_v5, SUPEREGO_RESISTANCE_GUILT_AND_PUNISHMENT)
    RETURN state_v5


################################################################
# 42. COMPLETE MAIN OPERATING LOOP V6
################################################################

PROCEDURE COMPLETE_MAIN_OPERATING_LOOP_V6(state_v5):

    WHILE subject_is_alive:

        ################################################################
        # 42.1 Perception, body-ego boundary, and internal pressure
        ################################################################

        external_input = PERCEIVE_EXTERNAL_REALITY()
        internal_stimuli = DETECT_INTERNAL_STIMULI(state_v5.base_state)
        state_v5 = UPDATE_BODY_EGO_BOUNDARY(state_v5, internal_stimuli, external_input)
        state_v5 = INTEGRATE_BODILY_EGO_IN_MAIN_LOOP(state_v5, internal_stimuli, external_input)
        reactivated_memories = DETECT_MEMORY_REACTIVATION(state_v5.base_state, external_input, internal_stimuli)

        object_events = EXTRACT_OBJECT_EVENTS(external_input, internal_stimuli, reactivated_memories)
        state_v5 = UPDATE_LIBIDO_DISTRIBUTION(state_v5, object_events, CURRENT_STATE)

        cultural_context = EXTRACT_CULTURAL_CONTEXT(external_input)
        state_v5 = APPLY_CULTURAL_SUPEREGO_PRESSURE(state_v5, cultural_context)

        ################################################################
        # 42.2 Developmental residues and instinct mixture
        ################################################################

        current_conflict = SAFE_CURRENT_CONFLICT_FOR_INSTINCT_UPDATE(state_v5)
        state_v5 = UPDATE_INSTINCT_MIXTURE(state_v5, internal_stimuli, current_conflict)
        state_v5 = HANDLE_INSTINCT_DEFUSION(state_v5)

        IF DEVELOPMENTAL_EVENT_PRESENT(external_input, internal_stimuli):
            event = EXTRACT_DEVELOPMENTAL_EVENT(external_input, internal_stimuli)
            state_v5 = PSYCHOSEXUAL_DEVELOPMENT_UPDATE(state_v5, event, CURRENT_AGE_PHASE)
            state_v5 = OEDIPAL_CONFIGURATION_UPDATE(state_v5, event, CURRENT_FAMILY_OR_AUTHORITY_MATRIX)
            state_v5 = LATER_SUPEREGO_MODIFICATION(state_v5, event)
            IF event.type == RENUNCIATION:
                state_v5 = SUPEREGO_RENUNCIATION_FEEDBACK_LOOP(state_v5, EXTRACT_RENOUNCED_IMPULSE(event))

        ################################################################
        # 42.3 Id demand generation and structural route capture
        ################################################################

        state_v5.base_state.active_packets = []
        state_v5.base_state.active_drive_demands =
            ID_GENERATE_DRIVE_DEMANDS(state_v5.base_state, internal_stimuli, reactivated_memories)

        FOR EACH demand IN state_v5.base_state.active_drive_demands:
            state_v5 = ROUTE_ID_MATERIAL_TO_EGO(state_v5, demand)

        primary_packets =
            ID_PRIMARY_PROCESS_TRANSFORMATION(state_v5.base_state, state_v5.base_state.active_drive_demands)

        all_packets = MERGE(primary_packets, state_v5.base_state.active_packets)

        ################################################################
        # 42.4 Repression and return of repressed
        ################################################################

        FOR EACH packet IN all_packets:
            IF PACKET_REQUIRES_PRIMAL_REPRESSION(packet, state_v5):
                state_v5 = ESTABLISH_PRIMAL_REPRESSION(state_v5, packet, packet.affect_charge)
            ELSE IF PACKET_REQUIRES_REPRESSION_PROPER(packet, state_v5):
                state_v5 = APPLY_REPRESSION_PROPER(state_v5, packet)

        state_v5 = GENERATE_DERIVATIVES_OF_REPRESSED(state_v5)
        state_v5 = RETURN_OF_THE_REPRESSED_ROUTING(state_v5)
        all_packets = MERGE(all_packets, state_v5.base_state.active_packets)

        ################################################################
        # 42.5 Dream branch if sleeping
        ################################################################

        IF CURRENT_STATE == SLEEP:
            state_v5 = SLEEP_MODE_DREAM_LOOP(state_v5)
            state_v5.base_state = MEMORY_REPRESSION_REPETITION_UPDATE(
                state_v5.base_state,
                DREAM_OUTPUT_RESULT(state_v5.active_dream_packet)
            )
            CONTINUE

        ################################################################
        # 42.6 Waking topographic routing, representation linking, and ego synthesis
        ################################################################

        routed_packets = TOPOGRAPHIC_ROUTING_AND_CENSORSHIP(state_v5.base_state, all_packets)
        ego_material = EGO_RECEIVE_AND_TRANSLATE(state_v5.base_state, routed_packets)
        ego_material = LINK_EGO_MATERIAL_THROUGH_WORD_PRESENTATIONS(state_v5, ego_material)

        ################################################################
        # 42.7 Reality, cultural, and superego pressures
        ################################################################

        state_v5.base_state.active_reality_report =
            EGO_REALITY_TESTING(state_v5.base_state, ego_material, external_input)

        cultural_context = UPDATE_CULTURAL_CONTEXT_FROM_REALITY_REPORT(
            cultural_context,
            state_v5.base_state.active_reality_report
        )
        state_v5 = APPLY_CULTURAL_SUPEREGO_PRESSURE(state_v5, cultural_context)

        state_v5.base_state.active_superego_judgment =
            SUPEREGO_EVALUATION(state_v5.base_state, ego_material, state_v5.base_state.active_reality_report)

        state_v5 = PLEASURE_REALITY_PRINCIPLE_ARBITRATION(
            state_v5,
            ego_material,
            state_v5.base_state.active_reality_report,
            state_v5.base_state.active_superego_judgment
        )

        state_v5 = HANDLE_NEGATION_AND_JUDGMENT(
            state_v5,
            ego_material,
            state_v5.base_state.active_reality_report,
            state_v5.base_state.active_superego_judgment
        )

        state_v5 = HANDLE_EGO_SPLIT_AS_PARALLEL_ATTITUDES(
            state_v5,
            ego_material,
            state_v5.base_state.active_reality_report,
            state_v5.base_state.active_superego_judgment
        )

        threat = BUILD_THREAT_PROFILE(external_input, ego_material, state_v5.base_state.active_superego_judgment)
        developmental_anxieties = COMPUTE_DEVELOPMENTAL_ANXIETY(state_v5, threat)

        ################################################################
        # 42.8 Conflict and anxiety signal
        ################################################################

        state_v5.base_state.active_conflict_report =
            EGO_COMPUTE_CONFLICT(
                state_v5.base_state,
                ego_material,
                state_v5.base_state.active_reality_report,
                state_v5.base_state.active_superego_judgment
            )

        state_v5 = MAP_DEVELOPMENTAL_ANXIETY_TO_STRUCTURAL_ANXIETY(state_v5)

        state_v5.base_state.active_conflict_report =
            EGO_GENERATE_ANXIETY_SIGNAL(state_v5.base_state, state_v5.base_state.active_conflict_report)

        state_v5 = APPLY_REGRESSION_IF_EGO_OVERWHELMED(state_v5, state_v5.base_state.active_conflict_report)

        ################################################################
        # 42.9 Defense and output selection
        ################################################################

        state_v5.base_state.active_ego_response =
            EGO_DEFENSE_AND_OUTPUT_SELECTION(
                state_v5.base_state,
                ego_material,
                state_v5.base_state.active_reality_report,
                state_v5.base_state.active_superego_judgment,
                state_v5.base_state.active_conflict_report
            )

        state_v5.clinical_pattern_state.active_pattern = CLASSIFY_CLINICAL_PATTERN_V5(state_v5)

        IF state_v5.clinical_pattern_state.active_pattern == HYSTERICAL_CONVERSION:
            state_v5 = HANDLE_HYSTERICAL_CONVERSION(state_v5)

        IF state_v5.clinical_pattern_state.active_pattern == PHOBIC_DISPLACEMENT:
            state_v5 = HANDLE_PHOBIC_DISPLACEMENT(state_v5)

        IF state_v5.clinical_pattern_state.active_pattern == OBSESSIONAL_NEUROSIS:
            state_v5 = HANDLE_OBSESSIONAL_NEUROSIS(state_v5)

        IF state_v5.clinical_pattern_state.active_pattern == MELANCHOLIA:
            state_v5 = HANDLE_MELANCHOLIA(state_v5, CURRENT_LOST_OR_DISAPPOINTING_OBJECT)

        IF state_v5.clinical_pattern_state.active_pattern == MOURNING:
            state_v5 = HANDLE_MOURNING(state_v5, CURRENT_LOST_OBJECT)

        IF state_v5.clinical_pattern_state.active_pattern == PARANOIA:
            state_v5 = HANDLE_PARANOIA(state_v5)

        IF state_v5.clinical_pattern_state.active_pattern IN [PSYCHOSIS_WITHDRAWAL, PSYCHOSIS_RECONSTRUCTION]:
            state_v5 = HANDLE_PSYCHOSIS_WITH_REALITY_RECONSTRUCTION(state_v5)

        IF state_v5.clinical_pattern_state.active_pattern == MORAL_MASOCHISM:
            state_v5 = HANDLE_MORAL_MASOCHISM(state_v5)

        ################################################################
        # 42.10 Slips and everyday compromise formations
        ################################################################

        IF CURRENT_ACTION_OR_SPEECH_INTENTION_EXISTS():
            intended_act = GET_CURRENT_INTENDED_ACT()
            parapraxis = GENERATE_PARAPRAXIS_OR_EVERYDAY_FORMATION(state_v5, intended_act)
            IF parapraxis != null:
                state_v5.base_state.active_ego_response.output_type = SLIP_OR_PARAPRAXIS

        ################################################################
        # 42.11 Execute output and update economy
        ################################################################

        output_result = EXECUTE_OUTPUT(state_v5.base_state, state_v5.base_state.active_ego_response, external_input)
        state_v5.base_state = FEEDBACK_UPDATE(state_v5.base_state, output_result)
        state_v5.base_state = MEMORY_REPRESSION_REPETITION_UPDATE(state_v5.base_state, output_result)
        state_v5.base_state = HOMEOSTATIC_NORMALIZATION(state_v5.base_state)

    END WHILE


################################################################
# 43. COMPLETE THERAPEUTIC REVERSAL LOOP V6
################################################################

PROCEDURE COMPLETE_THERAPEUTIC_REVERSAL_V6(state_v5, target_pattern):

    DEFINE therapeutic_goal =
        "Replace repetition, symptom, inhibition, or self-punishment with remembered,
         word-linked, affect-linked, reality-linked, ego-owned representation."

    WHILE target_pattern.is_active:

        session_input = RECEIVE_ANALYTIC_SESSION_INPUT()
        state_v5 = ANALYTIC_SESSION_LOOP(state_v5, session_input)
        state_v5 = HANDLE_NEGATIVE_THERAPEUTIC_REACTION(state_v5)

        IF state_v5.active_dream_packet != null:
            interpreted_dream = INTERPRET_DREAM_BACKWARD(state_v5, state_v5.active_dream_packet)
            state_v5 = APPLY_DREAM_INTERPRETATION_TO_REPRESSION_NETWORK(state_v5, interpreted_dream)

        IF state_v5.active_parapraxis_packet != null:
            state_v5 = APPLY_PARAPRAXIS_INTERPRETATION(state_v5, state_v5.active_parapraxis_packet)

        hidden_conflict = TRACE_SYMPTOM_TO_MEMORY_OR_WISH(state_v5.base_state, target_pattern)

        IF hidden_conflict != NOT_FOUND:
            state_v5.base_state = WORKING_THROUGH_PIPELINE(state_v5.base_state, hidden_conflict)
            state_v5 = REDUCE_REPRESSION_AND_REPETITION(state_v5, hidden_conflict)
            state_v5 = SOFTEN_SUPEREGO_WHEN_GUILT_IS_INTERPRETED(state_v5, hidden_conflict)
            state_v5 = INCREASE_EGO_CAPACITY_AFTER_SUCCESSFUL_INTEGRATION(state_v5)

        target_pattern = REEVALUATE_TARGET_PATTERN(state_v5, target_pattern)

        IF target_pattern.repetition_pressure <= LOW
           AND target_pattern.symptom_intensity <= LOW
           AND target_pattern.unconscious_guilt <= LOW
           AND state_v5.base_state.ego.integration_capacity >= SUFFICIENT:
            target_pattern.is_active = false

    RETURN state_v5


PROCEDURE REDUCE_REPRESSION_AND_REPETITION(state_v5, source):

    IF source IS RepressionNode:
        source.repression_phase = PARTIAL_LIFTING_OF_REPRESSION
        source.affect_quota -= AFFECT_LINKING_RELIEF
        source.anticathexis_cost -= ANTICATHEXIS_RELEASE
        source.censorship_pass_probability += CONSCIOUS_TOLERANCE_INCREMENT

        IF source.affect_quota <= LOW:
            source.repression_phase = WORKED_THROUGH
            REMOVE_OR_REDUCE_ANTICATHEXIS(state_v5, source)

    IF source HAS repetition_pressure:
        source.repetition_pressure -= REPETITION_TO_REMEMBERING_RELIEF
        state_v5.base_state.id.repetition_pressure -= REPETITION_TO_REMEMBERING_RELIEF

    RETURN state_v5


PROCEDURE SOFTEN_SUPEREGO_WHEN_GUILT_IS_INTERPRETED(state_v5, source):

    IF source.related_to_oedipal_guilt OR source.related_to_ambivalence:
        state_v5.base_state.superego.unconscious_punishment_need -= GUILT_INTERPRETATION_RELIEF
        state_v5.base_state.superego.sadistic_punishment_force -= SUPEREGO_SADISM_RELIEF
        state_v5.base_state.superego.rigidity -= FLEXIBILITY_GAIN
        state_v5.base_state.ego.guilt_tolerance += GUILT_TOLERANCE_INCREMENT

    RETURN state_v5


PROCEDURE INCREASE_EGO_CAPACITY_AFTER_SUCCESSFUL_INTEGRATION(state_v5):

    state_v5.base_state.ego.strength += EGO_STRENGTH_INCREMENT
    state_v5.base_state.ego.integration_capacity += INTEGRATION_CAPACITY_INCREMENT
    state_v5.base_state.ego.binding_capacity += BINDING_CAPACITY_INCREMENT
    state_v5.base_state.ego.reality_testing_capacity += REALITY_TESTING_INCREMENT
    state_v5.base_state.ego.symbolization_capacity += SYMBOLIZATION_INCREMENT
    state_v5.base_state.ego.defense_flexibility += FLEXIBLE_DEFENSE_INCREMENT
    state_v5.base_state.ego.repression_load -= REPRESSION_LOAD_RELIEF

    RETURN state_v5


################################################################
# 44. COMPLETE FUNCTIONAL FORMULA V6
################################################################

DEFINE COMPLETE_FORMULA_V6 =

    "Any Freudian output is produced by the ego attempting to manage:

        ID:
            drive pressure, infantile wish, libido, aggression,
            Eros, destructive instinct, repetition, primary process.

        SUPEREGO:
            Oedipal heir, conscience, ego ideal, parental imago,
            later authority, guilt, shame, inferiority, punishment,
            moral masochism, approval, demand for renunciation.

        EXTERNAL REALITY:
            perception, danger, scarcity, law, social consequence,
            object availability, bodily limits, time, feasibility.

        TOPOGRAPHIC / REPRESENTATION SYSTEM:
            unconscious, preconscious, conscious, censorship,
            thing-presentation, word-presentation, visual residue,
            auditory word residue, affect-linking, representation.

        BODILY EGO SYSTEM:
            body surface, pain, internal/external perception,
            motility, body image, inside/outside boundary,
            somatic symbolization and conversion risk.

        ECONOMIC SYSTEM:
            cathexis, anticathexis, binding, discharge, damming-up,
            ego-libido, object-libido, withdrawal from objects,
            narcissistic accumulation, sublimation, symptom-bound energy,
            free and bound energy.

        DEVELOPMENTAL / CIVILIZATION SYSTEM:
            oral, anal, phallic, latency, genital residues,
            fixation, regression, Oedipus, identification, trauma,
            renunciation feedback, later authority, cultural superego,
            group ideals and collective guilt.

        FORMATION SYSTEM:
            dream, slip, joke, symptom, inhibition, anxiety,
            compulsion, fantasy, action, self-punishment, sublimation.

        TREATMENT SYSTEM:
            free association, resistance, transference, repetition,
            remembering, interpretation, abreaction, working-through.

     If ego mediation succeeds:
         thought, delay, reality-compatible action, repair, love, work,
         sublimation, integration.

     If mediation partially succeeds:
         compromise formation, symptom, dream, parapraxis, joke,
         fantasy, inhibition, displacement, reaction formation.

     If mediation fails:
         traumatic anxiety, compulsion, self-punishment, severe symptom,
         melancholic attack on ego, paranoid projection,
         withdrawal from reality, substitute reality construction.

     If analytic working-through succeeds:
         repetition becomes memory;
         affect becomes word-linked;
         repressed derivatives become tolerable;
         superego punishment softens;
         id pressure becomes representable;
         ego becomes stronger and less dependent on costly repression."


################################################################
# 45. COVERAGE CHECKLIST
################################################################

PROCEDURE VERIFY_FREUDIAN_COVERAGE_V6(state_v5):

    checklist = {}

    checklist["id_as_drive_reservoir"] = MODEL_HAS(IdState, DriveDemand, InstinctMixture)
    checklist["ego_as_mediator"] = MODEL_HAS(EGO_REALITY_TESTING, EGO_COMPUTE_CONFLICT, EGO_DEFENSE_AND_OUTPUT_SELECTION)
    checklist["superego_as_oedipal_heir"] = MODEL_HAS(OEDIPAL_CONFIGURATION_UPDATE, DISSOLVE_OEDIPUS_AND_FORM_SUPEREGO)
    checklist["ego_ideal_and_conscience"] = MODEL_HAS(SuperegoFormationRecord, SuperegoJudgment)
    checklist["three_masters"] = MODEL_HAS(ego_serves_three_masters, REALISTIC_ANXIETY, NEUROTIC_ANXIETY, MORAL_ANXIETY)
    checklist["topographic_system"] = MODEL_HAS(TopographicRegion, TOPOGRAPHIC_ROUTING_AND_CENSORSHIP)
    checklist["thing_word_representation_route"] = MODEL_HAS(RepresentationPacket, LINK_THING_PRESENTATION_TO_WORD_PRESENTATION)
    checklist["bodily_ego"] = MODEL_HAS(BodyEgoBoundary, UPDATE_BODY_EGO_BOUNDARY)
    checklist["primary_secondary_process"] = MODEL_HAS(ProcessMode, ID_PRIMARY_PROCESS_TRANSFORMATION, EGO_SYNTHESIS)
    checklist["energy_economy"] = MODEL_HAS(EnergyEconomy, cathexis, anticathexis, binding, discharge)
    checklist["ego_object_libido_mobility"] = MODEL_HAS(LibidoDistribution, UPDATE_LIBIDO_DISTRIBUTION)
    checklist["eros_death_instinct"] = MODEL_HAS(InstinctMixture, UPDATE_INSTINCT_MIXTURE, HANDLE_INSTINCT_DEFUSION)
    checklist["psychosexual_development"] = MODEL_HAS(PsychosexualFixation, PSYCHOSEXUAL_DEVELOPMENT_UPDATE)
    checklist["oedipal_variants"] = MODEL_HAS(OedipusVariant, OEDIPAL_CONFIGURATION_UPDATE)
    checklist["developmental_anxieties"] = MODEL_HAS(DevelopmentalAnxietyType, COMPUTE_DEVELOPMENTAL_ANXIETY)
    checklist["renunciation_superego_feedback"] = MODEL_HAS(SUPEREGO_RENUNCIATION_FEEDBACK_LOOP)
    checklist["cultural_superego"] = MODEL_HAS(CulturalSuperego, APPLY_CULTURAL_SUPEREGO_PRESSURE)
    checklist["primal_repression"] = MODEL_HAS(ESTABLISH_PRIMAL_REPRESSION)
    checklist["repression_proper"] = MODEL_HAS(APPLY_REPRESSION_PROPER)
    checklist["return_of_repressed"] = MODEL_HAS(RETURN_OF_THE_REPRESSED_ROUTING)
    checklist["dream_work"] = MODEL_HAS(SLEEP_MODE_DREAM_LOOP, DreamWorkPacket)
    checklist["slips_and_parapraxes"] = MODEL_HAS(GENERATE_PARAPRAXIS_OR_EVERYDAY_FORMATION)
    checklist["jokes"] = MODEL_HAS(GENERATE_JOKE_OR_WIT_FORMATION)
    checklist["hysteria"] = MODEL_HAS(HANDLE_HYSTERICAL_CONVERSION)
    checklist["phobia"] = MODEL_HAS(HANDLE_PHOBIC_DISPLACEMENT)
    checklist["obsessional_neurosis"] = MODEL_HAS(HANDLE_OBSESSIONAL_NEUROSIS)
    checklist["mourning"] = MODEL_HAS(HANDLE_MOURNING)
    checklist["melancholia"] = MODEL_HAS(HANDLE_MELANCHOLIA)
    checklist["paranoia"] = MODEL_HAS(HANDLE_PARANOIA)
    checklist["psychosis"] = MODEL_HAS(HANDLE_PSYCHOSIS_WITH_REALITY_RECONSTRUCTION)
    checklist["moral_masochism"] = MODEL_HAS(HANDLE_MORAL_MASOCHISM)
    checklist["resistance"] = MODEL_HAS(DETECT_RESISTANCE, HANDLE_RESISTANCE)
    checklist["transference"] = MODEL_HAS(DETECT_TRANSFERENCE, HANDLE_TRANSFERENCE)
    checklist["working_through"] = MODEL_HAS(WORK_THROUGH_RESISTANCE_ITERATIVELY, COMPLETE_THERAPEUTIC_REVERSAL_V6)
    checklist["prior_consistency_repairs"] = MODEL_HAS(AVOIDANCE, pending_defense_biases, prohibition_against_aggression, symptom_choice)
    checklist["v5_consistency_repairs"] = MODEL_HAS(MERGE, SAFE_CURRENT_CONFLICT_FOR_INSTINCT_UPDATE, state_v5.base_state, all_packets)
    checklist["v5_struct_order_cleanup"] = MODEL_HAS(BodyEgoBoundary, RepresentationPacket, LibidoDistribution, CulturalSuperego, CompleteSystemStateV6)
    checklist["v5_superego_field_cleanup"] = MODEL_HAS(later_authority_strength, SuperegoFormationRecord)
    checklist["v5_defense_output_separation"] = MODEL_HAS(associated_defenses, associated_outputs, DELAYED_ACTION, REPAIR_ACTION)
    checklist["v5_explicit_region_routing"] = MODEL_HAS(CONSCIOUS, PRECONSCIOUS, TopographicRegion)
    checklist["v6_pleasure_reality_arbitration"] = MODEL_HAS(PleasureRealityArbitrationRecord, PLEASURE_REALITY_PRINCIPLE_ARBITRATION)
    checklist["v6_negation_and_judgment"] = MODEL_HAS(NegationJudgmentRecord, HANDLE_NEGATION_AND_JUDGMENT)
    checklist["v6_persistent_ego_splitting"] = MODEL_HAS(EgoSplitState, HANDLE_EGO_SPLIT_AS_PARALLEL_ATTITUDES)
    checklist["v6_bodily_ego_main_loop_integration"] = MODEL_HAS(BodilyEgoMainLoopInfluence, INTEGRATE_BODILY_EGO_IN_MAIN_LOOP)
    checklist["v5_base_loop_non_authoritative"] = MODEL_HAS(COMPLETE_MAIN_OPERATING_LOOP_V6)

    IF ALL_VALUES_TRUE(checklist):
        RETURN "V6 covers the full functional mechanism at conceptual pseudocode level, with explicit pleasure/reality arbitration, negation/judgment, persistent ego-splitting, and bodily-ego main-loop integration."
    ELSE:
        RETURN LIST_FALSE_ITEMS(checklist)

END PROCEDURE
```

---

# V6 Compact Interaction Diagram

```text
                         EXTERNAL REALITY
                     danger / limits / objects / law
                                  |
                                  v
ID ---------------------------> EGO <------------------------- SUPEREGO
wishes, drives,                mediator,                       conscience,
Eros, aggression,              reality tester,                  ego ideal,
repetition,                    anxiety signal,                  guilt, shame,
primary process                defense selector,                punishment,
                               action controller                approval
                                  |
                                  v
              action / inhibition / symptom / dream / slip /
              fantasy / compulsion / sublimation / repair

Development underneath:
    psychosexual stages -> fixation -> regression
    Oedipus -> identification -> superego
    trauma -> repression -> repetition

Therapy reverses the chain:
    symptom or repetition
        -> resistance and transference
        -> repressed memory/wish
        -> affect linked to words
        -> unconscious becomes preconscious/conscious
        -> ego strengthens
        -> repetition and repression load decrease
```


---

# V6 Final Coverage Assessment

```text
Coverage status:
    Conceptual Freudian id–ego–superego interaction: COMPLETE / 100% conceptual coverage
    Structural model: COMPLETE
    Topographic model: COMPLETE
    Economic model: COMPLETE
    Dynamic conflict/defense model: COMPLETE
    Developmental/Oedipal model: COMPLETE
    Dream/parapraxis/joke formations: COMPLETE
    Clinical formation mapping: COMPLETE
    Therapeutic reversal model: COMPLETE
    Internal pseudocode consistency repairs from V2: COMPLETE
    V5 bodily ego layer: COMPLETE
    V5 thing-presentation / word-presentation route: COMPLETE
    V5 ego-libido / object-libido mobility: COMPLETE
    V5 renunciation-to-superego feedback loop: COMPLETE
    V5 cultural/group superego layer: COMPLETE
    V5 packet merge and dream update flow repairs: COMPLETE
    V5 struct declaration order cleanup: COMPLETE
    V5 missing superego field cleanup: COMPLETE
    V5 defense/output enum separation cleanup: COMPLETE
    V5 explicit region-routing cleanup: COMPLETE
    V5 base-loop authority labeling cleanup: COMPLETE
    V6 pleasure/reality arbitration layer: COMPLETE
    V6 negation and judgment layer: COMPLETE
    V6 persistent ego-splitting layer: COMPLETE
    V6 bodily-ego main-loop integration: COMPLETE

Important limitation:
    This is complete as a conceptual pseudocode reconstruction of the core Freudian structural interaction mechanism, including the V6 additions for pleasure/reality arbitration, negation/judgment, persistent ego-splitting, and bodily-ego main-loop integration.
    It is not a literal implementation, not clinical advice, and not an empirical validation of Freud.
```
