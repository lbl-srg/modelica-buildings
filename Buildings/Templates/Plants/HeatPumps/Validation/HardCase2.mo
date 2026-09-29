within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2 "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversibleHeatRecovery(
    pla(linearized=false,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      ctl(have_senDpHeaWatRemWir=false),
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversibleHeatRecovery))
    annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(revisions="",
        info="linearized=true is detrimental in this case!
- with linearized=true: simulation fails on native amd64 Linux, succeeds on emulated amd64.
- with linearized=false: simulation SUCCEEDS on native amd64 Linux as well.


Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase2
Integration started at 0 using integration method:
cvode from sundials

SUNDIALS: CVODE CVode At t = 27153.6, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.96801 seconds
   CPU-time for initialization               : 0.347956 seconds
   Number of result points                   : 1979
   Number of grid points                     : 501
   Number of accepted steps                  : 17089
   Number of rejected steps                  : 600
   Number of f-evaluations (dynamics)        : 26016
   Number of non-linear iteration            : 24447
   Number of non-linear convergence failures : 855
   Number of Jacobian-evaluations            : 1445
   Number of crossing function evaluations   : 20688
   Number of model time events               : 476
   Number of state events                    : 265
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2

"), Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase2;
