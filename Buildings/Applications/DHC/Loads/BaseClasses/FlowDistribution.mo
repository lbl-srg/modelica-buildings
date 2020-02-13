within Buildings.Applications.DHC.Loads.BaseClasses;
model FlowDistribution "Model of building hydraulic distribution system"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare replaceable package Medium = Buildings.Media.Water,
    final m_flow_small=1E-4*m_flow_nominal,
    final show_T=false,
    final allowFlowReversal=false);
  import Type_dis = Buildings.Applications.DHC.Loads.Types.DistributionType
    "Types of distribution system";
  import Type_ctr = Buildings.Applications.DHC.Loads.Types.PumpControlType
    "Types of distribution pump control";
  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow=m_flow_nominal/rho_default.*{0,1,2},
      dp=dp_nominal.*{1.5,1,0.5}),
    motorCooledByFluid=false) constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{70,-100},{90,-80}})));
  parameter Integer nPorts_a1 = 0
    "Number of terminal units return ports"
    annotation(Dialog(connectorSizing=true), Evaluate=true);
  parameter Integer nPorts_b1 = 0
    "Number of terminal units supply ports"
    annotation(Dialog(connectorSizing=true), Evaluate=true);
  final parameter Integer nUni = nPorts_a1
    "Number of served units"
    annotation(Evaluate=true);
  parameter Boolean have_pum
    "Set to true if the system has a pump"
    annotation(Evaluate=true);
  parameter Boolean have_val
    "Set to true if the system has a mixing valve"
    annotation(Evaluate=true);
  parameter Type_dis typDis = Type_dis.HeatingWater
    "Type of distribution system"
    annotation(Dialog(enable=have_val), Evaluate=true);
  parameter Type_ctr typCtr = Type_ctr.ConstantHead
    "Type of distribution pump control"
    annotation(Dialog(enable=have_pum), Evaluate=true);
  parameter Real spePum_nominal(final unit="1", final min=0, final max=1) = 1
    "Pump speed at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp_nominal(
    final min=0, final displayUnit="Pa")
    "Pressure drop at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.PressureDifference dpVal_nominal(
    final min=0, final displayUnit="Pa")=
    if have_val then 0.1 * dp_nominal else 0
    "Mixing valve pressure drop at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDis_nominal[:](
    final min=0, final displayUnit="Pa")=
    if nUni==1 then {1/2*(dp_nominal-dpVal_nominal-dpMin)} else
    1/2 .* cat(1, {(dp_nominal-dpVal_nominal-dpMin)*0.2},
    fill((dp_nominal-dpVal_nominal-dpMin)*0.8 / (nUni-1), nUni-1))
    "Pressure drop between each connected unit at nominal conditions (supply line)"
    annotation(Dialog(
      group="Nominal condition",
      enable=typCtr==Type_ctr.ConstantDp));
  parameter Modelica.SIunits.PressureDifference dpMin(
    final min=0, final displayUnit="Pa") = dp_nominal / 2
    "Pressure difference setpoint for ConstantDp or at zero flow for LinearHead"
    annotation(Dialog(enable=typCtr==Type_ctr.ConstantDp));
  parameter Modelica.SIunits.MassFlowRate mUni_flow_nominal[:](min=0)=
    fill(m_flow_nominal/nUni, nUni)
    "Mass flow rate of each connected unit at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=typCtr==Type_ctr.ConstantDp));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance (except for the pump always modeled in steady state)"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance (except for the pump always modeled in steady state)"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 120
    "Time constant of fluid temperature variation at nominal flow rate"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nPorts_a1](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Terminal units return ports"
    annotation (Placement(transformation(extent={{-110,160},{-90,240}}),
      iconTransformation(extent={{90,20},{110,100}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nPorts_b1](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Terminal units supply ports"
    annotation (Placement(transformation(extent={{90,160},{110,240}}),
      iconTransformation(extent={{-110,20},{-90,100}})));
  Modelica.Blocks.Interfaces.RealInput mReq_flow[nUni](
    each final quantity="MassFlowRate")
    "Heating or chilled water flow rate required to meet the load"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,260}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-40})));
  Modelica.Blocks.Interfaces.IntegerInput modChaOve if
    have_val and typDis == Type_dis.ChangeOver
    "Operating mode in change-over (1 for heating, -1 for cooling)"
    annotation (Placement(
      transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,-60}), iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K", final displayUnit="degC") if have_val
    "Supply temperature set point"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,-100}),
      iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,-80})));
  Modelica.Blocks.Interfaces.RealOutput mReqTot_flow(
    final quantity="MassFlowRate")
    "Total heating or chilled water flow rate required to meet the loads"
    annotation (Placement(transformation(extent={{100,240},{140,280}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput QActTot_flow(
    final quantity="HeatFlowRate")
    "Total heat flow rate transferred to the loads (>=0 for heating)"
    annotation (Placement(transformation(extent={{100,140},{140,180}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final quantity="Power") if have_pum
    "Power drawn by pump motor"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),
      iconTransformation(extent={{100,-90},{120,-70}})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumMasFloReq(
    final k=fill(1, nUni), final nin=nUni)
    "Total required mass flow rate"
    annotation (Placement(transformation(extent={{-80,250},{-60,270}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_m_flow[nUni](
    redeclare each final package Medium = Medium,
    each final use_m_flow_in=true,
    each final use_T_in=true,
    each final nPorts=1)
    "Source for terminal units supplied flow rate"
    annotation (Placement(transformation(extent={{60,190},{80,210}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium=Medium,
    final nPorts=nUni)
    "Sink for terminal units return flow rate"
    annotation (Placement(transformation(extent={{-60,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flowSum(
    final nin=nUni)
    annotation (Placement(transformation(extent={{-70,150},{-50,170}})));
  Modelica.Blocks.Sources.RealExpression mAct_flow[nUni](
    final y=if have_pum then mReq_flow else mReq_flow .*
    Buildings.Utilities.Math.Functions.smoothMin(
      1,
      senMasFlo.m_flow/Buildings.Utilities.Math.Functions.smoothMax(
        mReqTot_flow,
        m_flow_small,
        m_flow_small),
      1E-2))
    "Actual supplied mass flow rate"
    annotation (Placement(transformation(extent={{-20,198},{0,218}})));
  Modelica.Blocks.Sources.RealExpression QAct_flow[nUni](
    final y=mAct_flow.y .* (ports_b1.h_outflow - inStream(ports_a1.h_outflow)))
    "Actual heat flow rate transferred to each load"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare final package Medium = Medium,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final dpValve_nominal=dpVal_nominal,
    final use_inputFilter=false,
    final m_flow_nominal=m_flow_nominal,
    final linearized={true,true},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics) if have_val
    "Mixing valve"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, origin={-80,0})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource pipPre(
    redeclare final package Medium = Medium,
    final dp_start=dp_nominal - dpVal_nominal,
    final m_flow_start=m_flow_nominal,
    final show_T=false,
    final show_V_flow=false,
    final control_m_flow=typCtr==Type_ctr.ConstantSpeed,
    final control_dp=typCtr<>Type_ctr.ConstantSpeed,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small)
    "Fictitious pipe used to prescribe pump head or flow rate"
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium=Medium,
    final dp_nominal=0,
    final m_flow_nominal=m_flow_nominal,
    final tau=tau,
    final Q_flow_nominal=-1,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics)
    "Heat transfer from the terminal units to the distribution system"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare final package Medium=Medium,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m_flow_nominal*{1,1,1},
    final dp_nominal=0*{1,1,1},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics) if have_val
    "Flow splitter"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}}, origin={80,0})));
  Modelica.Blocks.Sources.RealExpression TSupVal(y=TSup)
    "Supply temperature value"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=180, origin={-90,140})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    "Supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nUni)
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  MixingValveControl conVal(final typDis=typDis) if have_val
    "Mixing valve controller"
    annotation (Placement(transformation(extent={{-48,-106},{-28,-86}})));
  // MISCELLANEOUS VARIABLES
  Modelica.SIunits.Temperature TSup(final displayUnit="degC")=
    Medium.temperature(state=Medium.setState_phX(
    p=pipPre.port_a.p,
    h=inStream(pipPre.port_a.h_outflow),
    X=inStream(pipPre.port_a.Xi_outflow)))
    "Supply temperature";
  Modelica.Blocks.Sources.RealExpression dpNetVal(final y=dpPum - dpVal_nominal)
    "Pressure drop over the distribution network (excluding mixing valve)"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=180, origin={-90,120})));
  Modelica.Blocks.Sources.RealExpression masFloPum(final y=mPum_flow)
    "Pump mass flow rate value"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=180, origin={-90,100})));
  Modelica.Blocks.Sources.RealExpression spePum(final y=spePum_nominal)
    "Pump speed (fractional)" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,80})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumFlo(
    redeclare final package Medium = Medium,
    per(
      final hydraulicEfficiency=per.hydraulicEfficiency,
      final motorEfficiency=per.motorEfficiency,
      final motorCooledByFluid=per.motorCooledByFluid,
      final speed_nominal=per.speed_nominal,
      final constantSpeed=per.constantSpeed,
      final speeds=per.speeds,
      final power=per.power),
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) if
    have_pum and typCtr <> Type_ctr.ConstantSpeed
    "Distribution pump with prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumSpe(
    redeclare final package Medium = Medium,
    per(
      pressure(
        final V_flow=per.pressure.V_flow,
        final dp=per.pressure.dp),
      final hydraulicEfficiency=per.hydraulicEfficiency,
      final motorEfficiency=per.motorEfficiency,
      final motorCooledByFluid=per.motorCooledByFluid,
      final speed_nominal=per.speed_nominal,
      final constantSpeed=per.constantSpeed,
      final speeds=per.speeds,
      final power=per.power),
    final allowFlowReversal=allowFlowReversal,
    addPowerToMedium=false,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) if
    have_pum and typCtr == Type_ctr.ConstantSpeed
    "Distribution pump with prescribed speed (fractional)"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
protected
  final parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal[nUni]=
    {sum(mUni_flow_nominal[i:nUni]) for i in 1:nUni}
    "Distribution flow rate between each connected unit at nominal conditions";
  final parameter Real kDis[nUni]=
    {if dpDis_nominal[i] > Modelica.Constants.eps then
      mDis_flow_nominal[i] / sqrt(dpDis_nominal[i]) else Modelica.Constants.inf
      for i in 1:nUni}
    "Flow coefficient between each connected unit at nominal conditions";
  Modelica.SIunits.MassFlowRate mDis_flow[nUni]=
    {sum(mReq_flow[i:nUni]) for i in 1:nUni}
    "Distribution flow rate between each connected unit";
  Modelica.SIunits.PressureDifference dpDis[nUni]=
    (mDis_flow ./ kDis) .^ 2
    "Pressure drop between each connected unit (supply line)";
  Modelica.SIunits.PressureDifference dpPum(final displayUnit="Pa")=
    if typCtr==Type_ctr.LinearHead then dpMin + mPum_flow / m_flow_nominal * dp_nominal
    elseif typCtr==Type_ctr.ConstantDp then 2 * sum(dpDis) + dpMin + dpVal_nominal
    else dp_nominal
    "Pump head";
  Modelica.SIunits.MassFlowRate mPum_flow=
    if typCtr==Type_ctr.ConstantFlow then m_flow_nominal else sum(mReq_flow)
    "Pump mass flow rate";
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default);
  parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";
initial equation
  assert(nPorts_a1 == nPorts_b1,
    "In " + getInstanceName() +
    ": The numbers of terminal units return ports (" + String(nPorts_a1) +
    ") and supply ports (" + String(nPorts_b1) + ") must be equal.");
  assert(if have_val then have_pum else true,
    "In " + getInstanceName() +
    ": The configuration where have_val is true and have_pum is false is not allowed.");
equation
  connect(sumMasFloReq.y, mReqTot_flow)
    annotation (Line(points={{-58,260},{120,260}}, color={0,0,127}));
  connect(mReq_flow, sumMasFloReq.u)
    annotation (Line(points={{-120,260},{-82,260}}, color={0,0,127}));
  connect(mAct_flow.y, sou_m_flow.m_flow_in)
    annotation (Line(points={{1,208},{58,208}}, color={0,0,127}));
  connect(ports_a1, sin.ports)
    annotation (Line(points={{-100,200},{-80,200}}, color={0,127,255}));
  connect(sou_m_flow.ports[1], ports_b1)
    annotation (Line(points={{80,200},{100,200}}, color={0,127,255}));
  connect(pipPre.port_b, senMasFlo.port_a)
    annotation (Line(points={{4,0},{10,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, heaCoo.port_a)
    annotation (Line(points={{30,0},{46,0}}, color={0,127,255}));
  connect(Q_flowSum.y, QActTot_flow)
    annotation (Line(points={{-48,160},{120,160}}, color={0,0,127}));
  connect(QAct_flow.y, Q_flowSum.u)
    annotation (Line(points={{-79,160},{-72,160}}, color={0,0,127}));
  connect(Q_flowSum.y, heaCoo.u) annotation (Line(points={{-48,160},{40,160},{40,
          6},{44,6}}, color={0,0,127}));
  connect(TSupVal.y, reaRep.u)
    annotation (Line(points={{-79,140},{-22,140}}, color={0,0,127}));
  connect(reaRep.y, sou_m_flow.T_in)
    annotation (Line(points={{2,140},{20,140},{
          20,204},{58,204}}, color={0,0,127}));

  if have_val then
    connect(port_a, val.port_1)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
    connect(heaCoo.port_b, spl.port_1)
      annotation (Line(points={{66,0},{70,0}}, color={0,127,255}));
    connect(spl.port_2, port_b)
      annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
    connect(spl.port_3, val.port_3)
      annotation (Line(points={{80,10},{80,40},{-80,40},{-80,10}}, color={0,127,255}));
    connect(TSupSet, conVal.TSupSet)
      annotation (Line(points={{-120,-100},{-49, -100}}, color={0,0,127}));
    connect(TSupVal.y, conVal.TSupMes)
      annotation (Line(points={{-79,140},{-60,140}, {-60,-104},{-49,-104}}, color={0,0,127}));
    connect(conVal.yVal, val.y)
      annotation (Line(points={{-27,-96},{-20,-96},{-20,-80},{-80,-80},{-80,-12}},
      color={0,0,127}));
    if typDis == Type_dis.ChangeOver then
      connect(modChaOve, conVal.modChaOve)
        annotation (Line(points={{-120,-60},{-88,-60},{-88,-88},{-49,-88}},
                                              color={255,127,0}));
    end if;

    connect(val.port_2, pumFlo.port_a)
      annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
    connect(val.port_2, pumSpe.port_a)
      annotation (Line(points={{-70,0},{-56,0},{-56,-40},{-50,-40}},  color={0,127,255}));

  else
    connect(heaCoo.port_b, port_b)
      annotation (Line(points={{66,0},{100,0}}, color={0,127,255}));
    if have_pum then
      connect(port_a, pumFlo.port_a)
        annotation (Line(points={{-100,0},{-50,0}}, color={0,127,255}));
      connect(port_a, pumSpe.port_a)
        annotation (Line(points={{-100,0},{-56,0},{-56,-40},{-50,-40}},  color={0,127,255}));
    else
      connect(port_a, pipPre.port_a)
        annotation (Line(points={{-100,0},{-16,0}}, color={0,127,255}));
    end if;
  end if;

  connect(pumFlo.port_b, pipPre.port_a)
    annotation (Line(points={{-30,0},{-16,0}}, color={0,127,255}));
  connect(pumSpe.port_b, pipPre.port_a)
    annotation (Line(points={{-30,-40},{-24,-40},{-24,0},{-16,0}},  color={0,127,255}));

  connect(pumFlo.P, PPum)
    annotation (Line(points={{-29,9},{-20,9},{-20,20},{90,
        20},{90,120},{120,120}}, color={0,0,127}));
  connect(pumSpe.P, PPum)
    annotation (Line(points={{-29,-31},{90,-31},{90,120},{120,120}},
                 color={0,0,127}));

  connect(dpNetVal.y, pipPre.dp_in)
    annotation (Line(points={{-79,120},{0,120},{0,8}}, color={0,0,127}));
  connect(masFloPum.y, pipPre.m_flow_in)
    annotation (Line(points={{-79,100},{-12,100},{-12,8}}, color={0,0,127}));

  connect(masFloPum.y, pumFlo.m_flow_in)
    annotation (Line(points={{-79,100},{-40,100},{-40,12}}, color={0,0,127}));
  connect(spePum.y, pumSpe.y)
    annotation (Line(points={{-79,80},{-46,80},{-46,-20},{-40,-20},{-40,-28}},  color={0,0,127}));

annotation (
  defaultComponentName="dis",
  Documentation(info="<html>
<p>
This model represents a hydraulic distribution system serving multiple terminal units.
It is primarily intended to be used in conjunction with models that derive from
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit</a>.
</p>
<p>
The fluid flow modeling is decoupled between a main distribution loop and several terminal
branch circuits:
</p>
<ul>
<li>
The flow rate in each branch circuit is equal to the flow rate demand yielded by the terminal
unit model, constrained by the condition that the sum of all demands is lower or equal to
the flow rate in the main loop.
</li>
<li>
The inlet temperature in each branch circuit is equal to the supply temperature in the main loop.
The outlet temperature in the main loop results from transferring the enthalpy flow rate of each
individual fluid stream to the main fluid stream.
</li>
<li>
The pressure drop in the main distribution loop corresponds to the pressure drop
over the whole distribution system (the pump head): it is governed by an equation representing
the control logic of the distribution pump. The pressure drop in each branch circuit is
irrelevant: <code>dp_nominal</code> (water side) must be set to zero for each terminal unit component.
</li>
</ul>
<p>
This modeling approach aims to minimize the number of algebraic equations by avoiding an explicit
modeling of the terminal actuators and the whole flow network.
</p>
<p>
In addition the assumption <code>allowFlowReversal=false</code> is used systematically
together with boundary conditions which actually ensure that no reverse flow conditions are
encountered in simulation. This allows directly accessing the inlet enthalpy value of a
component from the fluid port <code>port_a</code> with the built-in function <code>inStream</code>.
This approach is preferred to the use of two-port sensors which introduce a state to ensure
a smooth transition at flow reversal.
All connected components must meet the same requirements.
</p>
<p>
Optionally:
</p>
<ul>
<li>
a distribution pump can be modeled with a prescribed flow rate corresponding to the total flow rate
demand,
</li>
<li>
a mixing valve can be modeled (together with a distribution pump) with a control loop
tracking the supply temperature.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-104,6},{6,-6}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-50,6},{50,-6}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={66,44},
          rotation=90),
        Rectangle(
          extent={{72,6},{100,-6}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-60,78},{-6,66}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-36,6},{36,-6}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-8.88178e-16,42},
          rotation=90),
        Rectangle(
          extent={{-15,20},{15,-20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_val,
          origin={-42,-3},
          rotation=-90),
        Polygon(
          points={{-10,12},{-10,-8},{10,2},{-10,12}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-52,-2},
          rotation=0,
          lineThickness=0.5),
        Polygon(
          points={{-10,12},{-10,-8},{10,2},{-10,12}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-40,-10},
          rotation=90,
          lineThickness=0.5),
        Polygon(
          points={{-10,12},{-10,-8},{10,2},{-10,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-32,2},
          rotation=180,
          lineThickness=0.5),
        Rectangle(
          extent={{-48,-56},{72,-68}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          visible=have_val),
        Rectangle(
          extent={{-33,6},{33,-6}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-66,61},
          rotation=90),
        Rectangle(
          extent={{-100,94},{-72,82}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,66},{-72,54}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,40},{-72,28}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{72,66},{100,54}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{72,94},{100,82}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{72,40},{100,28}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-20,56},{20,16}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-16,16},{-16,-16},{16,0},{-16,16}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={0,40},
          rotation=90,
          visible=have_pum),
        Rectangle(
          extent={{-18,6},{18,-6}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-42,-38},
          rotation=90,
          visible=have_val),
        Rectangle(
          extent={{-25,6},{25,-6}},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={66,-31},
          rotation=90,
          visible=have_val)}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            280}})));
end FlowDistribution;
