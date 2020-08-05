within Buildings.Fluid.Sensors;
model EntropyFlowRate "Ideal entropy flow rate sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput S_flow(final unit="W/K")
    "Entropy flow rate, positive if from port_a to port_b"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  parameter Modelica.SIunits.SpecificEntropy s_out_start=
    Medium.specificEntropy_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Initial or guess value of measured specific entropy"
    annotation (Dialog(group="Initialization"));
protected
  Modelica.SIunits.SpecificEntropy sMed_out(start=s_out_start)
    "Medium entropy to which the sensor is exposed";
  Modelica.SIunits.SpecificEntropy s_out(start=s_out_start)
    "Medium entropy that is used to compute the entropy flow rate";
  Modelica.SIunits.SpecificEntropy port_b_s_outflow(start=s_out_start)
    "Medium entropy outflowing at port_b if mass flow were from port_a to port_b";
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(s_out) = 0;
    elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      s_out = s_out_start;
    end if;
  end if;
equation
  port_b_s_outflow = Medium.specificEntropy(
                       Medium.setState_phX(
                         p=port_b.p,
                         h=port_b.h_outflow,
                         X=port_b.Xi_outflow));
  if allowFlowReversal then
    sMed_out = Modelica.Fluid.Utilities.regStep(
                 x=port_a.m_flow,
                 y1=port_b_s_outflow,
                 y2=Medium.specificEntropy(
                      Medium.setState_phX(
                         p=port_a.p,
                         h=port_a.h_outflow,
                         X=port_a.Xi_outflow)),
                 x_small=m_flow_small);
  else
    sMed_out = port_b_s_outflow;
  end if;
  // Specific entropy measured by sensor
  if dynamic then
    der(s_out) = (sMed_out-s_out)*k*tauInv;
  else
    s_out = sMed_out;
  end if;
  // Sensor output signal
  S_flow = port_a.m_flow * s_out;
annotation (defaultComponentName="senS_flow",
  Icon(graphics={
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Text(
          extent={{180,151},{20,99}},
          lineColor={0,0,0},
          textString="S_flow"),
        Ellipse(extent={{-70,70},{70,-70}}, lineColor={255,0,0}),
        Text(
         extent={{-20,120},{-140,70}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(S_flow, leftjustified=false, significantDigits=3)))}),
  Documentation(info="<html>
<p>
This model outputs the entropy flow rate of the medium in the flow
between fluid ports. The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
If the parameter <code>tau</code> is non-zero, then the measured
specific entropy <i>s<sub>out</sub></i> that is used to
compute the entropy flow rate
<i>S&#775; = m&#775; s<sub>out</sub></i>
is computed using a first order differential equation.
See <a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 25, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
July 29, 2016, by Michael Wetter:<br/>
First implementation based on
<a href=\"modelica://Buildings.Fluid.Sensors.EnthalpyFlowRate\">
Buildings.Fluid.Sensors.EnthalpyFlowRate</a>.
</li>
</ul>
</html>"));
end EntropyFlowRate;
