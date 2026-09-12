within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.Validation;
model ChillerLifts "Validation the calculation of the chiller lifts"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.ChillerLifts chiLif(
    nChi=4,
    minChiLif={12,10,13,11},
    maxChiLif={18,18,18,18}) "Average lifts of the enabled chillers"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chi2[4](k={true,true,false,false})
    "Chillers enabling status"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(chi2.y, chiLif.uChi)
    annotation (Line(points={{-18,0},{38,0}}, color={255,0,255}));
annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Generic/Validation/ChillerLifts.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.ChillerLifts\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.ChillerLifts</a>.
It shows how to calculate current chiller lifts.
</p>
</html>", revisions="<html>
<ul>
<li>
August 3, 2025, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end ChillerLifts;
