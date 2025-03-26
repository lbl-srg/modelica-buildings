within Buildings.Fluid.Sensors;
model HeatMeter "Measures thermal energy provided between supply and return pipes"
  extends BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RoundSensor;
  Modelica.Blocks.Interfaces.RealInput TExt(
    final unit="K",
    displayUnit="degC") "External temperature measurement to calculate temperature difference"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Heat flow rate"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  parameter Modelica.Units.SI.Temperature T_start=Medium.T_default
    "Initial or guess value of temperature"
    annotation (Dialog(group="Initialization"));
  Medium.Temperature T(start=T_start) "Temperature of the passing fluid";
protected
  Medium.Temperature TMed(start=T_start) "Medium temperature to which the sensor is exposed";
  Medium.Temperature T_a_inflow "Temperature of inflowing fluid at port_a";
  Medium.Temperature T_b_inflow "Temperature of inflowing fluid at port_b, or T_a_inflow if uni-directional flow";
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
  if dynamic then
    der(T) = (TMed-T)*k*tauInv;
  else
    T = TMed;
  end if;
  Q_flow = port_a.m_flow * Medium.cp_const * (T - TExt);

annotation (defaultComponentName="senHeaFlo",
  Icon(graphics={
        Ellipse(
          fillColor={245,222,222},
          fillPattern=FillPattern.Solid,
          extent={{-70,-70},{70,70}}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Text(
          extent={{180,151},{20,99}},
          textColor={0,0,0},
          textString="Q_flow"),
        Text(
          extent={{-20,120},{-140,70}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(Q_flow, leftJustified=false, significantDigits=3))),
        Text(
          extent={{-22,120},{-100,48}},
          textColor={0,0,127},
          textString="TExt"),
        Line(points={{37.6,13.7},{65.8,23.9}}),
        Line(points={{22.9,32.8},{40.2,57.3}}),
        Line(points={{0,70},{0,40}}),
        Line(points={{-22.9,32.8},{-40.2,57.3}}),
        Line(points={{-37.6,13.7},{-65.8,23.9}}),
        Ellipse(
          fillColor={64,64,64},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-7,-7},{7,7}}),
        Polygon(
          rotation=-17.5,
          fillColor={64,64,64},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-5.0,0.0},{-2.0,60.0},{0.0,65.0},{2.0,60.0},{5.0,0.0}}),
        Ellipse(
          lineColor={64,64,64},
          fillColor={255,255,255},
          extent={{-12,-12},{12,12}})}),
Documentation(info="<html>
<p>
This model measures thermal energy provided between a supply and return pipe.
It measures the capacity flow rate of the heat transfer fluid and the change in its
temperature compared to an external temperature measurement that is input into the port
<code>TExt</code>. The sensor does not influence the fluid.
</p>
<p>
The rate of heat flow is calculated as <i>Q&#775; = m&#775; c<sub>p</sub> (T - T<sub>Ext</sub>)</i>.</p>
</html>",
revisions="<html>
<ul>
<li>
February 1, 2024, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1831\">IBPSA, #1831</a>.
</li>
<li>
February 1, 2024, by Jan Gall:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1831\">IBPSA, #1831</a>.
</li>
</ul>
</html>"));
end HeatMeter;
