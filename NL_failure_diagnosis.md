# NL convergence failures in Templates

TODO on main branches:

- Chiller:
  - [x] `pla(intChi(valChiWatChiBypPar(from_dp=true)))`:
    - [x] solves HardCase1 with 7 NL failures (`linearized=true` has 6)
    - [x] HardCase2 NL failures 4 → 0



Alternatives:

- Leakage:

  - not robust solution due to sensitivity to event grid (e.g. suppressing assert blocks!), or NL scale (HardCase1NLoadsLeakage failing) or structure (Chillers.Validation.HardCase1Leakage failing)
  - impact of leakage flow (0.2 kg/s ) on HP inlet temperatures (0.6 K)

- Linearize valve flow functions:

  - impact on trajectories e.g. when primary pumps are maxed out before staging up, the loop ∆p is no more feedback controlled but rather driven by pump VS valve characteristic, which impacts load valve opening, CHW/HW requests, temperature reset, capacity requirement, HP staging
  - may be detrimental in some cases: Buildings.Templates.Plants.HeatPumps.Validation.HardCase2




----

The analysis is based on the three plant templates from

- https://github.com/lbl-srg/modelica-buildings/pull/4657: AWHP plant
- https://github.com/lbl-srg/modelica-buildings/pull/3167: chiller plant
- https://github.com/lbl-srg/modelica-buildings/pull/3364: boiler plant

The template validation models are all simulated with `pla(linearized=false)` for all valid plant configurations using the scripts under `Buildings/Resources/Scripts/travis/templates`.

- Test branch: https://github.com/AntoineGautier/modelica-buildings/tree/issue3759_templateNumerics

Several simulation failures were fixed by

- correcting the control sequences (e.g. chiller enabled with no CW pump enabled): https://github.com/lbl-srg/modelica-buildings/pull/4705, https://github.com/lbl-srg/modelica-buildings/pull/4696, https://github.com/lbl-srg/modelica-buildings/pull/4693, https://github.com/lbl-srg/modelica-buildings/pull/2299
- fixing a bug in the HP model: https://github.com/ibpsa/modelica-ibpsa/issues/2162

After that, two types of configuration still fail to simulate.

1. AWHP plant: separate dedicated primary pumps (one for CHW, one for HW), primary-only or primary-secondary distribution (both failing). This fails with both OCT and Dymola (CVode solver). Completes successfully with Dassl solver.
2. Chiller plant: WSE with heat exchanger bypass valve, headered primary pumps, primary-only distribution. This fails with Dymola (CVode solver). (OCT cannot translate the chiller plant controller). Completes successfully with Dassl solver.

---

## 1. AWHP plant template

### State at failure

**Dymola**

```
Warning: Failed to solve nonlinear system using Newton solver.
  Time: 22015.93464026791
  Tag: simulation.nonlinear[1]
   * Number of calls to nonlinear solver DymNL has reached or exceeded
     the maximum allowed number of function calls= 900
  Jacobian inverse norm estimate: 801468
  Condition number estimate: 1.26339e+06
  1-norm of the residual = 15.9088
  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[3].dp = -2243.27
    pla.valIso.port_aChiWat.m_flow = -0.00111231
    pla.port_aChiWat.m_flow = 4.08264E-05
    ...
  Last value of the residual (unscaled!):
    { -0.000218064, -0.000278686, -0.000101332, 8.24992E-05, -0.000277594,
      0.000579542, 15.9073, -2.91588E-05 }
SUNDIALS: CVODE CVode At t = 22015.9 repeated recoverable right-hand side function errors.
```

All three HPs are in heating mode during the whole run: CHW isolation valves and CHW load valve closed, CHW pumps off, CHW minimum flow bypass valve fully open.

> [!warning]
> Insert plot

**OCT**

```
FMIL: module = Model, log level = 2: [ERROR][FMU status:Error]   Failed to find a solution for nonlinear <value name="block">"1"</value> at <value name="time">        3.1800000000000000E+04</value>.
FMIL: module = Model, log level = 2: [INFO][FMU status:Error]   Could not compute next set of values for the iteration variables that would get us closer to a solution.
FMIL: module = Model, log level = 2: [ERROR][FMU status:Error]   The <value name="function">KINSol</value> outputs:
FMIL: module = Model, log level = 2: [ERROR][FMU status:Error]   <value name="msg">"The line search algorithm was unable to find an iterate sufficiently distinct from the current iterate."</value>
FMIL: module = Model, log level = 2: [ERROR][FMU status:Error]   <value name="functionL2Norm">        2.7085720517482533E-05</value>, <value name="scaledStepLength">        1.8365244104071753E+01</value>, <value name="tolerance">        1.0000000000000000E-10</value>
FMIL: module = Model, log level = 2: [ERROR][FMU status:Error]   <value name="conditionNumber">        9.9662279183288262E+14</value>
```

At that time, HP #1 has just been disabled, while HP #2 and #3 are still enabled in heating mode.

### Block at cause

**Dymola**

`simulation.nonlinear[1]` is a 8×8 system of the isolation/check valve network. From `dsmodel.mof`:

```
Iteration variables                        Residual equations (kg/s)
1  valIso.valHeaWatUniInlIso[1].port_b.p   1  junHeaWatSup.ports[1].m_flow - m_che(pumHeaWat.valChe[1].dp)
2  pumPri.pumChiWat.valChe[3].dp           2  junHeaWatSup.ports[3].m_flow - m_che(pumHeaWat.valChe[3].dp)
3  valIso.valHeaWatUniInlIso[3].port_b.p   3  pumPri.ports_bChiWat[1].m_flow + m_che(pumChiWat.valChe[1].dp)
4  VHeaWat_flow.port_a.m_flow              4  pumPri.ports_bChiWat[2].m_flow + m_che(pumChiWat.valChe[2].dp)
5  pumPri.pumHeaWat.valChe[2].dp           5  junHeaWatRet.ports[2].m_flow + m_flow_dp(valHeaWatUniInlIso[2].lin.dp, ...)
6  valIso.port_bHeaWat.m_flow              6  junChiWatRet.ports[2].m_flow + m_flow_dp(valChiWatUniInlIso[2].lin.dp, ...)
7  valIso.port_aChiWat.m_flow              7  junChiWatBypSup.port_3.m_flow + m_flow_dp(valChiWatMinByp.lin.dp, ...)
8  port_aChiWat.m_flow                     8  junHeaWatBypSup.port_3.m_flow + m_flow_dp(valHeaWatMinByp.lin.dp, ...)
```

In contrast with OCT, Dymola's residual equations don't include the iteration variables directly. The residuals are tied to the iteration variables through the torn assignments. For example :

```
From port_aChiWat.m_flow to residual 7:
pipChiWat.dp := basicFlowFunction_m_flow(port_aChiWat.m_flow, 0.2267, 21.51)
loaCoo.con.val.valEqu.dp := basicFlowFunction_m_flow(port_aChiWat.m_flow, loaCoo.con.val.valEqu.k, loaCoo.con.val.valEqu.m_flow_turbulent)
valChiWatMinByp.lin.dp := pipChiWat.dp + loaCoo.con.val.valEqu.dp
junChiWatBypSup.port_3.m_flow := port_aChiWat.m_flow - valIso.port_aChiWat.m_flow

From pumChiWat.valChe[3].dp to residuals 1–3, through the reverse flow of check valve 3:
pumPri.ports_bChiWat[3].m_flow := -m_che(pumChiWat.valChe[3].dp)
junHeaWatSup.ports[1].m_flow := -(junHeaWatSup.ports[2].m_flow - (junChiWatRet.ports[3].m_flow + junHeaWatRet.ports[3].m_flow - pumPri.ports_bChiWat[3].m_flow) + port_bHeaWat.m_flow)
junHeaWatSup.ports[3].m_flow := -(junChiWatRet.ports[3].m_flow + junHeaWatRet.ports[3].m_flow - pumPri.ports_bChiWat[3].m_flow)
pumPri.ports_bChiWat[1].m_flow := junChiWatRet.ports[1].m_flow + junChiWatRet.ports[3].m_flow + ... - pumPri.ports_bChiWat[3].m_flow

From pumChiWat.valChe[3].dp to residuals 1–4 and 6, through the isolation valve ∆p:
valChiWatUniInlIso[2].lin.dp := pumChiWat.pum[3].dpMachine - (pipChiWat.dp + pumChiWat.valChe[3].dp + loaCoo.con.val.valEqu.dp + valHeaWatUniInlIso[2].port_b.p) + valHeaWatUniInlIso[3].port_b.p
valChiWatUniInlIso[1|3].lin.dp := valChiWatUniInlIso[2].lin.dp + valHeaWatUniInlIso[2].port_b.p - valHeaWatUniInlIso[1|3].port_b.p
junChiWatRet.ports[1|3].m_flow := -m_flow_dp(valChiWatUniInlIso[1|3].lin.dp, ...)
pumChiWat.valChe[1].dp := pumChiWat.pum[1].dpMachine - (pipChiWat.dp + loaCoo.con.val.valEqu.dp + valChiWatUniInlIso[2].lin.dp + valHeaWatUniInlIso[2].port_b.p) + valHeaWatUniInlIso[1].port_b.p
pumChiWat.valChe[2].dp := pumChiWat.pum[2].dpMachine - (pipChiWat.dp + loaCoo.con.val.valEqu.dp + valChiWatUniInlIso[2].lin.dp)
```

With the CHW isolation valves and load valve closed and the CHW pumps off, two of the eight iteration variables reach the residuals only through closed elements:

- `port_aChiWat.m_flow` (variable 8) reaches row 7 through the closed load valve's flow function `basicFlowFunction_m_flow` (`from_dp=false`: ∆p computed from ṁ). This is **defect A**.
- `pumChiWat.valChe[3].dp` (variable 2) reaches rows 1–4 and 6 through leak laws only: the reverse flow of check valve 3, and the leaks of the three CHW isolation valves and of check valves 1 and 2 via the isolation valve ∆p. This is **defect B**.

**Defect A: the iteration variable is the flow through a closed valve.**

The pattern is two valves in parallel: one closed with `from_dp=false` (∆p from ṁ), one open with `from_dp=true` (ṁ from ∆p). The torn system follows these formulations. The closed-branch flow becomes the iteration variable. The closed valve's `basicFlowFunction_m_flow` gives the common ∆p, the open valve's `basicFlowFunction_dp` gives its flow from that ∆p, and the flow balance is the residual. Here the closed valve is the load valve and the open one is the minimum flow bypass:

```
dp        = R_load · port_aChiWat.m_flow        R_load = 0.375 · deltaM · Δp_nom / (l² · ṁ_nom) = 3.1e8 Pa/(kg/s)
r7        = port_aChiWat.m_flow − valIso.port_aChiWat.m_flow + m_byp(dp)
∂r7/∂m    = 1 + R_load · ∂m_byp/∂∆p
```

An error δm on the iteration variable is multiplied by `R_load` into a ∆p error, then by `∂m_byp/∂∆p` into a bypass flow error. So the residual sees δm with a gain `R_load · ∂m_byp/∂∆p`, the ratio of the open to the closed branch `∂ṁ/∂∆p`, which is O(1/l²).

At the solution, where the loop flow is about zero (no CHW pump runs), the gain is 1.7e7. The last iterate in the error message, `port_aChiWat.m_flow = 4.08e-5 kg/s`, gives a bypass ∆p of 12.8 kPa and a bypass flow of `0.14 · √12.8e3 = 15.9 kg/s`, which is exactly the residual of row 7 printed at failure.

The gain is the Jacobian entry, and Newton's method takes it into account. What breaks is resolution: meeting a flow tolerance on row 7 requires resolving the loop flow 1.7e7 times more finely, while the solver steps it as a flow (see Tested on this block).

**Defect B: `valChe[3].dp` is set by leakage equations only.**

Slope of the leak law of a closed valve: `∂ṁ/∂∆p = 1.40625 · k² / m_flow_turbulent = 1.40625 · l² · ṁ_nom / (deltaM · Δp_nom)`, with `k = l · kVal`: 1.7e-7 kg/s/Pa for a closed check valve (`l = 1e-3` by default), 1.7e-8 for a closed isolation valve (`l = 1e-4` by default).

The Jacobian column of `valChe[3].dp` is therefore O(1e-7), while the rows it enters (1–4, 6) carry pump and header flows of O(17 kg/s): its contribution is below the row resolution.

The near-singularity is physical, the node pressure is set by leakage alone with a sensitivity `∂∆p/∂ṁ ≈ 1e7 Pa/(kg/s)`, and it does not depend on the valve formulation (`from_dp`).

**OCT**

Torn system (Block 1) of 11 iteration variables and 72 solved variables

```
			Iteration variables                      Residual equations (Pa)
0     pla.port_bHeaWat.p                       loaHea.dp = pla.port_bHeaWat.p - VHeaWat_flow.port_a.p
1     pipChiWat.port_b.p											 pla.valIso.valChiWatUniInlIso[1].dp = pipChiWat.port_b.p - pla.pumPri.ports_aChiHeaWat[1].p
2     pla.port_bChiWat.p                       loaCoo.dp = pla.port_bChiWat.p - VChiWat_flow.port_a.p
3     pla.pumPri.ports_aChiHeaWat[2].p         pla.valIso.valChiWatUniInlIso[2].dp = pipChiWat.port_b.p - pla.pumPri.ports_aChiHeaWat[2].p
4     pla.pumPri.pumChiWat.valChe[2].dp				 pla.pumPri.pumChiWat.valChe[2].dp = pla.pumPri.pumChiWat.pum[2].port_b.p - pla.port_bChiWat.p
5     pla.pumPri.pumHeaWat.valChe[2].dp        pla.pumPri.pumHeaWat.valChe[2].dp = pla.pumPri.pumHeaWat.pum[2].port_b.p - pla.port_bHeaWat.p
6     pla.pumPri.ports_aChiHeaWat[3].p		     pla.valIso.valHeaWatUniInlIso[3].dp = pipHeaWat.port_b.p - pla.pumPri.ports_aChiHeaWat[3].p
7     pla.pumPri.pumChiWat.valChe[3].dp   	   pla.pumPri.pumChiWat.valChe[3].dp = pla.pumPri.pumChiWat.pum[3].port_b.p - pla.port_bChiWat.p
8     pla.pumPri.pumHeaWat.valChe[3].dp			   pla.pumPri.pumHeaWat.valChe[3].dp = pla.pumPri.pumHeaWat.pum[3].port_b.p - pla.port_bHeaWat.p
9     pla.valIso.valChiWatUniOutIso[1].m_flow  pla.valIso.valChiWatUniOutIso[1].m_flow = m_flow_dp(pla.pumPri.pumChiWat.valChe[1].dp, ...)
10    pla.pumPri.pumHeaWat.valChe[1].dp        pla.pumPri.pumHeaWat.valChe[1].dp = pla.pumPri.pumHeaWat.pum[1].port_b.p - pla.port_bHeaWat.p
```



### NL log (Dymola)

Newton iteration trace of `simulation.nonlinear[1]` over the run, `Advanced.Simulation.Debug.LogNonlinearIterations`.

**1. Both defects are visible in every call, and the block converges anyway.**

- Defect B: Dymola evaluated the Jacobian 12,521 times; the condition estimate is above 1e8 in most of them, and is 8.349e8, constant to six digits, during the fatal calls. The same block converged in ~6,600 calls at that condition number. So neither `cond` nor `‖J⁻¹‖` explains why this call fails and the others did not; they only measure defect B, i.e. that an O(1 kg/s) error in any residual is worth O(1 kPa) of `valChe[3].dp` in a Newton step.
- Defect A: row 7 is linear in the iteration variable only while the bypass stays inside its regularization band, `|∆p| < ∆p_t = (m_flow_turbulent / k)² = (0.53 / 0.14)² ≈ 14 Pa`, i.e. `|port_aChiWat.m_flow| < ∆p_t / R_load ≈ 4.5e-8 kg/s`. 47 % of the 41,286 iterates of `port_aChiWat.m_flow` lie outside it, up to 0.021 kg/s (bypass ∆p ≈ 6.5 MPa). Accordingly, the row scale of row 7 (`J_sum`) varies between 588 and 1.7e7 across Jacobian evaluations. The loop flow never leaves the load valve's own band (1.43 kg/s), so the quadratic branch of the m-form is not involved.

**2. The trigger is defect B: an HW-side residual at the start of a call becomes a kPa error on `valChe[3].dp`.**

Each call starts from the previous solution, so its initial residual comes from what changed on the HW side since. Newton's first step turns it into a large move of `valChe[3].dp`, which the following steps do not undo (point 3):

| call | HW residual at start | first step on `valChe[3].dp` | outcome |
| --- | --- | --- | --- |
| 21690.27 s | 0.5 kg/s | +0.5 kPa | fails; CVode retries with a smaller step, converges |
| 21861.08 s | 0.2 kg/s | +0.2 kPa | fails; retry with a smaller step converges |
| 22015.9346 s, 9 calls | 26 kg/s | −4.7 kPa | all fail |

Small residuals are recovered because a smaller CVode step shrinks them. The nine fatal calls start with the same 26 kg/s residual whatever the step size, down to 0.1 ms, so CVode gives up.

**3. Defect B also blocks the recovery; defect A makes it erratic.**

After the first step, `valChe[3].dp` stays about 2.5 kPa away from its solution, so the closed isolation valves leak into the CHW loop. With that leak, rows 6 and 7 cannot both be satisfied: the isolation-valve balance (row 6) needs a small loop flow, the bypass balance (row 7) needs none. Only moving `valChe[3].dp` back reconciles them, and Newton does not do it: in 94 % of its steps the change of `valChe[3].dp` is exactly zero. It moves the loop flow back and forth between the two values instead, until the call budget is spent.

In the failing solve, the other rows reach 1e-8 to 1e-4 kg/s while the loop flow changes sign with overshoot (e.g. −3.9e-6 → +3.0e-5 kg/s) and row 7 stagnates at 9–15 kg/s. That is defect A: the slope of the bypass row changes by three orders of magnitude between the two loop flows, and the printed residual looks large because the 15.9 kg/s of the error message is row 7 alone. It is not what blocks: `Leakage` (§2, Tested workarounds) leaves defect A intact and completes.

### Tested on this block

Removing either defect lets the run pass the failure time:

| option | defect removed | how | result |
| --- | --- | --- | --- |
| `from_dp=true` on the CHW load valve | A | the iteration variable becomes `loaCoo.con.val.valEqu.dp`; its 22,675 logged iterates stay below 0.054 Pa, well inside the 14 Pa band | passes 22015 s |
| `Leakage`, `l = 1e-3` on isolation and bypass valves | B (attenuated: `valChe[3].dp` column × 100) | see §2, Tested workarounds | completes |
| `Linearized`, `linearized=true` on the isolation valves | not analysed on this block | see §2, Tested workarounds | completes |
| Compliance, `C = 1e-5` | B (removed: `valChe[i].dp` enter pressure sums with coefficient −1) | see §2, Tested workarounds | completes |


## 2. Chiller plant template

### State at failure

```
Warning: Failed to solve nonlinear system using Newton solver.
  Time: 30820.79078302091
  Tag: simulation.nonlinear[1]

  Jacobian inverse norm estimate: 2.9724e+08
  Condition number estimate: 5.14083e+08
  1-norm of the residual = 227.344
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatPri.valChe[2].dp = -57435.3
    pla.port_a.m_flow = 7.96592
    pla.intChi.valChiWatChiBypPar.port_a.m_flow = 0.000552757
  Last value of the residual:
    { 208.826, -14.7577, -3.75946 }

Previous problem occured when evaluating crossing function, reducing step-size
SUNDIALS: CVODE cvRcheck3 At t = 30820.7, the rootfinding routine failed in an unrecoverable manner.
```

WSE-only operation from ~30000 s. Chiller 1 is enabled: its isolation valve opens 30600–30700, then the chiller bypass closes 30800–30821, and the run dies when `kVal` reaches the leakage limit `l·k_nom = 3.0e-4`:

> [!warning]
>
> Plot

### Block at cause

`simulation.nonlinear[1]` is a 3x3 system of the chiller bypass/check valve network. From `dsmodel.mof`:

```
Iteration variables                                   Residuals
 1  pla.pumChiWatPri.valChe[2].dp                     1  0 = pum[2].dpMachine - (valChe[2].dp + valChiWatMinByp.lin.dp + valChiWatChiIsoPar[1].lin.dp)
 2  pla.port_a.m_flow                                 2  0 = intChi.ports_bSup[1].m_flow + m_che(valChe[1].dp)
 3  pla.intChi.valChiWatChiBypPar.port_a.m_flow       3  0 = eco.hex.port_a2.m_flow - port_a.m_flow + eco.valChiWatByp.port_a.m_flow

Torn assignment:
pla.chi.valChiWatChiIsoPar[1].lin.dp := basicFlowFunction_m_flow(valChiWatChiBypPar.port_a.m_flow, valChiWatChiBypPar.lin.kVal, ...)
```

Chiller bypass valve, chiller #1 and chiller #2 are in parallel. Tearing selects the flow through the *closed* chiller bypass valve as the group's iteration variable and computes the group ∆p from the bypass valve's flow function `basicFlowFunction_m_flow` (`from_dp=false`, ∆p from ṁ). The flow through the open chiller #1 isolation valve, the mininum flow bypass valve ∆p, `valChe[1].dp` and the economizer ∆p all follow forward: defect A. That assignment's slope is `R_byp = 0.375 · m_turb / kVal²`, which grows by `1/l² = 1e8` as the valve closes, from 0.08 to 7.8e6 Pa/(kg/s), and every quantity derived from the group ∆p inherits the factor:

```
∂r1/∂m_byp ≈ R_byp · (1 + R_minByp · ∂m_iso1/∂∆p) = 7.8e6 · (1 + 1.5e4 · 2.1e-3) = 2.7e8      (log: J_sum row 1 = 2.1e8)
```

#### NL log

The log confirms the timing: the block's condition estimate is 2e3–5e4 for the last half of the run and reaches 5e8 only in the final Jacobians as `kVal` hits its floor. A 2e-5 kg/s change in the bypass iterate moves the group ∆p by 157 Pa, the chiller #1 flow by 0.33 kg/s and `valChe[1].dp` by 5.2 kPa, walking check valve 1 across its whole 0–5000 Pa blend region (`J_sum` row 2 alternates 1.3e4 ↔ 2.4e6 between consecutive Jacobians). After row scaling all three rows are ≈ `e_{m_byp}`, hence `cond = 5e8` and Dymola's "no solution", a misreading: the system is well posed, the Jacobian is scaled by the `1/l²` of one torn assignment.

### Tested workarounds

Three options tested:

1. Improve `‖J⁻¹‖` (defect B): the lever is the valve leakage coefficient, that is increased to 1e-3 from the default 1e-4 for two-way valves.
   - Solves the AWHP case, but not the chiller case (below).
   -
2. Linearize the flow characteristic: setting `linearized=true` for the isolation valves.
3. Introduce a pressure state so that the check valve ∆p's are fixed by pressure sums instead of leak laws (defect B): using a component with hydraulic capacitance (compliance), sized to represent a typical expansion vessel (C range 1E-4 - 1E-5 kg/Pa).


**Why `Leakage` passes.** Raising `l` from 1e-4 to 1e-3 on the isolation and bypass valves only multiplies the `valChe[3].dp` column by 100. Defect A is untouched: the load valve keeps `l = 1e-4`, so `R_load` is unchanged, and the bypass is open, so its `l` plays no role. The run completes: in this run defect A alone does not cause a failure.



`Buildings.Templates.Components.Routing.Compliance` at the CHW supply junction, inside the idle loop, `C = 1e-5 kg/Pa` (`C * der(p) = port_a.m_flow`). With `comChiWatSup` (and `comHeaWatSup`) in `ValvesIsolation` the block becomes:

```
Iteration variables:  pumChiWat.valChe[1..3].dp, pumHeaWat.valChe[1..3].dp, valIso.port_aChiWat.m_flow, port_aChiWat.m_flow
Residual equations:
  0 = pumChiWat.pum[i].dpMachine - (pumChiWat.valChe[i].dp + comChiWatSup.p) + valHeaWatUniInlIso[i].port_b.p     i = 1..3
  0 = junHeaWatRet.ports[2].m_flow + m_flow_dp(valHeaWatUniInlIso[2].lin.dp, ...)
  0 = junChiWatRet.ports[i].m_flow + m_flow_dp(valChiWatUniInlIso[i].lin.dp, ...)                                     i = 1..3
  0 = junChiWatBypSup.port_3.m_flow + m_flow_dp(valChiWatMinByp.lin.dp, ...)
```

**The compliance removes defect B, not defect A.** With `comChiWatSup.p` a state, each `valChe[i].dp` is fixed by the pressure sum around its pump branch (first residual above, `p_i + dpMachine − valChe[i].dp = comChiWatSup.p`), in which it enters with coefficient −1; in the baseline `valChe[3].dp` entered only flow balances, through leak laws, with coefficient `∂ṁ/∂∆p ≈ 1.7e-7`. An HW-side residual can no longer be turned into kPa of `valChe[3].dp`. `port_aChiWat.m_flow` is still an iteration variable seen through `R_load`, so the amplifier of defect A remains; the block converges nonetheless:

```
                              baseline              compliance
Continuous time states        89                    91
Nonlinear systems             {52, 43, 43, 3,3,3}   {45, 3, 43, 43, 3,3,3}
  after manipulation          { 8,  1,  1, 1,1,1}   { 8, 1,  1,  1, 1,1,1}
 simulation.nonlinear[1]    : 96022 calls, 317424 residues, 96155 Jacobians   (3.3 residuals, 1.0 Jacobian per call; 0 NL failures)
 initialization.nonlinear[1..6]: 1 call each, 2–9 residues                     (baseline: init.nonlinear[3] 1225 residues, failed)
```

#### Why compliance is also effective for the chiller case?

With `use_cpl=true` the primary pump suction pressure is a state and the group ∆p is solved by a pressure sum `bouChiWat.p − com.p` (boundary value minus a state).
Bypass and chiller flows are evaluated forward (`m = m_flow_dp(Δp, k)`).
The bypass flow leaves the iteration set and residual 1 is linear in `valChe[2].dp`.

The simulation with the compliance component passes through the identical transition (`kVal` reaches leakage value) and completes the day with no NL solver failure.
The Leakage variant fails.
Steering the tearing with `__Dymola_SimulationIterationVariables` is untested.

### Cost (NL debug logging off; the debug log itself inflates CPU 15–21× and non-uniformly)

| variant             | CPU (s) | accepted | rejected | f-evals | Jac  | NL conv. failures | outcome              |
| ------------------- | ------- | -------- | -------- | ------- | ---- | ----------------- | -------------------- |
| baseline            | 0.37    | 1263     | 72       | 1973    | 94   | 69                | **FAILED** @ 22015.9 |
| Leakage             | 3.39    | 15932    | 564      | 24309   | 1353 | 886               | OK                   |
| Linearized          | 3.48    | 16895    | 575      | 25737   | 1388 | 926               | OK                   |
| Compliance `C=1E-5` | 4.07    | 21158    | 824      | 31234   | 1410 | 894               | OK                   |
| Compliance `C=1E-4` | 4.07    | 20188    | 1004     | 30992   | 1522 | 1005              | OK                   |

Per simulated second Compliance costs ~25 % more f-evaluations than Leakage/Linearized. `C = 1e-4` is not better (more rejected steps, Jacobians and convergence failures); `C = 1e-5` stays the default. Initialization CPU is 0.31–0.33 s for every variant.

### Cost with a distributed load: `HardCase1NLoads`, 12 terminal units per loop

`HardCase1NLoads` replaces the aggregated load with `nLoa=12` throttled terminal units tapped off supply/return mains, remote ∆p sensed upstream of the last unit; sizing is preserved so the design point is identical for any `nLoa`.

| variant (`nLoa=12`)  | CPU (s) | accepted | rejected | f-evals | Jac  | NL conv. failures | Newton failures         | outcome |
| -------------------- | ------- | -------- | -------- | ------- | ---- | ----------------- | ----------------------- | ------- |
| baseline             | 37.7    | 16895    | 518      | 25879   | 1363 | 887               | 1 init + 12 sim         | OK      |
| Compliance `C=1E-5`  | 32.6    | 19306    | 722      | 29191   | 1427 | 946               | 0                       | OK      |

- **The block grows with the distribution.** Nothing between the plant supply junction and the terminal valves carries a pressure state, so every takeoff adds algebraic pressure nodes to the same block: 8 (aggregated) → 10 (`nLoa=1`) → 13 (`nLoa=4`) → 31 (`nLoa=12`) iteration variables, CPU 3–4 s → 33–38 s.
- **The baseline no longer fails, by luck.** Its 12 Newton failures (cond 5e6–1.6e14, same signature) are all recovered by CVode step reduction. Same defects, different event grid.
- **Compliance pays for itself at scale.** It costs ~20 % CPU with one load and saves 14 % at `nLoa=12`, despite more steps and Jacobians: the supply-node states split the 31-variable block into two independent ones and the cost per f-evaluation drops 1.46 → 1.12 ms. Newton failures drop to zero.


---



---

## Common cause

|                                              | HP `HardCase1`                           | Chiller `HardCase1`                                 |
| -------------------------------------------- | ---------------------------------------- | --------------------------------------------------- |
| iteration variable                           | flow through the closed load valve       | flow through the closing chiller bypass             |
| ∆p from its `basicFlowFunction_m_flow` (`from_dp=false`) | `R_load = 3.1e8 Pa/(kg/s)`               | `R_byp` up to 7.8e6 Pa/(kg/s)                       |
| open branch evaluated forward from that ∆p   | minimum-flow bypass                      | chiller #1 isolation valve                          |
| gain on the iteration variable (log `J_sum`) | 8.6e3 – 1.7e7 (row 7)                    | 2.1e8 (row 1)                                       |
| amplifier over the run                       | constant: load valve closed all run      | grows as `1/kVal²` while the bypass closes          |
| HP-specific defect                           | B: `valChe[3].dp` tied by leak laws only | none: nothing floats                                |
| trigger                                      | HW-side residual at the start of a call  | bypass reaching its leakage floor                   |
| what the compliance removes                  | defect B; the amplifier remains          | the amplifier: bypass flow leaves the iteration set |
| `Leakage` (`l = 1e-3`)                       | passes                                   | fails                                               |

## Summary

Both failures share one cause, defect A: the tearing takes the flow through the closed branch of a parallel pair of valves as iteration variable, gets the pair's ∆p from the closed valve's `basicFlowFunction_m_flow` (`from_dp=false`), and evaluates the open branch from that ∆p with `basicFlowFunction_dp`. The open branch's residual then sees the iteration variable with a gain of `O(1/l²)`.

- **Chiller plant.** The run dies when the bypass reaches its leakage floor. The compliance on the pump suction header makes the group ∆p a boundary value minus a state, and the bypass flow leaves the iteration set.
- **HP plant.** Defect A alone does not fail this run; defect B does. With all units in heating, `valChe[3].dp` is tied to the rest of the block by leak laws only. An HW-side residual at the start of a call becomes a kPa error on it, Newton never moves it back, and the isolation-valve and bypass balances are left asking for different loop flows. Removing defect B is enough: `Leakage` passes, and the CHW supply compliance converges in about 3 residual evaluations per call. Defect A remains, and `HardCase1ComplianceCHW` shows it can still stall on its own.


## Appendix 1. When to use compliance and where?

**Use it** when at least one of these shows up in `dsmodel.mof`:
- A pressure is set only by leak laws (defect B), and the block also contains something that moves on its own. Typical case: CHW and HW loops sharing HP units behind isolation valves (HardCase1).
- Tearing gets a group ∆p from the `basicFlowFunction_m_flow` (`from_dp=false`) of a valve that closes during the run (defect A), e.g. the chiller bypass. The compliance must turn that ∆p into “boundary minus state”, e.g. at the pump suction.
- A large distributed network that the pressure state splits. In NLoads it cut a 31-unknown block into two and lowered total CPU despite more steps.

**Skip it** when the loop is hydraulically separate, has its own pressure boundary on a path that stays open, and its block has no HW/CHW coupling (HardCase3, 4-pipe or standalone loops). Quick check: if enabling compliance leaves the block sizes and iteration variables unchanged and removes no leak-law-only unknown, it only adds a stiff state (τ = C · ∂∆p/∂ṁ, about 10 ms with flow).

**Two roles per loop.** For the compliance to pin the check valves, a loop needs:
1. A pressure reference at the pump suction (primary return / common leg): the expansion-tank role.
2. A known pressure downstream of *all* pump check valves: the pinning role. `com*WatSec` sits at the plant supply outlet (`V*WatLooOrSec_flow.port_a`), i.e. after the secondary pumps if any, else after the primary pumps, whether dedicated or headered. Sensors, pass-through tanks and junctions have zero ∆p, so in primary-only plants this is the same pressure as the primary pump outlet.

| `typ`, distribution                | Reference (pump suction)                   | Pinning (supply outlet) |
| ---------------------------------- | ------------------------------------------ | ----------------------- |
| HW, all but Polyvalent             | `bouHeaWat`                                | `comHeaWatSec`          |
| CHW, reversible, primary-only      | none; reached through the HPs to `bouHeaWat` | `comChiWatSec`          |
| CHW, reversible, primary-secondary | `comChiWatRet`                             | `comChiWatSec`          |
| Polyvalent (HW and CHW)            | `bouHeaWat`, `bouChiWat`                   | none (excluded)         |

**Why `comChiWatRet` only with secondary pumps.** A compliance merges nonlinear systems only if it puts an absolute pressure into a subnet that until then involved only pressure differences.
- *Primary-secondary (HardCase4):* the secondary loop meets the plant at one node, the zero-∆p common leg (fixed bypass, `Valve.None`), so it solves on its own from Σ∆p = 0. `comChiWatSec` alone makes the pump and load flows depend on the common-leg pressure, which is set only through the primary loop, the HPs and `bouHeaWat`. The CHW secondary 2×2 and the primary 3×3 merged into a 6×6. On the HW side, `bouHeaWat` fixes the common leg and the secondary 2×2 splits into 1+1. `comChiWatRet` gives the CHW common leg the same known pressure.
- *Primary-only:* the loop with the compliance already runs through the HPs to `bouHeaWat`, and its return pressure is already an unknown of that system. A known supply pressure can only split it. HardCase2 went from a 12×12 to 4×4 (HW) + 7×7 (CHW), with the old `valIso` placement.

**Caveats**
- *Placement.* The old `valIso.comChiWatSup` at `ValvesIsolation.port_bChiWat` is downstream of the check valves with dedicated pumps but at the pump suction with headered pumps, where it failed (HardCase2). The supply-outlet placement avoids this in every configuration.
- *Why a compliance and not a second `bouChiWat` on reversible plants:* CHW and HW are joined through the HP isolation valves. Two fixed boundaries would drive a permanent leak flow between them, carrying their fixed temperatures. `comChiWatRet` settles to the pressure `bouHeaWat` imposes and then carries no flow. Both nominal pressures are 2.5e5 Pa.
- *A bypass resistance is not an alternative to `comChiWatRet`.* Any ∆p across the common leg couples primary and secondary flows, so the merge happens without compliance.
- *Polyvalent is excluded on empirical grounds only.* HardCase3 showed no gain, but with the old `valIso` placement. The supply-outlet placement is untested there, and `HardCase3Compliance` now translates to the same model as HardCase3.
- *Cost.* Each compliance adds a fast state. HardCase4Compliance, before `comChiWatRet` was added: +11% steps and 734 vs 609 rejected steps. The HW split did not reduce residual calls (234k → 236k + 247k, plus 254k for the new 1×1 load branch). Both HardCase4 runs hit the same Newton failure in the CHW secondary block (t ≈ 57070 s). HardCase4 with `comChiWatRet` is not yet tested.
- *Coil "flow direction reversed" warnings* (e.g. HardCase2Compliance, `loaHea`, −51 kg/s at t ≈ 27170 s) come from CVODE trial points, where the stiff compliance pressure is off by several bar. On accepted steps (`equidistant=false`) the flow never reverses. The warning moves with the output settings and disappears at tol=1e-8. Ignore it; `use_dynamicFlowRegime=true` would only hide it.
- Always diff the nonlinear system sizes and iteration variables in `dsmodel.mof` with and without `use_cpl`.


## Appendix 2. Is the HW compliance needed? `HardCase1ComplianceCHW`, `use_cpl=true, use_cplHw=false`

Only the CHW loop can lose its pressure reference, so in principle the HW compliance is redundant. It is not: besides adding a state it **splits the block**. With both, the HW loop is its own 1×1 system (`0 = loaHea.val.dp − comHeaWatSup.p + pipHeaWat.dp + bouHeaWat.p`) and block 1 holds 8 CHW/check valve unknowns; with CHW only, the HW supply pressure is rebuilt algebraically and the HW loop flow and min-bypass row join block 1 (9 unknowns). The run still completes (58.5 s, faster than either), but three Newton failures survive: `initialization.nonlinear[3]` (772 residues, rescued by global homotopy; 2 residues with both) and two at t = 19172.6 / 19174.3, the start of HW pump 1.

These two failures are defect A on its own. There the CHW side is dead (all pumps off, load valve shut) yet not idle: pump 1 pulls node 1 down 24.2 kPa below `comChiWatSup.p` and pushes 4.07e-4 kg/s through the closed `valChiWatUniInlIso[1]`, out through the min bypass. `comChiWatSup.p` is a state, but `port_aChiWat.m_flow` *still* reaches the rows only through the closed load valve's `basicFlowFunction_m_flow` (`from_dp=false`), so it must be resolved at 2.4e-11 with `∂r/∂m_load = 1 + R_load · ∂m_byp/∂∆p = 1.66e7` on the bypass row (row 8 of this 9×9 block; log: `J_sum` = 1.65737e7). The HW transient in the same block keeps kicking it past the bypass breakpoint `dp_turb = 14.0 Pa` ⇔ `m_load = 4.5e-8`: at the stall the iterate sits at −9.58e-8, i.e. −30 Pa across the bypass and a phantom 0.77 kg/s of bypass flow — exactly the printed residual. `J_sum` of that row alternates 5.3e5 ↔ 5e6 and the scaled residual limit-cycles between 1.2e-6 and 1.1e-5, never reaching tolerance; `cond = 2.2e6`, nowhere near singular. The trajectory is unaffected (both were rejected steps).



OCT findings



Several torn equations compute a closed valve’s Δp from its flow, via basicFlowFunction_m_flow ***even with from_dp=true***:

- valHeaWatUniInlIso[1], valChiWatUniInlIso[1] and valChiWatUniInlIso[2]: HP 1 is isolated, and HP 2’s CHW side is closed.
- valHeaWatUniInlIso[3], plus the load valves loaCoo and loaHea. This is the load-side defect A from earlier.

Why setting from_dp doesn’t help?

basicFlowFunction_dp and basicFlowFunction_m_flow each carry an inverse() annotation pointing to the other. So even with from_dp=true, the default in ValvesIsolation, the compiler is allowed to invert the law, and OCT does so for closed valves. Changing from_dp or other tearing hints on the valves is therefore unlikely to fix this.
