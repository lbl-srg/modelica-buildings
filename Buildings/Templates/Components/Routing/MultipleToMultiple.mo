within Buildings.Templates.Components.Routing;
model MultipleToMultiple
  "Multiple inlet ports, multiple outlet ports"

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
  parameter Integer nPorts_a
    "Number of inlet ports"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPorts_b = nPorts_a
    "Number of outlet ports"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=not have_comLeg));
  parameter Boolean have_comLeg = false
    "Set to true for common leg between inlet and outlet ports (headered connection)"
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
    "= true to allow flow reversal, false restricts to design direction (ports_a -> ports_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  // Diagnostics
  parameter Boolean show_T = false
    "Set to true if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"), HideResult=true);

  parameter Integer icon_extend = 0
    "Extend lines by this amount in x-direction in icon layer: >0 at outlet, <0 at inlet"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Integer icon_dy = 100
    "Distance in y-direction between each branch in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean icon_dash = false
    "Set to true for a dashed line (return line), false for a solid line"
    annotation(Dialog(tab="Graphics", enable=false));

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPorts_a](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from ports_a to ports_b)"
    annotation (Placement(transformation(extent={{-110,-40},{-90,40}}),
        iconTransformation(extent={{-110,-40},{-90,40}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPorts_b](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors b (positive design flow direction is from ports_a to ports_b)"
    annotation (Placement(transformation(extent={{90,-40},{110,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aComLeg(
    redeclare final package Medium=Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_comLeg "Common leg port - Case with common leg"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}}),
                             iconTransformation(extent={{-10,-10},{10,10}})));

  PassThroughFluid pasDed[nPorts_a](
    redeclare each final package Medium=Medium) if not have_comLeg
    "Dedicated fluid pass-through if dedicated arrangement"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Medium.ThermodynamicState sta_a[nPorts_a]=
      Medium.setState_phX(ports_a.p,
                          noEvent(actualStream(ports_a.h_outflow)),
                          noEvent(actualStream(ports_a.Xi_outflow)))
      if show_T "Medium properties in ports_a";

  Medium.ThermodynamicState sta_b[nPorts_b]=
      Medium.setState_phX(ports_b.p,
                          noEvent(actualStream(ports_b.h_outflow)),
                          noEvent(actualStream(ports_b.Xi_outflow)))
      if show_T "Medium properties in ports_b";

  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nPorts_a+nPorts_b+1)
    if have_controlVolume and have_comLeg
    "Fluid volume to break algebraic loop - Case with common leg"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

  PassThroughFluid pasSteInl(redeclare final package Medium = Medium)
    if have_comLeg and not have_controlVolume
    "Fluid pass-through in lieu of control volume - Case with common leg"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  PassThroughFluid pasSteOut(redeclare final package Medium = Medium)
    if have_comLeg and not have_controlVolume
    "Fluid pass-through in lieu of control volume - Case with common leg"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

protected
  parameter Boolean have_controlVolume=
    energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "Boolean flag used to remove conditional components"
    annotation(Evaluate=true);

initial equation
  if not have_comLeg then
    assert(nPorts_a==nPorts_b,
    "In "+ getInstanceName() + ": "+
    "In the absence of a common leg (dedicated connection), the number of inlet ports (" +
    String(nPorts_a) + ") must be equal to the number of outlet ports (" +
    String(nPorts_b) +")");
  end if;
equation
  for i in 1:nPorts_a loop
  connect(ports_a[i], pasSteInl.port_a) annotation (Line(points={{-100,0},{-80,0},
          {-80,-60},{-60,-60}}, color={0,127,255}));
  end for;
  for i in 1:nPorts_b loop
    connect(pasSteOut.port_b, ports_b[i]) annotation (Line(points={{60,-60},{80,-60},
        {80,0},{100,0}}, color={0,127,255}));
  end for;
  connect(ports_a, pasDed.port_a) annotation (Line(points={{-100,0},{-20,0},{-20,
          20},{-10,20}}, color={0,127,255}));
  connect(pasDed.port_b, ports_b) annotation (Line(points={{10,20},{20,20},{20,0},
          {100,0}}, color={0,127,255}));
  connect(del.ports[nPorts_a+nPorts_b+1], port_aComLeg) annotation (Line(points={{0,-20},
          {0,-20},{0,-60}},
                         color={0,127,255}));
  connect(ports_a, del.ports[1:nPorts_a])
    annotation (Line(points={{-100,0},{-20,0},{-20,
          -20},{0,-20}}, color={0,127,255}));
  connect(del.ports[(nPorts_a+1):(nPorts_a+nPorts_b)], ports_b)
    annotation (Line(points={{0,-20},{20,-20},{20,0},{100,0}},
                           color={0,127,255}));
  connect(pasSteInl.port_b, port_aComLeg)
    annotation (Line(points={{-40,-60},{0,-60}}, color={0,127,255}));
  connect(port_aComLeg, pasSteOut.port_a)
    annotation (Line(points={{0,-60},{40,-60}}, color={0,127,255}));


  annotation (
    defaultComponentName="rou",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Text( extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name"),
    Line( points={{-100 + min(0,icon_extend), 0}, {100 + max(0, icon_extend),0}},
          color={0,0,0},
          thickness=1,
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid),
    Line( visible=nPorts_a>=2,
          points=if have_comLeg then
            {{-100 + min(0,icon_extend), icon_dy}, {-40,icon_dy}, {-40, 0}}
            else {{-100 + min(0,icon_extend),icon_dy}, {100 + max(0, icon_extend),icon_dy}},
          color={0,0,0},
          thickness=1,
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid),
    Line( visible=nPorts_a>=3,
          points=if have_comLeg then
            {{-100 + min(0,icon_extend), 2*icon_dy}, {-40, 2*icon_dy}, {-40, icon_dy}}
            else {{-100 + min(0,icon_extend),2*icon_dy}, {100 + max(0, icon_extend),2*icon_dy}},
          color={0,0,0},
          thickness=1,
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid),
    Line( visible=nPorts_a>=4,
          points=if have_comLeg then
            {{-100 + min(0,icon_extend), 3*icon_dy}, {-40, 3*icon_dy}, {-40, 2*icon_dy}}
            else {{-100 + min(0,icon_extend),3*icon_dy}, {100 + max(0, icon_extend),3*icon_dy}},
          color={0,0,0},
          thickness=1,
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid),
    Line( visible=nPorts_b>=2 and have_comLeg,
          points={{40, 0}, {40, icon_dy}, {100 + max(0, icon_extend), icon_dy}},
          color={0,0,0},
          thickness=1,
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid),
    Line( visible=nPorts_b>=3 and have_comLeg,
          points={{40, icon_dy}, {40, 2*icon_dy}, {100 + max(0, icon_extend), 2*icon_dy}},
          color={0,0,0},
          thickness=1,
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid),
    Line( visible=nPorts_b>=4 and have_comLeg,
          points={{40, 2*icon_dy}, {40, 3*icon_dy}, {100 + max(0, icon_extend), 3*icon_dy}},
          color={0,0,0},
          thickness=1,
          pattern=if icon_dash then LinePattern.Dash else LinePattern.Solid)}),
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
This is a model of a many-to-many fluid connector with an
optional control volume, and an optional mixing port (common leg).
It is typically used to connect parallel pumps with parallel
chillers or boilers. 
Selecting a mixing port allows modeling a headered pumping arrangement.
Without any mixing port, a dedicated pumping arrangement is modeled.
</p>
</html>"));
end MultipleToMultiple;
