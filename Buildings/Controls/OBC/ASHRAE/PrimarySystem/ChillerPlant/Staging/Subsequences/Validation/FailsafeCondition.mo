within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model FailsafeCondition "Validate failsafe condition sequence"

  parameter Integer numSta = 2
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[numSta] = {5e5, 1e6}
  "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[numSta] = {0.2*staNomCap[1], 0.2*staNomCap[2]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small[1] = {0.001}
  "Small number to avoid division with zero";

  parameter Real large[1] = {staNomCap[numSta]*2}
  "Large number for numerical consistency";

equation

annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
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
end FailsafeCondition;
