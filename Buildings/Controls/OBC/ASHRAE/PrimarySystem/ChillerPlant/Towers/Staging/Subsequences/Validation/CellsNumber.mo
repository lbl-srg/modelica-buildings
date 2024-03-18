within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.Validation;
model CellsNumber
  "Validation sequence of identifying total number of enabling cells"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.CellsNumber
    enaTowCel(
    nConWatPum=2,
    nTowCel=4) "Find number of enabling cells"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    width=0.15,
    period=3600,
    shift=300) "Water side economizer status"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp chiStaGen(
    height=1.2,
    duration=3600,
    offset=1) "Generate chiller stage"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger chiStaSet "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant curChiSta(
    k=1) "Current chiller stage"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    width=0.75,
    period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not StaTow "Stage tower cells"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conWatPumSpe[2](
    k=fill(0.5, 2)) "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    k=false)
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
<p>
It shows the calculation of total number of tower cells when the plant is
operating in scenarios including:
</p>
<ul>
<li>
1 chiller only,
</li>
<li>
1 chiller and waterside economizer together,
</li>
<li>
in the chiller staging process but before staging up the tower cells,
</li>
<li>
in the chiller staging process after staging up the tower cell.
</li>
</ul>
<p>
Note in this example, the total number of tower cells is specified
according to following table. It is defined by the
parameter <code>towCelOnSet[totSta]</code>.
</p>

<table summary=\"summary\" border=\"1\">
<tr>
<th>Plant stage </th>
<th>Index</th>
<th>Number of enabled cells </th>  
</tr>
<tr>
<td align=\"left\">0</td>
<td align=\"center\">1</td>
<td align=\"center\">0</td>
</tr>
<tr>
<td align=\"left\">WSE</td>
<td align=\"center\">2</td>
<td align=\"center\">2</td>
</tr>
<tr>
<td align=\"left\">1 chiller</td>
<td align=\"center\">3</td>
<td align=\"center\">2</td>
</tr>
<tr>
<td align=\"left\">1 chiller + WSE</td>
<td align=\"center\">4</td>
<td align=\"center\">4</td>
</tr>
<tr>
<td align=\"left\">2 chillers</td>
<td align=\"center\">5</td>
<td align=\"center\">4</td>
</tr>
<tr>
<td align=\"left\">2 chillers + WSE</td>
<td align=\"center\">6</td>
<td align=\"center\">4</td>
</tr>
</table>
<br/>
<p>
The example shows following process:
</p>
<ul>
<li>
Before 300 seconds, the chiller stage equals to its setpoint (1)
and the economizer is not enabled. Thus the plant stage index is 3.
The total number of tower cells should be <code>towCelOnSet[3]</code>,
which is 2.
</li>
<li>
Between 300 seconds and 840 seconds, the chiller stage still equals
to its setpoint (1), but the ecnomizer is enabled. Thus the plant
stage index is 4. The total number of tower cells should be
<code>towCelOnSet[4]</code>, which is 4.
</li>
<li>
Between 840 seconds and 1500 seconds, the economizer is disabled and
the chiller stage keeps equal to its setpoint at 1. Thus the plant
stage index is 3 and the total number of tower cells should be
<code>towCelOnSet[3]</code>, which is 2.
</li>
<li>
Between 1500 seconds and 2700 seconds, the economizer keeps
disabled. However, the chiller stage setpoint changes to be
different from its current stage index. This means the plant
is in the chiller staging process. Since the input
<code>uTowStaCha</code> is false, it means the staging process
has not yet into the subprocess to staging up tower cells.
Thus the plant stage is still 3 and the total number of tower cells
should be <code>towCelOnSet[3]</code>, which is 2.
</li>
<li>
After 2700 seconds, the economizer keeps disabled and it is still
in the chiller staging process. However, the input
<code>uTowStaCha</code> becomes true, it means the staging process
requires staging up tower cells. The plant stage becomes 5.
The total number of tower cells should be <code>towCelOnSet[5]</code>,
which is 4.
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end CellsNumber;
