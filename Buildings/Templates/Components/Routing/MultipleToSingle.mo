within Buildings.Templates.Components.Routing;
model MultipleToSingle "Multiple inlet port, single outlet ports"
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
    "Set to true to allow flow reversal, false restricts to design direction (ports_a -> port_b)"
    annotation (Evaluate=true, Dialog(tab="Assumptions"));
  // Diagnostics
   parameter Boolean show_T = false
    "Set to true if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  constant Integer icon_offset = 0
    "Offset in y-direction between inlet and outlet in icon layer";
  constant Integer icon_dy = 100
    "Distance in y-direction between each branch in icon layer";
  constant Buildings.Templates.Components.Types.IntegrationPoint icon_pipe=
      Buildings.Templates.Components.Types.IntegrationPoint.None "Pipe symbol";

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPorts](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from ports_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-40},{-90,40}}),
        iconTransformation(extent={{-110,-40},{-90,40}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors b (positive design flow direction is from ports_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

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

  Medium.ThermodynamicState sta_a[nPorts]=
      Medium.setState_phX(ports_a.p,
                          noEvent(actualStream(ports_a.h_outflow)),
                          noEvent(actualStream(ports_a.Xi_outflow)))
      if show_T "Medium properties in ports_a";
  Medium.ThermodynamicState sta_b=
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow)))
      if show_T "Medium properties in port_b";

protected
  parameter Boolean have_controlVolume=
    energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "Boolean flag used to remove conditional components"
    annotation(Evaluate=true);

equation
  for i in 1:nPorts loop
  connect(ports_a[i], pasSte.port_a) annotation (Line(points={{-100,0},{-20,0},{
          -20,20},{-10,20}}, color={0,127,255}));
  end for;
  connect(ports_a, del.ports[1:nPorts]) annotation (Line(points={{-100,0},{-20,0},
          {-20,-20},{0,-20}}, color={0,127,255}));
  connect(del.ports[nPorts+1], port_b) annotation (Line(points={{0,-20},{20,-20},
          {20,0},{100,0}}, color={0,127,255}));
  connect(pasSte.port_b, port_b) annotation (Line(points={{10,20},{20,20},{20,0},
          {100,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="rou",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Text( extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name"),
    Line( points={{-100, 0}, {100, 0}},
          color={0,127,255},
          visible=icon_pipe==Buildings.Templates.Components.Types.IntegrationPoint.None),
    Line( points={{-100, icon_offset}, {0, icon_offset}, {0,0}, {100,0}},
          color={0,0,0},
          thickness=5,
          visible=icon_pipe<>Buildings.Templates.Components.Types.IntegrationPoint.None,
          pattern=if icon_pipe==Buildings.Templates.Components.Types.IntegrationPoint.Supply
          then LinePattern.Solid else LinePattern.Dash),
    Line( visible=nPorts>=2 and icon_pipe<>Buildings.Templates.Components.Types.IntegrationPoint.None,
          points=if icon_offset*icon_dy>=0 then
            {{0,icon_offset},{0,icon_offset+icon_dy},{-100,icon_offset+icon_dy}}
            elseif icon_offset>0 and icon_offset+icon_dy<0 or icon_offset<0 and icon_offset+icon_dy>0 then
            {{0,0},{0,icon_offset+icon_dy},{-100,icon_offset+icon_dy}}
            else {{0,icon_offset+icon_dy},{-100,icon_offset+icon_dy}},
          color={0,0,0},
          pattern=if icon_pipe==Buildings.Templates.Components.Types.IntegrationPoint.Supply
          then LinePattern.Solid else LinePattern.Dash,
          thickness=5),
    Line( visible=nPorts>=3 and icon_pipe<>Buildings.Templates.Components.Types.IntegrationPoint.None,
          points=if icon_offset*icon_dy>=0 then
            {{0, icon_offset+icon_dy},{0, icon_offset+2*icon_dy},{-100, icon_offset+2*icon_dy}}
            elseif icon_offset>0 and icon_offset+2*icon_dy<0 or icon_offset<0 and icon_offset+2*icon_dy>0 then
            {{0, 0},{0, icon_offset+2*icon_dy},{-100, icon_offset+2*icon_dy}}
            else {{0, icon_offset+2*icon_dy},{-100, icon_offset+2*icon_dy}},
          color={0,0,0},
          pattern=if icon_pipe==Buildings.Templates.Components.Types.IntegrationPoint.Supply
          then LinePattern.Solid else LinePattern.Dash,
          thickness=5),
    Line( visible=nPorts>=4 and icon_pipe<>Buildings.Templates.Components.Types.IntegrationPoint.None,
          points=if icon_offset*icon_dy>=0 then
            {{0, icon_offset+2*icon_dy},{0, icon_offset+3*icon_dy},{-100, icon_offset+3*icon_dy}}
            elseif icon_offset>0 and icon_offset+3*icon_dy<0 or icon_offset<0 and icon_offset+3*icon_dy>0 then
            {{0, 0},{0, icon_offset+3*icon_dy},{-100, icon_offset+3*icon_dy}}
            else {{0, icon_offset+3*icon_dy},{-100, icon_offset+3*icon_dy}},
          color={0,0,0},
          pattern=if icon_pipe==Buildings.Templates.Components.Types.IntegrationPoint.Supply
          then LinePattern.Solid else LinePattern.Dash,
          thickness=5),
    Line( visible=nPorts>=5 and icon_pipe<>Buildings.Templates.Components.Types.IntegrationPoint.None,
          points=if icon_offset*icon_dy>=0 then
            {{0, icon_offset+3*icon_dy},{0, icon_offset+4*icon_dy},{-100, icon_offset+4*icon_dy}}
            elseif icon_offset>0 and icon_offset+4*icon_dy<0 or icon_offset<0 and icon_offset+4*icon_dy>0 then
            {{0, 0},{0, icon_offset+4*icon_dy},{-100, icon_offset+4*icon_dy}}
            else {{0, icon_offset+4*icon_dy},{-100, icon_offset+4*icon_dy}},
          color={0,0,0},
          pattern=if icon_pipe==Buildings.Templates.Components.Types.IntegrationPoint.Supply
          then LinePattern.Solid else LinePattern.Dash,
          thickness=5),
    Line( visible=nPorts>=6 and icon_pipe<>Buildings.Templates.Components.Types.IntegrationPoint.None,
          points=if icon_offset*icon_dy>=0 then
            {{0, icon_offset+4*icon_dy},{0, icon_offset+5*icon_dy},{-100, icon_offset+5*icon_dy}}
            elseif icon_offset>0 and icon_offset+5*icon_dy<0 or icon_offset<0 and icon_offset+5*icon_dy>0 then
            {{0, 0},{0, icon_offset+5*icon_dy},{-100, icon_offset+5*icon_dy}}
            else {{0, icon_offset+5*icon_dy},{-100, icon_offset+5*icon_dy}},
          color={0,0,0},
          pattern=if icon_pipe==Buildings.Templates.Components.Types.IntegrationPoint.Supply
          then LinePattern.Solid else LinePattern.Dash,
          thickness=5)}),
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
This is a model of a many-to-one fluid connector with an
optional control volume.
It is typically used to represent an outlet manifold or
multiple junctions converging into a single pipe.
</p>
</html>"));
end MultipleToSingle;
