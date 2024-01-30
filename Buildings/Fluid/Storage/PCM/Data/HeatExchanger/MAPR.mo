within Buildings.Fluid.Storage.PCM.Data.HeatExchanger;
record MAPR "Material Properties Record"
  parameter Modelica.Units.SI.Temperature TSolCoo=273.15 + 10
    "Solidus temperature, used only for cold PCM."
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Temperature TLiqCoo=273.15 + 12
    "Liquidus temperature, used only for cold PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Temperature TSolHig=273.15 + 55
    "Solidus temperature, used only for hot PCM."
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Temperature TLiqHig=273.15 + 59
    "Liquidus temperature, used only for hot PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Temperature TSolLow=273.15 + 47
    "Solidus temperature, used only for warm PCM."
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Temperature TLiqLow=273.15 + 49
    "Liquidus temperature, used only for warm PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Temperature TSolPas=273.15 + 22
    "Solidus temperature, used only for passive PCM."
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Temperature TLiqPas=273.15 + 23
    "Liquidus temperature, used only for passive PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificEnthalpy LHeaCoo=126000
    "Latent heat of fusion of cold PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificEnthalpy LHeaHig=226000
    "Latent heat of fusion of hot PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificEnthalpy LHeaLow=0.8*226000
    "Latent heat of fusion of warm PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificEnthalpy LHeaPas=150000
    "Latent heat of fusion of passive PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cPCMCoo=2050
    "Specific heat capacity of cold PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cPCMHig=3150
    "Specific heat capacity of hot PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cPCMLow=3150
    "Specific heat capacity of warm PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cPCMPas=1450
    "Specific heat capacity of passive PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Density dPCMCoo=1125
    "Average density of cold PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Density dPCMHig=1360 "Average density of hot PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Density dPCMLow=1360
    "Average density of warm PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.Density dPCMPas=1620
    "Average density of passive PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.ThermalConductivity kPCMCoo=0.2
    "Thermal conductivity of cold PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.ThermalConductivity kPCMHig=0.584
    "Thermal conductivity of hot PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.ThermalConductivity kPCMLow=0.584
    "Thermal conductivity of warm PCM"
    annotation (Dialog(group="Material Properties"));
  parameter Modelica.Units.SI.ThermalConductivity kPCMPas=0.7
    "Thermal conductivity of passive PCM"
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
end MAPR;
