within Buildings.Fluid.Sensors;
model DensityTwoPort "Ideal two port density sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RoundSensor;
  Modelica.Blocks.Interfaces.RealOutput d(final quantity="Density",
                                          final unit="kg/m3",
                                          min=0) "Density of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  parameter Medium.Density d_start=
     Medium.density(state=Medium.setState_pTX(
       p=p_start, T=T_start, X=X_start))
    "Initial or guess value of output (=state)"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=Medium.T_default
    "Temperature used to compute d_start"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Pressure p_start=Medium.p_default
    "Pressure used to compute d_start"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.MassFraction X_start[Medium.nX]=Medium.X_default
    "Mass fraction used to compute d_start"
    annotation (Dialog(group="Initialization"));
protected
  Medium.Density dMed(start=d_start)
    "Medium density to which the sensor is exposed";

  Medium.Density d_a_inflow "Density of inflowing fluid at port_a";
  Medium.Density d_b_inflow
    "Density of inflowing fluid at port_b, or rho_a_inflow if uni-directional flow";
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(d) = 0;
     elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      d = d_start;
    end if;
  end if;
equation
  if allowFlowReversal then
     d_a_inflow = Medium.density(
       state=Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     d_b_inflow = Medium.density(
       state=Medium.setState_phX(p=port_a.p, h=port_a.h_outflow, X=port_a.Xi_outflow));
     dMed = Modelica.Fluid.Utilities.regStep(
       x=port_a.m_flow, y1=d_a_inflow, y2=d_b_inflow, x_small=m_flow_small);
  else
     dMed = Medium.density(
       state=Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     d_a_inflow = dMed;
     d_b_inflow = dMed;
  end if;
  // Output signal of sensor
  if dynamic then
    der(d) = (dMed-d)*k*tauInv;
  else
    d = dMed;
  end if;
annotation (defaultComponentName="senDen",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          extent={{102,124},{6,95}},
          textColor={0,0,0},
          textString="d"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Text(
          extent={{-20,120},{-140,70}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(d, leftJustified=false, significantDigits=3)))}),
  Documentation(info="<html>
<p>
This model outputs the density of the fluid flowing from
<code>port_a</code> to <code>port_b</code>.
</p>
<p>
The sensor is ideal, i.e., it does not influence the fluid.
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
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation, based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end DensityTwoPort;
