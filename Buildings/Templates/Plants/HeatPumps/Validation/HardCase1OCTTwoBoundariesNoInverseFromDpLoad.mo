within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1OCTTwoBoundariesNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCT(
    pla(
      use_bouChiWat=true,
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
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTTwoBoundariesNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.57875 seconds
   CPU-time for initialization               : 0.318067 seconds
   Number of result points                   : 1981
   Number of grid points                     : 501
   Number of accepted steps                  : 19880
   Number of rejected steps                  : 839
   Number of f-evaluations (dynamics)        : 30569
   Number of non-linear iteration            : 28790
   Number of non-linear convergence failures : 884
   Number of Jacobian-evaluations            : 1519
   Number of crossing function evaluations   : 24343
   Number of model time events               : 446
   Number of state events                    : 296
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTTwoBoundariesNoInverseFromDpLoad

------------- OCT 25 NonlinearBlockConvergenceError

Final Run Statistics: --- e+04

 Number of steps                                 : 20786
 Number of function evaluations                  : 33260
 Number of Jacobian evaluations                  : 1722
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 916
 Number of nonlinear iterations                  : 30209
 Number of nonlinear convergence failures        : 416
 Number of state function evaluations            : 25608
 Number of state events                          : 316
 Number of time events                           : 445

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-06 1.e-06
 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06 1.e-01 3.e-04 1.e-01
 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-01 1.e-01
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04
 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 27.613185277998127 seconds."),
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
end HardCase1OCTTwoBoundariesNoInverseFromDpLoad;
