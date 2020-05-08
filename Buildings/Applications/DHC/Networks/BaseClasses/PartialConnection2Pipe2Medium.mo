within Buildings.Applications.DHC.Networks.BaseClasses;
partial model PartialConnection2Pipe2Medium
  "Partial model for connecting an agent to a two-pipe distribution network with 2 medium models"
  replaceable package MediumSup =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for supply fluid";
  replaceable package MediumRet =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for return fluid";

  replaceable model Model_pipDisSup = Fluid.Interfaces.PartialTwoPortInterface
      (
    redeclare final package Medium = MediumSup,
    final m_flow_nominal=mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  replaceable model Model_pipDisRet = Fluid.Interfaces.PartialTwoPortInterface
      (
    redeclare final package Medium = MediumRet,
    final m_flow_nominal=mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  replaceable model Model_pipConSup = Fluid.Interfaces.PartialTwoPortInterface
      (
    redeclare final package Medium = MediumSup,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  replaceable model Model_pipConRet = Fluid.Interfaces.PartialTwoPortInterface
      (
    redeclare final package Medium = MediumRet,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  parameter Boolean have_heaFloOut = false
    "Set to true to output the heat flow rate transferred to the connected load"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in the connection line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau=10
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
  Modelica.Blocks.Interfaces.RealOutput mCon_flow(
    final quantity="MassFlowRate", final unit="kg/s")
    "Connection supply mass flow rate"
    annotation (Placement(transformation(
      extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,50},{120, 70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate", final unit="W") if have_heaFloOut
    "Heat flow rate transferred to the connected load (>=0 for heating)"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput dp(
    final quantity="PressureDifference",
    final unit="Pa", final displayUnit="Pa")
    "Pressure drop accross the connection (measured)"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,30},{120,50}})));
  // COMPONENTS
  Model_pipDisSup pipDisSup
    "Distribution supply pipe"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Model_pipDisRet pipDisRet
    "Distribution return pipe"
    annotation (Placement(transformation(extent={{-60,-90},{-80,-70}})));
  Model_pipConSup pipConSup "Connection supply pipe"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-20,-10})));
  Model_pipConRet pipConRet "Connection return pipe"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={20,-10})));
  Fluid.FixedResistances.Junction junConSup(
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
    final massDynamics=massDynamics,
    final tau=tau,
    final m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,-mCon_flow_nominal})
    "Junction with connection supply"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-50}})));
  Fluid.FixedResistances.Junction junConRet(
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
    final massDynamics=massDynamics,
    final tau=tau,
    final m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,mCon_flow_nominal})
    "Junction with connection return"
    annotation (Placement(transformation(extent={{30,-70},{10,-90}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCon(
    redeclare final package Medium = MediumSup,
    final allowFlowReversal=allowFlowReversal)
    "Connection supply mass flow rate (measured)"
    annotation (Placement(
      transformation(
      extent={{-10,10},{10,-10}},
      rotation=90,
      origin={-20,30})));
  Fluid.Sensors.TemperatureTwoPort senTConSup(
    redeclare final package Medium = MediumSup,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mCon_flow_nominal,
    final tau=if allowFlowReversal then 1 else 0) if have_heaFloOut
    "Connection supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,90})));
  Fluid.Sensors.TemperatureTwoPort senTConRet(
    redeclare final package Medium = MediumRet,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mCon_flow_nominal,
    final tau=if allowFlowReversal then 1 else 0) if have_heaFloOut
    "Connection return temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,90})));
  Buildings.Controls.OBC.CDL.Continuous.Add sub(final k1=-1) if have_heaFloOut
    "Delta T"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro if have_heaFloOut
    "Delta T times flow rate"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=cp_default) if have_heaFloOut
    "Times cp"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={82,80})));
  Fluid.Sensors.Pressure senPreRet(redeclare package Medium = MediumRet)
    "Return pressure sensor"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-110}})));
  Fluid.Sensors.Pressure senPreSup(redeclare package Medium = MediumSup)
    "Supply pressure sensor"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-70}})));
  Modelica.Blocks.Math.Add dpSen(k2=-1) "Sensed change in pressure"
    annotation (Placement(transformation(extent={{50,-76},{70,-56}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    MediumRet.specificHeatCapacityCp(MediumRet.setState_pTX(
      p = MediumRet.p_default,
      T = MediumRet.T_default,
      X = MediumRet.X_default))
    "Specific heat capacity of medium at default medium state";
equation
  // Connect statements involving conditionally removed components are
  // removed at translation time by Modelica specification.
  // Only obsolete statements corresponding to the default model structure need
  // to be programmatically removed.
  if not have_heaFloOut then
    connect(port_bCon, senMasFloCon.port_b)
      annotation (Line(points={{-20,120},{-20,40}}, color={0,127,255}));
  end if;
  connect(junConSup.port_3, pipConSup.port_a)
    annotation (Line(points={{-20,-30},{-20,-20}}, color={0,127,255}));
  connect(pipDisSup.port_b, junConSup.port_1)
    annotation (Line(points={{-60,-40},{-30,-40}}, color={0,127,255}));
  connect(senMasFloCon.m_flow, mCon_flow)
    annotation (Line(points={{-9,30},{54,30},{54,40},{120,40}},
      color={0,0,127}));
  connect(pipConSup.port_b, senMasFloCon.port_a)
    annotation (Line(points={{-20,0},{-20,20}}, color={0,127,255}));
  connect(port_aDisSup, pipDisSup.port_a)
    annotation (Line(points={{-100,-40},{-80,-40}}, color={0,127,255}));
  connect(port_aDisRet, junConRet.port_1)
    annotation (Line(points={{100,-80},{30,-80}}, color={0,127,255}));
  connect(junConSup.port_2, port_bDisSup)
    annotation (Line(points={{-10,-40},{100,-40}}, color={0,127,255}));
  connect(junConRet.port_2, pipDisRet.port_a)
    annotation (Line(points={{10,-80},{-60,-80}}, color={0,127,255}));
  connect(pipDisRet.port_b, port_bDisRet)
    annotation (Line(points={{-80,-80},{-100,-80}}, color={0,127,255}));
  connect(senMasFloCon.port_b, senTConSup.port_a)
    annotation (Line(points={{-20,40},{-20,76},{-40,76},{-40,80}},
      color={0,127,255}));
  connect(senTConSup.port_b, port_bCon)
    annotation (Line(points={{-40,100},{-40,110},{-20,110},{-20,120}},
      color={0,127,255}));
  connect(port_aCon, senTConRet.port_a)
    annotation (Line(points={{20,120},{20,110},{0,110},{0,100},{1.77636e-15,
      100}}, color={0,127,255}));
  connect(Q_flow, gai.y)
    annotation (Line(points={{120,80},{94,80}}, color={0,0,127}));
  connect(pro.y, gai.u)
    annotation (Line(points={{62,60},{66,60},{66,80},{70,80}}, color={0,0,127}));
  connect(senMasFloCon.m_flow, pro.u2)
    annotation (Line(points={{-9,30},{30,30}, {30,54},{38,54}}, color={0,0,127}));
  connect(sub.y, pro.u1)
    annotation (Line(points={{12,60},{30,60},{30,66},{38, 66}}, color={0,0,127}));
  connect(senTConSup.T, sub.u2)
    annotation (Line(points={{-51,90},{-60,90},{-60, 54},{-12,54}}, color={0,0,127}));
  connect(senTConRet.T, sub.u1)
    annotation (Line(points={{-11,90},{-16,90},{-16, 66},{-12,66}}, color={0,0,127}));
  connect(junConRet.port_3, pipConRet.port_a)
    annotation (Line(points={{20,-70},{20,-20}}, color={0,127,255}));
  connect(pipConRet.port_b, port_aCon)
    annotation (Line(points={{20,0},{20,120}}, color={0,127,255}));
  connect(pipConRet.port_b, senTConRet.port_b)
    annotation (Line(points={{20,0},{20,76},{0,76},{0,80}}, color={0,127,255}));
  connect(senPreSup.port, junConSup.port_1)
    annotation (Line(points={{-40,-50},{-40,-40},{-30,-40}}, color={0,127,255}));
  connect(senPreRet.port, junConRet.port_2)
    annotation (Line(points={{-40,-90},{-40,-80},{10,-80}}, color={0,127,255}));
  connect(senPreSup.p, dpSen.u1)
    annotation (Line(points={{-29,-60},{48,-60}}, color={0,0,127}));
  connect(senPreRet.p, dpSen.u2)
    annotation (Line(points={{-29,-100},{40,-100},{40,-72},{48,-72}}, color={0,0,127}));
  connect(dpSen.y, dp)
    annotation (Line(points={{71,-66},{76,-66},{76,0},{120,0}},color={0,0,127}));
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
Four instances of a replaceable partial model are used to represent the pipes:
</p>
<ul>
<li>
Two representing the main distribution supply and return pipes immediately upstream
and downstream of the connection, respectively.
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
May 8, 2020, by Kathryn Hinkelman:<br/>
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
          lineColor={0,0,0}),           Text(
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
          rotation=90)}),       Diagram(coordinateSystem(extent={{-100,-120},{100,
            120}})));
end PartialConnection2Pipe2Medium;
