within Buildings.Fluid.Interfaces;
model PrescribedOutletState_TX
  "Component that assigns the outlet fluid property at port_a based on an input signal"
  extends Buildings.Fluid.Interfaces.PartialPrescribedOutletState_T(
    final use_Xi=true);

  constant Boolean simplify_mWat_flow = true
    "Set to true to cause port_a.m_flow + port_b.m_flow = 0 even if mWat_flow is non-zero";

  Modelica.Blocks.Interfaces.RealInput XiSet[Medium.nXi]
    "Set point temperature of the fluid that leaves port_b" annotation (
      Placement(transformation(
        origin={-120,40},
        extent={{20,-20},{-20,20}},
        rotation=180)));

  // variables

  Modelica.SIunits.MassFraction dXi[Medium.nXi];

equation

  //
  Xi=XiSet;
  dXi=XiSet-inStream(port_a.Xi_outflow);

  // Design direction of mass flow rate
  m_flow = port_a.m_flow;
  assert(m_flow > -m_flow_small or allowFlowReversal,
      "Reverting flow occurs even though allowFlowReversal is false");

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Substance balance


  //port_a.Xi_outflow = if allowFlowReversal then inStream(port_b.Xi_outflow)-dXi else Medium.X_default[1:Medium.nXi];

  //port_b.Xi_outflow = inStream(port_a.Xi_outflow)+dXi;
  port_a.Xi_outflow=inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow)+dXi;


  port_a.C_outflow = if allowFlowReversal then inStream(port_b.C_outflow) else zeros(Medium.nC);
  port_b.C_outflow = inStream(port_a.C_outflow);

    annotation (
  defaultComponentName="heaCoo",
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                      graphics={
        Rectangle(
          extent={{-68,70},{74,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,6},{102,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-4},{102,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,92},{-78,70}},
          lineColor={0,0,127},
          textString="T"),
        Text(
          extent={{48,102},{92,74}},
          lineColor={0,0,127},
          textString="Q_flow")}),
  Documentation(info="<html>
<p>
This model sets the temperature of the medium that leaves <code>port_a</code>
to the value given by the input <code>TSet</code>, subject to optional
limitations on the heating and cooling capacity.
</p>
<p>
In case of reverse flow, the set point temperature is still applied to
the fluid that leaves <code>port_b</code>.
</p>
<p>
If the parameter <code>energyDynamics</code> is not equal to
<code>Modelica.Fluid.Types.Dynamics.SteadyState</code>,
the component models the dynamic response using a first order differential equation.
The time constant of the component is equal to the parameter <code>tau</code>.
This time constant is adjusted based on the mass flow rate using
</p>
<p align=\"center\" style=\"font-style:italic;\">
&tau;<sub>eff</sub> = &tau; |m&#775;| &frasl; m&#775;<sub>nom</sub>
</p>
<p>
where
<i>&tau;<sub>eff</sub></i> is the effective time constant for the given mass flow rate
<i>m&#775;</i> and
<i>&tau;</i> is the time constant at the nominal mass flow rate
<i>m&#775;<sub>nom</sub></i>.
This type of dynamics is equal to the dynamics that a completely mixed
control volume would have.
</p>
<p>
This model has no pressure drop.
See <a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_T\">
Buildings.Fluid.HeatExchangers.HeaterCooler_T</a>
for a model that instantiates this model and that has a pressure drop.
</p>
</html>", revisions="<html>
<ul>
<li>
January 26, 2016, by Michael Wetter:<br/>
Removed inequality comparison of real numbers in <code>restrictCool</code>
and in <code>restrictHeat</code> as this is not allowed in Modelica.
</li>
<li>
November 10, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrescribedOutletState_TX;
