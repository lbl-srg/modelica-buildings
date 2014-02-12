within Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses;
record Stage "Generic data record for a stage of a DX coil"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.AngularVelocity spe(displayUnit="1/min")
    "Rotational speed";
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues
    nomVal "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve
    perCur "Performance curves for this stage"
    annotation (choicesAllMatching = true, Placement(transformation(extent={{60,20},{80,40}})));
annotation (defaultComponentName="per",
              preferredView="info",
  Documentation(info="<html>
<p>
This is the base record for DX cooling coil model at a compressor speed.
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 25, 2012 by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
August 13, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Stage;
