within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2NoInverse "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2(
    pla(
      valIso(
        valHeaWatUniOutIso(lin(each use_inv=false)),
        valHeaWatUniInlIso(lin(each use_inv=false)),
        valChiWatUniOutIso(lin(each use_inv=false)),
        valChiWatUniInlIso(lin(each use_inv=false))),
      valHeaWatMinByp(lin(use_inv=false)),
      valChiWatMinByp(lin(use_inv=false))))
  annotation(IconMap(primitivesVisible = false));

annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(revisions="",
        info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase2NoInverse
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 83928.28785435818
  Tag: simulation.nonlinear[1]

  Common causes:
   * The system of equations has no solution - the residual will be above zero.
     - In some cases the event-logic can cause this.
   * Starting values are too far from the solution.
     - In rare cases this could occur at events.
   * The equations are too discontinuous for the nonlinear solver - the residual will have knees.
     - Likely caused by over-using noEvent.

  To get more information consider the options:
   * Simulation/Setup/Translation/Generate listing of translated Modelica code in dsmodel.mof
   * Simulation/Setup/Translation/List non-linear iteration variables
   * The options under the group Simulation/Setup/Debug/Nonlinear solver diagnostics

  Jacobian inverse norm estimate: 8.93968e+11
  Condition number estimate: 6.39184e+11
  1-norm of the residual = 22.729
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valHeaWatMinByp.lin.dp = 11.442
    pla.pumHeaWatPri.valChe[3].dp = 514.179
    pla.pumChiWatPri.valChe[3].dp = 2746.11
    pla.port_aChiWat.m_flow = 2.38216
    pla.pumChiWatPri.valChe[2].dp = 2746.1
    pla.valIso.valHeaWatUniOutIso[1].lin.dp = 29704.9
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 87391.9
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 343110
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 351325
    pla.valIso.port_aChiWat.m_flow = 25.3329
    pla.pumHeaWatPri.valChe[2].dp = 514.178
    pla.VHeaWatPri_flow.port_a.m_flow = 0.233259
  Last value of the residual:
    { 20.2606, 0.780526, -3.64323E-05, -0.139103, -0.73591,
      0.139102, 0.641425, -0.0310595, -0.000364706, -0.000242185,
      -0.000672569, -9.54512E-07 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 7.17364 seconds
   CPU-time for initialization               : 0.369084 seconds
   Number of result points                   : 1981
   Number of grid points                     : 501
   Number of accepted steps                  : 16633
   Number of rejected steps                  : 578
   Number of f-evaluations (dynamics)        : 25553
   Number of non-linear iteration            : 23986
   Number of non-linear convergence failures : 878
   Number of Jacobian-evaluations            : 1458
   Number of crossing function evaluations   : 20196
   Number of model time events               : 478
   Number of state events                    : 264
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2NoInverse"));
end HardCase2NoInverse;
