within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase6BoundaryHPOutletNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase6NoInverseFromDpLoad(
    pla(locBou=Buildings.Templates.Plants.HeatPumps.Types.LocationBoundary.HeatPumpOutlet))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase6BoundaryHPOutletNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials

SUNDIALS: CVODE CVode At t = 66027.8, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.97322 seconds
   CPU-time for initialization               : 0.320296 seconds
   Number of result points                   : 1695
   Number of grid points                     : 501
   Number of accepted steps                  : 16751
   Number of rejected steps                  : 588
   Number of f-evaluations (dynamics)        : 25693
   Number of non-linear iteration            : 24396
   Number of non-linear convergence failures : 918
   Number of Jacobian-evaluations            : 1431
   Number of crossing function evaluations   : 19813
   Number of model time events               : 422
   Number of state events                    : 177
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase6BoundaryHPOutletNoInverseFromDpLoad

--------------- OCT 226 NonlinearBlockConvergenceError

Final Run Statistics: --- e+04

 Number of steps                                 : 18040
 Number of function evaluations                  : 28070
 Number of Jacobian evaluations                  : 1564
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 623
 Number of nonlinear iterations                  : 25685
 Number of nonlinear convergence failures        : 446
 Number of state function evaluations            : 20951
 Number of state events                          : 175
 Number of time events                           : 419

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-08 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01
 1.e-01 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06 1.e-01 3.e-04
 1.e-01 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-01
 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 1.e-01 1.e-01 3.e-04 3.e-04 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04
 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 25.568338152999786 seconds."),
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
end HardCase6BoundaryHPOutletNoInverseFromDpLoad;
