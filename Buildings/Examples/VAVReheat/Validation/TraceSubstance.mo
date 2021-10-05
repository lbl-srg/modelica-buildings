within Buildings.Examples.VAVReheat.Validation;
model TraceSubstance
  "This validates the ability to simulate trace substances in the air"
  extends ASHRAE2006(
    MediumA(extraPropertiesNames={"CO2"}),
    hvac(
      amb(
        C=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
                    /Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, MediumA.nC))),
    redeclare BaseClasses.Floor flo);

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
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
May 9, 2021, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstance;
