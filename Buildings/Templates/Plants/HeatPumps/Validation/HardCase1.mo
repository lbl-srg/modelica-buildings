within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversibleHeatRecovery(
    pla(
      linearized=false,
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Reversible,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      have_pumPriDedComHp_select=false,
      ctl(have_senTLooRet_select=true, have_senDpHeaWatRemWir=false)))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Sizes after manipulation of the nonlinear systems: {8, 1, 1, 1, 1, 1}
Number of numerical Jacobians: 2

Integration terminated unsuccesfully at T = 22015.9
   CPU-time for integration                  : 0.394827 seconds
   CPU-time for initialization               : 0.341389 seconds
   Number of result points                   : 341
   Number of grid points                     : 128
   Number of accepted steps                  : 1263
   Number of rejected steps                  : 72
   Number of f-evaluations (dynamics)        : 1973
   Number of non-linear iteration            : 1858
   Number of non-linear convergence failures : 69
   Number of Jacobian-evaluations            : 94
   Number of crossing function evaluations   : 1638
   Number of model time events               : 94
   Number of state events                    : 13
   Number of step events                     : 0
   Maximum integration order                 : 5

ERROR: The simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1 FAILED"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase1;
