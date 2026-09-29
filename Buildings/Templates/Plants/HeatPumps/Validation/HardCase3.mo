within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase3 "Validation of AWHP plant template"
  // Polyvalent HP => CHW and HW loops not connected!
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent(
    pla(linearized=false,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      ctl(have_senTLooRet_select=true, have_senDpHeaWatRemWir=false)))
      annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase3
Integration started at 0 using integration method:
cvode from sundials


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.53022 seconds
   CPU-time for initialization               : 0.353246 seconds
   Number of result points                   : 2251
   Number of grid points                     : 501
   Number of accepted steps                  : 21232
   Number of rejected steps                  : 904
   Number of f-evaluations (dynamics)        : 32825
   Number of non-linear iteration            : 30781
   Number of non-linear convergence failures : 975
   Number of Jacobian-evaluations            : 1695
   Number of crossing function evaluations   : 25462
   Number of model time events               : 474
   Number of state events                    : 403
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase3


--------------------------- OCT 85 NonlinearBlockConvergenceError

Final Run Statistics: --- e+04

 Number of steps                                 : 122989
 Number of function evaluations                  : 152140
 Number of Jacobian evaluations                  : 3640
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 1026
 Number of nonlinear iterations                  : 148386
 Number of nonlinear convergence failures        : 485
 Number of state function evaluations            : 127859
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
Elapsed simulation time: 110.94869557499987 seconds.

"), Icon(graphics={
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
end HardCase3;
