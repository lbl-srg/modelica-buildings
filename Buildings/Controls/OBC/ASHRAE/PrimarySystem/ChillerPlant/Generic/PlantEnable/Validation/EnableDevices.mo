within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Validation;
model EnableDevices "Validation sequence for enabling plant devices"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.EnableDevices enaDev
    "Enable valves and pumps"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=3600)
    "Enabled plant"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Stage 1, meaning it stages in chiller mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse staSet(
    final amplitude=-1,
    final width=0.8,
    final period=3600,
    offset=2) "Stage setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.3,
    final period=3600)
    "Proven on pumps"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Disabled pump"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  connect(booPul.y, not1.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));
  connect(not1.y, enaDev.uPla) annotation (Line(points={{-18,80},{40,80},{40,38},
          {58,38}}, color={255,0,255}));
  connect(conInt.y, enaDev.uIni) annotation (Line(points={{-38,40},{28,40},{28,34},
          {58,34}}, color={255,127,0}));
  connect(staSet.y, enaDev.uChiSta) annotation (Line(points={{-58,0},{0,0},{0,30},
          {58,30}}, color={255,127,0}));
  connect(booPul1.y, not2.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(not2.y, enaDev.uChiWatPum[1]) annotation (Line(points={{-18,-40},{20,-40},
          {20,26},{58,26}}, color={255,0,255}));
  connect(not2.y, enaDev.uConWatPum[1]) annotation (Line(points={{-18,-40},{20,-40},
          {20,22},{58,22}}, color={255,0,255}));
  connect(con.y, enaDev.uChiWatPum[2]) annotation (Line(points={{-18,-80},{40,-80},
          {40,26},{58,26}}, color={255,0,255}));
  connect(con.y, enaDev.uConWatPum[2]) annotation (Line(points={{-18,-80},{40,-80},
          {40,22},{58,22}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/PlantEnable/Validation/EnableDevices.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.EnableDevices\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.EnableDevices</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end EnableDevices;
