within Buildings.Examples.VAVReheat.Validation;
model TraceSubstance
  "This validates the ability to simulate trace substances in the air"
  extends ASHRAE2006(
    MediumA(extraPropertiesNames={"CO2"}),
    redeclare BaseClasses.Floor flo(
      final lat=lat,
      final sampleModel=sampleModel),
    amb(nPorts=3, C=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                         /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, MediumA.nC)));
  annotation (experiment(
      StartTime=4492800,
      StopTime=4665600,
      Interval=900,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Validation/TraceSubstance.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This model validates that the detailed model of multiple rooms and an HVAC system
with a trace substance simulates properly.  CO<sub>2</sub> is used as the trace substance.
A concentration of 400ppm is assumed for the ambient air.  For assumptions
about zone CO<sub>2</sub> sources, see the model
<a href=\"modelica://Buildings.Examples.VAVReheat.Validation.BaseClasses.Floor\">
Buildings.Examples.VAVReheat.Validation.BaseClasses.Floor</a>.
</p>
</html>",revisions="<html>
<ul>
<li>
May 9, 2021, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstance;
