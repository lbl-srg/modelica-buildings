within Districts.Electrical.AC.Transmission.Materials;
record Material
    extends Modelica.Icons.Record;
 parameter Modelica.SIunits.Resistivity r0
    "Material electrical resistivity per unit length at T0";
 parameter Modelica.SIunits.LinearTemperatureCoefficient alphaT0
    "Linear temperature electrical resistivity coefficient";
 parameter Modelica.SIunits.Temperature T0
    "reference temperature for linear electrical resistivity";
end Material;
