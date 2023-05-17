within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.Validation;
model ChangeCells
  "Validation sequence of identifying cells that should change status"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells
    enaTowCel(
    nTowCel=4) "Find enabling cells"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[4](
    final k={true,true,false,false})
    "Enabling cells index"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable celNum(
    table=[0, 2;
           1200,2;
           2000,3;
           2800,2;
           3200,1],
    period=3600) "Number of cell that should be enabled"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

equation
  connect(celNum.y[1], enaTowCel.uCelNum) annotation (Line(points={{-38,40},{0,40},
          {0,4},{18,4}}, color={255,127,0}));
  connect(con2.y, enaTowCel.uTowSta) annotation (Line(points={{-38,-40},{0,-40},
          {0,-4},{18,-4}}, color={255,0,255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/Staging/Subsequences/Validation/ChangeCells.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences.ChangeCells</a>.
</p>
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
