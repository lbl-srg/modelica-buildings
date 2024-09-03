within Buildings.ThermalZones.Detailed.BaseClasses;
model CFDSurfaceInterface
 extends Buildings.BaseClasses.BaseIcon;
  parameter Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions bouCon
    "Boundary condition used in the CFD simulation" annotation (Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput Q_flow_in
 if bouCon == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature
    "Surface heat flow rate, used for temperature boundary condition"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealOutput T_out
 if bouCon == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature
    "Surface temperature, used for temperature boundary condition"
    annotation (Placement(transformation(extent={{-100,30},{-120,50}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow_out
 if bouCon == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate
    "Surface heat flow rate, used for temperature boundary condition"
    annotation (Placement(transformation(extent={{-120,-60},{-80,-20}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput T_in
 if bouCon == Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate
    "Surface temperature, used for temperature boundary condition"
    annotation (Placement(transformation(extent={{-100,-90},{-120,-70}}),
        iconTransformation(extent={{-100,-90},{-120,-70}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port "Heat ports"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // Internal connectors to change causality depending on the specifie
  // boundary condition
protected
  Modelica.Blocks.Interfaces.RealInput Q_flow_internal "Surface heat flow rate";

  Modelica.Blocks.Interfaces.RealOutput T_internal "Surface temperature";

equation
  connect(T_internal,      T_out);
  connect(Q_flow_internal, Q_flow_in);
  connect(T_internal,      T_in);
  connect(Q_flow_internal, Q_flow_out);
  T_internal      = port.T;
  Q_flow_internal = port.Q_flow;

  annotation (    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model is used to connect temperatures and heat flow rates between the
block that communicates with the CFD program
and the heat port of the model that encapsulates the air heat and mass balance.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CFDSurfaceInterface;
