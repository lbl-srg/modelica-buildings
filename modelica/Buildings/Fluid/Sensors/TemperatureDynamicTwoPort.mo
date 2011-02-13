within Buildings.Fluid.Sensors;
model TemperatureDynamicTwoPort "Ideal temperature sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialFlowSensor;

  parameter Modelica.SIunits.Time tau(min=0) = 10 "Time constant";
  Modelica.Blocks.Interfaces.RealOutput T( final quantity="Temperature",
                                           final unit="K",
                                           displayUnit = "degC",
                                           min = 0,
                                           start=T_start)
    "Temperature of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));

  parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (InitialState and InitialOutput are identical)"
     annotation(Evaluate=true, Dialog(group="Initialization"));
  parameter Modelica.SIunits.Temperature T_start=Medium.T_default
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));
  Medium.Temperature TMed "Medium temperature to which sensor is exposed";
protected
  Medium.Temperature T_a_inflow "Temperature of inflowing fluid at port_a";
  Medium.Temperature T_b_inflow
    "Temperature of inflowing fluid at port_b or T_a_inflow, if uni-directional flow";
initial equation
  if initType == Modelica.Blocks.Types.Init.SteadyState then
    der(T) = 0;
  elseif initType == Modelica.Blocks.Types.Init.InitialState or
         initType == Modelica.Blocks.Types.Init.InitialOutput then
    T = T_start;
  end if;
equation
  if allowFlowReversal then
     T_a_inflow = Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     T_b_inflow = Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow));
     TMed = Modelica.Fluid.Utilities.regStep(port_a.m_flow, T_a_inflow, T_b_inflow, m_flow_small);
  else
     TMed = Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     T_a_inflow = TMed;
     T_b_inflow = TMed;
  end if;
  der(T)  = (TMed-T)/tau;
annotation (defaultComponentName="senTem",
  Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),
          graphics),
    Icon(graphics={
        Line(points={{-100,0},{92,0}}, color={0,128,255}),
        Ellipse(
          extent={{-20,-58},{20,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{20,10},{24,26},{34,40},{54,52},{78,54},{96,54}}, color={0,
              0,127}),
        Line(points={{-40,60},{-12,60}}, color={0,0,0}),
        Line(points={{-40,30},{-12,30}}, color={0,0,0}),
        Line(points={{-40,0},{-12,0}}, color={0,0,0}),
        Rectangle(
          extent={{-12,60},{12,-24}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,60},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,
              80},{12,60},{-12,60}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Text(
          extent={{102,140},{-18,90}},
          lineColor={0,0,0},
          textString="T"),
        Line(
          points={{-12,60},{-12,-25}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,60},{12,-24}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{0,100},{0,50}}, color={0,0,127})}),
    Documentation(info="<HTML>
<p>
This component monitors the temperature of the medium in the flow
between fluid ports. The sensor does not influence the fluid. Its output
is computed using a first order differential equation.
</p>
</HTML>
", revisions="<html>
<html>
<ul>
<li>
February 26, 2010 by Michael Wetter:<br>
Set start attribute for temperature output. Prior to this change,
the output was 0 at initial time, which caused the plot of the output to 
use 0 Kelvin as the lower value of the ordinate.
</li>
</ul>
</html>"),
revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br>
First implementation based on 
<a href=\"modelica://Buildings.Fluid.Sensors.Temperature\">Buildings.Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>");
end TemperatureDynamicTwoPort;
