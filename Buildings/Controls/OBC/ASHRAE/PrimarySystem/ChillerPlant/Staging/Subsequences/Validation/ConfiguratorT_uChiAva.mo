within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model ConfiguratorT_uChiAva
  "Validate stage capacities sequence for chiller stage inputs"

  parameter Integer nSta = 2
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5}
    "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Large number for numerical consistency";

  ConfiguratorT conf
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](final k=fill(true,
        2)) "Stage availability array"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

equation
  connect(con.y, conf.uChiAva)
    annotation (Line(points={{-59,0},{-22,0}}, color={255,0,255}));
annotation (
 experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_uSta.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ConfiguratorT_uChiAva;
