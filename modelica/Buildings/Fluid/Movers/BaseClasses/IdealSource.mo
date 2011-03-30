within Buildings.Fluid.Movers.BaseClasses;
model IdealSource
  "Base class for pressure and mass flow source with optional power input"
  extends Modelica.Fluid.Interfaces.PartialTwoPortTransport(final show_V_flow=true);
  Modelica.Blocks.Interfaces.RealInput P_in if addPowerToMedium
    "Power added to the medium"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,80}),    iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,80})));

  parameter Boolean addPowerToMedium
    "Set to false to avoid any power being added to medium (may give simpler equations)";

  // what to control
  parameter Boolean control_m_flow "= false to control dp instead of m_flow"
    annotation(Evaluate = true);
  Modelica.Blocks.Interfaces.RealInput m_flow_in if control_m_flow
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-50,82}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,80})));
  Modelica.Blocks.Interfaces.RealInput dp_in if not control_m_flow
    "Prescribed outlet pressure"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,82}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={60,80})));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput dp_internal
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput P_internal
    "Needed to connect to conditional connector";

equation
  // Ideal control
  if control_m_flow then
    m_flow = m_flow_internal;
    dp_internal = 0;
  else
    dp = dp_internal;
    m_flow_internal = 0;
  end if;

  if not addPowerToMedium then
    P_internal = 0;
  end if;

  connect(dp_internal, dp_in);
  connect(m_flow_internal, m_flow_in);
  connect(P_internal, P_in);

  // Energy balance (no storage)
  if addPowerToMedium then
    if noEvent(abs(port_a.m_flow)>Modelica.Constants.small) then
      port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = -P_internal;
      port_b.m_flow*port_b.h_outflow + port_a.m_flow*inStream(port_a.h_outflow) = -P_internal;
    else
      port_a.h_outflow = inStream(port_b.h_outflow);
      port_b.h_outflow = inStream(port_a.h_outflow);
    end if;
  else
    port_a.h_outflow = inStream(port_b.h_outflow);
    port_b.h_outflow = inStream(port_a.h_outflow);
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Text(
          visible=not control_m_flow,
          extent={{24,44},{80,24}},
          lineColor={255,255,255},
          textString="dp"),
        Text(
          visible=control_m_flow,
          extent={{-80,44},{-24,24}},
          lineColor={255,255,255},
          textString="m"),
        Text(
          visible=addPowerToMedium,
          extent={{-30,44},{26,24}},
          lineColor={255,255,255},
          textString="P")}),
    Documentation(info="<html>
<p>
Model of a fictious pipe that is used as a base class
for a pressure source or to prescribe a mass flow rate.
Optionally, power can be added to the enthalpy balance of the medium.
If <code>addPowerToMedium = false</code>, then no power will be added to the medium.
This can lead to simpler equations and more robust simulation, in particular
if the mass flow rate is zero.
</p>
<p>
Note that for fans and pumps with dynamic balance,
both the heat and the flow work are added to the volume of
air or water. This simplifies the equations compared to 
adding heat to the volume, and flow work to this model.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 29, 2011, by Michael Wetter:<br>
Changed energy balance to avoid a division by zero if <code>m_flow=0</code>.
</li>
<li>
July 27, 2010 by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>
April 13, 2010 by Michael Wetter:<br>
Made heat connector optional.
</li>
<li>
March 23, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
                    graphics));
end IdealSource;
