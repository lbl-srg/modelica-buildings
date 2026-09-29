within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase3ComplianceNoBoundaryNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase3(
    pla(use_cpl=true, use_bouHeaWat=false, use_bouChiWat=false,
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
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase3ComplianceNoBoundaryNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.60562 seconds
   CPU-time for initialization               : 0.343414 seconds
   Number of result points                   : 2265
   Number of grid points                     : 501
   Number of accepted steps                  : 20977
   Number of rejected steps                  : 884
   Number of f-evaluations (dynamics)        : 32491
   Number of non-linear iteration            : 30420
   Number of non-linear convergence failures : 987
   Number of Jacobian-evaluations            : 1713
   Number of crossing function evaluations   : 25183
   Number of model time events               : 474
   Number of state events                    : 410
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase3ComplianceNoBoundaryNoInverseFromDpLoad

----------------------- OCT 6 NL failures

Final Run Statistics: --- e+04

 Number of steps                                 : 22478
 Number of function evaluations                  : 36406
 Number of Jacobian evaluations                  : 1927
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 1022
 Number of nonlinear iterations                  : 32646
 Number of nonlinear convergence failures        : 481
 Number of state function evaluations            : 27375
 Number of state events                          : 462
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
 1.e-01 1.e-01 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06
 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04
 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 37.621316657001444 seconds."),
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
end HardCase3ComplianceNoBoundaryNoInverseFromDpLoad;
