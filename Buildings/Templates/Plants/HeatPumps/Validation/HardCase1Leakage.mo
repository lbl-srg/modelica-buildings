within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1Leakage "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1(pla(valIso(
    valHeaWatUniOutIso(each l=1E-3),
    valChiWatUniOutIso(each l=1E-3),
    valHeaWatUniInlIso(each l=1E-3),
    valChiWatUniInlIso(each l=1E-3)),
    valChiWatMinByp(l=1E-3),
    valHeaWatMinByp(l=1E-3)))
      annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Sizes after manipulation of the nonlinear systems: {8, 1, 1, 1, 1, 1}
Number of numerical Jacobians: 2

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 3.73993 seconds
   CPU-time for initialization               : 0.341328 seconds
   Number of result points                   : 1609
   Number of grid points                     : 501
   Number of accepted steps                  : 15932
   Number of rejected steps                  : 564
   Number of f-evaluations (dynamics)        : 24309
   Number of non-linear iteration            : 23147
   Number of non-linear convergence failures : 886
   Number of Jacobian-evaluations            : 1353
   Number of crossing function evaluations   : 18677
   Number of model time events               : 417
   Number of state events                    : 139
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1Leakage"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end HardCase1Leakage;
