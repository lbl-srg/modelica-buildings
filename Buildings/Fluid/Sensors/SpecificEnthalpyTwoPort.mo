within Buildings.Fluid.Sensors;
model SpecificEnthalpyTwoPort "Ideal two port sensor for the specific enthalpy"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter Modelica.SIunits.SpecificEnthalpy h_out_start=
    Medium.specificEnthalpy_pTX(p=Medium.p_default, T=Medium.T_default, X=Medium.X_default)
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));
  Modelica.Blocks.Interfaces.RealOutput h_out(final quantity="SpecificEnergy",
                                              final unit="J/kg",
                                              start=h_out_start)
    "Specific enthalpy of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
protected
  Modelica.SIunits.SpecificEnthalpy hMed_out(start=h_out_start)
    "Medium enthalpy to which the sensor is exposed";
initial equation
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
    hMed_out = Modelica.Fluid.Utilities.regStep(
                 x=port_a.m_flow,
                 y1=port_b.h_outflow,
                 y2=port_a.h_outflow,
                 x_small=m_flow_small);
  else
    hMed_out = port_b.h_outflow;
  end if;
  // Output signal of sensor
  if dynamic then
    der(h_out) = (hMed_out-h_out)*k*tauInv;
  else
    h_out = hMed_out;
  end if;
annotation (defaultComponentName="senSpeEnt",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{102,120},{0,90}},
          lineColor={0,0,0},
          textString="h"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<html>
<p>
This model outputs the specific enthalpy of a passing fluid.
The sensor is ideal, i.e. it does not influence the fluid.
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
January 18, 2016 by Filip Jorissen:<br/>
Using parameter <code>tauInv</code>
since this now exists in
<a href=\"modelica://Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor\">Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor</a>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>.
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
end SpecificEnthalpyTwoPort;
