within Buildings.Examples.VAVReheat.BaseClasses.Controls.Examples;
model SupplyAirTemperature
  "Validation of the supply air temperature control"
  extends Modelica.Icons.Example;
  Buildings.Examples.VAVReheat.BaseClasses.Controls.SupplyAirTemperature conTSup(k=0.1, Ti=
        60)
    "Controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uEna(period=2800)
    "Enable signal"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet(
    y(final unit="K", displayUnit="degC"),
    k=13 + 273.15)
    "Set point"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TSup(
    phase=3.1415926535898,
    y(final unit="K", displayUnit="degC"),
    amplitude=5,
    freqHz=2/3600,
    offset=13 + 273.15) "Measurement"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(TSupSet.y, conTSup.TSupSet)
    annotation (Line(points={{-58,0},{-12,0}}, color={0,0,127}));
  connect(uEna.y, conTSup.uEna) annotation (Line(points={{-58,-60},{-20,-60},{-20,
          -6},{-12,-6}}, color={255,0,255}));
  connect(TSup.y, conTSup.TSup) annotation (Line(points={{-58,60},{-20,60},{-20,
          6},{-12,6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(StopTime=3600,  Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/BaseClasses/Controls/Examples/SupplyAirTemperature.mos"
  "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the supply air temperature control, as implemented in
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.SupplyAirTemperature\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.SupplyAirTemperature</a>
</p>
</html>",
revisions="<html>
<ul>
<li>
October 27, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupplyAirTemperature;
