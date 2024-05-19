within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve.Validation;
block BypassValvePosition

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve.BypassValvePosition
    bypValPos(
    final nPum=2,
    final k=1,
    final Ti=10,
    final Td=10e-6)
    "Test instance for bypass valve controller"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=1.2)
    "Minimum flow setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin(
    final amplitude=0.5,
    final freqHz=1/75,
    final phase=0,
    final offset=1.2,
    final startTime=1)
    "Sine input"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.5,
    final period=300)
    "Boolean pulse generator"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=0.2)
    "Minimum valve position for condensation control"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Pass zero flowrate when pumps are switched off"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation
  connect(con.y, bypValPos.VHotWatMinSet_flow) annotation (Line(points={{-18,60},
          {0,60},{0,6},{8,6}},         color={0,0,127}));
  connect(con1.y, bypValPos.uMinBypValPos) annotation (Line(points={{-18,-60},{0,
          -60},{0,-6},{8,-6}},   color={0,0,127}));
  connect(booPul.y, booRep.u)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={255,0,255}));
  connect(booRep.y, bypValPos.uPumSta) annotation (Line(points={{-18,-20},{-10,-20},
          {-10,-2},{8,-2}}, color={255,0,255}));

  connect(swi.y, bypValPos.VHotWat_flow) annotation (Line(points={{-18,20},{-10,
          20},{-10,2},{8,2}}, color={0,0,127}));
  connect(sin.y, swi.u1) annotation (Line(points={{-58,20},{-50,20},{-50,28},{-42,
          28}}, color={0,0,127}));
  connect(con2.y, swi.u3) annotation (Line(points={{-58,60},{-54,60},{-54,12},{-42,
          12}}, color={0,0,127}));
  connect(booPul.y, swi.u2) annotation (Line(points={{-58,-20},{-46,-20},{-46,20},
          {-42,20}}, color={255,0,255}));
annotation (
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve.BypassValvePosition\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.BypassValve.BypassValvePosition</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 17, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/BypassValve/Validation/BypassValvePosition.mos"
        "Simulate and plot"),
    experiment(
      StartTime=0,
      StopTime=300,
      Interval=1,
      Tolerance=1e-06));
end BypassValvePosition;
