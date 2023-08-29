within Buildings.Experimental.DHC.Loads.DHW.BaseClasses.DELETE;
partial model PartialDHWGeneration
  "A partial model for domestic water heating"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.Temperature TSetHw "Temperature setpoint of hot water supply from heater";
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal "Nominal mass flow rate of hot water supply";
  parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal "Nominal mass flow rate of district heating water";

  Modelica.Fluid.Interfaces.FluidPort_b port_hw(redeclare package Medium = Medium) "Hot water supply port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_cw(redeclare package Medium = Medium) "Port for domestic cold water inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_dhs(redeclare package Medium = Medium) "Port for district heating supply"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_dhr(redeclare package Medium = Medium) "Port for district heating return"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Modelica.Blocks.Interfaces.RealOutput PEle "Electric power required for generation equipment"
    annotation (Placement(transformation(extent={{96,30},{116,50}})));
  Modelica.Blocks.Sources.Constant conTSetHw(k=TSetHw)
    "Temperature setpoint for domestic hot water supply from heater"
    annotation (Placement(transformation(extent={{-100,24},{-84,40}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialDHWGeneration;
