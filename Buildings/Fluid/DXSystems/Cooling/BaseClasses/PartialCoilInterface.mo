within Buildings.Fluid.DXSystems.Cooling.BaseClasses;
partial block PartialCoilInterface "Partial block for DX coil"
  extends Modelica.Blocks.Icons.Block;
  extends
    Buildings.Fluid.DXSystems.Cooling.BaseClasses.EssentialParameters;

  constant Boolean use_mCon_flow "Set to true to enable connector for the condenser mass flow rate";

  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of coil, or 0/1 for variable-speed coil"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,66},{-100,86}})));
  Modelica.Blocks.Interfaces.RealInput m_flow "Air mass flow rate"
     annotation (Placement(transformation(extent={{-120,14},{-100,34}})));
  Modelica.Blocks.Interfaces.RealInput TEvaIn
    "Temperature of air entering the cooling coil"
     annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TConIn(
    unit="K",
    displayUnit="degC")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
   annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput EIR "Energy Input Ratio"
     annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    max=0,
    unit="W") "Total cooling capacity"
     annotation (Placement(transformation(extent={{100,30},{120,50}})));


  Modelica.Blocks.Interfaces.RealInput mCon_flow if use_mCon_flow
    "Water mass flow rate at condensers for water source DX units"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  annotation ( Documentation(info="<html>
<p>
This partial block declares the inputs and outputs that are common for
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.DryCoil\">
Buildings.Fluid.DXSystems.BaseClasses.DryCoil</a> and
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.DXCooling\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.DXCooling</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 13, 2017, by Michael Wetter:<br/>
Removed connectors that are no longer needed.
</li>
<li>February 17, 2017 by Yangyang Fu:<br/>
Added a boolean constant <code>use_mCon_flow</code> which is required in water source DX coils.
</li>
<li>August 1, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialCoilInterface;
