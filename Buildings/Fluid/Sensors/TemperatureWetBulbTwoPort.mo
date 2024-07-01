within Buildings.Fluid.Sensors;
model TemperatureWetBulbTwoPort "Ideal wet bulb temperature sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  Modelica.Blocks.Interfaces.RealOutput T(
    start=TWetBul_start,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit = "degC") "Wet bulb temperature in port medium"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  parameter Modelica.Units.SI.Temperature TWetBul_start=Medium.T_default
    "Initial or guess value of wet bulb temperature (used to compute initial output signal))"
    annotation (Dialog(group="Initialization"));

protected
  Medium.Temperature TMedWetBul(start=TWetBul_start)
    "Medium wet bulb temperature to which the sensor is exposed";
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulMod(
    redeclare package Medium = Medium,
    TWetBul(start=TWetBul_start)) "Block for wet bulb temperature";
  Modelica.Units.SI.SpecificEnthalpy h "Specific enthalpy";
  Medium.MassFraction Xi[Medium.nXi]
    "Species vector, needed because indexed argument for the operator inStream is not supported";
initial equation
  // Initialization of wet bulb temperature
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(T) = 0;
     elseif initType == Modelica.Blocks.Types.Init.InitialState or
            initType == Modelica.Blocks.Types.Init.InitialOutput then
      T = TWetBul_start;
    end if;
  end if;
equation
  if allowFlowReversal then
    h  = Modelica.Fluid.Utilities.regStep(
           x=port_a.m_flow,
           y1=port_b.h_outflow,
           y2=port_a.h_outflow,
           x_small=m_flow_small);
    Xi = Modelica.Fluid.Utilities.regStep(
           x=port_a.m_flow,
           y1=port_b.Xi_outflow,
           y2=port_a.Xi_outflow,
           x_small=m_flow_small);
  else
    h = port_b.h_outflow;
    Xi = port_b.Xi_outflow;
  end if;
  // Compute wet bulb temperature
  wetBulMod.TDryBul = Medium.temperature_phX(
    p=port_a.p,
    h=h,
    X=if Medium.reducedX then cat(1, Xi, {1-sum(Xi)}) else Xi);
  wetBulMod.Xi = Xi;
  wetBulMod.p  = port_a.p;
  TMedWetBul = wetBulMod.TWetBul;
  // Output signal of sensor
  if dynamic then
    der(T) = (TMedWetBul-T)*k*tauInv;
  else
    T = TMedWetBul;
  end if;
annotation (defaultComponentName="senWetBul",
    Icon(graphics={
        Line(points={{-100,0},{92,0}}, color={0,128,255}),
        Ellipse(
          extent={{-20,-58},{20,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,60},{-12,60}}),
        Line(points={{-40,30},{-12,30}}),
        Line(points={{-40,0},{-12,0}}),
        Rectangle(
          extent={{-12,60},{12,-24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
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
        Text(
         extent={{-20,120},{-140,70}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(T-273.15, format=".1f")))}),
    Documentation(info="<html>
<p>
This sensor outputs the wet bulb temperature of the medium in the flow
between its fluid ports. The sensor is ideal, i.e., it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 24, 2022, by Michael Wetter:<br/>
Improved conversion from <code>Xi</code> to <code>X</code> so that it also works
with media that have <code>reducedX=true</code>.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1650\">#1650</a>.
</li>
<li>
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
January 18, 2016 by Filip Jorissen:<br/>
Using parameter <code>tauInv</code>
since this now exists in
<a href=\"modelica://Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor\">Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor</a>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>.
</li>
<li>
September 10, 2013 by Michael Wetter:<br/>
Set <code>start</code> attribute for <code>wetBulMod</code>
to use consistent start values within this model.
</li>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
February 18, 2010, by Michael Wetter:<br/>
Revised model to use new block for computing the wet bulb temperature.
</li>
<li>
September 10, 2008, by Michael Wetter:<br/>
Renamed output port to have the same interfaces as the dry bulb temperature sensor.
</li>
<li>
May 5, 2008, by Michael Wetter:<br/>
First implementation.
Implementation is based on
<a href=\"modelica://Buildings.Fluid.Sensors.Temperature\">Buildings.Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>"));
end TemperatureWetBulbTwoPort;
