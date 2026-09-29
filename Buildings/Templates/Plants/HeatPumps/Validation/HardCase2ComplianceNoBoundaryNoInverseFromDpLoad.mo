within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2ComplianceNoBoundaryNoInverseFromDpLoad
  "Validation of AWHP plant template"
  // Diagnostic only: load valves in dp form without inverse annotation
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2ComplianceNoBoundaryNoInverse(
    loaCoo(con(val(from_dp=true, valEqu(use_inv=false)))),
    loaHea(con(val(from_dp=true, valEqu(use_inv=false)))))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase2NoInverseComplianceNoBoundaryFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 7.5677 seconds
   CPU-time for initialization               : 0.349313 seconds
   Number of result points                   : 2007
   Number of grid points                     : 501
   Number of accepted steps                  : 16804
   Number of rejected steps                  : 589
   Number of f-evaluations (dynamics)        : 25626
   Number of non-linear iteration            : 24047
   Number of non-linear convergence failures : 845
   Number of Jacobian-evaluations            : 1427
   Number of crossing function evaluations   : 20521
   Number of model time events               : 479
   Number of state events                    : 276
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2NoInverseComplianceNoBoundaryFromDpLoad


------------------ OCT 0 FAILURE !
Warning: Possible chattering detected at t = 7.223695e+04 in state event(s): [191]
Final Run Statistics: --- e+04

 Number of steps                                 : 18282
 Number of function evaluations                  : 28943
 Number of Jacobian evaluations                  : 1654
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 622
 Number of nonlinear iterations                  : 25946
 Number of nonlinear convergence failures        : 409
 Number of state function evaluations            : 21872
 Number of state events                          : 272
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
 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01
 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01
 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 34.947629876000065 seconds."),
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
end HardCase2ComplianceNoBoundaryNoInverseFromDpLoad;
