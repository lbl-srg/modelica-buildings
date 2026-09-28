within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1FromDpLoad "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1(
    loaCoo(con(val(from_dp=true))), loaHea(con(val(from_dp=true))))
  annotation(IconMap(primitivesVisible = false));
  annotation(
           experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Sizes after manipulation of the nonlinear systems: {8, 1, 1, 1, 1, 1}
Number of numerical Jacobians: 2

Integration terminated unsuccesfully at T = 27192.7
   CPU-time for integration                  : 0.528163 seconds
   CPU-time for initialization               : 0.325109 seconds
   Number of result points                   : 433
   Number of grid points                     : 158
   Number of accepted steps                  : 2179
   Number of rejected steps                  : 104
   Number of f-evaluations (dynamics)        : 3342
   Number of non-linear iteration            : 3174
   Number of non-linear convergence failures : 92
   Number of Jacobian-evaluations            : 147
   Number of crossing function evaluations   : 2641
   Number of model time events               : 116
   Number of state events                    : 22
   Number of step events                     : 0
   Maximum integration order                 : 5

ERROR: The simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1BypassFromDpLoad FAILED"),
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
end HardCase1FromDpLoad;
