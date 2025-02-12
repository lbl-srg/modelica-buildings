within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.Validation;
model ChangeCells
  "Validation sequence of identifying cells that should change status"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells
    enaTowCel(
    nTowCel=4) "Find enabling cells"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable celNum(
    table=[0, 2;
           1200,2;
           2000,3;
           2800,2;
           3200,1],
    period=3600) "Number of cell that should be enabled"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[4] "Current tower cell status"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(celNum.y[1], enaTowCel.uCelNum) annotation (Line(points={{-38,40},{0,40},
          {0,4},{18,4}}, color={255,127,0}));
  connect(pre.y, enaTowCel.uTowSta) annotation (Line(points={{-38,-40},{0,-40},{
          0,-4},{18,-4}}, color={255,0,255}));
  connect(enaTowCel.yTowSta, pre.u) annotation (Line(points={{42,4},{60,4},{60,-60},
          {-70,-60},{-70,-40},{-62,-40}}, color={255,0,255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/Staging/Subsequences/Validation/ChangeCells.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells</a>.
It shows the process of enabling and disabling tower cells
according to the input <code>uCelNum</code> that specifies
total number of cells that should be enabled.
</p>
<p>
Note that this sequence assumes that the cells are enabled
sequentially as 1, 2, 3, etc. Thus, for example if it
requires two enabled cells, cell 1 and 2 will be enabled.
While if it requires three enabled cell, cell 1, 2 and 3 will
be enabled.
</p>
<ul>
<li>
Before 2000 seconds, the input <code>uCelNum</code> equals 2.
Thus the first two cells are enabled, <code>uTowSta[1]=true</code>
and <code>uTowSta[2]=true</code>.
</li>
<li>
From 2000 seconds to 2800 seconds, the input <code>uCelNum</code>
equals 3.
Thus the first three cells are enabled, <code>uTowSta[1]=true</code>,
<code>uTowSta[2]=true</code>, and <code>uTowSta[3]=true</code>
</li>
<li>
From 2800 seconds to 3200 seconds, the input <code>uCelNum</code>
becomes 2 again.
Thus the first two cells are enabled, <code>uTowSta[1]=true</code>,
and <code>uTowSta[2]=true</code>. The third cell becomes disabled,
<code>uTowSta[3]=false</code>.
</li>
<li>
After 3200 seconds, the input <code>uCelNum</code> equals 1.
Thus only one cell should be enabled, <code>uTowSta[1]=true</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 26, 2022, by Jianjun Hu:<br/>
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
end ChangeCells;
