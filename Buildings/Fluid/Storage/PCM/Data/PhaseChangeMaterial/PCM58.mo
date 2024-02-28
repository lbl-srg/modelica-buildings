within Buildings.Fluid.Storage.PCM.Data.PhaseChangeMaterial;
record PCM58 "Properties for 58 C phase change material"
  parameter Modelica.Units.SI.Temperature TSol=273.15 + 55
    "Solidus temperature, used only for PCM."
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Temperature TLiq=273.15 + 59
    "Liquidus temperature, used only for PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificEnthalpy LHea=226000
    "Latent heat of fusion of PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cPCM=3150
    "Specific heat capacity of PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Density dPCM=1360 "Average density of PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.ThermalConductivity kPCM=0.584
    "Thermal conductivity of PCM"
    annotation (Dialog(group="Material Properties"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,60},{150,100}},
          textString="%name"),
        Rectangle(
          origin={0.0,-25.0},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-75.0},{100.0,75.0}},
          radius=25.0),
        Line(
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0.0,-50.0},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0.0,-25.0},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64})}), Documentation(info="<html>
          <p>This record contains the material properties of the PCM.
</p>
</html>"));
end PCM58;
