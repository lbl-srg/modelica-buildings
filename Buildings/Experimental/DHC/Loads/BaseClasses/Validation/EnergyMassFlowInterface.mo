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
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
  Utilities.Math.IntegratorWithReset int(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time > 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Utilities.Math.IntegratorWithReset int1(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE
    annotation (Placement(transformation(extent={{220,40},{240,60}})));
  Fluid.Sources.Boundary_pT serSup1(
    redeclare package Medium = Medium,
    p=Medium.p_default + dp_nominal/20,
    T=TSupSet_nominal,
    nPorts=1) "Service supply"
    annotation (Placement(transformation(extent={{-242,-130},{-222,-110}})));
  Fluid.Sources.Boundary_pT serRet1(redeclare package Medium = Medium, nPorts=1)
    "Service return"
    annotation (Placement(transformation(extent={{-242,-170},{-222,-150}})));
  Fluid.Sensors.TemperatureTwoPort senTRet1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,-170},{-70,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea1(delta=10*tau)
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{90,-110},{110,-90}})));
  Utilities.Math.IntegratorWithReset int2(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{140,-150},{160,-130}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=time > 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));
  Utilities.Math.IntegratorWithReset int3(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE1
    annotation (Placement(transformation(extent={{220,-160},{240,-140}})));
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
    annotation (Placement(transformation(extent={{8,-130},{28,-110}})));
  Fluid.Sensors.TemperatureTwoPort senTSup1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));

protected
  parameter Modelica.SIunits.TemperatureDifference dT1_nominal = 10
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
          -20},{0,86},{8,86}},    color={0,0,127}));
  connect(hex.port_a2, senTRet.port_b) annotation (Line(points={{-88,50},{-88,40},
          {-70,40}},  color={0,127,255}));
  connect(movMea.u, add2.y)
    annotation (Line(points={{138,100},{112,100}},
                                                 color={0,0,127}));
  connect(loa.y[2], add2.u1) annotation (Line(points={{-219,-20},{60,-20},{60,106},
          {88,106}}, color={0,0,127}));
  connect(temSupSet.y, eneMasFlo.TSupSet) annotation (Line(points={{-218,-60},{-10,
          -60},{-10,83},{8,83}},      color={0,0,127}));
  connect(add2.y, int.u) annotation (Line(points={{112,100},{120,100},{120,60},{
          138,60}},
                 color={0,0,127}));
  connect(booleanExpression.y, int.trigger)
    annotation (Line(points={{141,20},{150,20},{150,48}}, color={255,0,255}));
  connect(booleanExpression.y, int1.trigger) annotation (Line(points={{141,20},{
          190,20},{190,28}},   color={255,0,255}));
  connect(loa.y[2], int1.u) annotation (Line(points={{-219,-20},{10,-20},{10,40},
          {178,40}}, color={0,0,127}));
  connect(int1.y, NMBE.u2) annotation (Line(points={{201,40},{210,40},{210,44},{
          218,44}},   color={0,0,127}));
  connect(int.y, NMBE.u1) annotation (Line(points={{161,60},{210,60},{210,56},{218,
          56}},       color={0,0,127}));
  connect(movMea1.u, add1.y) annotation (Line(points={{138,-100},{112,-100}},
                      color={0,0,127}));
  connect(loa.y[2],add1. u1) annotation (Line(points={{-219,-20},{60,-20},{60,-94},
          {88,-94}}, color={0,0,127}));
  connect(add1.y, int2.u) annotation (Line(points={{112,-100},{130,-100},{130,-140},
          {138,-140}}, color={0,0,127}));
  connect(booleanExpression1.y, int2.trigger) annotation (Line(points={{121,-180},
          {150,-180},{150,-152}}, color={255,0,255}));
  connect(booleanExpression1.y, int3.trigger) annotation (Line(points={{121,-180},
          {190,-180},{190,-172}}, color={255,0,255}));
  connect(loa.y[2],int3. u) annotation (Line(points={{-219,-20},{60,-20},{60,-160},
          {178,-160}},
                     color={0,0,127}));
  connect(int3.y, NMBE1.u2) annotation (Line(points={{201,-160},{210,-160},{210,
          -156},{218,-156}}, color={0,0,127}));
  connect(int2.y, NMBE1.u1) annotation (Line(points={{161,-140},{210,-140},{210,
          -144},{218,-144}}, color={0,0,127}));
  connect(ena.y, eneMasFlo.ena) annotation (Line(points={{-218,180},{-40,180},{-40,
          89},{8,89}},   color={255,0,255}));
  connect(bou2.ports[1], hex.port_a2)
    annotation (Line(points={{-88,30},{-88,50}},   color={0,127,255}));
  connect(eneMasFlo.port_b, senTRet.port_a) annotation (Line(points={{30,80},{
          40,80},{40,40},{-50,40}}, color={0,127,255}));
  connect(hex.port_b2, senTSup.port_a) annotation (Line(points={{-88,70},{-88,80},
          {-70,80}},  color={0,127,255}));
  connect(senTSup.port_b, eneMasFlo.port_a)
    annotation (Line(points={{-50,80},{10,80}},   color={0,127,255}));
  connect(senTSup.T, conPID.u_m) annotation (Line(points={{-60,91},{-60,100},{-160,
          100},{-160,108}},
                        color={0,0,127}));
  connect(eneMasFlo1.port_b, senTRet1.port_a) annotation (Line(points={{28,-120},
          {40,-120},{40,-160},{-50,-160}}, color={0,127,255}));
  connect(temSupSet.y, eneMasFlo1.TSupSet) annotation (Line(points={{-218,-60},{
          -10,-60},{-10,-117},{6,-117}},          color={0,0,127}));
  connect(ena.y, eneMasFlo1.ena) annotation (Line(points={{-218,180},{-40,180},{
          -40,-111},{6,-111}}, color={255,0,255}));
  connect(senTSup1.port_b, eneMasFlo1.port_a)
    annotation (Line(points={{-50,-120},{8,-120}},  color={0,127,255}));
  connect(serSup1.ports[1], senTSup1.port_a)
    annotation (Line(points={{-222,-120},{-70,-120}}, color={0,127,255}));
  connect(serRet1.ports[1], senTRet1.port_b)
    annotation (Line(points={{-222,-160},{-70,-160}}, color={0,127,255}));
  connect(serSup.ports[1], val.port_a)
    annotation (Line(points={{-220,80},{-176,80},{-176,80},{-130,80}},
                                                   color={0,127,255}));
  connect(serRet.ports[1], hex.port_b1) annotation (Line(points={{-220,40},{-100,
          40},{-100,50}},      color={0,127,255}));
  connect(eneMasFlo.dH_flow, add2.u2) annotation (Line(points={{32,86},{80,86},{
          80,94},{88,94}},    color={0,0,127}));
  connect(eneMasFlo1.dH_flow, add1.u2) annotation (Line(points={{30,-114},{80,-114},
          {80,-106},{88,-106}},  color={0,0,127}));
  connect(loa.y[2], eneMasFlo1.QPre_flow) annotation (Line(points={{-219,-20},{0,
          -20},{0,-114},{6,-114}},    color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-220},{260,220}})),
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
