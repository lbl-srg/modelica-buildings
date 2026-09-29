within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase5 "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2(
    pla(ctl(have_senDpHeaWatRemWir=true)))
     annotation(IconMap(primitivesVisible = false));
    annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}),
    Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase5
Integration started at 0 using integration method:
cvode from sundials


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.51286 seconds
   CPU-time for initialization               : 0.355216 seconds
   Number of result points                   : 1961
   Number of grid points                     : 501
   Number of accepted steps                  : 16317
   Number of rejected steps                  : 592
   Number of f-evaluations (dynamics)        : 24681
   Number of non-linear iteration            : 23132
   Number of non-linear convergence failures : 703
   Number of Jacobian-evaluations            : 1265
   Number of crossing function evaluations   : 19954
   Number of model time events               : 474
   Number of state events                    : 258
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase5
"));
end HardCase5;
