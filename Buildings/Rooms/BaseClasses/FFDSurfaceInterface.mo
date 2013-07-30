within Buildings.Rooms.BaseClasses;
model FFDSurfaceInterface
 extends Buildings.BaseClasses.BaseIcon;
  parameter Integer n(min=0) "Number of surfaces";
  parameter Buildings.Rooms.Types.CFDBoundaryConditions bouCon[n]
   "Boundary condition used in the CFD simulation";

  Modelica.Blocks.Interfaces.RealInput Q_flow[n]
    "Surface temperaturesHeat flow rate"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealOutput T[n] "Surface temperatures"
    annotation (Placement(transformation(extent={{-100,-50},{-120,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port[n] "Heat ports"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));



equation
  T = port.T;
  port.Q_flow = Q_flow;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model is used to connect temperatures and heat flow rates between the 
block that communicates with the fast fluid flow dynamic program
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
end FFDSurfaceInterface;
