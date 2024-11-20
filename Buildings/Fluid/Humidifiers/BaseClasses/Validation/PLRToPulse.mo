within Buildings.Fluid.Humidifiers.BaseClasses.Validation;
model PLRToPulse
  "Validation model for the PLRToPulse block"
  extends Modelica.Icons.Example;

  Buildings.Fluid.Humidifiers.BaseClasses.PLRToPulse plrToPul
    "Instance of the PLR converter to validate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timEna
    "Time for which the enable signal is true"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiTim(
    final k=15*60)
    "Calculate time for which component needs to be enabled"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp plr(
    final height=1,
    final duration(displayUnit="min")= 15*5*60)
    "Part-load ratio signal"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Controls.OBC.CDL.Discrete.Sampler samPLR(
    final samplePeriod = 900)
    "Sample the PLR every time period"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

equation
  connect(plr.y,plrToPul. uPLR)
    annotation (Line(points={{-28,0},{-12,0}}, color={0,0,127}));
  connect(plrToPul.yEna, timEna.u)
    annotation (Line(points={{12,0},{38,0}}, color={255,0,255}));
  connect(plr.y, samPLR.u) annotation (Line(points={{-28,0},{-20,0},{-20,40},{-12,
          40}}, color={0,0,127}));
  connect(samPLR.y, gaiTim.u)
    annotation (Line(points={{12,40},{38,40}}, color={0,0,127}));
  annotation (
  experiment(
    Tolerance=1e-6,
    StopTime=7200),
  Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Fluid.Humidifiers.BaseClasses.PLRToPulse\">
Buildings.Fluid.Humidifiers.BaseClasses.PLRToPulse</a> 
by providing it a time-varying input signal for the part-load ratio, and then 
comparing the enabled time results against required calculated values.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 03, 2023 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/BaseClasses/Validation/PLRToPulse.mos"
        "Simulate and plot"));
end PLRToPulse;
