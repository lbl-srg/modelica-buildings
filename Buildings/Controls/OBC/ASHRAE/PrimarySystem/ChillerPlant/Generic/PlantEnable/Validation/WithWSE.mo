within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Validation;
model WithWSE
  "Validate devices control when plant is enabled in economizer mode"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.WithWSE wseSta
    "Devices control when the plant is enabled in waterside economizer mode"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(final delayTime=120)
    "Delay the rising edge"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=3600)
    "Enabled plant"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=0)
    "Stage 0"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=1)
    "Stage 1"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(booPul.y, not1.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));
  connect(not1.y, wseSta.uPla) annotation (Line(points={{-18,80},{40,80},{40,-11},
          {58,-11}}, color={255,0,255}));
  connect(conInt2.y, wseSta.uIni) annotation (Line(points={{-38,40},{34,40},{34,
          -14},{58,-14}}, color={255,127,0}));
  connect(not1.y, truDel.u) annotation (Line(points={{-18,80},{-10,80},{-10,20},
          {-90,20},{-90,0},{-82,0}}, color={255,0,255}));
  connect(truDel.y, intSwi.u2)
    annotation (Line(points={{-58,0},{-2,0}}, color={255,0,255}));
  connect(conInt1.y, intSwi.u1) annotation (Line(points={{-38,-60},{-20,-60},{-20,
          8},{-2,8}}, color={255,127,0}));
  connect(conInt2.y, intSwi.u3) annotation (Line(points={{-38,40},{-28,40},{-28,
          -8},{-2,-8}}, color={255,127,0}));
  connect(intSwi.y, wseSta.uChiSta) annotation (Line(points={{22,0},{28,0},{28,-17},
          {58,-17}}, color={255,127,0}));
  connect(truDel.y, wseSta.uWSEConIsoVal) annotation (Line(points={{-58,0},{-40,
          0},{-40,-20},{58,-20}}, color={255,0,255}));
  connect(truDel.y, wseSta.uLeaPriChiPum) annotation (Line(points={{-58,0},{-40,
          0},{-40,-23},{58,-23}}, color={255,0,255}));
  connect(truDel.y, wseSta.uLeaConPum) annotation (Line(points={{-58,0},{-40,0},
          {-40,-26},{58,-26}}, color={255,0,255}));
  connect(truDel.y, wseSta.uLeaTwoCel) annotation (Line(points={{-58,0},{-40,0},
          {-40,-29},{58,-29}}, color={255,0,255}));
  annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/PlantEnable/Validation/WithWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.WithWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.WithWSE</a>.
</p>
</html>", revisions="<html>
<ul>
July 20, 2022, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false)));
end WithWSE;
