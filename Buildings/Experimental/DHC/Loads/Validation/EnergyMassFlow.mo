within Buildings.Experimental.DHC.Loads.Validation;
model EnergyMassFlow
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water
    "Source side medium";
  constant Modelica.SIunits.SpecificHeatCapacity cpWatLiq=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity of liquid water";
  parameter String filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos")
    "Path of the file with loads as time series";
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal=
    Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp_nominal=30000
    "Nominal pressure drop";
  parameter Real fra_m_flow_min = 0.1
    "Minimum flow rate (ratio to nominal)";
  parameter Modelica.SIunits.Temperature TSupSet_nominal=333.15
    "Supply temperature set point at nominal conditions";
  parameter Modelica.SIunits.Temperature TSupSer_nominal=TSupSet_nominal + 10
    "Service supply temperature at nominal conditions";
  parameter Boolean have_reset = false
    "Set to true to reset the supply temperature (consider enumeration for open loop reset based on TOut or closed loop based on load signal (approximating T&R)";
  parameter Modelica.SIunits.Time tau = 60
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=filNam,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-240,110},{-220,130}})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare package Medium1=Medium,
    redeclare package Medium2=Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=dp_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=Q_flow_nominal,
    T_a1_nominal=TSupSer_nominal,
    T_a2_nominal=TSupSet_nominal - dT1_nominal) "ETS HX"
   annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-94,-40})));
  Fluid.Sensors.TemperatureTwoPort senTSup(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Fluid.Sources.Boundary_pT serSup(
    redeclare package Medium = Medium,
    p=Medium.p_default + 10E4,
    T=TSupSer_nominal - 30,
    nPorts=1) "Service supply"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    dpFixed_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Fluid.Sources.Boundary_pT serRet(redeclare package Medium = Medium, nPorts=1)
    "Service return"
    annotation (Placement(transformation(extent={{-240,-70},{-220,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(k=0.01, Ti=60)
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temSupSet(
    y(final unit="K", displayUnit="degC"),
    k=TSupSet_nominal)
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    per(pressure(V_flow=m_flow_nominal/1000*{0,1,2}, dp=dp_nominal*{2,1,0})),
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  .Buildings.Experimental.DHC.Loads.EnergyMassFlow masFlo(
    have_pum=true,
    tau=tau,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Fluid.Delays.DelayFirstOrder del(
    redeclare package Medium=Medium,
    tau=10*tau,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal, nPorts=3)
    annotation (Placement(transformation(extent={{110,-20},{130,0}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFlo "Heat flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,10})));
  Fluid.Sensors.TemperatureTwoPort senTRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,-70},{-70,-50}})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium=Medium, nPorts=1)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={120,-40})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=10*tau)
    annotation (Placement(transformation(extent={{130,130},{150,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{150,-30},{170,-10}})));
  Utilities.Math.IntegratorWithReset int(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{130,90},{150,110}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time > 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Utilities.Math.IntegratorWithReset int1(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{170,70},{190,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE
    annotation (Placement(transformation(extent={{210,80},{230,100}})));
  Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Fluid.Sensors.TemperatureTwoPort senTSup1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,-250},{-50,-230}})));
  Fluid.Sources.Boundary_pT serSup1(
    redeclare package Medium = Medium,
    p=Medium.p_default + dp_nominal/4,
    T=TSupSet_nominal,
    nPorts=1) "Service supply"
    annotation (Placement(transformation(extent={{-240,-250},{-220,-230}})));
  Fluid.Sources.Boundary_pT serRet1(redeclare package Medium = Medium, nPorts=1)
    "Service return"
    annotation (Placement(transformation(extent={{-240,-290},{-220,-270}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valPreInd(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    from_dp=true,
    dpValve_nominal=dp_nominal,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{50,-250},{70,-230}})));
  Buildings.Experimental.DHC.Loads.EnergyMassFlow  masFlo1(
    have_pum=false,
    tau=tau,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Fluid.Delays.DelayFirstOrder del1(
    redeclare package Medium = Medium,
    tau=10*tau,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    nPorts=2)
    annotation (Placement(transformation(extent={{110,-240},{130,-220}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFlo1
                                                 "Heat flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-210})));
  Fluid.Sensors.TemperatureTwoPort senTRet1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,-290},{-70,-270}})));
  Fluid.HeatExchangers.HeaterCooler_u hea1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{150,-250},{170,-230}})));
  Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-30,-250},{-10,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=1/m_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-210})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea1(delta=10*tau)
    annotation (Placement(transformation(extent={{130,-90},{150,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Utilities.Math.IntegratorWithReset int2(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{130,-130},{150,-110}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=time > 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{100,-170},{120,-150}})));
  Utilities.Math.IntegratorWithReset int3(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{170,-150},{190,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE1
    annotation (Placement(transformation(extent={{210,-140},{230,-120}})));
  Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo1(redeclare
      package Medium1 = Medium, final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-170,-270},{-150,-250}})));
  Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo(redeclare
      package Medium1 = Medium, final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-170,-50},{-150,-30}})));
protected
  parameter Modelica.SIunits.TemperatureDifference dT1_nominal = 20
    "Nominal Delta-T: change default btw cooling and heating applications";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    abs(Q_flow_nominal / dT1_nominal / cpWatLiq)
    "Nominal mass flow rate";
equation
  connect(hex.port_b2, senTSup.port_a)
    annotation (Line(points={{-88,-30},{-88,-20},{-70,-20}},
                                                          color={0,127,255}));
  connect(val.port_b, hex.port_a1)
    annotation (Line(points={{-110,-20},{-100,-20},{-100,-30}},
                                                          color={0,127,255}));
  connect(senTSup.T, conPID.u_m) annotation (Line(points={{-60,-9},{-60,0},{
          -160,0},{-160,8}},
                          color={0,0,127}));
  connect(conPID.y, val.y)
    annotation (Line(points={{-148,20},{-120,20},{-120,-8}},
                                                          color={0,0,127}));
  connect(temSupSet.y, conPID.u_s)
    annotation (Line(points={{-218,60},{-200,60},{-200,20},{-172,20}},
                                                   color={0,0,127}));
  connect(loa.y[2], masFlo.Q_flow) annotation (Line(points={{-219,120},{0,120},
          {0,49},{18,49}},    color={0,0,127}));
  connect(heaFlo.port, del.heatPort) annotation (Line(points={{100,0},{100,-10},
          {110,-10}},         color={191,0,0}));
  connect(hex.port_a2, senTRet.port_b) annotation (Line(points={{-88,-50},{-88,
          -60},{-70,-60}},
                      color={0,127,255}));
  connect(movMea.u, add2.y)
    annotation (Line(points={{128,140},{120,140},{120,120},{102,120}},
                                                 color={0,0,127}));
  connect(loa.y[2], add2.u1) annotation (Line(points={{-219,120},{60,120},{60,
          126},{78,126}},
                     color={0,0,127}));
  connect(temSupSet.y, masFlo.TSupSet) annotation (Line(points={{-218,60},{-100,
          60},{-100,40},{10,40},{10,43},{18,43}},
                                    color={0,0,127}));
  connect(senTSup.T, masFlo.TSup_actual)
    annotation (Line(points={{-60,-9},{-60,37},{18,37}},    color={0,0,127}));
  connect(pum.port_b, del.ports[1])
    annotation (Line(points={{70,-20},{117.333,-20}},color={0,127,255}));
  connect(del.ports[2], hea.port_a)
    annotation (Line(points={{120,-20},{150,-20}},
                                               color={0,127,255}));
  connect(bou2.ports[1], del.ports[3]) annotation (Line(points={{120,-30},{120,
          -20},{122.667,-20}},
                         color={0,127,255}));
  connect(add2.y, int.u) annotation (Line(points={{102,120},{120,120},{120,100},
          {128,100}},
                 color={0,0,127}));
  connect(booleanExpression.y, int.trigger)
    annotation (Line(points={{121,60},{140,60},{140,88}}, color={255,0,255}));
  connect(senTRet.port_a, hea.port_b) annotation (Line(points={{-50,-60},{180,
          -60},{180,-20},{170,-20}},
                             color={0,127,255}));
  connect(booleanExpression.y, int1.trigger) annotation (Line(points={{121,60},
          {180,60},{180,68}},  color={255,0,255}));
  connect(loa.y[2], int1.u) annotation (Line(points={{-219,120},{0,120},{0,80},
          {168,80}}, color={0,0,127}));
  connect(int1.y, NMBE.u2) annotation (Line(points={{191,80},{200,80},{200,84},
          {208,84}},  color={0,0,127}));
  connect(int.y, NMBE.u1) annotation (Line(points={{151,100},{200,100},{200,96},
          {208,96}},  color={0,0,127}));
  connect(masFlo.Q_flow_residual, heaFlo.Q_flow)
    annotation (Line(points={{42,34},{100,34},{100,20}},color={0,0,127}));
  connect(masFlo.Q_flow_actual, hea.u) annotation (Line(points={{42,40},{140,40},
          {140,-14},{148,-14}}, color={0,0,127}));
  connect(masFlo.m_flow, pum.m_flow_in)
    annotation (Line(points={{42,46},{60,46},{60,-8}},  color={0,0,127}));
  connect(senMasFlo.port_b, pum.port_a)
    annotation (Line(points={{-10,-20},{50,-20}}, color={0,127,255}));
  connect(senMasFlo.m_flow, masFlo.m_flow_actual) annotation (Line(points={{-20,-9},
          {-20,31.2},{18,31.2}},      color={0,0,127}));
  connect(heaFlo1.port, del1.heatPort)
    annotation (Line(points={{100,-220},{100,-230},{110,-230}},
                                                             color={191,0,0}));
  connect(senTSup1.T, masFlo1.TSup_actual) annotation (Line(points={{-60,-229},
          {-60,-183},{18,-183}},color={0,0,127}));
  connect(masFlo1.Q_flow_residual, heaFlo1.Q_flow)
    annotation (Line(points={{42,-186},{100,-186},{100,-200}},
                                                             color={0,0,127}));
  connect(senTSup1.port_b, senMasFlo1.port_a)
    annotation (Line(points={{-50,-240},{-30,-240}}, color={0,127,255}));
  connect(senMasFlo1.m_flow, masFlo1.m_flow_actual) annotation (Line(points={{-20,
          -229},{-20,-188.8},{18,-188.8}}, color={0,0,127}));
  connect(valPreInd.y, gai.y)
    annotation (Line(points={{60,-228},{60,-222}}, color={0,0,127}));
  connect(senTSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-50,-20},{-30,-20}}, color={0,127,255}));
  connect(loa.y[2], masFlo1.Q_flow) annotation (Line(points={{-219,120},{0,120},
          {0,-171},{18,-171}},   color={0,0,127}));
  connect(temSupSet.y, masFlo1.TSupSet) annotation (Line(points={{-218,60},{
          -200,60},{-200,-180},{0,-180},{0,-177},{18,-177}},color={0,0,127}));
  connect(masFlo1.m_flow, gai.u)
    annotation (Line(points={{42,-174},{60,-174},{60,-198}}, color={0,0,127}));
  connect(masFlo1.Q_flow_actual, hea1.u) annotation (Line(points={{42,-180},{
          140,-180},{140,-234},{148,-234}},
                                        color={0,0,127}));
  connect(senMasFlo1.port_b, valPreInd.port_a)
    annotation (Line(points={{-10,-240},{50,-240}}, color={0,127,255}));
  connect(valPreInd.port_b, del1.ports[1])
    annotation (Line(points={{70,-240},{118,-240}},color={0,127,255}));
  connect(hea1.port_b, senTRet1.port_a) annotation (Line(points={{170,-240},{
          180,-240},{180,-280},{-50,-280}}, color={0,127,255}));
  connect(del1.ports[2], hea1.port_a)
    annotation (Line(points={{122,-240},{150,-240}}, color={0,127,255}));
  connect(movMea1.u, add1.y) annotation (Line(points={{128,-80},{120,-80},{120,
          -100},{102,-100}},
                      color={0,0,127}));
  connect(loa.y[2],add1. u1) annotation (Line(points={{-219,120},{60,120},{60,
          -94},{78,-94}},
                     color={0,0,127}));
  connect(add1.y, int2.u) annotation (Line(points={{102,-100},{120,-100},{120,
          -120},{128,-120}},
                       color={0,0,127}));
  connect(booleanExpression1.y, int2.trigger) annotation (Line(points={{121,
          -160},{140,-160},{140,-132}},
                                  color={255,0,255}));
  connect(booleanExpression1.y, int3.trigger) annotation (Line(points={{121,
          -160},{180,-160},{180,-152}},
                                  color={255,0,255}));
  connect(loa.y[2],int3. u) annotation (Line(points={{-219,120},{0,120},{0,-140},
          {168,-140}},
                     color={0,0,127}));
  connect(int3.y, NMBE1.u2) annotation (Line(points={{191,-140},{200,-140},{200,
          -136},{208,-136}}, color={0,0,127}));
  connect(int2.y, NMBE1.u1) annotation (Line(points={{151,-120},{200,-120},{200,
          -124},{208,-124}}, color={0,0,127}));
  connect(serSup1.ports[1], senDifEntFlo1.port_a1) annotation (Line(points={{
          -220,-240},{-180,-240},{-180,-254},{-170,-254}}, color={0,127,255}));
  connect(serRet1.ports[1], senDifEntFlo1.port_b2) annotation (Line(points={{
          -220,-280},{-180,-280},{-180,-266},{-170,-266}}, color={0,127,255}));
  connect(senDifEntFlo1.port_a2, senTRet1.port_b) annotation (Line(points={{
          -150,-266},{-140,-266},{-140,-280},{-70,-280}}, color={0,127,255}));
  connect(senTSup1.port_a, senDifEntFlo1.port_b1) annotation (Line(points={{-70,
          -240},{-140,-240},{-140,-254},{-150,-254}}, color={0,127,255}));
  connect(senDifEntFlo1.dH_flow, add1.u2) annotation (Line(points={{-148,-257},
          {-80,-257},{-80,-120},{60,-120},{60,-106},{78,-106}}, color={0,0,127}));
  connect(serSup.ports[1], senDifEntFlo.port_a1) annotation (Line(points={{-220,
          -20},{-180,-20},{-180,-34},{-170,-34}}, color={0,127,255}));
  connect(senDifEntFlo.port_b1, val.port_a) annotation (Line(points={{-150,-34},
          {-144,-34},{-144,-20},{-130,-20}}, color={0,127,255}));
  connect(senDifEntFlo.port_a2, hex.port_b1) annotation (Line(points={{-150,-46},
          {-140,-46},{-140,-60},{-100,-60},{-100,-50}}, color={0,127,255}));
  connect(senDifEntFlo.port_b2, serRet.ports[1]) annotation (Line(points={{-170,
          -46},{-180,-46},{-180,-60},{-220,-60}}, color={0,127,255}));
  connect(senDifEntFlo.dH_flow, add2.u2) annotation (Line(points={{-148,-37},{
          -110,-37},{-110,-28},{-80,-28},{-80,100},{70,100},{70,114},{78,114}},
        color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-320},{260,160}})),
      experiment(
      StopTime=360000,
      Tolerance=1e-06),
      __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Validation/EnergyMassFlow.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a validation model for the block
Buildings.Experimental.DHC.Loads.EnergyMassFlow.
</p>
<p>
In the first case
the service supply temperature is voluntarily lowered
to simulate a mismatch between the supply temperature
set point of the building distribution system,
and the actual supply temperature.
This leads to an increase in the mass flow rate to compensate
for the low supply temperature.
When the mass flow rate reaches its nominal value, a part of the
load cannot be met.
This part is applied as a heat flow rate to a control volume.
It will contribute to the variation of the average temperature
of the fluid volume inside the distribution system.
The part of the load that can be met is directly applied to the fluid
stream as a steady-state heat flow rate.
</p>
<p>
In the second case
the service supply pressure is voluntarily lowered
to simulate a starving in the mass flow rate, which also
leads to a load that can only be partially met.
</p>
<p>
Changing the boundary condition for the service supply line allows
to simulate conditions where the load is always met and conditions where
the load cannot be met transiently.
In all cases the NMBE between the time series and the actual change in
enthalpy flow rate acroos the ETS remains close to zero.
</p>
</html>"));
end EnergyMassFlow;
