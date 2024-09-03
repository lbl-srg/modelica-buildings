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
  parameter Modelica.Units.SI.Temperature T_start=Medium.T_default
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

  parameter Boolean transferHeat = false
    "if true, temperature T converges towards TAmb when no flow"
    annotation(Evaluate=true, Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Temperature TAmb=Medium.T_default
    "Fixed ambient temperature for heat transfer"
    annotation (Dialog(enable=transferHeat, group="Heat transfer"));
  parameter Modelica.Units.SI.Time tauHeaTra(min=1) = 1200
    "Time constant for heat transfer, default 20 minutes"
    annotation (Dialog(enable=transferHeat, group="Heat transfer"));

protected
  parameter Real tauHeaTraInv(final unit = "1/s")=
    if tauHeaTra<1E-10 then 0 else 1/tauHeaTra
    "Dummy parameter to avoid division by tauHeaTra";
  parameter Real ratTau = if dynamic then tauHeaTra/tau else 1
    "Ratio of tau";
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
    if transferHeat then
      der(T) = (TMed-T)*k*tauInv + (TAmb-T)*tauHeaTraInv/(ratTau*k+1);
    else
      der(T) = (TMed-T)*k*tauInv;
    end if;
  else
    T = TMed;
  end if;
annotation (defaultComponentName="senTem",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Line(points={{-100,0},{92,0}}, color={0,128,255}),
        Ellipse(
          extent={{-20,-58},{20,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,60},{-12,60}}),
        Line(points={{-40,30},{-12,30}}),
        Line(points={{-40,0},{-12,0}}),
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
          textColor={0,0,0},
          textString="T"),
        Line(
          points={{-12,60},{-12,-25}},
          thickness=0.5),
        Line(
          points={{12,60},{12,-24}},
          thickness=0.5),
        Line(points={{0,100},{0,50}}, color={0,0,127}),
    Line(
    origin={-77.5,-22.3333},
    points={{43.5,8.3333},{37.5,0.3333},{21.5,-3.6667},{37.5,-17.6667},{7.5,-17.6667},
              {19.5,-37.6667},{3.5,-38.3333},{-2.5,-48.3333}},
      smooth=Smooth.Bezier,
      visible=transferHeat),
        Polygon(
          points={{-90,-80},{-84,-66},{-76,-74},{-90,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=transferHeat),
        Text(
         extent={{-20,120},{-140,70}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(T-273.15, format=".1f")))}),
    Documentation(info="<html>
<p>
This model outputs the temperature of the medium in the flow
between its fluid ports. The sensor does not influence the fluid.
</p>
<h4>Typical use and important parameters</h4>
<p>
If the parameter <code>tau</code> is non-zero, then its output <i>T</i>
converges to the temperature of the incoming fluid using
a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
<p>
If <code>transferHeat = true</code>, then heat transfer with the ambient is
approximated and <i>T</i> converges towards the fixed ambient
temperature <i>T<sub>Amb</sub></i> using a first order approximation
with a time constant of <code>tauHeaTra</code>
when the flow rate is small.
Note that no energy is exchanged with the fluid as the
sensor does not influence the fluid temperature.
</p>
<p>
Setting <code>transferHeat = true</code> is useful, for example,
if the sensor is used to measure the fluid temperature in
a system with on/off control on the mass flow rate.
If <code>transferHeat</code> were <code>false</code>, then the sensor output <i>T</i>
would remain constant if the mass flow rate is set to zero, and hence
the controller may never switch the mass flow rate on again.
</p>
<p>
In general, applications in which the sensor output is not used to switch
the mass flow rate on should set <code>transferHeat=false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
October 23, 2017 by Filip Jorissen:<br/>
Revised implementation of equations
when <code>transferHeat=true</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/840\">#840</a>.
</li>
<li>
January 12, 2016 by Filip Jorissen:<br/>
Removed parameter <code>tauInv</code>
since this now exists in
<a href=\"modelica://Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor\">Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor</a>.
</li>
<li>
June 19, 2015 by Michael Wetter:<br/>
Revised model and documentation.
</li>
<li>
June 18, 2015 by Filip Jorissen:<br/>
Added option for simulating thermal losses.
</li>
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
