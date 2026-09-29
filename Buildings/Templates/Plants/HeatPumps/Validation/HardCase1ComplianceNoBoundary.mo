within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1ComplianceNoBoundary
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1(
    pla(use_cpl=true, use_bouHeaWat=false, use_bouChiWat=false))
    annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="SUNDIALS: CVODE CVode At t = 51197.3, mxstep steps taken before reaching tout.
SUNDIALS: CVODE CVode At t = 64596.9, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.59872 seconds
   CPU-time for initialization               : 0.322768 seconds
   Number of result points                   : 1629
   Number of grid points                     : 501
   Number of accepted steps                  : 18298
   Number of rejected steps                  : 608
   Number of f-evaluations (dynamics)        : 28063
   Number of non-linear iteration            : 26855
   Number of non-linear convergence failures : 978
   Number of Jacobian-evaluations            : 1468
   Number of crossing function evaluations   : 20903
   Number of model time events               : 419
   Number of state events                    : 147
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1ComplianceNoBoundary

------------------ OCT 152 NonlinearBlockConvergenceError

Final Run Statistics: ---

 Number of steps                                 : 18744
 Number of function evaluations                  : 29233
 Number of Jacobian evaluations                  : 1574
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 615
 Number of nonlinear iterations                  : 26981
 Number of nonlinear convergence failures        : 442
 Number of state function evaluations            : 21267
 Number of state events                          : 146
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
 1.e-01 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01
 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 27.73620094099897 seconds."),
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
end HardCase1ComplianceNoBoundary;
