within Buildings.Fluid.Storage.Ice_ntu_ini.Data.Tank;
record Generic
  extends Modelica.Icons.Record;
  constant Integer nCha = 4 "Number of coefficients for charging characteristic curve";
  constant Integer nDisCha = 4 "Number of coefficients for discharging characteristic curve";

  parameter Modelica.Units.SI.Volume Vtank;
  parameter Modelica.Units.SI.Diameter Dtank;
  parameter Modelica.Units.SI.Height Htank;
  parameter Modelica.Units.SI.SpecificEnergy Hf = 333550 "Heat of fusion for water";
  parameter Modelica.Units.SI.Temperature TFre = 273.15
    "Freezing temperature of water or the latent energy storage material";

  parameter Real coeCha[nCha] "Coefficients for charging curve";
  parameter Real coeDisCha[nDisCha] "Coefficients for discharging curve";

  annotation (defaultComponentName="datIceTan",
     defaultComponentPrefixes="parameter",
    Documentation(revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Performance data for ice tank charging and discharging curves.
See
<a href=\"modelica://Buildings.Fluid.Storage.Ice.Tank\">Buildings.Fluid.Storage.Ice.Tank</a>
for the definition of the charging and discharging coefficients.
</p>
</html>"));
end Generic;
