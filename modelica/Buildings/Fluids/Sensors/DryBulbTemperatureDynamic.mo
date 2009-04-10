within Buildings.Fluids.Sensors;
model DryBulbTemperatureDynamic "Ideal temperature sensor"
  extends Modelica_Fluid.Sensors.BaseClasses.PartialFlowSensor;
annotation (
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
"),
revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br>
First implementation based on 
<a href=\"Modelica:Modelica_Fluid.Sensors.Temperature\">Modelica_Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>");

  parameter Modelica.SIunits.Time tau(min=0) = 10 "Time constant";
  Modelica.Blocks.Interfaces.RealOutput T( final quantity="ThermodynamicTemperature",
                                           final unit="K",
                                           min = 0,
                                           displayUnit="degC")
    "Temperature of the passing fluid" 
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));

  parameter Medium.MassFlowRate m_flow_nominal(min=0) "Nominal mass flow rate" 
    annotation(Dialog(group = "Nominal condition"));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
    "For bi-directional flow, temperature is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(tab="Advanced"));

  parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (InitialState and InitialOutput are identical)" 
     annotation(Evaluate=true, Dialog(group="Initialization"));
  parameter Modelica.SIunits.Temperature T_start=Medium.T_default
    "Initial or guess value of output (= state)" 
    annotation (Dialog(group="Initialization"));
protected
  Medium.Temperature T_a_inflow "Temperature of inflowing fluid at port_a";
  Medium.Temperature T_b_inflow
    "Temperature of inflowing fluid at port_b or T_a_inflow, if uni-directional flow";
  Medium.Temperature TMed "Medium to which sensor is exposed";
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
     TMed = Modelica_Fluid.Utilities.regStep(port_a.m_flow, T_a_inflow, T_b_inflow, m_flow_small);
  else
     TMed = Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     T_a_inflow = TMed;
     T_b_inflow = TMed;
  end if;
  der(T)  = (TMed-T)/tau;
end DryBulbTemperatureDynamic;
