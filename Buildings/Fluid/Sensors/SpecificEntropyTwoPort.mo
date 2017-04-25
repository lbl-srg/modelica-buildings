within Buildings.Fluid.Sensors;
model SpecificEntropyTwoPort "Ideal two port sensor for the specific entropy"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter Modelica.SIunits.SpecificEntropy s_start=
    Medium.specificEntropy_pTX(p=Medium.p_default, T=Medium.T_default, X=Medium.X_default)
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));
  Modelica.Blocks.Interfaces.RealOutput s(final quantity="SpecificEntropy",
                                          final unit="J/(kg.K)",
                                          start=s_start)
    "Specific entropy of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
protected
  Modelica.SIunits.SpecificEntropy sMed(start=s_start)
    "Medium entropy to which the sensor is exposed";
  Medium.SpecificEntropy s_a_inflow
    "Specific entropy of inflowing fluid at port_a";
  Medium.SpecificEntropy s_b_inflow
    "Specific entropy of inflowing fluid at port_b, or s_a_inflow if uni-directional flow";
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(s) = 0;
    elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      s = s_start;
    end if;
  end if;
equation
  if allowFlowReversal then
     s_a_inflow = Medium.specificEntropy(state=
                    Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     s_b_inflow = Medium.specificEntropy(state=
                    Medium.setState_phX(p=port_a.p, h=port_a.h_outflow, X=port_a.Xi_outflow));
     sMed = Modelica.Fluid.Utilities.regStep(
           x=port_a.m_flow,
           y1=s_a_inflow,
           y2=s_b_inflow,
           x_small=m_flow_small);
  else
     sMed = Medium.specificEntropy(state=
           Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     s_a_inflow = sMed;
     s_b_inflow = sMed;
  end if;
  // Output signal of sensor
  if dynamic then
    der(s) = (sMed-s)*k*tauInv;
  else
    s = sMed;
  end if;
annotation (defaultComponentName="senSpeEnt",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{120,120},{0,90}},
          lineColor={0,0,0},
          textString="s"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Ellipse(extent={{-70,70},{70,-70}}, lineColor={255,0,0})}),
  Documentation(info="<html>
<p>
This model outputs the specific entropy of the passing fluid.
The sensor is ideal, i.e., it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>", revisions="<html>
<ul>
<li>
January 18, 2016 by Filip Jorissen:<br/>
Using parameter <code>tauInv</code>
since this now exists in
<a href=\"modelica://Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor\">Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor</a>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>.
</li>
<li>
August 31, 2013, by Michael Wetter:<br/>
Corrected wrong computation of <code>s</code> and <code>sMed</code>.
</li>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpecificEntropyTwoPort;
