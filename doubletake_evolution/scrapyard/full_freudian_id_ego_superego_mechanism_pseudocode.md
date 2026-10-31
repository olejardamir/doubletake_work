# Full Freudian Id–Ego–Superego Mechanism — End-to-End Pseudocode

## Status

This is a conceptual pseudocode model of the full mechanism of interaction between id, ego, superego, external reality, unconscious/preconscious/conscious routing, energy economy, defenses, symptom formation, repetition, development, and therapeutic reversal.

It is not a clinical diagnosis tool and not a literal computational implementation of Freud. It is a functional reconstruction of the mechanism.

---

# PROCEDURE Full_Freudian_Id_Ego_Superego_Mechanism()

```text
PROCEDURE Full_Freudian_Id_Ego_Superego_Mechanism()

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
# 5. MAIN OPERATING LOOP
################################################################

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

    response.selected_defenses = []
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
        response.selected_defenses = [AVOIDANCE_OUTPUT, FANTASY_WITHDRAWAL]
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
        hidden_trace.current_region = PRECONSCIOUS_OR_CONSCIOUS
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
