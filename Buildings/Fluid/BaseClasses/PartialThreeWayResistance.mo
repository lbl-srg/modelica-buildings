within Buildings.Fluid.BaseClasses;
partial model PartialThreeWayResistance
  "Flow splitter with partial resistance model at each port"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final mSenFac=1);

  Modelica.Fluid.Interfaces.FluidPort_a port_1(
    redeclare package Medium = Medium,
    m_flow(min=if (portFlowDirection_1 == Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_1== Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "First port, typically inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_2(
    redeclare package Medium = Medium,
    m_flow(min=if (portFlowDirection_2 == Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_2 == Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "Second port, typically outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_3(
    redeclare package Medium=Medium,
    m_flow(min=if (portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "Third port, can be either inlet or outlet"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  parameter Boolean dynamicBalance = true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation (Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (Dialog(tab="Dynamics", group="Nominal condition", enable=dynamicBalance));
  parameter Modelica.SIunits.MassFlowRate mDyn_flow_nominal
    "Nominal mass flow rate for dynamic momentum and energy balance"
    annotation (Dialog(tab="Dynamics", group="Equations", enable=dynamicBalance));
  parameter Boolean from_dp = true
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_1"
   annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_2"
   annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_3"
   annotation(Dialog(tab="Advanced"));

  replaceable Buildings.Fluid.Interfaces.PartialTwoPortInterface res1(
    redeclare package Medium = Medium,
    allowFlowReversal=portFlowDirection_1 == Modelica.Fluid.Types.PortFlowDirection.Bidirectional)
    "Partial model, to be replaced with a fluid component"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  replaceable Buildings.Fluid.Interfaces.PartialTwoPortInterface res2(
    redeclare package Medium = Medium,
    allowFlowReversal=portFlowDirection_2 == Modelica.Fluid.Types.PortFlowDirection.Bidirectional)
    "Partial model, to be replaced with a fluid component"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  replaceable Buildings.Fluid.Interfaces.PartialTwoPortInterface res3(
    redeclare package Medium = Medium,
    allowFlowReversal=portFlowDirection_3 == Modelica.Fluid.Types.PortFlowDirection.Bidirectional)
    "Partial model, to be replaced with a fluid component"
    annotation (Placement(transformation(
        origin={0,-50},
        extent={{-10,10},{10,-10}},
        rotation=90)));

  Buildings.Fluid.Delays.DelayFirstOrder vol(
    redeclare final package Medium = Medium,
    final nPorts=3,
    final tau=tau,
    final m_flow_nominal=mDyn_flow_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final allowFlowReversal=true,
    final prescribedHeatFlowRate=false) if
       dynamicBalance "Fluid volume to break algebraic loop"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

protected
  Modelica.Fluid.Interfaces.FluidPort_a port_internal(
    redeclare package Medium = Medium) if not dynamicBalance
    "Internal dummy port for easier connection of conditional connections"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
equation

  if portFlowDirection_1==Modelica.Fluid.Types.PortFlowDirection.Leaving then
    if not dynamicBalance then
       connect(res1.port_a, port_internal) annotation (Line(
      points={{-60,0},{-60,60},{0,60}},
      color={0,127,255},
      smooth=Smooth.None));
    else
       connect(res1.port_a, vol.ports[1]) annotation (Line(
      points={{-60,0},{-2.66667,0}},
      color={0,127,255},
      smooth=Smooth.None));
    end if;
    connect(port_1, res1.port_b) annotation (Line(points={{-100,0},{-100,0},{-40,
            0}},                                                                      color={0,127,255}));
  else
    if not dynamicBalance then
       connect(res1.port_b, port_internal) annotation (Line(
      points={{-40,0},{-40,60},{0,60}},
      color={0,127,255},
      smooth=Smooth.None));
    else
       connect(res1.port_b, vol.ports[1]) annotation (Line(
      points={{-40,0},{-2.66667,0}},
      color={0,127,255},
      smooth=Smooth.None));
    end if;
    connect(port_1, res1.port_a) annotation (Line(points={{-100,0},{-100,0},{-60,0}}, color={0,127,255}));
  end if;

  if portFlowDirection_2==Modelica.Fluid.Types.PortFlowDirection.Leaving then
    if not dynamicBalance then
       connect(res2.port_a, port_internal) annotation (Line(
      points={{60,0},{60,60},{0,60}},
      color={0,127,255},
      smooth=Smooth.None));
    else
       connect(res2.port_a, vol.ports[2]) annotation (Line(
      points={{60,0},{2.22045e-16,0}},
      color={0,127,255},
      smooth=Smooth.None));
    end if;
    connect(port_2, res2.port_b) annotation (Line(points={{100,0},{100,0},{40,0}},    color={0,127,255}));
  else
    if not dynamicBalance then
       connect(res2.port_b, port_internal) annotation (Line(
      points={{40,0},{40,60},{0,60}},
      color={0,127,255},
      smooth=Smooth.None));
    else
       connect(res2.port_b, vol.ports[2]) annotation (Line(
      points={{40,0},{2.22045e-16,0}},
      color={0,127,255},
      smooth=Smooth.None));
    end if;
    connect(port_2, res2.port_a) annotation (Line(points={{100,0},{100,0},{60,0}},    color={0,127,255}));
  end if;

  if portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Leaving then
    if not dynamicBalance then
       connect(res3.port_a, port_internal) annotation (Line(
      points={{-4.44089e-16,-60},{20,-60},{20,60},{0,60}},
      color={0,127,255},
      smooth=Smooth.None));
    else
       connect(res3.port_a, vol.ports[3]) annotation (Line(
      points={{-6.66134e-16,-60},{0,-60},{0,0},{2.66667,0}},
      color={0,127,255},
      smooth=Smooth.None));
    end if;
    connect(port_3, res3.port_b) annotation (Line(points={{0,-100},{0,-100},{0,-40}}, color={0,127,255}));
  else
    if not dynamicBalance then
       connect(res3.port_b, port_internal) annotation (Line(
      points={{4.44089e-16,-40},{20,-40},{20,60},{0,60}},
      color={0,127,255},
      smooth=Smooth.None));
    else
       connect(res3.port_b, vol.ports[3]) annotation (Line(
      points={{4.44089e-16,-40},{0,-40},{0,0},{2.66667,0}},
      color={0,127,255},
      smooth=Smooth.None));
    end if;
    connect(port_3, res3.port_a) annotation (Line(points={{0,-100},{0,-100},{0,-60}}, color={0,127,255}));
  end if;
   annotation (
    Documentation(info="<html>
<p>
Partial model for flow resistances with three ports such as a
flow mixer/splitter or a three way valve.
</p>
<p>
If <code>dynamicBalance=true</code>, then at the junction of the three flows,
a mixing volume will be present. This will introduce a dynamic energy and momentum
balance, which often breaks algebraic loops.
The time constant of the mixing volume is determined by the parameter <code>tau</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13 2015, by Filip Jorissen:<br/>
Exposed options for flow reversal to users and added corresponding implementation.
</li>
<li>
March 23 2010, by Michael Wetter:<br/>
Changed start values from <code>system.p_start</code> or (code <code>T_start</code>)
to <code>Medium.p_default</code>.
</li>
<li>
September 18, 2008 by Michael Wetter:<br/>
Replaced splitter model with a fluid port since the
splitter model in Modelica.Fluid 1.0 beta does not transport
<code>mC_flow</code>.
<li>
June 11, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics));
end PartialThreeWayResistance;
