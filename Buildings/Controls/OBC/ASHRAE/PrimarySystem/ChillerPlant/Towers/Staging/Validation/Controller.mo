within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Validation;
model Controller "Validation sequence of tower cell controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Controller
    towSta(nTowCel=4, nConWatPum=2)
    "Cooling tower staging control, specifies total number of cells and the staging process"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4] "Actual cells status"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[4](
    final samplePeriod=fill(2, 4)) "Actual isolation valve positions"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600,
    final shift=300) "Water side economizer status"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiStaGen(
    final height=1.2,
    final duration=3600,
    final offset=1) "Generate chiller stage"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger chiStaSet
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curChiSta(final k=1)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.75,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not StaTow "Stage tower cells"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conWatPumSpe[2](
    final k=fill(0.5, 2)) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pul(
    final width=0.05,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not leaConPum "Lead condenser water pump status"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[4](
    final k={false,true,true,false})
    "Enabling cells index"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[4](
    final k=fill(false,4)) "Constant zero"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(final nout=4)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[4] "Logical switch"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));

equation
  connect(pre1.y, towSta.uTowSta)
    annotation (Line(points={{102,10},{120,10},{120,50},{-14,50},{-14,21},{38,21}},
      color={255,0,255}));
  connect(towSta.yIsoVal, zerOrdHol.u)
    annotation (Line(points={{62,30},{72,30},{72,-30},{78,-30}}, color={0,0,127}));
  connect(zerOrdHol.y, towSta.uIsoVal)
    annotation (Line(points={{102,-30},{120,-30},{120,-50},{-20,-50},{-20,23},{38,
          23}}, color={0,0,127}));
  connect(chiStaGen.y,chiStaSet. u)
    annotation (Line(points={{-98,80},{-82,80}}, color={0,0,127}));
  connect(booPul2.y,StaTow. u)
    annotation (Line(points={{-98,40},{-82,40}}, color={255,0,255}));
  connect(pul.y,leaConPum. u)
    annotation (Line(points={{-98,-30},{-82,-30}}, color={255,0,255}));
  connect(curChiSta.y, towSta.uChiSta) annotation (Line(points={{-58,120},{30,120},
          {30,39},{38,39}}, color={255,127,0}));
  connect(chiStaSet.y, towSta.uChiStaSet) annotation (Line(points={{-58,80},{24,
          80},{24,37},{38,37}}, color={255,127,0}));
  connect(StaTow.y, towSta.uTowStaCha) annotation (Line(points={{-58,40},{-40,40},
          {-40,35},{38,35}}, color={255,0,255}));
  connect(wseSta.y, towSta.uWse) annotation (Line(points={{-58,0},{-34,0},{-34,33},
          {38,33}}, color={255,0,255}));
  connect(leaConPum.y, towSta.uLeaConWatPum) annotation (Line(points={{-58,-30},
          {-30,-30},{-30,30},{38,30}}, color={255,0,255}));
  connect(conWatPumSpe.y, towSta.uConWatPumSpe) annotation (Line(points={{-58,-60},
          {-26,-60},{-26,27},{38,27}}, color={0,0,127}));
  connect(towSta.yTowSta, pre1.u) annotation (Line(points={{62,26},{68,26},{68,
          10},{78,10}}, color={255,0,255}));
  connect(StaTow.y, booRep.u) annotation (Line(points={{-58,40},{-40,40},{-40,-110},
          {-22,-110}}, color={255,0,255}));
  connect(con2.y, logSwi.u1) annotation (Line(points={{-98,-90},{20,-90},{20,-102},
          {38,-102}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2)
    annotation (Line(points={{2,-110},{38,-110}}, color={255,0,255}));
  connect(con.y, logSwi.u3) annotation (Line(points={{-98,-130},{20,-130},{20,-118},
          {38,-118}}, color={255,0,255}));
  connect(logSwi.y, towSta.uChaCel) annotation (Line(points={{62,-110},{80,-110},
          {80,-60},{20,-60},{20,25},{38,25}}, color={255,0,255}));

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
