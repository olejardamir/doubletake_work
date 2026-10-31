# Crystal-Radio-Powered Chaotic Pendulum
## Simplified Engineering Specification

**Version:** 0.2  
**Date:** 2026-09-19  
**Status:** Simplified build specification

---

## 1. Purpose

Build a very-low-loss pendulum that is kept moving by small, timed magnetic kicks.

The project has three stages:

1. **Mechanical prototype:** sustain the pendulum from a small battery.
2. **RF-powered prototype:** replace the battery with energy harvested from AM radio using a pyrite crystal detector.
3. **Nonlinear pendulum:** add fixed magnets and allow two-dimensional motion to produce complex, potentially chaotic behavior.

The system is not a perpetual-motion machine. It depends on externally supplied RF energy.

---

## 2. Core Design Principle

The entire system is:

> **A very-low-loss oscillator that occasionally receives a small packet of externally harvested energy.**

The pendulum should lose as little energy as possible. The electrical system only needs to replace that loss.

For a pendulum of length \(L\):

\[
T = 2\pi\sqrt{\frac{L}{g}}
\]

For small swing angle \(\theta\):

\[
E \approx \frac{1}{2}mgL\theta^2
\]

Approximate loss per cycle:

\[
\Delta E \approx \frac{2\pi E}{Q}
\]

Required average replacement power:

\[
P \approx \frac{\Delta E}{T}
\]

The actual design should be based on measured loss and measured harvested RF energy rather than assumed capacitor sizes or voltages.

---

# 3. Phase 1 — Battery-Powered Pendulum

## 3.1 Mechanical System

Recommended starting values:

| Parameter | Starting value |
|---|---:|
| Pendulum length | 0.5 m |
| Bob mass | 20–50 g |
| Bob magnet | Small neodymium magnet |
| Pivot | Very low friction |
| Frame | Wood, acrylic, or plastic |
| Target quality factor | \(Q > 300\) |

Use the lowest-friction pivot practical.

A thread or fine suspension can also be used if the final system will become a two-dimensional pendulum.

---

## 3.2 Simplified Escapement

Use **one magnetic kick per oscillation**, not separate left and right kick systems.

```text
Battery
   |
   v
Charge resistor
   |
   v
Capacitor
   |
   v
Reed switch
   |
   v
Coil  --->  Bob magnet
```

Place the coil and reed switch near one side of the swing.

As the pendulum reaches that region:

1. the bob magnet closes the reed switch;
2. the capacitor briefly discharges through the coil;
3. the coil pushes the bob back into the swing;
4. the reed opens as the bob moves away;
5. the capacitor slowly recharges before the next cycle.

Only one well-timed kick per cycle is required to replace mechanical losses.

---

## 3.3 Initial Electrical Parts

| Item | Suggested starting point |
|---|---|
| Battery | 0.9–1.5 V AA/AAA |
| Charge resistor | 10 kΩ |
| Capacitor | 10–470 µF for experimentation |
| Reed switch | Normally open |
| Coil | 500–2000 turns |
| Bob magnet | Neodymium |

The capacitor value is not fixed. Start modestly and determine the smallest pulse that reliably sustains the pendulum.

Avoid adding boost converters, voltage doublers, transistors, or other circuitry until measurements show they are necessary.

---

## 3.4 Phase 1 Measurements

First measure the pendulum without electrical assistance.

### Free-decay test

1. Start the pendulum at a known amplitude.
2. Disconnect the kick circuit.
3. Record amplitude over time.
4. Estimate the pendulum's energy loss per cycle.

Then reconnect the kick circuit and reduce kick strength until it only just compensates for the measured loss.

### Phase 1 success

The pendulum sustains approximately constant amplitude for at least 5 minutes using one magnetic kick per cycle.

---

# 4. Phase 2 — AM Crystal-Radio Energy Harvester

Before attempting to power the pendulum, measure how much usable energy can actually be harvested at the installation location.

The RF system is:

```text
Long-wire antenna
       |
       v
   LC tuner
       |
       v
Pyrite detector
       |
       v
Storage capacitor
       |
       v
Reed switch
       |
       v
     Coil
```

Keep the energy path as simple as possible.

---

## 4.1 Antenna and Ground

Recommended starting point:

- **Antenna:** 10–30 m long wire
- **Ground:** effective earth ground or suitable grounded metal system
- **Frequency range:** AM broadcast band

For a permanent outdoor antenna, use appropriate lightning protection and disconnect it during storms.

---

## 4.2 Tuned Circuit

Typical components:

- tuning coil around 200–300 µH;
- variable capacitor around 10–365 pF.

Tune for the strongest local AM signal.

The exact values are less important than achieving a clear resonance at the desired station.

---

## 4.3 Pyrite Detector

Use:

- a clean pyrite specimen;
- a fine adjustable metal point;
- mechanical adjustment fine enough to search for a sensitive contact.

Because pyrite contact sensitivity can vary greatly, first test the same RF circuit with a known low-forward-voltage detector such as a germanium diode.

This separates two questions:

1. Is enough RF energy available?
2. Is the pyrite contact working well enough?

Once the harvester is proven, substitute the pyrite detector.

---

## 4.4 RF Energy Measurement

Do not begin by trying to run the pendulum.

First connect the detector to a known capacitor and measure how quickly the voltage rises.

Stored energy is:

\[
E = \frac{1}{2}CV^2
\]

Approximate harvested power over charging interval \(t\):

\[
P \approx \frac{\frac{1}{2}CV^2}{t}
\]

Example procedure:

1. discharge the capacitor;
2. tune the radio circuit;
3. measure capacitor voltage after a known time;
4. calculate stored energy;
5. compare harvested energy per pendulum period with measured mechanical loss.

The RF system is viable only if enough energy reaches the coil after electrical losses to compensate for pendulum losses.

---

## 4.5 Direct Integration

The preferred first attempt is:

```text
Antenna -> LC -> Pyrite -> Capacitor -> Reed -> Coil
```

Do **not** initially add:

- Joule Thief circuits;
- boost converters;
- voltage multipliers;
- transistor pulse drivers;
- multiple storage stages.

Each extra stage can consume some of the already limited harvested energy.

Add circuitry only after measurement identifies a specific problem that requires it.

---

## 4.6 Phase 2 Success

Phase 2 is complete when the pendulum sustains motion using harvested AM RF energy with no battery connected.

The important criterion is energy balance, not a particular capacitor voltage or charging time.

---

# 5. Phase 3 — Nonlinear / Chaotic Motion

For richer dynamics, the pendulum should be able to move in **two horizontal directions**, rather than being constrained to a single vertical plane.

A thread-suspended spherical pendulum is preferable.

Place three or more fixed magnets below the bob.

```text
              suspension
                  |
                  |
             [bob magnet]
              /   |   \
             /    |    \
           M1     M2     M3
```

Use repelling orientation between the bob magnet and fixed magnets.

---

## 5.1 Magnet Arrangement

Start with three fixed magnets.

Use deliberately imperfect geometry:

- unequal spacing;
- slightly different distances from the center;
- small differences in magnet strength or height;
- slight frame tilt if necessary.

This creates a nonlinear potential landscape with multiple competing paths.

Avoid nearby conductive metal that could increase eddy-current damping.

---

## 5.2 Operating Regime

Interesting nonlinear behavior is most likely when the system operates near the minimum energy required to keep moving.

Possible observations include:

- switching between regions around different magnets;
- changing orbital paths;
- amplitude modulation;
- period multiplication;
- irregular plane rotation;
- long non-repeating trajectories.

AM modulation may naturally vary the amount of available harvested energy, but irregular motion alone does not prove deterministic chaos.

---

## 5.3 Demonstrating Chaos

If the goal is only an interesting non-repeating kinetic object, visual irregularity is sufficient.

If the goal is to claim **deterministic chaos**, "motion did not repeat for 10 minutes" is not enough.

A stronger analysis would record bob position over time and examine properties such as:

- phase-space structure;
- sensitivity to nearly identical initial conditions;
- return maps;
- broadband spectral behavior;
- positive Lyapunov exponent, if practical.

---

# 6. Development Sequence

Follow this order:

```text
1. Build low-friction pendulum
        |
        v
2. Measure free decay and energy loss
        |
        v
3. Add one battery-powered magnetic kick
        |
        v
4. Minimize required kick energy
        |
        v
5. Build AM harvester separately
        |
        v
6. Measure actual harvested energy
        |
        v
7. Compare RF energy with pendulum loss
        |
        v
8. Replace battery with RF harvester
        |
        v
9. Convert to 2-D pendulum
        |
        v
10. Add nonlinear fixed magnets
```

Do not proceed to a more complicated stage until the previous stage works and has been measured.

---

# 7. Minimal Bill of Materials

## Mechanical

- pendulum suspension;
- lightweight non-magnetic bob;
- small neodymium magnet;
- rigid frame;
- one drive coil;
- one reed switch.

## Phase 1 electronics

- AA or AAA battery;
- resistor;
- capacitor;
- hookup wire.

## RF harvester

- 10–30 m antenna wire;
- ground connection;
- tuning coil;
- variable capacitor;
- pyrite;
- adjustable cat's-whisker contact;
- low-leakage capacitor;
- germanium diode for comparison/testing.

## Nonlinear stage

- three or more fixed neodymium magnets.

---

# 8. Main Engineering Rule

Every design decision should follow the measured energy budget:

\[
\boxed{
E_{\text{harvested per cycle}}
>
E_{\text{electrical losses}}
+
E_{\text{mechanical losses}}
}
\]

The best route to RF-powered operation is therefore not stronger circuitry but:

- lower pivot friction;
- lower aerodynamic drag;
- lower electrical leakage;
- efficient coil coupling;
- correct kick timing;
- the strongest practical AM signal;
- the simplest possible energy path.

---

# 9. Final Architecture

```text
                   AM RADIO WAVES
                         |
                         v
                 Long-wire antenna
                         |
                         v
                     LC tuner
                         |
                         v
                  Pyrite detector
                         |
                         v
                     Capacitor
                         |
                         v
                    Reed switch
                         |
                         v
                       Coil
                         |
                         v
                 Magnetic impulse
                         |
                         v
                Low-loss pendulum
                         |
                         v
             Fixed nonlinear magnets
                         |
                         v
             Complex / chaotic motion
```

---

*End of specification.*
