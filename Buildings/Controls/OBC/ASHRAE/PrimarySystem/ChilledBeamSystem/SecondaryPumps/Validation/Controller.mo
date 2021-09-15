within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SecondaryPumps.Validation;
model Controller
    "Validate chilled beam chilled water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SecondaryPumps.Controller
    pumCon(
    final nPum=2,
    final nSen=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final k=1,
    final Ti=0.5,
    final Td=0.1)
    "Testing pump controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul[3](
    final width=fill(0.9, 3),
    final period=fill(3600, 3),
    final shift=fill(100, 3))
    "Real pulse source"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin2[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/1800, 2),
    final offset=fill(1, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(conInt1.y, pumCon.uPumLeaLag) annotation (Line(points={{-58,60},{0,60},
          {0,8},{18,8}}, color={255,127,0}));

  connect(pumCon.yChiWatPum, pre2.u)
    annotation (Line(points={{42,2},{50,2},{50,0},{58,0}}, color={255,0,255}));

  connect(sin2.y, pumCon.dpChiWat_remote) annotation (Line(points={{-58,-20},{-20,
          -20},{-20,-4},{18,-4}}, color={0,0,127}));

  connect(pre2.y, pumCon.uChiWatPum) annotation (Line(points={{82,0},{90,0},{90,
          70},{10,70},{10,4},{18,4}}, color={255,0,255}));

  connect(con3.y, pumCon.dpChiWatSet) annotation (Line(points={{-58,-60},{0,-60},
          {0,-8},{18,-8}}, color={0,0,127}));

  connect(pul.y, pumCon.uValPos) annotation (Line(points={{-58,20},{-20,20},{-20,
          0},{18,0}}, color={0,0,127}));

annotation (
  experiment(
      StopTime=3600,
      Interval=0.5,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChilledBeamSystem/SecondaryPumps/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SecondaryPumps.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SecondaryPumps.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}}),
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
end Controller;
