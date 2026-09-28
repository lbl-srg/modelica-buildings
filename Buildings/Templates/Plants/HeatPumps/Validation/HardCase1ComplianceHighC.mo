within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1ComplianceHighC "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1Compliance(
    pla(C=1E-4));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Sizes after manipulation of the nonlinear systems: {1, 8, 1, 1, 1, 1, 1}
Number of numerical Jacobians: 2

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.31433 seconds
   CPU-time for initialization               : 0.309562 seconds
   Number of result points                   : 1661
   Number of grid points                     : 501
   Number of accepted steps                  : 19773
   Number of rejected steps                  : 992
   Number of f-evaluations (dynamics)        : 30829
   Number of non-linear iteration            : 29585
   Number of non-linear convergence failures : 1021
   Number of Jacobian-evaluations            : 1542
   Number of crossing function evaluations   : 22550
   Number of model time events               : 422
   Number of state events                    : 160
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1ComplianceHighC

 Number of steps                                 : 20521
 Number of function evaluations                  : 32564
 Number of Jacobian evaluations                  : 1607
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 1006
 Number of nonlinear iterations                  : 30166
 Number of nonlinear convergence failures        : 377
 Number of state function evaluations            : 23471
 Number of state events                          : 178
 Number of time events                           : 419

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
Elapsed simulation time: 25.230557705999672 seconds."));
end HardCase1ComplianceHighC;
