within Buildings.Fluid.HeatExchangers.Borefield.Data.Records;
record Filling "Thermal properties of the borehole filling material"
  extends Buildings.HeatTransfer.Data.BoreholeFillings.Generic;

  parameter String pathMod = "Buildings.Fluid.HeatExchangers.Borefield.Data.Records.Filling"
    "Modelica path of the record";
  parameter String pathCom = Modelica.Utilities.Files.loadResource("modelica://Buildings/Fluid/HeatExchangers/Borefield/Data/Records/Filling.mo")
    "Computer path of the record";
  final parameter Modelica.SIunits.DiffusionCoefficient alp=k/d/c
    "Heat diffusion coefficient of the filling material";
 annotation (Documentation(info="<html>
 <p>Thermal properties of the borehole filling material and record path.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end Filling;
