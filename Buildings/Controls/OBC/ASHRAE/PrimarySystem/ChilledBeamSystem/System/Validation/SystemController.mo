within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.System.Validation;
model SystemController
  "Validate zone temperature setpoint controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.System.SystemController
    sysCon
    "System controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul[3](
    final width=fill(0.9, 3),
    final period=fill(3600, 3),
    final shift=fill(100, 3))
    "Real pulse source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin2(
    final amplitude=7500,
    final freqHz=1/1800,
    final offset=25000)
    "Sine signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  connect(pul.y, sysCon.uValPos)
    annotation (Line(points={{-58,0},{-40,0},{-40,-4},{-12,-4}}, color={0,0,127}));
  connect(sin2.y, sysCon.dPChiWatLoo)
    annotation (Line(points={{-58,40},{-28,40},{-28,0},{-12,0}}, color={0,0,127}));
  connect(sysCon.yChiWatPum, pre1.u)
    annotation (Line(points={{12,4},{20,4},{20,0},{28,0}}, color={255,0,255}));
  connect(pre1.y, sysCon.uPumSta)
    annotation (Line(points={{52,0},{60,0},{60,50},{-20,50},{-20,4},{-12,4}},
      color={255,0,255}));

annotation (
  experiment(
      StopTime=3600,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChilledBeamSystem/System/Validation/SystemController.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.System.SystemController\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.System.SystemController</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 9, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SystemController;
