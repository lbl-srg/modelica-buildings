within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block PartialCoilInterface "Partial block for DX coil"
  extends Modelica.Blocks.Icons.Block;
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialParameters;
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
  Modelica.Blocks.Interfaces.RealInput XEvaIn "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Modelica.Blocks.Interfaces.RealInput hEvaIn
    "Specific enthalpy of air entering the coil"
            annotation (Placement(transformation(extent={{-120,-87},{-100,-67}})));
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

  annotation ( Documentation(info="<html>
<p>
This partial block declares the inputs and outputs that are common for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCondition\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCondition</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"));
end PartialCoilInterface;
