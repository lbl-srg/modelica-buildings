within Buildings.Applications.DHC.Loads.BaseClasses;
model FlowDistribution_pump
  "Model for computing flow distribution based on terminal units flow demand"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare replaceable package Medium=Buildings.Media.Water,
    final allowFlowReversal=false);
  import typ = Buildings.Applications.DHC.Loads.Types.DistributionType
    "Types of distribution system";
  parameter Integer nUni = 1
    "Number of served units"
    annotation(Evaluate=true);
  parameter typ disTyp = typ.HeatingWater
    "Type of distribution system"
    annotation(Evaluate=true);
  parameter Boolean havePum = false
    "Set to true if the system has a pump"
    annotation(Evaluate=true);
  parameter Boolean haveVal = false
    "Set to true if the system has a mixing valve"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.PressureDifference dp_nominal(
    min=0, displayUnit="Pa")
    "Total pressure drop at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 120
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  // IO connectors
  Modelica.Blocks.Interfaces.RealInput m1Req_flow[nUni](
    each quantity="MassFlowRate")
    "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}}, rotation=0, origin={-120,220}),
      iconTransformation(extent={{-10,-10},{10,10}}, rotation=0, origin={-110,-40})));
  Modelica.Blocks.Interfaces.RealOutput mReq_flow(
    quantity="MassFlowRate")
    "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(extent={{100,200},
      {140,240}}),iconTransformation(extent={{100,-70},{120,-50}})));
  // Building blocks
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium=Medium,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    final Q_flow_nominal=1,
    final allowFlowReversal=allowFlowReversal)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    k=fill(1, nUni), nin=nUni)
    "Total required water mass flow rate"
    annotation (Placement(transformation(extent={{-10,210}, {10,230}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_m1_flow[nUni](
    redeclare each final package Medium = Medium,
    each final use_m_flow_in=true,
    each final use_T_in=true,
    each final nPorts=1)
    annotation (Placement(transformation(extent={{32,150},{52,170}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nUni](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{-110,120},{-90,200}}),
      iconTransformation(extent={{90,20},{110,100}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nUni](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{90,120},{110,200}}),
      iconTransformation(extent={{-110,20},{-90,100}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium=Medium,
    final nPorts=nUni)
    annotation (Placement(transformation(extent={{-40,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flowSum(
    final nin=1)
    annotation (Placement(transformation(extent={{-52,90},{-32,110}})));
  Modelica.Blocks.Interfaces.RealOutput QAct_flow(
    each quantity="HeatFlowRate")
    "Heat flow rate transferred to the source (<0 for heating)"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Sources.RealExpression m1Act_flow[nUni](y=m1Req_flow .*
        Buildings.Utilities.Math.Functions.smoothMin(
        1,
        senMasFlo.m_flow/Buildings.Utilities.Math.Functions.smoothMax(
          mReq_flow,
          m_flow_small,
          m_flow_small),
        1E-2))
    "Actual mass flow rate (constrained by sum(m1Act_flow)<=port_a.m_flow)"
    annotation (Placement(transformation(extent={{-18,158},{2,178}})));
  Modelica.Blocks.Sources.RealExpression Q1Act_flow[nUni](
    y=m1Act_flow.y .* (inStream(ports_a1.h_outflow) - ports_b1.h_outflow))
    "Actual heat flow rate transferred to the source"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    final dp_nominal=dp_nominal,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics)
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare final package Medium = Medium,
    final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    final use_inputFilter=false,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.1*dp_nominal,
    final linearized={true,true},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, origin={-80,0})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idealSource(
    redeclare final package Medium = Medium,
    final control_m_flow=false,
    final control_dp=true,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{-36,10},{-16,-10}})));
  Modelica.Blocks.Interfaces.RealInput mPum_flow(
    final quantity="MassFlowRate")
    "Prescribed flow rate of the pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-60})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare final package Medium = Medium,
    final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m_flow_nominal*{1,1,1},
    final dp_nominal=0*{1,1,1},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics)
    "Splitter/mixer"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}}, origin={80,0})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTSup(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    Ti=120,
    final yMax=1,
    final yMin=0,
    final reverseAction=(disTyp==typ.ChilledWater))
    "PI controller tracking supply temperature"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    final quantity="ThermodynamicTemperature",
    final displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-30})));
  Modelica.Blocks.Sources.RealExpression TSupVal(y=TSup)
    "Supply temperature value"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180, origin={-90,80})));
  Buildings.Utilities.Math.Polynominal pol(
    a={0.9*dp_nominal})
    "Polynomial expression defining pressure drop variation with flow rate"
    annotation (Placement(transformation(extent={{20,-50},{0,-30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal)
    "Supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=nUni)
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Modelica.SIunits.Temperature TSup(displayUnit="degC") = Medium.temperature(
    state=Medium.setState_phX(
      p=pum.port_b.p, h=pum.port_b.h_outflow, X=pum.port_b.Xi_outflow))
    "Supply temperature";
equation
  connect(mulSum.y, mReq_flow)
    annotation (Line(points={{12,220},{120,220}}, color={0,0,127}));
  connect(m1Req_flow, mulSum.u)
    annotation (Line(points={{-120,220},{-12, 220}}, color={0,0,127}));
  connect(m1Act_flow.y, sou_m1_flow.m_flow_in)
    annotation (Line(points={{3,168},{30,168}}, color={0,0,127}));
  connect(ports_a1, sin.ports)
    annotation (Line(points={{-100,160},{-60,160}}, color={0,127,255}));
  connect(sou_m1_flow.ports[1], ports_b1)
    annotation (Line(points={{52,160},{100,160}}, color={0,127,255}));
  connect(port_a, val.port_1)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(val.port_2, pum.port_a)
    annotation (Line(points={{-70,0},{-64,0}}, color={0,127,255}));
  connect(pum.port_b, idealSource.port_a)
    annotation (Line(points={{-44,0},{-36,0}},
                                             color={0,127,255}));
  connect(mPum_flow, pum.m_flow_in)
    annotation (Line(points={{-120,60},{-54,60},{-54,12}}, color={0,0,127}));
  connect(heaCoo.port_b, spl.port_1)
    annotation (Line(points={{64,0},{70,0}}, color={0,127,255}));
  connect(spl.port_2, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(spl.port_3, val.port_3)
    annotation (Line(points={{80,10},{80,40},{-80,40},{-80,10}},  color={0,127,255}));
  connect(TSupSet, conTSup.u_s)
    annotation (Line(points={{-120,-40},{-92,-40}}, color={0,0,127}));
  connect(TSupVal.y, conTSup.u_m)
    annotation (Line(points={{-79,80},{-40,80},{-40,-60},{-80,-60},{-80,-52}},
                                                                         color={0,0,127}));
  connect(conTSup.y, val.y)
    annotation (Line(points={{-68,-40},{-60,-40},{-60,-20},{-80,-20},{-80,-12}},
                                                              color={0,0,127}));
  connect(idealSource.port_b, senMasFlo.port_a)
    annotation (Line(points={{-16,0},{-10,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, heaCoo.port_a)
    annotation (Line(points={{10,0},{44,0}}, color={0,127,255}));
  connect(Q_flowSum.y, QAct_flow)
    annotation (Line(points={{-30,100},{120,100}}, color={0,0,127}));
  connect(Q1Act_flow.y, Q_flowSum.u[1:1])
    annotation (Line(points={{-79,100},{-54,100}}, color={0,0,127}));
  connect(Q_flowSum.y, heaCoo.u) annotation (Line(points={{-30,100},{36,100},{36,
          6},{42,6}}, color={0,0,127}));
  connect(pol.y, idealSource.dp_in)
    annotation (Line(points={{-1,-40},{-20,-40},{-20,-8}}, color={0,0,127}));
  connect(senMasFlo.m_flow, pol.u) annotation (Line(points={{0,11},{0,20},{30,20},
          {30,-40},{22,-40}}, color={0,0,127}));
  connect(TSupVal.y, reaRep.u)
    annotation (Line(points={{-79,80},{-22,80}}, color={0,0,127}));
  connect(reaRep.y, sou_m1_flow.T_in) annotation (Line(points={{2,80},{20,80},{20,
          164},{30,164}}, color={0,0,127}));
annotation (
defaultComponentName="disFlo",
Documentation(
info="<html>
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
irrelevant: <code>dp_nominal</code> must be set to zero for each terminal unit component.
</li>
</ul>
<p>
This modeling approach aims to minimize the number of algebraic equations by avoiding an explicit
modeling of the terminal actuators and the whole flow network.
</p>
<p>
In addition the assumption <code>allowFlowReversal = false</code> is used systematically
together with boundary conditions which actually ensure that no reverse flow conditions are
encountered in simulation. This allows directly accessing the inlet enthalpy value of a
component from the fluid port <code>port_a</code> with the built-in function <code>inStream</code>.
This approach is preferred to the use of two-port sensors which introduce a state to ensure
a smooth transition at flow reversal.
All connected components must meet the same requirements.
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
      Rectangle(
        extent={{-101,5},{100,-4}},
        lineColor={0,0,255},
        pattern=LinePattern.None,
        fillColor={0,0,255},
        fillPattern=FillPattern.Solid),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95})}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},
          {100,240}}),                                                                    graphics={Text(
        extent={{-100,270},{100,242}},
        lineColor={28,108,200},
        horizontalAlignment=TextAlignment.Left,
        textString="Implement piping heat loss using eps-ntu model with nominal dT"),               Text(
        extent={{-96,-64},{104,-92}},
        lineColor={28,108,200},
        horizontalAlignment=TextAlignment.Left,
        textString=
            "CPU time for integration is twice lower when Dynamics of valve, pump and splitter are NOT steady state!?")}));
end FlowDistribution_pump;
