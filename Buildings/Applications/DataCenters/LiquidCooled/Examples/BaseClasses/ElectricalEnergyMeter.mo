within Buildings.Applications.DataCenters.LiquidCooled.Examples.BaseClasses;
  model ElectricalEnergyMeter
    extends Modelica.Blocks.Continuous.Integrator(
      u(final unit="W"),
      y(final unit="J",
        displayUnit="Wh"),
      final k = 1,
      final use_reset=false,
      final initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0);
    annotation (Documentation(info="<html>
<p>
Block for an electrical energy meter that takes a real-valued signal as the input.
</p>
</html>", revisions="<html>
<ul>
<li>
June 24, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end ElectricalEnergyMeter;
