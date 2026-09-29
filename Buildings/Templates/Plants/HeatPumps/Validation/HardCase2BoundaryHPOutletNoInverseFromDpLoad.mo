within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2BoundaryHPOutletNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2BoundaryHPOutlet(
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
  __Dymola_Algorithm="Cvode"), Documentation(revisions="",
        info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase2BoundaryHPOutletNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 7.0206 seconds
   CPU-time for initialization               : 0.35707 seconds
   Number of result points                   : 2011
   Number of grid points                     : 501
   Number of accepted steps                  : 16446
   Number of rejected steps                  : 570
   Number of f-evaluations (dynamics)        : 25285
   Number of non-linear iteration            : 23674
   Number of non-linear convergence failures : 850
   Number of Jacobian-evaluations            : 1444
   Number of crossing function evaluations   : 20158
   Number of model time events               : 478
   Number of state events                    : 279
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2BoundaryHPOutletNoInverseFromDpLoad

------------------- OCT 0 NonlinearBlockConvergenceError !!

Final Run Statistics: --- e+04

 Number of steps                                 : 17612
 Number of function evaluations                  : 28118
 Number of Jacobian evaluations                  : 1629
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 598
 Number of nonlinear iterations                  : 25118
 Number of nonlinear convergence failures        : 413
 Number of state function evaluations            : 21257
 Number of state events                          : 273
 Number of time events                           : 473

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
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04
 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 36.038858812997205 seconds.

"), Icon(graphics={
        Ellipse(fillColor={255,255,0},
                fillPattern=FillPattern.Solid,
                extent={{-100,-100},{100,100}},
          pattern=LinePattern.None),
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
end HardCase2BoundaryHPOutletNoInverseFromDpLoad;
