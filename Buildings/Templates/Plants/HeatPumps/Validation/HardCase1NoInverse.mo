within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1NoInverse "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1(
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
  __Dymola_Algorithm="Cvode"), Documentation(info="Integration terminated unsuccesfully at T = 22015.9
   CPU-time for integration                  : 0.414445 seconds
   CPU-time for initialization               : 0.342637 seconds
   Number of result points                   : 341
   Number of grid points                     : 128
   Number of accepted steps                  : 1263
   Number of rejected steps                  : 72
   Number of f-evaluations (dynamics)        : 1973
   Number of non-linear iteration            : 1858
   Number of non-linear convergence failures : 69
   Number of Jacobian-evaluations            : 94
   Number of crossing function evaluations   : 1638
   Number of model time events               : 94
   Number of state events                    : 13
   Number of step events                     : 0
   Maximum integration order                 : 5

ERROR: The simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NoInverse FAILED


Final Run Statistics: ---

 Number of steps                                 : 17779
 Number of function evaluations                  : 27734
 Number of Jacobian evaluations                  : 1595
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 517
 Number of nonlinear iterations                  : 25485
 Number of nonlinear convergence failures        : 480
 Number of state function evaluations            : 20303
 Number of state events                          : 145
 Number of time events                           : 415

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-08 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01
 1.e-06 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01
 1.e-01 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06 1.e-01 3.e-04
 1.e-01 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-01
 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04
 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 19.816927906000274 seconds."),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase1NoInverse;
