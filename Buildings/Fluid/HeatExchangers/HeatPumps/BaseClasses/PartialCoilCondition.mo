within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
partial block PartialCoilCondition "Partial block for dry-wet coil condition"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialHPInterface;
//   constant Boolean isMedium2Water "Set to true if Medium2 mass flow rate affects the capacity of heat pump; set true for
//     water to water heatpump";
//   Modelica.Blocks.Interfaces.RealInput m_flow[2] if isMedium2Water
//     "Air mass flow rate"
//      annotation (Placement(transformation(extent={{-120,14},{-100,34}})));

//   Modelica.Blocks.Interfaces.RealInput m1_flow if not (isMedium2Water)
//     "Air mass flow rate"
//      annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
protected
  DXCoils.BaseClasses.SpeedShift
             speShiEIR "Interpolates EIR"
    annotation (Placement(transformation(extent={{44,72},{60,88}})));
  DXCoils.BaseClasses.SpeedShift
             speShiQ_flow "Interpolates Q_flow"
    annotation (Placement(transformation(extent={{44,32},{60,48}})));
equation
  connect(speShiEIR.y, EIR) annotation (Line(
      points={{60.8,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, Q_flow) annotation (Line(
      points={{60.8,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
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
end PartialCoilCondition;
