within Buildings.Fluid.FMI.Interfaces;
connector Inlet "Connector for fluid inlet"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean use_p_in = true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  input Medium.MassFlowRate m_flow
    "Mass flow rate from the connection point into the component";
  Buildings.Fluid.FMI.Interfaces.PressureInput p
  if use_p_in "Thermodynamic pressure in the connection point";

  input Buildings.Fluid.FMI.Interfaces.FluidProperties forward(
    redeclare final package Medium = Medium) "Inflowing properties";
  output Buildings.Fluid.FMI.Interfaces.FluidProperties backward(
    redeclare final package Medium = Medium)
    if allowFlowReversal "Outflowing properties";

annotation (defaultComponentName="inlet",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Polygon(
          points={{-100,100},{-100,-100},{100,0},{-100,100}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
          Text(
          extent={{-58,134},{48,94}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
This is a connector for a fluid inlet.
The connector takes as an input the
following quantities:
</p>
<ul>
<li>
The mass flow rate <code>m_flow</code>.
</li>
<li>
The pressure <code>p</code>,
unless <code>use_p_in=false</code>.
</li>
<li>
The temperature of the inflowing fluid
<code>forward.T</code>,
e.g., the temperature of the fluid that streams out of the component if <code>m_flow &gt; 0</code>.
</li>
<li>
The mass fraction of the inflowing fluid
<code>forward.Xi</code>,
unless <code>Medium.nXi=0</code>.
</li>
<li>
The trace substances of the inflowing fluid
<code>forward.C</code>,
unless <code>Medium.nC=0</code>.
</li>
</ul>
<p>
If <code>allowFlowReversal = true</code>,
the connector also outputs the following quantities.
</p>
<ul>
<li>
The temperature of the outflowing fluid
<code>backward.T</code>,
e.g., if <code>m_flow &le; 0</code>.
</li>
<li>
The mass fraction of the outflowing fluid
<code>backward.Xi</code>,
unless <code>Medium.nXi=0</code>.
</li>
<li>
The trace substances of the outflowing fluid
<code>backward.C</code>,
unless <code>Medium.nC=0</code>.
</li>
</ul>
<p>
If <code>allowFlowReversal = false</code>, then these outputs are not present.
</p>
</html>", revisions="<html>
<ul>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
April 29, 2015, by Michael Wetter:<br/>
Redesigned to conditionally remove the pressure connector
if <code>use_p_in=false</code>.
</li>
<li>
April 15, 2015 by Michael Wetter:<br/>
Changed connector variable to be temperature instead of
specific enthalpy.
</li>
<li>
November 8, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Inlet;
