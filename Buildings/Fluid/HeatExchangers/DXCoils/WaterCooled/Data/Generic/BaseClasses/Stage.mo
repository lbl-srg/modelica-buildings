within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses;
record Stage "Generic data record for a stage of a DX coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
  redeclare final parameter Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues nomVal,
  redeclare final parameter Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.PerformanceCurve perCur);

annotation (defaultComponentName="per",
              preferredView="info",
  Documentation(info="<html>
<p>This is the base record for DX cooling coil model at a compressor speed. See the information section of <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil\">Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil</a> for a description of the data. </p>
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
