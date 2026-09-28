within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1ComplianceHighCNoBoundary
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1Compliance(
    pla(C=1E-4, use_bouHeaWat=false, use_bouChiWat=false))
    annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="SUNDIALS: CVODE CVode At t = 36019.1, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.29888 seconds
   CPU-time for initialization               : 0.312916 seconds
   Number of result points                   : 1667
   Number of grid points                     : 501
   Number of accepted steps                  : 17915
   Number of rejected steps                  : 637
   Number of f-evaluations (dynamics)        : 27203
   Number of non-linear iteration            : 25955
   Number of non-linear convergence failures : 953
   Number of Jacobian-evaluations            : 1452
   Number of crossing function evaluations   : 20688
   Number of model time events               : 423
   Number of state events                    : 162
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1ComplianceHighCNoBoundary

Final Run Statistics: ---

 Number of steps                                 : 17566
 Number of function evaluations                  : 27664
 Number of Jacobian evaluations                  : 1535
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 618
 Number of nonlinear iterations                  : 25322
 Number of nonlinear convergence failures        : 434
 Number of state function evaluations            : 20313
 Number of state events                          : 168
 Number of time events                           : 416

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
Elapsed simulation time: 24.804208336001466 seconds."));
end HardCase1ComplianceHighCNoBoundary;
