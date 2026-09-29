within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase4NoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase4(
    pla(
      valIso(
        valHeaWatUniOutIso(lin(each use_inv=false)),
        valHeaWatUniInlIso(lin(each use_inv=false)),
        valChiWatUniOutIso(lin(each use_inv=false)),
        valChiWatUniInlIso(lin(each use_inv=false))),
      valHeaWatMinByp(lin(use_inv=false)),
      valChiWatMinByp(lin(use_inv=false))),
    loaCoo(con(val(from_dp=true, valEqu(use_inv=false)))),
    loaHea(con(val(from_dp=true, valEqu(use_inv=false)))))
      annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase4NoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.58057 seconds
   CPU-time for initialization               : 0.356884 seconds
   Number of result points                   : 2129
   Number of grid points                     : 501
   Number of accepted steps                  : 19092
   Number of rejected steps                  : 612
   Number of f-evaluations (dynamics)        : 29388
   Number of non-linear iteration            : 27498
   Number of non-linear convergence failures : 938
   Number of Jacobian-evaluations            : 1618
   Number of crossing function evaluations   : 23166
   Number of model time events               : 475
   Number of state events                    : 341
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase4NoInverseFromDpLoad

---------------------- OCT 18 NonlinearBlockConvergenceError

Final Run Statistics: --- e+04

 Number of steps                                 : 19981
 Number of function evaluations                  : 31892
 Number of Jacobian evaluations                  : 1760
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 684
 Number of nonlinear iterations                  : 28585
 Number of nonlinear convergence failures        : 450
 Number of state function evaluations            : 24158
 Number of state events                          : 350
 Number of time events                           : 475

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-06 1.e-06
 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06
 1.e-01 1.e-06 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-01 1.e-01 1.e-06 1.e-01
 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04
 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 35.139640304998466 seconds."),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={244,125,35},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase4NoInverseFromDpLoad;
