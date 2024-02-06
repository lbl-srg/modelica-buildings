within Buildings.Experimental.DHC.Networks.BaseClasses;
partial model PartialConnection2Pipe2Medium "Partial model for connecting an 
  agent to a two-pipe distribution network with two medium declarations"
  replaceable package MediumSup =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for supply fluid";
  replaceable package MediumRet =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for return fluid";

  replaceable model Model_pipDisSup =
      Buildings.Fluid.Interfaces.PartialTwoPortInterface
      constrainedby Buildings.Fluid.Interfaces.PartialTwoPortInterface(
        redeclare final package Medium = MediumSup,
        final m_flow_nominal=mDis_flow_nominal,
        final allowFlowReversal=allowFlowReversal)
    "Interface for inlet pipe for the distribution supply";
  replaceable model Model_pipDisRet =
      Buildings.Fluid.Interfaces.PartialTwoPortInterface
      constrainedby Buildings.Fluid.Interfaces.PartialTwoPortInterface(
        redeclare final package Medium = MediumRet,
        final m_flow_nominal=mDis_flow_nominal,
        final allowFlowReversal=allowFlowReversal)
    "Interface for outlet pipe for the distribution return";

  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in the connection line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (
      Dialog(tab="Dynamics", group="Nominal condition",
      enable=not energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState));

  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisSup(
    redeclare final package Medium = MediumSup,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSup.h_default, nominal=MediumSup.h_default))
    "Distribution supply inlet port"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
      iconTransformation(extent={{-110,-10}, {-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisSup(
    redeclare final package Medium = MediumSup,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSup.h_default, nominal=MediumSup.h_default))
    "Distribution supply outlet port"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
      iconTransformation(extent={{90,-10},{ 110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisRet(
    redeclare final package Medium = MediumRet,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumRet.h_default, nominal=MediumRet.h_default))
    "Distribution return inlet port"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}}),
      iconTransformation(extent={{90,-70},{ 110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisRet(
    redeclare final package Medium = MediumRet,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumRet.h_default, nominal=MediumRet.h_default))
    "Distribution return outlet port"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}}),
      iconTransformation(extent={{-110,-70}, {-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bCon(
    redeclare final package Medium = MediumSup,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSup.h_default, nominal=MediumSup.h_default))
    "Connection supply port"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}}),
      iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aCon(
    redeclare final package Medium = MediumRet,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumRet.h_default, nominal=MediumRet.h_default))
    "Connection return port"
    annotation (Placement(transformation(extent={{10,110},{30,130}}),
      iconTransformation(extent={{50,90},{70,110}})));
  // COMPONENTS
  Model_pipDisSup pipDisSup "Distribution supply pipe"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Model_pipDisRet pipDisRet "Distribution return pipe"
    annotation (Placement(transformation(extent={{-60,-90},{-80,-70}})));
  Buildings.Fluid.FixedResistances.Junction junConSup(
    redeclare final package Medium = MediumSup,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final dp_nominal = {0, 0, 0},
    final energyDynamics=energyDynamics,
    final tau=tau,
    final m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,-mCon_flow_nominal})
    "Junction with connection supply"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-50}})));
  Buildings.Fluid.FixedResistances.Junction junConRet(
    redeclare final package Medium = MediumRet,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final dp_nominal = {0, 0, 0},
    final energyDynamics=energyDynamics,
    final tau=tau,
    final m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,mCon_flow_nominal})
    "Junction with connection return"
    annotation (Placement(transformation(extent={{30,-70},{10,-90}})));
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    MediumRet.specificHeatCapacityCp(MediumRet.setState_pTX(
      p = MediumRet.p_default,
      T = MediumRet.T_default,
      X = MediumRet.X_default))
    "Specific heat capacity of medium at default medium state";
equation
  connect(pipDisSup.port_b, junConSup.port_1)
    annotation (Line(points={{-60,-40},{-30,-40}}, color={0,127,255}));
  connect(port_aDisSup, pipDisSup.port_a)
    annotation (Line(points={{-100,-40},{-80,-40}}, color={0,127,255}));
  connect(junConRet.port_2, pipDisRet.port_a)
    annotation (Line(points={{10,-80},{-60,-80}}, color={0,127,255}));
  connect(pipDisRet.port_b, port_bDisRet)
    annotation (Line(points={{-80,-80},{-100,-80}}, color={0,127,255}));
  connect(junConSup.port_2, port_bDisSup)
    annotation (Line(points={{-10,-40},{100,-40}}, color={0,127,255}));
  connect(junConRet.port_1, port_aDisRet)
    annotation (Line(points={{30,-80},{100,-80},{100,-80}}, color={0,127,255}));
  annotation (
    defaultComponentName="con",
    Documentation(info="
<html>
<p>
Partial model to be used for connecting an agent (e.g. an energy transfer station)
to a two-pipe distribution network featuring different supply and return fluids
(e.g. steam and liquid water).
</p>
<p>
Six instances of a replaceable partial model are used to represent the pipes:
</p>
<ul>
<li>
Two representing the main distribution supply and return pipes immediately upstream
of the connection.
</li>
<li>
Two representing the main distribution supply and return pipes immediately downstream
of the connection.
</li>
<li>
The other two representing the branch connection supply and return pipes immediately 
upstream and downstream of the connection, respectively.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 28, 2022, by Kathryn Hinkelman:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
March 2, 2022, by Antoine Gautier and Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={   Rectangle(
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
          textColor={0,0,255}),
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
          extent={{58,-60},{62,-6}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}), Diagram(coordinateSystem(extent={{-100,-120},{100,
            120}})));
end PartialConnection2Pipe2Medium;
