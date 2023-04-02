within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses;
record Stage "Generic data record for a stage of a air source DX coil"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.AngularVelocity spe(displayUnit="1/min")
    "Rotational speed";

  parameter Boolean activate_CooCoi = true
    "=false, for heating coil";

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues
    nomVal(
    final activate_CooCoi=activate_CooCoi)
    "Nominal values"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve
    perCur
    "Performance curves for this stage"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,20},{80,40}})));

annotation (defaultComponentName="per",
              preferredView="info",
  Documentation(info="<html>
<p>This is the base record for air source DX cooling coil model at a compressor speed.
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil</a> for a description of the data. </p>
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
