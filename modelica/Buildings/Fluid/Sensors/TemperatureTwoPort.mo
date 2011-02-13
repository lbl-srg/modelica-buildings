within Buildings.Fluid.Sensors;
model TemperatureTwoPort "Ideal two port temperature sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialFlowSensor;

  Modelica.Blocks.Interfaces.RealOutput T( final quantity="Temperature",
                                           final unit="K",
                                           displayUnit = "degC",
                                           min = 0)
    "Temperature of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
protected
  Medium.Temperature T_a_inflow "Temperature of inflowing fluid at port_a";
  Medium.Temperature T_b_inflow
    "Temperature of inflowing fluid at port_b or T_a_inflow, if uni-directional flow";
equation
  if allowFlowReversal then
    T_a_inflow = Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
    T_b_inflow = Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow));
    T = Modelica.Fluid.Utilities.regStep(port_a.m_flow, T_a_inflow, T_b_inflow, m_flow_small);
  else
     T = Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     T_a_inflow = T;
     T_b_inflow = T;
  end if;
annotation (defaultComponentName="senTem",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}},
        grid={1,1}),
          graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{0,100},{0,50}}, color={0,0,127}),
        Line(points={{-92,0},{100,0}}, color={0,128,255}),
        Ellipse(
          extent={{-20,-68},{20,-30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,50},{12,-34}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,50},{-12,70},{-10,76},{-6,78},{0,80},{6,78},{10,76},{12,
              70},{12,50},{-12,50}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,50},{-12,-35}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,50},{12,-34}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-40,-10},{-12,-10}}, color={0,0,0}),
        Line(points={{-40,20},{-12,20}}, color={0,0,0}),
        Line(points={{-40,50},{-12,50}}, color={0,0,0}),
        Text(
          extent={{94,122},{0,92}},
          lineColor={0,0,0},
          textString="T")}),
  Documentation(info="<HTML>
<p>
This component monitors the temperature of the passing fluid. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
</HTML>
"));
end TemperatureTwoPort;
