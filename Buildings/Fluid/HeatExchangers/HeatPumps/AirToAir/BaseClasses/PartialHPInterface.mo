within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses;
partial block PartialHPInterface "Partial block for heat pump interface"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Interfaces.IntegerInput mode "Mode of operation"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,66},{-100,86}})));
  Modelica.Blocks.Interfaces.RealInput T[2](unit="K")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
   annotation (Placement(transformation(extent={{-120,40},{-100,60}},  rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput EIR "Energy Input Ratio"
     annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    max=0,
    unit="W") "Total cooling capacity"
     annotation (Placement(transformation(extent={{100,30},{120,50}})));
  parameter Integer nm_flow=2;
  Modelica.Blocks.Interfaces.RealInput m_flow[nm_flow] "Air mass flow rate"
     annotation (Placement(transformation(extent={{-120,14},{-100,34}})));
  annotation (Diagram(graphics), Documentation(info="<html>
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
August 1, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end PartialHPInterface;
