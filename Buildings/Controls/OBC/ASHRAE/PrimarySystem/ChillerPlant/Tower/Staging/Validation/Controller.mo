within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Validation;
model Controller "Validation sequence of tower cell controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Controller towSta
    "Tower fan staging control"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15, final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Chiller stage up status"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.18, final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not towStaUp "Tower stage up status"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600,
    final startTime=300) "Boolean pulse"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[4](
    final k={4,1,2,3})
    "Tower cells enabling priority"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) "Stage down"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4] "Break algebraic"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[4](
    final samplePeriod=fill(5, 4))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-78,-10},{-62,-10}}, color={255,0,255}));
  connect(staUp.y, chiSta.u)
    annotation (Line(points={{-38,-10},{-30,-10},{-30,80},{-22,80}},
      color={255,0,255}));
  connect(booPul1.y, towStaUp.u)
    annotation (Line(points={{-78,-50},{-62,-50}}, color={255,0,255}));
  connect(chiSta.y, towSta.uChiSta)
    annotation (Line(points={{2,80},{20,80},{20,9},{38,9}}, color={255,127,0}));
  connect(wseSta.y, towSta.uWSE)
    annotation (Line(points={{-38,60},{-14,60},{-14,7},{38,7}}, color={255,0,255}));
  connect(towSta.yTowSta, pre1.u)
    annotation (Line(points={{62,0},{78,0}}, color={255,0,255}));
  connect(pre1.y, towSta.uTowSta)
    annotation (Line(points={{102,0},{110,0},{110,40},{0,40},{0,5},{38,5}},
      color={255,0,255}));
  connect(enaPri.y, towSta.uTowCelPri)
    annotation (Line(points={{-38,30},{-20,30},{-20,3},{38,3}}, color={255,127,0}));
  connect(staUp.y, towSta.uStaUp)
    annotation (Line(points={{-38,-10},{-30,-10},{-30,0},{38,0}},
      color={255,0,255}));
  connect(towStaUp.y, towSta.uTowStaUp)
    annotation (Line(points={{-38,-50},{-26,-50},{-26,-3},{38,-3}},
      color={255,0,255}));
  connect(con1.y, towSta.uStaDow)
    annotation (Line(points={{-38,-80},{-20,-80},{-20,-5},{38,-5}},
      color={255,0,255}));
  connect(con1.y, towSta.uTowStaDow)
    annotation (Line(points={{-38,-80},{-20,-80},{-20,-7},{38,-7}},
      color={255,0,255}));
  connect(towSta.yIsoVal, zerOrdHol.u)
    annotation (Line(points={{62,-9},{70,-9},{70,-40},{78,-40}}, color={0,0,127}));
  connect(zerOrdHol.y, towSta.uIsoVal)
    annotation (Line(points={{102,-40},{110,-40},{110,-60},{0,-60},{0,-9},
      {38,-9}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/Staging/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end Controller;
