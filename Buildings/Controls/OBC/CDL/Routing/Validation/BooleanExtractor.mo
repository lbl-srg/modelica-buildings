within Buildings.Controls.OBC.CDL.Routing.Validation;
model BooleanExtractor
  "Validation model for the boolean extractor block"
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extIndBooSig(
    final nin=4)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extIndBooSig1(
    final nin=4)
    "Block that extracts signal from an input signal vector"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true)
    "Block that outputs true signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Block that outputs false signal"
    annotation (Placement(transformation(extent={{-80,-28},{-60,-8}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=0.2) "Generate pulse signal of type boolean"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=0.3)
    "Generate pulse signal of type boolean"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=6)
    "Index to extract input signal"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

equation
  connect(conInt.y, extIndBooSig.index)
    annotation (Line(points={{42,30},{50,30},{50,68}}, color={255,127,0}));
  connect(conInt1.y, extIndBooSig1.index)
    annotation (Line(points={{42,-80},{50,-80},{50,-52}}, color={255,127,0}));
  connect(con1.y, extIndBooSig.u[1]) annotation (Line(points={{-58,80},{-10,80},
          {-10,79.25},{38,79.25}}, color={255,0,255}));
  connect(booPul.y, extIndBooSig.u[2]) annotation (Line(points={{-58,50},{-20,50},
          {-20,79.75},{38,79.75}}, color={255,0,255}));
  connect(booPul1.y, extIndBooSig.u[3]) annotation (Line(points={{-58,20},{-16,20},
          {-16,80.25},{38,80.25}}, color={255,0,255}));
  connect(con.y, extIndBooSig.u[4]) annotation (Line(points={{-58,-18},{-12,-18},
          {-12,80.75},{38,80.75}}, color={255,0,255}));
  connect(con1.y, extIndBooSig1.u[1]) annotation (Line(points={{-58,80},{0,80},{
          0,-40.75},{38,-40.75}}, color={255,0,255}));
  connect(booPul.y, extIndBooSig1.u[2]) annotation (Line(points={{-58,50},{-20,50},
          {-20,-40.25},{38,-40.25}}, color={255,0,255}));
  connect(booPul1.y, extIndBooSig1.u[3]) annotation (Line(points={{-58,20},{-16,
          20},{-16,-39.75},{38,-39.75}}, color={255,0,255}));
  connect(con.y, extIndBooSig1.u[4]) annotation (Line(points={{-58,-18},{-12,-18},
          {-12,-39.25},{38,-39.25}}, color={255,0,255}));

annotation (
  experiment(StopTime=1.0,Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/BooleanExtractor.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.BooleanExtractor\">
Buildings.Controls.OBC.CDL.Routing.BooleanExtractor</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end BooleanExtractor;
