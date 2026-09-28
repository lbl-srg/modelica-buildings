within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1LinearizedBypass "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1(
    pla(valChiWatMinByp(linearized=true), valHeaWatMinByp(linearized=true)))
      annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Documentation(info="Integration terminated unsuccesfully at T = 26967.2
   CPU-time for integration                  : 0.477339 seconds
   CPU-time for initialization               : 0.314969 seconds
   Number of result points                   : 430
   Number of grid points                     : 157
   Number of accepted steps                  : 2013
   Number of rejected steps                  : 97
   Number of f-evaluations (dynamics)        : 3019
   Number of non-linear iteration            : 2854
   Number of non-linear convergence failures : 79
   Number of Jacobian-evaluations            : 129
   Number of crossing function evaluations   : 2500
   Number of model time events               : 115
   Number of state events                    : 22
   Number of step events                     : 0
   Maximum integration order                 : 5

ERROR: The simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1LinearizedBypass FAILED"));
end HardCase1LinearizedBypass;
