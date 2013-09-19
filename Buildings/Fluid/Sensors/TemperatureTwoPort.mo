within Buildings.Fluid.Sensors;
model TemperatureTwoPort "Ideal two port temperature sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature",
                                          final unit="K",
                                          displayUnit = "degC",
                                          min = 0,
                                          start=T_start)
    "Temperature of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  parameter Modelica.SIunits.Temperature T_start=Medium.T_default
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

protected
  Medium.Temperature TMed(start=T_start)
    "Medium temperature to which the sensor is exposed";
  Medium.Temperature T_a_inflow "Temperature of inflowing fluid at port_a";
  Medium.Temperature T_b_inflow
    "Temperature of inflowing fluid at port_b, or T_a_inflow if uni-directional flow";
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(T) = 0;
     elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      T = T_start;
    end if;
  end if;
equation
  if allowFlowReversal then
     T_a_inflow = Medium.temperature(state=
                    Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     T_b_inflow = Medium.temperature(state=
                    Medium.setState_phX(p=port_a.p, h=port_a.h_outflow, X=port_a.Xi_outflow));
     TMed = Modelica.Fluid.Utilities.regStep(
              x=port_a.m_flow,
              y1=T_a_inflow,
              y2=T_b_inflow,
              x_small=m_flow_small);
  else
     TMed = Medium.temperature(state=
              Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     T_a_inflow = TMed;
     T_b_inflow = TMed;
  end if;
  // Output signal of sensor
  if dynamic then
    der(T) = (TMed-T)*k/tau;
  else
    T = TMed;
  end if;
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
    Documentation(info="<html>
<p>
This model outputs the temperature of the medium in the flow
between its fluid ports. The sensor does not influence the fluid. 
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation. 
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>
", revisions="<html>
<ul>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that 
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
February 26, 2010 by Michael Wetter:<br/>
Set start attribute for temperature output. Prior to this change,
the output was 0 at initial time, which caused the plot of the output to 
use 0 Kelvin as the lower value of the ordinate.
</li>
<li>
September 10, 2008, by Michael Wetter:<br/>
First implementation, based on 
<a href=\"modelica://Buildings.Fluid.Sensors.Temperature\">Buildings.Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>"));
end TemperatureTwoPort;
