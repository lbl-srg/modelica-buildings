within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.Validation;
model CellsNumber
  "Validation sequence of identifying total number of enabling cells"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.CellsNumber
    enaTowCel(
    nConWatPum=2,
    nTowCel=4) "Find number of enabling cells"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600,
    final shift=300) "Water side economizer status"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp chiStaGen(
    final height=1.2,
    final duration=3600,
    final offset=1) "Generate chiller stage"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger chiStaSet "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curChiSta(
    final k=1) "Current chiller stage"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.75,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not StaTow "Stage tower cells"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conWatPumSpe[2](
    final k=fill(0.5, 2)) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
equation
  connect(chiStaGen.y, chiStaSet.u)
    annotation (Line(points={{-78,50},{-62,50}}, color={0,0,127}));
  connect(curChiSta.y, enaTowCel.uChiSta)
    annotation (Line(points={{-38,90},{40,90},{40,9},{58,9}}, color={255,127,0}));
  connect(chiStaSet.y, enaTowCel.uChiStaSet)
    annotation (Line(points={{-38,50},{34,50},{34,6},{58,6}}, color={255,127,0}));
  connect(booPul2.y, StaTow.u)
    annotation (Line(points={{-78,10},{-62,10}}, color={255,0,255}));
  connect(StaTow.y, enaTowCel.uTowStaCha)
    annotation (Line(points={{-38,10},{28,10},{28,2},{58,2}}, color={255,0,255}));
  connect(wseSta.y, enaTowCel.uWse)
    annotation (Line(points={{-38,-30},{-8,-30},{-8,-1},{58,-1}}, color={255,0,255}));
  connect(conWatPumSpe.y, enaTowCel.uConWatPumSpe)
    annotation (Line(points={{-38,-100},{8,-100},{8,-9},{58,-9}}, color={0,0,127}));
  connect(con.y, enaTowCel.uEnaPla) annotation (Line(points={{42,-100},{50,-100},
          {50,-3},{58,-3}}, color={255,0,255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/Staging/Subsequences/Validation/CellsNumber.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.CellsNumber\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.CellsNumber</a>.
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end CellsNumber;
