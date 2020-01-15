within Buildings.Applications.DHC.Loads.BaseClasses;
model FlowDistribution "Model of hydraulic distribution system"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare replaceable package Medium=Buildings.Media.Water,
    final m_flow_small=1E-4*m_flow_nominal,
    final show_T=false,
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
    "Pressure drop at nominal conditions (without valve)"
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
    "Time constant of primary fluid temperature variation at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  // IO connectors
  Modelica.Blocks.Interfaces.RealInput m1Req_flow[nUni](
    each quantity="MassFlowRate")
    "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}}, rotation=0, origin={-120,220}),
      iconTransformation(extent={{-10,-10},{10,10}}, rotation=0, origin={-110,-40})));
  Modelica.Blocks.Interfaces.IntegerInput modChaOve if haveVal and disTyp == typ.ChangeOver
    "Operating mode in change-over (1 for heating, -1 for cooling)"
    annotation (Placement(
      transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,-80}),
      iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,-60})));
  Modelica.Blocks.Interfaces.RealOutput mReq_flow(
    quantity="MassFlowRate")
    "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(extent={{100,200},
      {140,240}}),iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput QAct_flow(
    each quantity="HeatFlowRate")
    "Heat flow rate transferred to the source (<0 for heating)"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    quantity="Power", final unit="W") if havePum
    "Power drawn by pump motor"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,-90},{120,-70}})));
  // Building blocks
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium=Medium,
    dp_nominal=dp_nominal,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    tau=tau,
    Q_flow_nominal=1,
    final allowFlowReversal=allowFlowReversal)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final k=fill(1, nUni),
    final nin=nUni)
    "Total required water mass flow rate"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_m1_flow[nUni](
    redeclare each final package Medium=Medium,
    each final use_m_flow_in=true,
    each final use_T_in=true,
    each final nPorts=1)
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
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
    annotation (Placement(transformation(extent={{-60,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flowSum(
    final nin=nUni)
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Modelica.Blocks.Sources.RealExpression m1Act_flow[nUni](y=m1Req_flow .*
        Buildings.Utilities.Math.Functions.smoothMin(
        1,
        senMasFlo.m_flow/Buildings.Utilities.Math.Functions.smoothMax(
          mReq_flow,
          m_flow_small,
          m_flow_small),
        1E-2))
    "Actual mass flow rate (constrained by sum(m1Act_flow)<=port_a.m_flow)"
    annotation (Placement(transformation(extent={{-20,158},{0,178}})));
  Modelica.Blocks.Sources.RealExpression Q1Act_flow[nUni](
    y=m1Act_flow.y .* (inStream(ports_a1.h_outflow) - ports_b1.h_outflow))
    "Actual heat flow rate transferred to the source"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    per(motorCooledByFluid=false),
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) if havePum
    "Distribution pump"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
      redeclare final package Medium = Medium,
      final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
      final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
      final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
      final dpValve_nominal=1/9*dp_nominal,
      use_inputFilter=false,
      m_flow_nominal=m_flow_nominal,
      linearized={true,true},
      energyDynamics=energyDynamics,
      massDynamics=massDynamics) if haveVal
    "Mixing valve"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, origin={-80,0})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare final package Medium = Medium,
    dp_start=dp_nominal,
    m_flow_start=m_flow_nominal,
    show_T=false,
    show_V_flow=false,
    final control_m_flow=false,
    final control_dp=true,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small)
    "Fictitious pipe used to prescribe the total pressure drop"
    annotation (Placement(transformation(extent={{-20,10},{0,-10}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare final package Medium=Medium,
    final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=0*{1,1,1},
    energyDynamics=energyDynamics,
    massDynamics=massDynamics) if haveVal
    "Flow splitter"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}}, origin={80,0})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTSup(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    Ti=120,
    yMax=1,
    yMin=-1,
    final reverseAction=false) if haveVal
    "PI controller tracking supply temperature"
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    quantity="ThermodynamicTemperature",
    displayUnit="degC") if haveVal "Supply temperature set point"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,-120}),
      iconTransformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,-80})));
  Modelica.Blocks.Sources.RealExpression TSupVal(y=TSup)
    "Supply temperature value"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180, origin={-90,80})));
  Buildings.Utilities.Math.Polynominal pol(a={dp_nominal})
    "Polynomial expression defining pressure drop variation with flow rate"
    annotation (Placement(transformation(extent={{20,-30},{0,-10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    "Supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{18,10},{38,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=nUni)
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Max posPar if haveVal
    "Positive part of control signal"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Min negPar if haveVal
    "Negative part of control signal"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Sources.RealExpression zer(y=0) if haveVal
    "Zero value"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi if haveVal
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(k={-1}, nin=1) if haveVal
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Math.IntegerToBoolean toBoo(threshold=0) if
    haveVal and disTyp == typ.ChangeOver
    "Boolean conversion (true if heating mode)"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Modelica.Blocks.Sources.BooleanExpression fixMod(y=disTyp == typ.HeatingWater) if
    haveVal and disTyp <> typ.ChangeOver
    "Fixed operating mode"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Modelica.SIunits.Temperature TSup(displayUnit="degC") = Medium.temperature(
    state=Medium.setState_phX(
      p=ideSou.port_a.p,
      h=inStream(ideSou.port_a.h_outflow),
      X=inStream(ideSou.port_a.Xi_outflow)))
    "Supply temperature";
initial equation
  assert(if haveVal then havePum else true,
    "In " + getInstanceName() +
    ": The configuration where haveVal is true and havePum is false is not allowed.");
equation
  connect(mulSum.y, mReq_flow)
    annotation (Line(points={{-58,220},{120,220}},color={0,0,127}));
  connect(m1Req_flow, mulSum.u)
    annotation (Line(points={{-120,220},{-82,220}},  color={0,0,127}));
  connect(m1Act_flow.y, sou_m1_flow.m_flow_in)
    annotation (Line(points={{1,168},{38,168}}, color={0,0,127}));
  connect(ports_a1, sin.ports)
    annotation (Line(points={{-100,160},{-80,160}}, color={0,127,255}));
  connect(sou_m1_flow.ports[1], ports_b1)
    annotation (Line(points={{60,160},{100,160}}, color={0,127,255}));
  connect(val.port_2, pum.port_a)
    annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
  connect(pum.port_b, ideSou.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(ideSou.port_b, senMasFlo.port_a)
    annotation (Line(points={{0,0},{18,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, heaCoo.port_a)
    annotation (Line(points={{38,0},{46,0}}, color={0,127,255}));
  connect(Q_flowSum.y, QAct_flow)
    annotation (Line(points={{-48,100},{120,100}}, color={0,0,127}));
  connect(Q1Act_flow.y, Q_flowSum.u)
    annotation (Line(points={{-79,100},{-72,100}}, color={0,0,127}));
  connect(Q_flowSum.y, heaCoo.u) annotation (Line(points={{-48,100},{40,100},{40,
          6},{44,6}}, color={0,0,127}));
  connect(pol.y, ideSou.dp_in)
    annotation (Line(points={{-1,-20},{-4,-20},{-4,-8}},   color={0,0,127}));
  connect(senMasFlo.m_flow, pol.u) annotation (Line(points={{28,-11},{28,-20},{22,
          -20}},                  color={0,0,127}));
  connect(TSupVal.y, reaRep.u)
    annotation (Line(points={{-79,80},{-22,80}}, color={0,0,127}));
  connect(reaRep.y, sou_m1_flow.T_in) annotation (Line(points={{2,80},{20,80},{20,
          164},{38,164}}, color={0,0,127}));
  if haveVal then
    connect(port_a, val.port_1)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
    connect(heaCoo.port_b, spl.port_1)
      annotation (Line(points={{66,0},{70,0}}, color={0,127,255}));
    connect(spl.port_2, port_b)
      annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
    connect(spl.port_3, val.port_3)
      annotation (Line(points={{80,10},{80,40},{-80,40},{-80,10}}, color={0,127,255}));
    connect(TSupSet, conTSup.u_s)
      annotation (Line(points={{-120,-120},{-92,-120}}, color={0,0,127}));
    connect(TSupVal.y, conTSup.u_m)
      annotation (
      Line(points={{-79,80},{-60,80},{-60,-140},{-80,-140},{-80,-132}}, color={0,0,127}));
    connect(zer.y,negPar. u1) annotation (Line(points={{-69,-100},{-54,-100},{-54,
            -124},{-42,-124}}, color={0,0,127}));
    connect(zer.y, posPar.u1) annotation (Line(points={{-69,-100},{-54,-100},{-54,
            -84},{-42,-84}}, color={0,0,127}));
    connect(conTSup.y,negPar. u2) annotation (Line(points={{-68,-120},{-48,-120},
            {-48,-136},{-42,-136}}, color={0,0,127}));
    connect(conTSup.y, posPar.u2) annotation (Line(points={{-68,-120},{-48,-120},
            {-48,-96},{-42,-96}}, color={0,0,127}));
    connect(mulSum1.y, swi.u3) annotation (Line(points={{22,-130},{32,-130},{32,
            -118},{38,-118}}, color={0,0,127}));
    connect(swi.y, val.y) annotation (Line(points={{62,-110},{80,-110},{80,-60},
            {-80,-60},{-80,-12}},
                             color={0,0,127}));
    connect(negPar.y, mulSum1.u[1])
      annotation (Line(points={{-18,-130},{-2,-130}}, color={0,0,127}));
    connect(posPar.y, swi.u1)
      annotation (Line(points={{-18,-90},{32,-90},{32,-102},{38,-102}},
                      color={0,0,127}));
    if disTyp == typ.ChangeOver then
      connect(modChaOve, toBoo.u)
        annotation (Line(points={{-120,-80},{-92,-80}}, color={255,127,0}));
      connect(toBoo.y, swi.u2)
        annotation (Line(points={{-69,-80},{-64,-80},{-64,-110},{38,-110}},
                          color={255,0,255}));
    else
      connect(fixMod.y, swi.u2)
        annotation (Line(points={{21,-100},{26,-100},{26,-110},{38,-110}},
                        color={255,0,255}));
    end if;
  else
    connect(heaCoo.port_b, port_b)
      annotation (Line(points={{66,0},{100,0}}, color={0,127,255}));
    if havePum then
      connect(port_a, pum.port_a)
      annotation (Line(points={{-100,0},{-50,0}}, color={0,127,255}));
    else
      connect(port_a, ideSou.port_a)
        annotation (Line(points={{-100,0},{-20,0}}, color={0,127,255}));
    end if;
  end if;
  if havePum then
    connect(mulSum.y, pum.m_flow_in)
      annotation (Line(points={{-58,220},{-40,220},{-40,12}},
                                    color={0,0,127}));
  end if;
  connect(pum.P, PPum) annotation (Line(points={{-29,9},{-20,9},{-20,60},{120,60}},
        color={0,0,127}));
annotation (
  defaultComponentName="disFlo",
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
irrelevant: <code>dp_nominal</code> must be set to zero for each terminal unit component.
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
        extent={{-101,5},{100,-4}},
        lineColor={0,0,255},
        pattern=LinePattern.None,
        fillColor={0,0,255},
        fillPattern=FillPattern.Solid),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95})}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,
            240}}),                                                                       graphics={Text(
        extent={{-106,-142},{112,-170}},
        lineColor={28,108,200},
        horizontalAlignment=TextAlignment.Left,
          textString=
              "CPU time for integration is twice lower when Dynamics of valve or splitter are NOT steady state!?"),
                                                                                                    Text(
        extent={{-52,-32},{166,-60}},
        lineColor={28,108,200},
        horizontalAlignment=TextAlignment.Left,
          textString="Implement PI reset for change over")}));
end FlowDistribution;
