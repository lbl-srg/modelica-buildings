within Buildings.Templates.Components.Routing;
model SingleToMultiple "Single inlet port, multiple outlet ports"
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
  parameter Integer nPorts
    "Number of ports"
    annotation(Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean allowFlowReversal=true
    "Set to true to allow flow reversal, false restricts to design direction (port_a -> ports_b)"
    annotation (Evaluate=true, Dialog(tab="Assumptions"));
  // Diagnostics
   parameter Boolean show_T = false
    "Set to true if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  parameter Integer icon_offset = 0
    "Offset in y-direction between inlet and outlet in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Integer icon_dy = 100
    "Distance in y-direction between each branch in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean icon_dash = false
    "Set to true for a dashed line (return line), false for a solid line"
    annotation(Dialog(tab="Graphics", enable=false));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPorts](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{90,-40},{110,40}})));

  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium = Medium,
    final tau=tau,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nPorts+1)
    if have_controlVolume
    "Fluid volume to break algebraic loop"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  PassThroughFluid pasSte(
    redeclare final package Medium=Medium)
    if not have_controlVolume
    "Fluid pass-through in lieu of control volume"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Medium.ThermodynamicState sta_a=
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow)))
      if show_T "Medium properties in port_a";
  Medium.ThermodynamicState sta_b[nPorts]=
      Medium.setState_phX(ports_b.p,
                          noEvent(actualStream(ports_b.h_outflow)),
                          noEvent(actualStream(ports_b.Xi_outflow)))
      if show_T "Medium properties in ports_b";

protected
  parameter Boolean have_controlVolume=
    energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "Boolean flag used to remove conditional components"
    annotation(Evaluate=true);

equation
  for i in 1:nPorts loop
      connect(pasSte.port_b, ports_b[i]) annotation (Line(points={{10,20},{20,
            20},{20,0},{100,0}},
                       color={0,127,255}));
  end for;
    connect(port_a, pasSte.port_a) annotation (Line(points={{-100,0},{-20,0},{
          -20,20},{-10,20}},
                         color={0,127,255}));
  connect(del.ports[2:nPorts+1], ports_b) annotation (Line(points={{0,-20},{20,
          -20},{20,0},{100,0}},
                          color={0,127,255}));
  connect(del.ports[1], port_a) annotation (Line(points={{0,-20},{-20,-20},{-20,
          0},{-100,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="rou",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Text( extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name"),
    Line( points={{-100,0},{0,0},{0,icon_offset},{100,icon_offset}},
          color={0,0,0},
          thickness=1,
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid),
    Line( visible=nPorts>=2,
          points=if icon_offset*icon_dy>=0 then
            {{0,icon_offset},{0,icon_offset+icon_dy},{100,icon_offset+icon_dy}}
            else {{0,icon_offset+icon_dy},{100,icon_offset+icon_dy}},
          color={0,0,0},
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid,
          thickness=1),
    Line( visible=nPorts>=3,
          points=if icon_offset*icon_dy>=0 then
            {{0, icon_offset+icon_dy},{0, icon_offset+2*icon_dy},{100, icon_offset+2*icon_dy}}
            else {{0, icon_offset+2*icon_dy},{100, icon_offset+2*icon_dy}},
          color={0,0,0},
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid,
          thickness=1),
    Line( visible=nPorts>=4,
          points=if icon_offset*icon_dy>=0 then
            {{0, icon_offset+2*icon_dy},{0, icon_offset+3*icon_dy},{100, icon_offset+3*icon_dy}}
            else {{0, icon_offset+3*icon_dy},{100, icon_offset+3*icon_dy}},
          color={0,0,0},
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid,
          thickness=1)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a one-to-many fluid connector with an
optional control volume.
It is typically used to represent an inlet manifold or
a single pipe diverging into multiple junctions.
</p>
</html>"));
end SingleToMultiple;
