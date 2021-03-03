within Buildings.Experimental.DHC.Loads.Validation;
model Prototype
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
    annotation (Placement(transformation(extent={{-210,110},{-190,130}})));
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
        origin={-114,-40})));
  Fluid.Sensors.TemperatureTwoPort senTSup(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Fluid.Sources.Boundary_pT serSup(
    redeclare package Medium = Medium,
    p=Medium.p_default + 10E4,
    T=TSupSer_nominal - 40,
    nPorts=1) "Service supply"
    annotation (Placement(transformation(extent={{-210,-30},{-190,-10}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    dpFixed_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Fluid.Sources.Boundary_pT serRet(redeclare package Medium = Medium, nPorts=1)
    "Service return"
    annotation (Placement(transformation(extent={{-210,-70},{-190,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(k=0.01, Ti=60)
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temSupSet(
    y(final unit="K", displayUnit="degC"),
    k=TSupSet_nominal)
    annotation (Placement(transformation(extent={{-210,50},{-190,70}})));
  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    per(pressure(V_flow=m_flow_nominal/1000*{0,1,2}, dp=dp_nominal*{2,1,0})),
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  EnergyMassFlow masFlo(
    tau=tau,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Fluid.Delays.DelayFirstOrder del(
    redeclare package Medium=Medium,
    tau=10*tau,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal, nPorts=3)
    annotation (Placement(transformation(extent={{90,-20},{110,0}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFlo "Heat flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,10})));
  Fluid.Sensors.TemperatureTwoPort senTRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,-70},{-90,-50}})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium=Medium, nPorts=1)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={100,-40})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=10*tau)
    annotation (Placement(transformation(extent={{110,130},{130,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    u(unit="W"),
    Q_flow_nominal=1)
    annotation (Placement(transformation(extent={{130,-30},{150,-10}})));
  Utilities.Math.IntegratorWithReset int(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{110,90},{130,110}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time > 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=hex.Q2_flow)
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Utilities.Math.IntegratorWithReset int1(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{150,70},{170,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE
    annotation (Placement(transformation(extent={{190,90},{210,110}})));
protected
  parameter Modelica.SIunits.TemperatureDifference dT1_nominal = 20
    "Nominal Delta-T: change default btw cooling and heating applications";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    abs(Q_flow_nominal / dT1_nominal / cpWatLiq)
    "Nominal mass flow rate";
equation
  connect(hex.port_b2, senTSup.port_a)
    annotation (Line(points={{-108,-30},{-108,-20},{-70,-20}},
                                                          color={0,127,255}));
  connect(val.port_b, hex.port_a1)
    annotation (Line(points={{-130,-20},{-120,-20},{-120,-30}},
                                                          color={0,127,255}));
  connect(serSup.ports[1], val.port_a)
    annotation (Line(points={{-190,-20},{-150,-20}},
                                                   color={0,127,255}));
  connect(serRet.ports[1], hex.port_b1) annotation (Line(points={{-190,-60},{
          -120,-60},{-120,-50}},
                            color={0,127,255}));
  connect(senTSup.T, conPID.u_m) annotation (Line(points={{-60,-9},{-60,0},{
          -160,0},{-160,8}},
                          color={0,0,127}));
  connect(conPID.y, val.y)
    annotation (Line(points={{-148,20},{-140,20},{-140,-8}},
                                                          color={0,0,127}));
  connect(temSupSet.y, conPID.u_s)
    annotation (Line(points={{-188,60},{-180,60},{-180,20},{-172,20}},
                                                   color={0,0,127}));
  connect(loa.y[2], masFlo.Q_flow) annotation (Line(points={{-189,120},{-20,120},
          {-20,46},{-2,46}},  color={0,0,127}));
  connect(masFlo.m_flow, pum.m_flow_in)
    annotation (Line(points={{22,46},{40,46},{40,-8}},    color={0,0,127}));
  connect(heaFlo.port, del.heatPort) annotation (Line(points={{80,0},{80,-10},{
          90,-10}},           color={191,0,0}));
  connect(hex.port_a2, senTRet.port_b) annotation (Line(points={{-108,-50},{
          -108,-60},{-90,-60}},
                      color={0,127,255}));
  connect(movMea.u, add2.y)
    annotation (Line(points={{108,140},{100,140},{100,120},{82,120}},
                                                 color={0,0,127}));
  connect(loa.y[2], add2.u1) annotation (Line(points={{-189,120},{40,120},{40,
          126},{58,126}},
                     color={0,0,127}));
  connect(temSupSet.y, masFlo.TSupSet) annotation (Line(points={{-188,60},{-120,
          60},{-120,40},{-2,40}},   color={0,0,127}));
  connect(senTSup.T, masFlo.TSup_actual)
    annotation (Line(points={{-60,-9},{-60,34},{-2,34}},    color={0,0,127}));
  connect(masFlo.Q_flow_residual, heaFlo.Q_flow) annotation (Line(points={{22,34},
          {80,34},{80,20}},                 color={0,0,127}));
  connect(masFlo.Q_flow_actual, hea.u) annotation (Line(points={{22,40},{120,40},
          {120,-14},{128,-14}},
                            color={0,0,127}));
  connect(pum.port_b, del.ports[1])
    annotation (Line(points={{50,-20},{97.3333,-20}},color={0,127,255}));
  connect(del.ports[2], hea.port_a)
    annotation (Line(points={{100,-20},{130,-20}},
                                               color={0,127,255}));
  connect(bou2.ports[1], del.ports[3]) annotation (Line(points={{100,-30},{100,
          -20},{102.667,-20}},
                         color={0,127,255}));
  connect(add2.y, int.u) annotation (Line(points={{82,120},{100,120},{100,100},
          {108,100}},
                 color={0,0,127}));
  connect(booleanExpression.y, int.trigger)
    annotation (Line(points={{101,60},{120,60},{120,88}}, color={255,0,255}));
  connect(senTSup.port_b, pum.port_a)
    annotation (Line(points={{-50,-20},{30,-20}}, color={0,127,255}));
  connect(senTRet.port_a, hea.port_b) annotation (Line(points={{-70,-60},{160,
          -60},{160,-20},{150,-20}},
                             color={0,127,255}));
  connect(realExpression.y, add2.u2) annotation (Line(points={{31,100},{40,100},
          {40,114},{58,114}},  color={0,0,127}));
  connect(booleanExpression.y, int1.trigger) annotation (Line(points={{101,60},
          {160,60},{160,68}},  color={255,0,255}));
  connect(loa.y[2], int1.u) annotation (Line(points={{-189,120},{-20,120},{-20,
          80},{148,80}},
                     color={0,0,127}));
  connect(int1.y, NMBE.u2) annotation (Line(points={{171,80},{180,80},{180,94},
          {188,94}},  color={0,0,127}));
  connect(int.y, NMBE.u1) annotation (Line(points={{131,100},{180,100},{180,106},
          {188,106}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-140},{260,
            160}})),
      experiment(StopTime=360000),
      __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Validation/Prototype.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a validation model for the block
Buildings.Experimental.DHC.Loads.EnergyMassFlow.
The service supply temperature is voluntarily lowered 
to simulate a mismatch between the supply temperature
set point and the actual supply temperature, in the building
distribution system.
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
Changing the boundary condition for the service supply temperature allows
to simulate conditions where the load is always met and conditions where
the load cannot be met transiently.
In both cases the NMBE between the time series and the actual heat flow 
rate transferred by the ETS heat exchanger remains close to zero.
</p>
</html>"));
end Prototype;
