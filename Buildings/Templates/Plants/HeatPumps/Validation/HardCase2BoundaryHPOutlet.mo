within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2BoundaryHPOutlet "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2(
    pla(locBou=Buildings.Templates.Plants.HeatPumps.Types.LocationBoundary.HeatPumpOutlet))
    annotation(IconMap(primitivesVisible = false));

annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(revisions="",
        info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase2BoundaryHPOutlet
Integration started at 0 using integration method:
cvode from sundials

SUNDIALS: CVODE CVode At t = 42139.7, mxstep steps taken before reaching tout.

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 58930.36203277003
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

  Jacobian inverse norm estimate: 4.26867e+07
  Condition number estimate: 3.67607e+07
  1-norm of the residual = 61.7281
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatPri.valChe[3].dp = 1011.01
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 351457
    pla.pumHeaWatPri.valChe[2].dp = -0.000226734
    pla.pumHeaWatPri.valChe[3].dp = -0.000222918
    pla.valIso.valHeaWatUniOutIso[1].lin.dp = 1900.43
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 351460
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 9351.24
    pla.pumChiWatPri.valChe[2].dp = 1011.01
    pla.valIso.port_aChiWat.m_flow = 2.42276
    pla.port_aChiWat.m_flow = 1.67584
    pipHeaWat.port_b.p = 349425
    pla.valIso.port_aHeaWat.m_flow = 2.87577E-07
  Last value of the residual:
    { 38.8685, -6.24036E-05, -11.2968, -11.257, -6.29755E-05,
      -3.1897E-06, 0.303793, 0.00190344, 6.45183E-06, 1.39202E-07,
      -3.8159E-06, -2.87648E-07 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.77401 seconds
   CPU-time for initialization               : 0.351493 seconds
   Number of result points                   : 1983
   Number of grid points                     : 501
   Number of accepted steps                  : 16887
   Number of rejected steps                  : 554
   Number of f-evaluations (dynamics)        : 25708
   Number of non-linear iteration            : 24146
   Number of non-linear convergence failures : 855
   Number of Jacobian-evaluations            : 1442
   Number of crossing function evaluations   : 20497
   Number of model time events               : 477
   Number of state events                    : 266
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2BoundaryHPOutlet"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase2BoundaryHPOutlet;
