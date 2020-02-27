within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses;
record NominalValues "Data record of nominal values for water-cooled DX coils"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues;

//-----------------------------Nominal conditions-----------------------------//

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal water mass flow rate at condensers"
    annotation (Dialog(group="Nominal condition"));

annotation (defaultComponentName="nomVal",
              preferredView="info",
  Documentation(info="<html>
<p>
This is the base record of nominal values for water-cooled DX cooling coil models.
</p>
<p>See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 17, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end NominalValues;
