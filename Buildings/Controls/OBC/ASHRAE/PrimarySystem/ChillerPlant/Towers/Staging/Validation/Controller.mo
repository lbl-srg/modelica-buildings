within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Validation;
model Controller "Validation sequence of tower cell controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Controller
    towSta(
    final nTowCel=2,
    final nConWatPum=2,
    final totSta=5,
    final staVec={0,0.5,1,1.5,2},
    final towCelOnSet={0,1,1,2,2})
    "Cooling tower staging control, specifies total number of cells and the staging process"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2] "Actual cells status"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(2, 2))     "Actual isolation valve positions"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600,
    final shift=300) "Water side economizer status"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiStaGen(
    final height=1.2,
    final duration=3600,
    final offset=1) "Generate chiller stage"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger chiStaSet
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.75,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not StaTow "Stage tower cells"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conWatPumSpe[2](
    final k=fill(0.5, 2)) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaSet2(
    final k=1)
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse pul1(
    final width=0.001,
    final period=3600)
    "Block that generates pulse signal of type Integer at simulation start time and has infinite number of periods"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract intSub
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
equation
  connect(pre1.y, towSta.uTowSta)
    annotation (Line(points={{102,-50},{120,-50},{120,-10},{-14,-10},{-14,-39},{
          38,-39}}, color={255,0,255}));
  connect(towSta.yIsoVal, zerOrdHol.u)
    annotation (Line(points={{62,-30},{72,-30},{72,-90},{78,-90}}, color={0,0,127}));
  connect(zerOrdHol.y, towSta.uIsoVal)
    annotation (Line(points={{102,-90},{120,-90},{120,-110},{-20,-110},{-20,-37},
          {38,-37}}, color={0,0,127}));
  connect(chiStaGen.y,chiStaSet. u)
    annotation (Line(points={{-98,20},{-82,20}}, color={0,0,127}));
  connect(booPul2.y,StaTow. u)
    annotation (Line(points={{-98,-20},{-82,-20}}, color={255,0,255}));
  connect(chiStaSet.y, towSta.uChiStaSet) annotation (Line(points={{-58,20},{24,
          20},{24,-23},{38,-23}}, color={255,127,0}));
  connect(StaTow.y, towSta.uTowStaCha) annotation (Line(points={{-58,-20},{-40,-20},
          {-40,-25},{38,-25}}, color={255,0,255}));
  connect(wseSta.y, towSta.uWse) annotation (Line(points={{-58,-60},{-34,-60},{-34,
          -27},{38,-27}}, color={255,0,255}));
  connect(conWatPumSpe.y, towSta.uConWatPumSpe) annotation (Line(points={{-58,-120},
          {-26,-120},{-26,-33},{38,-33}}, color={0,0,127}));
  connect(towSta.yTowSta, pre1.u) annotation (Line(points={{62,-34},{68,-34},{68,
          -50},{78,-50}}, color={255,0,255}));
  connect(con1.y, towSta.uEnaPla) annotation (Line(points={{-98,130},{0,130},{0,
          -29},{38,-29}}, color={255,0,255}));
  connect(pul1.y, intSub.u2) annotation (Line(points={{-98,60},{-48,60},{-48,74},
          {-42,74}}, color={255,127,0}));
  connect(chiStaSet2.y, intSub.u1) annotation (Line(points={{-58,100},{-52,100},
          {-52,86},{-42,86}}, color={255,127,0}));
  connect(intSub.y, towSta.uChiSta) annotation (Line(points={{-18,80},{20,80},{20,
          -21},{38,-21}}, color={255,127,0}));
annotation (experiment(
      StopTime=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/Staging/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Controller</a>.
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}})));
end Controller;
