within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1BoundaryHPOutletNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1BoundaryHPOutlet(
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
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1BoundaryHPOutletNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials

SUNDIALS: CVODE CVode At t = 22020.1, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 3.78965 seconds
   CPU-time for initialization               : 0.324315 seconds
   Number of result points                   : 1617
   Number of grid points                     : 501
   Number of accepted steps                  : 16474
   Number of rejected steps                  : 549
   Number of f-evaluations (dynamics)        : 24820
   Number of non-linear iteration            : 23628
   Number of non-linear convergence failures : 879
   Number of Jacobian-evaluations            : 1357
   Number of crossing function evaluations   : 19154
   Number of model time events               : 418
   Number of state events                    : 142
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1BoundaryHPOutletNoInverseFromDpLoad

-------------------- OCT 0 NonlinearBlockConvergenceError  !!!

Final Run Statistics: --- e+04

 Number of steps                                 : 17182
 Number of function evaluations                  : 27025
 Number of Jacobian evaluations                  : 1550
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 535
 Number of nonlinear iterations                  : 24789
 Number of nonlinear convergence failures        : 454
 Number of state function evaluations            : 19684
 Number of state events                          : 142
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
Elapsed simulation time: 18.275705631000164 seconds.",
        revisions=""),
    Icon(graphics={
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
end HardCase1BoundaryHPOutletNoInverseFromDpLoad;
