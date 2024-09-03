within Buildings.ThermalZones.Detailed.Examples.Controls.Validation;
model ElectrochromicWindow
  "Validation model for the electrochromic window model"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Trapezoid TMea(
    amplitude=5,
    rising=3600,
    falling=3600,
    period=24*3600,
    width=12*3600,
    startTime=5*3600,
    offset=293.15) "Measured temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Trapezoid HMea(
    period=24*3600,
    nperiod=1,
    rising=2*3600,
    width=4*3600,
    falling=2*3600,
    startTime=7*3600,
    amplitude=500) "Measured irradiation"
    annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));
  Buildings.ThermalZones.Detailed.Examples.Controls.ElectrochromicWindow conWin
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(TMea.y, conWin.T) annotation (Line(points={{-39,30},{-24,30},{-24,4},
          {-9.5,4}}, color={0,0,127}));
  connect(HMea.y, conWin.H) annotation (Line(points={{-39,-28},{-24,-28},{-24,
          -4},{-9.5,-4}}, color={0,0,127}));
  annotation (
    experiment(Tolerance=1e-6, StopTime=172800),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/Controls/Validation/ElectrochromicWindow.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks the correct operation of the window controller.
Two days are emulated. During the days, the room temperature measurement signal
increases. The first day has solar radiation, but not the second.
Therefore, the window control signal switches to the dark state
only during the first day when the room is warm and
the solar irradiation is sufficiently large.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectrochromicWindow;
