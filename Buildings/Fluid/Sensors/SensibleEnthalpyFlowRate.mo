within Buildings.Fluid.Sensors;
model SensibleEnthalpyFlowRate
  "Ideal enthalphy flow rate sensor that outputs the sensible enthalpy flow rate only"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    tau=0);
  extends Buildings.Fluid.BaseClasses.IndexMassFraction(final substanceName="water");
  extends Modelica.Icons.RoundSensor;
  Modelica.Blocks.Interfaces.RealOutput H_flow(final unit="W")
    "Sensible enthalpy flow rate, positive if from port_a to port_b"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  parameter Modelica.Units.SI.SpecificEnthalpy h_out_start=
      Medium.enthalpyOfNonCondensingGas(T=Medium.T_default)
    "Initial or guess value of measured specific sensible enthalpy"
    annotation (Dialog(group="Initialization"));
protected
  Modelica.Units.SI.SpecificEnthalpy hMed_out(start=h_out_start)
    "Medium sensible enthalpy to which the sensor is exposed";
  Modelica.Units.SI.SpecificEnthalpy h_out(start=h_out_start)
    "Medium sensible enthalpy that is used to compute the enthalpy flow rate";
  Medium.MassFraction XiActual[Medium.nXi]
    "Medium mass fraction to which sensor is exposed to";
  Medium.SpecificEnthalpy hActual
    "Medium enthalpy to which sensor is exposed to";
initial equation
 // Compute initial state
 if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(h_out) = 0;
    elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      h_out = h_out_start;
    end if;
  end if;
equation
  if allowFlowReversal then
     XiActual = Modelica.Fluid.Utilities.regStep(
                  x=port_a.m_flow,
                  y1=port_b.Xi_outflow,
                  y2=port_a.Xi_outflow,
                  x_small=m_flow_small);
     hActual = Modelica.Fluid.Utilities.regStep(
                 x=port_a.m_flow,
                 y1=port_b.h_outflow,
                 y2=port_a.h_outflow,
                 x_small=m_flow_small);
  else
     XiActual = port_b.Xi_outflow;
     hActual = port_b.h_outflow;
  end if;
  // Specific enthalpy measured by sensor
  hMed_out = (1-XiActual[i_x]) * Medium.enthalpyOfNonCondensingGas(
      T=Medium.temperature(state=Medium.setState_phX(p=port_a.p, h=hActual, X=XiActual)));
  if dynamic then
    der(h_out) = (hMed_out-h_out)*k*tauInv;
  else
    h_out = hMed_out;
  end if;
  // Sensor output signal
  H_flow = port_a.m_flow * h_out;
annotation (defaultComponentName="senEntFlo",
  Icon(graphics={
        Ellipse(
          extent={{-70,70},{70,-70}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Text(
          extent={{180,151},{20,99}},
          textColor={0,0,0},
          textString="HS_flow"),
        Polygon(
          points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,0},{9.02,28.6}}),
        Ellipse(
          extent={{-5,5},{5,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{37.6,13.7},{65.8,23.9}}),
        Line(points={{22.9,32.8},{40.2,57.3}}),
        Line(points={{0,70},{0,40}}),
        Line(points={{-22.9,32.8},{-40.2,57.3}}),
        Line(points={{-37.6,13.7},{-65.8,23.9}}),
        Text(
         extent={{-20,120},{-140,70}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(H_flow, leftJustified=false, significantDigits=3)))}),
  Documentation(info="<html>
<p>
This model outputs the <i>sensible</i> enthalphy flow rate of the medium in the flow
between its fluid ports. In particular, if the total enthalpy flow rate is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  H&#775;<sub>tot</sub> = H&#775;<sub>sen</sub> + H&#775;<sub>lat</sub>,
</p>
<p>
where
<i>H&#775;<sub>sen</sub> = m&#775; (1-X<sub>w</sub>) c<sub>p,air</sub></i>,
then this sensor outputs <i>H&#775; = H&#775;<sub>sen</sub></i>.
</p>

<p>
If the parameter <code>tau</code> is non-zero, then the measured
specific sensible enthalpy <i>h<sub>out</sub></i> that is used to
compute the sensible enthalpy flow rate
<i>H&#775;<sub>sen</sub> = m&#775; h<sub>out</sub></i>
is computed using a first order differential equation.
See <a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>

<p>
For a sensor that measures
<i>H&#775;<sub>tot</sub></i>, use
<a href=\"modelica://Buildings.Fluid.Sensors.EnthalpyFlowRate\">
Buildings.Fluid.Sensors.EnthalpyFlowRate</a>.<br/>
For a sensor that measures
<i>H&#775;<sub>lat</sub></i>, use
<a href=\"modelica://Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
</p>

<p>
The sensor is ideal, i.e., it does not influence the fluid.
The sensor can only be used with medium models that implement the function
<code>enthalpyOfNonCondensingGas(T)</code>.</p>

</html>",
revisions="<html>
<ul>
<li>
October 19, 2020, by Antoine Gautier:<br/>
Changed default value for <code>tau</code> from <code>1</code> to <code>0</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1406\">#1406</a>.
</li>
<li>
February 25, 2020, by Michael Wetter:<br/>
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
September 10, 2013, by Michael Wetter:<br/>
Changed medium declaration in the <code>extends</code> statement
to <code>replaceable</code> to avoid a translation error in
OpenModelica.
</li>
<li>
August 31, 2013, by Michael Wetter:<br/>
Removed default value <code>tau=0</code> as the base class
already sets <code>tau=1</code>.
This change was made so that all sensors use the same default value.
</li>
<li>
December 18, 2012, by Michael Wetter:<br/>
Moved computation of <code>i_w</code> to new base class
<a href=\"modelica://Buildings.Fluid.BaseClasses.IndexWater\">
Buildings.Fluid.BaseClasses.IndexWater</a>.
The value of this parameter is now assigned dynamically and does not require to be specified
by the user.
</li>
<li>
November 3, 2011, by Michael Wetter:<br/>
Moved <code>der(h_out) := 0;</code> from the initial algorithm section to
the initial equation section
as this assignment does not conform to the Modelica specification.
</li>
<li>
August 10, 2011 by Michael Wetter:<br/>
Added parameter <code>i_w</code> and an assert statement to
make sure it is set correctly. Without this change, Dymola
cannot differentiate the model when reducing the index of the DAE.
</li>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that
the time constant increases as the mass flow rate tends to zero.
This can improve the numerics.
</li>
<li>
February 22, by Michael Wetter:<br/>
Improved code that searches for index of 'water' in the medium model.
</li>
<li>
September 9, 2009 by Michael Wetter:<br/>
First implementation.
Implementation is based on enthalpy sensor of <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end SensibleEnthalpyFlowRate;
