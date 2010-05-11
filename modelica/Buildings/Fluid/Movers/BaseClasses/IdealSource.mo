within Buildings.Fluid.Movers.BaseClasses;
model IdealSource
  "Base class for pressure and mass flow source with heat input"
  extends Modelica.Fluid.Interfaces.PartialTwoPortTransport;
  Modelica.Blocks.Interfaces.RealInput Q_flow_in if addHeatToMedium
    "Heat flow added to the medium"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,80}),    iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,80})));

  parameter Boolean addHeatToMedium=true
    "Set to false to avoid any heat being added to medium (may give simpler equations)";

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
  Modelica.Blocks.Interfaces.RealInput Q_flow_internal
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

  if not addHeatToMedium then
    Q_flow_internal = 0;
  end if;

  connect(dp_internal, dp_in);
  connect(m_flow_internal, m_flow_in);
  connect(Q_flow_internal, Q_flow_in);

  // Energy balance (no storage)
  if addHeatToMedium then
    port_a.m_flow*port_a.h_outflow + port_b.m_flow*inStream(port_b.h_outflow) = -Q_flow_internal;
    port_a.m_flow*port_b.h_outflow + port_b.m_flow*inStream(port_a.h_outflow) =  Q_flow_internal;
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
          visible=addHeatToMedium,
          extent={{-30,44},{26,24}},
          lineColor={255,255,255},
          textString="Q")}),
    Documentation(info="<html>
<p>
Model of a fictious pipe that is used as a base class
for a pressure source or to prescribe a mass flow rate.
Optionally, heat can be added to the medium.
</p>
</html>"),
revisions="<html>
<ul>
<li>
April 13, 2010 by Michael Wetter:<br>
Made heat connector optional.
</li>
<li>
March 23, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>",
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
                    graphics));
end IdealSource;
