within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses;
block InputInterface
  "Interface for base classes blocks in water to water heat pump"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Interfaces.IntegerInput mode(min=0,max=2)
    "Mode 0:off, 1:heating, 2:cooling"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
//   Modelica.Blocks.Interfaces.IntegerInput stage(final min=0)
//     "Stage of HP, positive value"
  Modelica.Blocks.Interfaces.RealInput T1(
    quantity="Temperature",unit="K",displayUnit="degC")
    "Temperature of water entering the load side coil "
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput T2(
    quantity="Temperature",unit="K",displayUnit="degC")
    "Temperature of water entering the source side coil "
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput m1_flow(
    quantity="MassFlowRate",unit="kg/s") "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
        iconTransformation(extent={{-120,0},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput m2_flow(
    quantity="MassFlowRate", unit="kg/s") "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput rho[4](quantity="Density", unit="kg/m3")
    "Medium density"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  annotation (Diagram(graphics), Icon(graphics));
end InputInterface;
