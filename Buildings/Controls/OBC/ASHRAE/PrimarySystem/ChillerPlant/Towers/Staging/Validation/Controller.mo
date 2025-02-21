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
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2] "Actual cells status"
    annotation (Placement(transformation(extent={{80,-24},{100,-4}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(2, 2))     "Actual isolation valve positions"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600,
    final shift=300) "Water side economizer status"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp chiStaGen(
    final height=1.2,
    final duration=3600,
    final offset=1) "Generate chiller stage"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger chiStaSet
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.75,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not StaTow "Stage tower cells"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conWatPumSpe[2](
    final k=fill(0.5, 2)) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaSet2(
    final k=1)
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(k=true)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
equation
  connect(pre1.y, towSta.uTowSta)
    annotation (Line(points={{102,-14},{120,-14},{120,10},{-14,10},{-14,-19},{38,
          -19}},    color={255,0,255}));
  connect(towSta.yIsoVal, zerOrdHol.u)
    annotation (Line(points={{62,-10},{70,-10},{70,-70},{78,-70}}, color={0,0,127}));
  connect(zerOrdHol.y, towSta.uIsoVal)
    annotation (Line(points={{102,-70},{120,-70},{120,-90},{-20,-90},{-20,-17},{
          38,-17}},  color={0,0,127}));
  connect(chiStaGen.y,chiStaSet. u)
    annotation (Line(points={{-98,40},{-82,40}}, color={0,0,127}));
  connect(booPul2.y,StaTow. u)
    annotation (Line(points={{-98,0},{-82,0}}, color={255,0,255}));
  connect(chiStaSet.y, towSta.uChiStaSet) annotation (Line(points={{-58,40},{20,
          40},{20,-3},{38,-3}},   color={255,127,0}));
  connect(StaTow.y, towSta.uTowStaCha) annotation (Line(points={{-58,0},{-40,0},
          {-40,-5},{38,-5}}, color={255,0,255}));
  connect(wseSta.y, towSta.uWse) annotation (Line(points={{-98,-40},{-34,-40},{-34,
          -7},{38,-7}},   color={255,0,255}));
  connect(conWatPumSpe.y, towSta.uConWatPumSpe) annotation (Line(points={{-58,-100},
          {-26,-100},{-26,-13},{38,-13}}, color={0,0,127}));
  connect(towSta.yTowSta, pre1.u) annotation (Line(points={{62,-14},{78,-14}},
          color={255,0,255}));
  connect(con1.y, towSta.uEnaPla) annotation (Line(points={{-98,120},{0,120},{0,
          -9},{38,-9}},   color={255,0,255}));
  connect(chiStaSet2.y, towSta.uChiSta) annotation (Line(points={{-58,80},{30,80},
          {30,-1},{38,-1}}, color={255,127,0}));
  connect(con2.y, towSta.uPla) annotation (Line(points={{-58,-60},{-30,-60},{-30,
          -11},{38,-11}}, color={255,0,255}));
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
It shows the process of staging tower cells when there is chiller stage
setpoint change and the enabling-disabling waterside economizer.
</p>
<ul>
<li>
At begining, the current chiller stage is 1 and it starts to staging up tower cell 1.
During the begining stage, according to the vector <code>staVec</code> current plant
stage is 1 (the 3rd element of vector <code>staVec</code>). Thus according to the
vector <code>towCelOnSet</code>,
the total number of cell is 1. It takes 90 seconds to fully open the isolation
valve 1 (<code>yIsoVal[1]=1</code>) and then the cell 1 becomes enabled
(<code>uTowSta[1]=true</code>) at 90 seconds.
</li>
<li>
At 300 seconds, the waterside economizer is enabled. Thus the current plant stage
is 1.5 (the 4th element of vector <code>staVec</code>). Thus according to the
vector <code>towCelOnSet</code>, the total number of cell is 2. It takes 90
seconds to fully open the isolation valve 2 (<code>yIsoVal[2]=1</code>) and
then the cell 2 becomes enabled (<code>uTowSta[2]=true</code>) at 390 seconds.
</li>
<li>
At 840 seconds, the waterside economizer becomes disabled. Thus the current
plant stage changes to 1 (the 3rd element of vector <code>staVec</code>).
Thus according to the vector <code>towCelOnSet</code>, the total number of
cell is 1. The isolation valve 2 becomes closed (<code>yIsoVal[2]=0</code>)
and the cell 2 becomes disabled (<code>uTowSta[2]=false</code>) at 840
seconds.
</li>
<li>
At 1500 seconds, the chiller stage setpoint changes to 2 and the current stage
is still 1. Therefore the chiller plant begins staging up. However, the plant
staging up process has not yet been into the step of staging up the tower
(<code>uTowStaCha=false</code>). Thus there is no change to the tower cells
and their valves.
</li>
<li>
At 2700 seconds, it is still in the plant staging up process and it now requires
staging up tower cells. The plant stage is 2 (the 5th element of vector
<code>staVec</code>). Thus according to the vector <code>towCelOnSet</code>,
the total number of cell is 2. It takes 90 seconds to fully open the isolation
valve 2 (<code>yIsoVal[2]=1</code>) and then the cell 2 becomes enabled
(<code>uTowSta[2]=true</code>) at 2790 seconds.
</li>
</ul>
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
