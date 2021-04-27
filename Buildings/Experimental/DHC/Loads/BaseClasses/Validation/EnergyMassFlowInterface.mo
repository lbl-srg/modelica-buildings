within Buildings.Experimental.DHC.Loads.BaseClasses.Validation;
model EnergyMassFlowInterface
  "Validation of the model EnergyMassFlowInterface"
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
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
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
        origin={-94,60})));
  Fluid.Sources.Boundary_pT serSup(
    redeclare package Medium = Medium,
    p=Medium.p_default + 10E4,
    T=TSupSer_nominal - 30,
    nPorts=1) "Service supply"
    annotation (Placement(transformation(extent={{-240,70},{-220,90}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    dpFixed_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));
  Fluid.Sources.Boundary_pT serRet(redeclare package Medium = Medium, nPorts=1)
    "Service return"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(k=0.01, Ti=60)
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temSupSet(
    y(final unit="K", displayUnit="degC"),
    k=TSupSet_nominal)
    annotation (Placement(transformation(extent={{-240,-70},{-220,-50}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface
    eneMasFlo(
    redeclare package Medium = Medium,
    del(T_start=TSupSet_nominal),
    have_pum=true,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    TLoa_nominal=20 + 273.15,
    dp_nominal=dp_nominal) "Model driving energy and mass flow rate "
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Fluid.Sensors.TemperatureTwoPort senTRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,30},{-70,50}})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium=Medium, nPorts=1)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-88,20})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=10*tau)
    annotation (Placement(transformation(extent={{130,190},{150,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{80,170},{100,190}})));
  Utilities.Math.IntegratorWithReset int(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{130,150},{150,170}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time > 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Utilities.Math.IntegratorWithReset int1(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{170,130},{190,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE
    annotation (Placement(transformation(extent={{210,140},{230,160}})));
  Fluid.Sources.Boundary_pT serSup1(
    redeclare package Medium = Medium,
    p=Medium.p_default + dp_nominal/20,
    T=TSupSet_nominal,
    nPorts=1) "Service supply"
    annotation (Placement(transformation(extent={{-240,-110},{-220,-90}})));
  Fluid.Sources.Boundary_pT serRet1(redeclare package Medium = Medium, nPorts=1)
    "Service return"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));
  Fluid.Sensors.TemperatureTwoPort senTRet1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,-150},{-70,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea1(delta=10*tau)
    annotation (Placement(transformation(extent={{130,10},{150,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Utilities.Math.IntegratorWithReset int2(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{130,-30},{150,-10}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=time > 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Utilities.Math.IntegratorWithReset int3(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{170,-50},{190,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE1
    annotation (Placement(transformation(extent={{210,-40},{230,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ena(
    k=true) "Enable signal"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));
  Fluid.Sensors.TemperatureTwoPort senTSup(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface
    eneMasFlo1(
    redeclare package Medium = Medium,
    del(T_start=TSupSet_nominal),
    have_pum=false,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    TLoa_nominal=293.15,
    dp_nominal=dp_nominal) "Model driving energy and mass flow rate "
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Fluid.Sensors.TemperatureTwoPort senTSup1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-68,-110},{-48,-90}})));
protected
  parameter Modelica.SIunits.TemperatureDifference dT1_nominal = 20
    "Nominal Delta-T: change default btw cooling and heating applications";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    abs(Q_flow_nominal / dT1_nominal / cpWatLiq)
    "Nominal mass flow rate";
equation
  connect(val.port_b, hex.port_a1)
    annotation (Line(points={{-110,80},{-100,80},{-100,70}},
                                                          color={0,127,255}));
  connect(conPID.y, val.y)
    annotation (Line(points={{-148,120},{-120,120},{-120,92}},
                                                          color={0,0,127}));
  connect(temSupSet.y, conPID.u_s)
    annotation (Line(points={{-218,-60},{-200,-60},{-200,120},{-172,120}},
                                                   color={0,0,127}));
  connect(loa.y[2], eneMasFlo.QPre_flow) annotation (Line(points={{-219,-20},{0,
          -20},{0,87},{8,87}},    color={0,0,127}));
  connect(hex.port_a2, senTRet.port_b) annotation (Line(points={{-88,50},{-88,40},
          {-70,40}},  color={0,127,255}));
  connect(movMea.u, add2.y)
    annotation (Line(points={{128,200},{120,200},{120,180},{102,180}},
                                                 color={0,0,127}));
  connect(loa.y[2], add2.u1) annotation (Line(points={{-219,-20},{40,-20},{40,186},
          {78,186}}, color={0,0,127}));
  connect(temSupSet.y, eneMasFlo.TSupSet) annotation (Line(points={{-218,-60},{-4,
          -60},{-4,83},{8,83}},       color={0,0,127}));
  connect(add2.y, int.u) annotation (Line(points={{102,180},{120,180},{120,160},
          {128,160}},
                 color={0,0,127}));
  connect(booleanExpression.y, int.trigger)
    annotation (Line(points={{121,120},{140,120},{140,148}},
                                                          color={255,0,255}));
  connect(booleanExpression.y, int1.trigger) annotation (Line(points={{121,120},
          {180,120},{180,128}},color={255,0,255}));
  connect(loa.y[2], int1.u) annotation (Line(points={{-219,-20},{0,-20},{0,140},
          {168,140}},color={0,0,127}));
  connect(int1.y, NMBE.u2) annotation (Line(points={{191,140},{200,140},{200,144},
          {208,144}}, color={0,0,127}));
  connect(int.y, NMBE.u1) annotation (Line(points={{151,160},{200,160},{200,156},
          {208,156}}, color={0,0,127}));
  connect(movMea1.u, add1.y) annotation (Line(points={{128,20},{120,20},{120,0},
          {102,0}},   color={0,0,127}));
  connect(loa.y[2],add1. u1) annotation (Line(points={{-219,-20},{0,-20},{0,6},{
          78,6}},    color={0,0,127}));
  connect(add1.y, int2.u) annotation (Line(points={{102,0},{120,0},{120,-20},{128,
          -20}},       color={0,0,127}));
  connect(booleanExpression1.y, int2.trigger) annotation (Line(points={{121,-60},
          {140,-60},{140,-32}},   color={255,0,255}));
  connect(booleanExpression1.y, int3.trigger) annotation (Line(points={{121,-60},
          {180,-60},{180,-52}},   color={255,0,255}));
  connect(loa.y[2],int3. u) annotation (Line(points={{-219,-20},{0,-20},{0,-40},
          {168,-40}},color={0,0,127}));
  connect(int3.y, NMBE1.u2) annotation (Line(points={{191,-40},{200,-40},{200,-36},
          {208,-36}},        color={0,0,127}));
  connect(int2.y, NMBE1.u1) annotation (Line(points={{151,-20},{200,-20},{200,-24},
          {208,-24}},        color={0,0,127}));
  connect(ena.y, eneMasFlo.ena) annotation (Line(points={{-218,180},{-40,180},{-40,
          89},{8,89}},   color={255,0,255}));
  connect(bou2.ports[1], hex.port_a2)
    annotation (Line(points={{-88,30},{-88,50}},   color={0,127,255}));
  connect(eneMasFlo.port_b, senTRet.port_a) annotation (Line(points={{30,80},{80,
          80},{80,40},{-50,40}},    color={0,127,255}));
  connect(hex.port_b2, senTSup.port_a) annotation (Line(points={{-88,70},{-88,80},
          {-70,80}},  color={0,127,255}));
  connect(senTSup.port_b, eneMasFlo.port_a)
    annotation (Line(points={{-50,80},{10,80}},   color={0,127,255}));
  connect(senTSup.T, conPID.u_m) annotation (Line(points={{-60,91},{-60,100},{-160,
          100},{-160,108}},
                        color={0,0,127}));
  connect(eneMasFlo1.port_b, senTRet1.port_a) annotation (Line(points={{30,-100},
          {80,-100},{80,-140},{-50,-140}}, color={0,127,255}));
  connect(temSupSet.y, eneMasFlo1.TSupSet) annotation (Line(points={{-218,-60},{
          -4,-60},{-4,-98},{8,-98},{8,-97}},      color={0,0,127}));
  connect(ena.y, eneMasFlo1.ena) annotation (Line(points={{-218,180},{-40,180},{
          -40,-91},{8,-91}},   color={255,0,255}));
  connect(loa.y[2], eneMasFlo1.QPre_flow) annotation (Line(points={{-219,-20},{0,
          -20},{0,-93},{8,-93}},      color={0,0,127}));
  connect(senTSup1.port_b, eneMasFlo1.port_a)
    annotation (Line(points={{-48,-100},{10,-100}}, color={0,127,255}));
  connect(serSup1.ports[1], senTSup1.port_a)
    annotation (Line(points={{-220,-100},{-68,-100}}, color={0,127,255}));
  connect(serRet1.ports[1], senTRet1.port_b)
    annotation (Line(points={{-220,-140},{-70,-140}}, color={0,127,255}));
  connect(serSup.ports[1], val.port_a)
    annotation (Line(points={{-220,80},{-130,80}}, color={0,127,255}));
  connect(serRet.ports[1], hex.port_b1) annotation (Line(points={{-220,40},{
          -100,40},{-100,50}}, color={0,127,255}));
  connect(eneMasFlo.dH_flow, add2.u2) annotation (Line(points={{32,86},{60,86},
          {60,174},{78,174}}, color={0,0,127}));
  connect(eneMasFlo1.dH_flow, add1.u2) annotation (Line(points={{32,-94},{60,
          -94},{60,-6},{78,-6}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-240},{260,240}})),
      experiment(
      StopTime=360000,
      Tolerance=1e-06),
      __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/BaseClasses/Validation/EnergyMassFlowInterface.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a validation model for
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface\">
Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface</a>.
</p>
<p>
In the first case
the service hot water temperature is voluntarily lowered
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
to simulate a starving of the ETS with hot water mass flow rate, 
which also leads to a load that can only be partially met.
</p>
<p>
Changing the boundary condition for the service supply line allows
to simulate conditions where the load is always met and conditions where
the load cannot be met transiently.
In all cases the NMBE between the time series and the actual change in
enthalpy flow rate across the ETS remains close to zero.
</p>
</html>"));
end EnergyMassFlowInterface;
