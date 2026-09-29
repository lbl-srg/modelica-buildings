within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase3NoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase3(
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
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase3NoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.83987 seconds
   CPU-time for initialization               : 0.343511 seconds
   Number of result points                   : 2261
   Number of grid points                     : 501
   Number of accepted steps                  : 21593
   Number of rejected steps                  : 906
   Number of f-evaluations (dynamics)        : 33389
   Number of non-linear iteration            : 31331
   Number of non-linear convergence failures : 986
   Number of Jacobian-evaluations            : 1716
   Number of crossing function evaluations   : 25846
   Number of model time events               : 473
   Number of state events                    : 409
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase3NoInverseFromDpLoad

---------------- OCT 9 NonlinearBlockConvergenceError

Final Run Statistics: --- e+04

 Number of steps                                 : 22833
 Number of function evaluations                  : 36970
 Number of Jacobian evaluations                  : 1962
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 1057
 Number of nonlinear iterations                  : 33216
 Number of nonlinear convergence failures        : 482
 Number of state function evaluations            : 27729
 Number of state events                          : 461
 Number of time events                           : 475

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-06 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04
 3.e-04 3.e-04 1.e-06 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 3.e-04 3.e-04
 1.e-06 1.e-06 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-01 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01
 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-06
 1.e-01 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04
 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04
 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06
 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 35.574740289001056 seconds.

"),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase3NoInverseFromDpLoad;
