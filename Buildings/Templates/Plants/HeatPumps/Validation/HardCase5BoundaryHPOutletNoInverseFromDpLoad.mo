within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase5BoundaryHPOutletNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase5NoInverseFromDpLoad(
    pla(locBou=Buildings.Templates.Plants.HeatPumps.Types.LocationBoundary.HeatPumpOutlet))
      annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase5BoundaryHPOutletNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 83925.43290523437
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

  Jacobian inverse norm estimate: 1.97258e+12
  Condition number estimate: 7.99048e+11
  1-norm of the residual = 3.47915
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[3].dp = 228.735
    pla.valHeaWatMinByp.lin.dp = 0.6226
    pla.valIso.port_aHeaWat.m_flow = 0.0152838
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 318091
    pla.valIso.valHeaWatUniOutIso[1].lin.dp = 33165.4
    pla.pumHeaWatPri.valChe[2].dp = 228.731
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 308913
    pla.pumChiWatPri.valChe[3].dp = 3717.14
    pla.pumChiWatPri.valChe[2].dp = -148959
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 97595.9
    pla.valIso.port_aChiWat.m_flow = 26.7711
    loaCoo.con.val.valEqu.dp = 49721.3
  Last value of the residual:
    { 0.715324, -4.98237E-05, -1.32624, 0.407677, -4.84247E-07,
      -0.610916, 0.413858, -0.000948846, -2.37067E-05, -0.00374495,
      -3.51432E-07, 0.000366557 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 83925.04879999766
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.07888e+12
  Condition number estimate: 3.20779e+11
  1-norm of the residual = 6.65854
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[3].dp = 394.373
    pla.valHeaWatMinByp.lin.dp = 3.08462
    pla.valIso.port_aHeaWat.m_flow = 0.0729651
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 318109
    pla.valIso.valHeaWatUniOutIso[1].lin.dp = 33182.3
    pla.pumHeaWatPri.valChe[2].dp = 394.369
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 308899
    pla.pumChiWatPri.valChe[3].dp = 3717.65
    pla.pumChiWatPri.valChe[2].dp = -148994
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 97627.1
    pla.valIso.port_aChiWat.m_flow = 26.7754
    loaCoo.con.val.valEqu.dp = 49716
  Last value of the residual:
    { 0.563051, -3.76165E-05, -2.33388, 1.66137, -2.63102E-07,
      -1.77083, 0.324391, -0.000794603, -1.99136E-05, -0.00388667,
      -2.06649E-06, 0.000281902 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 83925.17055543658
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.03021e+12
  Condition number estimate: 7.15316e+11
  1-norm of the residual = 8.79743
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[3].dp = 311.5
    pla.valHeaWatMinByp.lin.dp = 1.54505
    pla.valIso.port_aHeaWat.m_flow = 0.0368615
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 318145
    pla.valIso.valHeaWatUniOutIso[1].lin.dp = 33183.2
    pla.pumHeaWatPri.valChe[2].dp = 311.498
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 308906
    pla.pumChiWatPri.valChe[3].dp = 3717.39
    pla.pumChiWatPri.valChe[2].dp = -148983
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 97611.1
    pla.valIso.port_aChiWat.m_flow = 26.7732
    loaCoo.con.val.valEqu.dp = 49714.7
  Last value of the residual:
    { -0.0671615, -1.44967E-05, -2.85047, 2.88668, -7.7767E-08,
      -2.91763, 0.0738532, -1.81594E-05, -1.30759E-05, -0.00148782,
      -4.81391E-07, 9.41965E-05 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 83925.33139540897
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.3972e+12
  Condition number estimate: 5.71064e+11
  1-norm of the residual = 11.397
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[3].dp = 255.562
    pla.valHeaWatMinByp.lin.dp = 0.858719
    pla.valIso.port_aHeaWat.m_flow = 0.0208602
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 318161
    pla.valIso.valHeaWatUniOutIso[1].lin.dp = 33173.7
    pla.pumHeaWatPri.valChe[2].dp = 255.559
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 308910
    pla.pumChiWatPri.valChe[3].dp = 3717.13
    pla.pumChiWatPri.valChe[2].dp = -148969
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 97594.5
    pla.valIso.port_aChiWat.m_flow = 26.7709
    loaCoo.con.val.valEqu.dp = 49715.1
  Last value of the residual:
    { -0.242243, -1.72589E-05, -3.48605, 3.71969, -2.18976E-08,
      -3.72829, 0.21654, -0.000749002, -4.82369E-06, -0.00305379,
      -1.4047E-07, 0.000330644 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.32012 seconds
   CPU-time for initialization               : 0.340569 seconds
   Number of result points                   : 1963
   Number of grid points                     : 501
   Number of accepted steps                  : 16226
   Number of rejected steps                  : 576
   Number of f-evaluations (dynamics)        : 24561
   Number of non-linear iteration            : 23006
   Number of non-linear convergence failures : 712
   Number of Jacobian-evaluations            : 1275
   Number of crossing function evaluations   : 19815
   Number of model time events               : 474
   Number of state events                    : 259
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase5BoundaryHPOutletNoInverseFromDpLoad


---------------- OCT 8 NonlinearBlockConvergenceError

Final Run Statistics: ---

 Number of steps                                 : 17206
 Number of function evaluations                  : 27226
 Number of Jacobian evaluations                  : 1451
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 616
 Number of nonlinear iterations                  : 24278
 Number of nonlinear convergence failures        : 312
 Number of state function evaluations            : 20939
 Number of state events                          : 263
 Number of time events                           : 471

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-08 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-01 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01
 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06
 1.e-01 3.e-04 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01
 1.e-01 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-01
 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 1.e-01 1.e-01 3.e-04 3.e-04 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01
 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 35.19142799799738 seconds.

"), Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={244,125,35},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase5BoundaryHPOutletNoInverseFromDpLoad;
