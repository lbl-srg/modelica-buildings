within Buildings.Experimental.DHC.Networks.BaseClasses;
partial model PartialConnection2Pipe
  "Partial model for connecting an agent to a two-pipe distribution network"
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  replaceable model Model_pipDis=Fluid.Interfaces.PartialTwoPortInterface (
    redeclare final package Medium=Medium,
    final m_flow_nominal=mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  replaceable model Model_pipCon=Fluid.Interfaces.PartialTwoPortInterface (
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  parameter Boolean show_entFlo=false
    "Set to true to output enthalpy flow rate difference"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line"
    annotation (Dialog(tab="General",group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in the connection line"
    annotation (Dialog(tab="General",group="Nominal condition"));
  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisSup(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution supply inlet port"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisSup(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution supply outlet port"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
      iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisRet(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution return inlet port"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}}),
      iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisRet(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution return outlet port"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}}),
      iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bCon(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Connection supply port"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}}),
      iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aCon(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Connection return port"
    annotation (Placement(transformation(extent={{10,110},{30,130}}),
      iconTransformation(extent={{50,90},{70,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon_flow(
    final quantity="MassFlowRate",
    final unit="kg/s")
    "Connection supply mass flow rate"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dp(
    final quantity="PressureDifference",
    final unit="Pa",
    final displayUnit="Pa")
    "Pressure drop accross the connection (measured)"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dH_flow(
    final unit="W") if show_entFlo
    "Difference in enthalpy flow rate between connection supply and return"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,70},{140,110}})));
  // COMPONENTS
  Model_pipDis pipDisSup
    "Distribution supply pipe"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Model_pipDis pipDisRet
    "Distribution return pipe"
    annotation (Placement(transformation(extent={{-60,-90},{-80,-70}})));
  Model_pipCon pipCon
    "Connection pipe"
    annotation (Placement(
      transformation(extent={{-10,-10},{10,10}},rotation=90,origin={-20,-10})));
  Fluid.FixedResistances.Junction junConSup(
    redeclare final package Medium=Medium,
    final portFlowDirection_1=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final dp_nominal={0,0,0},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    final m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,-mCon_flow_nominal})
    "Junction with connection supply"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-50}})));
  Fluid.FixedResistances.Junction junConRet(
    redeclare final package Medium=Medium,
    final portFlowDirection_1=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Entering,
    final dp_nominal={0,0,0},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    final m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,mCon_flow_nominal})
    "Junction with connection return"
    annotation (Placement(transformation(extent={{30,-70},{10,-90}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCon(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    "Connection supply mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90,origin={-20,40})));
  Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium)
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={-40,-60})));
  DifferenceEnthalpyFlowRate senDifEntFlo(
    redeclare final package Medium1 = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mCon_flow_nominal) if show_entFlo
    "Difference in enthalpy flow rate"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,80})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Specific heat capacity of medium at default medium state";
equation
  // Connect statements involving conditionally removed components are
  // removed at translation time by Modelica specification.
  // Only obsolete statements corresponding to the default model structure need
  // to be programmatically removed.
  if not show_entFlo then
    connect(port_bCon,senMasFloCon.port_b)
      annotation (Line(points={{-20,120},{-20,50}},color={0,127,255}));
    connect(port_aCon,junConRet.port_3)
      annotation (Line(points={{20,120},{20,-70}},color={0,127,255}));
  end if;
  connect(junConSup.port_3,pipCon.port_a)
    annotation (Line(points={{-20,-30},{-20,-20}},color={0,127,255}));
  connect(pipDisSup.port_b,junConSup.port_1)
    annotation (Line(points={{-60,-40},{-30,-40}},color={0,127,255}));
  connect(senMasFloCon.m_flow,mCon_flow)
    annotation (Line(points={{-9,40},{120,40}},                color={0,0,127}));
  connect(pipCon.port_b,senMasFloCon.port_a)
    annotation (Line(points={{-20,0},{-20,30}},color={0,127,255}));
  connect(port_aDisSup,pipDisSup.port_a)
    annotation (Line(points={{-100,-40},{-80,-40}},color={0,127,255}));
  connect(port_aDisRet,junConRet.port_1)
    annotation (Line(points={{100,-80},{30,-80}},color={0,127,255}));
  connect(junConSup.port_2,port_bDisSup)
    annotation (Line(points={{-10,-40},{100,-40}},color={0,127,255}));
  connect(junConRet.port_2,pipDisRet.port_a)
    annotation (Line(points={{10,-80},{-60,-80}},color={0,127,255}));
  connect(pipDisRet.port_b,port_bDisRet)
    annotation (Line(points={{-80,-80},{-100,-80}},color={0,127,255}));
  connect(senRelPre.port_a,junConSup.port_1)
    annotation (Line(points={{-40,-50},{-40,-40},{-30,-40}},color={0,127,255}));
  connect(senRelPre.port_b,junConRet.port_2)
    annotation (Line(points={{-40,-70},{-40,-80},{10,-80}},color={0,127,255}));
  connect(senRelPre.p_rel,dp)
    annotation (Line(points={{-31,-60},{80,-60},{80,0},{120,0}},color={0,0,127}));
  connect(port_bCon, senDifEntFlo.port_b1) annotation (Line(points={{-20,120},{-20,
          100},{-6,100},{-6,90}}, color={0,127,255}));
  connect(senDifEntFlo.port_a2, port_aCon) annotation (Line(points={{6,90},{6,100},
          {20,100},{20,120}}, color={0,127,255}));
  connect(senDifEntFlo.dH_flow, dH_flow) annotation (Line(points={{-3,92},{-3,
          106},{40,106},{40,90},{120,90}},
                                      color={0,0,127}));
  connect(senMasFloCon.port_b, senDifEntFlo.port_a1) annotation (Line(points={{-20,
          50},{-20,60},{-6,60},{-6,70}}, color={0,127,255}));
  connect(senDifEntFlo.port_b2, junConRet.port_3) annotation (Line(points={{6,70},
          {6,60},{20,60},{20,-70}}, color={0,127,255}));
  annotation (
    defaultComponentName="con",
    Documentation(
      info="
<html>
<p>
Partial model to be used for connecting an agent (e.g. an energy transfer station)
to a two-pipe distribution network.
</p>
<p>
Three instances of a replaceable partial model are used to represent the pipes:
</p>
<ul>
<li>
One representing the main distribution supply pipe immediately upstream
the connection.
</li>
<li>
Another one representing the main distribution return pipe immediately downstream
the connection.
</li>
<li>
The last one representing both the supply and return lines of the connection.
When replacing that model with a pipe model computing the pressure drop,
one must double the length so that both the supply and return lines are
accounted for.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,2},{100,-2}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-2,-2},{2,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-152,-104},{148,-144}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-76,12},{-20,-12}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25,8},{25,-8}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={0,45},
          rotation=90),
        Rectangle(
          extent={{58,6},{62,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-58},{100,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-76,-48},{-20,-72}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{58,-62},{62,-6}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25.5,7.5},{25.5,-7.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={59.5,45.5},
          rotation=90)}),
    Diagram(
      coordinateSystem(
        extent={{-100,-120},{100,120}})));
end PartialConnection2Pipe;
