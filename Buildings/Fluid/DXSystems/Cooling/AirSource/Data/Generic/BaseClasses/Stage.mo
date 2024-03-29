within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses;
record Stage "Generic data record for a stage of a air source DX coil"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.AngularVelocity spe(displayUnit="1/min")
    "Rotational speed";

  replaceable parameter
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues
    nomVal "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  replaceable parameter
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve
    perCur "Performance curves for this stage"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,20},{80,40}})));

annotation (defaultComponentName="per",
              preferredView="info",
  Documentation(info="<html>
  <p>This is the base record for air source DX coil model at a particular compressor 
  speed.
See the information section of
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil\">
Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil</a> for a description of the data. </p>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2023, by Xing Lu and Karthik Devaprasad:<br/>
Added Boolean parameter <code>is_cooCoi</code> and propogated it in instance 
<code>nomVal</code>.<br/>
Updated information section.
</li>
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
