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
  parameter Modelica.SIunits.Temperature TSup_nominal=333.15
    "Supply temperature at nominal conditions";
  parameter Modelica.SIunits.Temperature TSupSer_nominal=TSup_nominal + 10
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
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
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
    T_a2_nominal=TSup_nominal - dT1_nominal) "ETS HX"
   annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-94,120})));
  Fluid.Sources.Boundary_pT serSup(
    redeclare package Medium = Medium,
    p=Medium.p_default + 10E4,
    T=TSupSer_nominal - 30,
    nPorts=2) "Service supply"
    annotation (Placement(transformation(extent={{-240,128},{-220,148}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    dpFixed_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-130,130},{-110,150}})));
  Fluid.Sources.Boundary_pT serRet(redeclare package Medium = Medium, nPorts=2)
    "Service return"
    annotation (Placement(transformation(extent={{-240,90},{-220,110}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(k=0.01, Ti=60)
    annotation (Placement(transformation(extent={{-170,170},{-150,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temSupSet(
    y(final unit="K", displayUnit="degC"),
    k=TSup_nominal)
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface
    eneMasFlo(
    redeclare package Medium = Medium,
    TSup_nominal=TSup_nominal,
    del(T_start=TSup_nominal),
    have_pum=true,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    TLoa_nominal=293.15,
    dp_nominal=dp_nominal) "Model driving energy and mass flow rate "
    annotation (Placement(transformation(extent={{10,130},{30,150}})));
  Fluid.Sensors.TemperatureTwoPort senTRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,90},{-70,110}})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium=Medium, nPorts=1)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-88,80})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(delta=10*tau)
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{90,150},{110,170}})));
  Utilities.Math.IntegratorWithReset int(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time >= 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Utilities.Math.IntegratorWithReset int1(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{180,90},{200,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE
    annotation (Placement(transformation(extent={{220,100},{240,120}})));
  Fluid.Sources.Boundary_pT serSup1(
    redeclare package Medium = Medium,
    p=Medium.p_default + dp_nominal/20,
    T=TSup_nominal,
    nPorts=1) "Service supply"
    annotation (Placement(transformation(extent={{-242,-170},{-222,-150}})));
  Fluid.Sources.Boundary_pT serRet1(redeclare package Medium = Medium, nPorts=1)
    "Service return"
    annotation (Placement(transformation(extent={{-242,-210},{-222,-190}})));
  Fluid.Sensors.TemperatureTwoPort senTRet1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,-210},{-70,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea1(delta=10*tau)
    annotation (Placement(transformation(extent={{140,-150},{160,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{90,-150},{110,-130}})));
  Utilities.Math.IntegratorWithReset int2(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{140,-190},{160,-170}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=time >= 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  Utilities.Math.IntegratorWithReset int3(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE1
    annotation (Placement(transformation(extent={{220,-200},{240,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ena(
    k=true) "Enable signal"
    annotation (Placement(transformation(extent={{-240,210},{-220,230}})));
  Fluid.Sensors.TemperatureTwoPort senTSup(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface
    eneMasFlo1(
    redeclare package Medium = Medium,
    TSup_nominal=TSup_nominal,
    del(T_start=TSup_nominal),
    have_pum=false,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    TLoa_nominal=293.15,
    dp_nominal=dp_nominal) "Model driving energy and mass flow rate "
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));
  Fluid.Sensors.TemperatureTwoPort senTSup1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,-170},{-50,-150}})));

  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=dp_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=Q_flow_nominal,
    T_a1_nominal=TSupSer_nominal,
    T_a2_nominal=TSup_nominal - dT1_nominal) "ETS HX"
   annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-94,-40})));

  Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    dpFixed_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID1(k=0.01, Ti=60)
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface
    eneMasFlo2(
    redeclare package Medium = Medium,
    have_masFlo=true,
    TSup_nominal=TSup_nominal,
    del(T_start=TSup_nominal),
    have_pum=true,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    TLoa_nominal=293.15,
    dp_nominal=dp_nominal) "Model driving energy and mass flow rate "
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Fluid.Sensors.TemperatureTwoPort senTRet2(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,-70},{-70,-50}})));
  Fluid.Sources.Boundary_pT bou1(redeclare package Medium = Medium, nPorts=1)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-88,-80})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea2(delta=10*tau)
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(k2=-1)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Utilities.Math.IntegratorWithReset int4(reset=Buildings.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression2(y=time >= 1E4)
    "Reset to cancel the effect of the warmup period"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Utilities.Math.IntegratorWithReset int5(
    y_start=1E-6,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=1E-6)
    annotation (Placement(transformation(extent={{180,-70},{200,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Division NMBE2
    annotation (Placement(transformation(extent={{220,-60},{240,-40}})));
  Fluid.Sensors.TemperatureTwoPort senTSup2(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Modelica.Blocks.Sources.RealExpression masFloPre(y=log(loa.y[2]/
        Q_flow_nominal*(exp(-2.5) - 1) + 1)/(-2.5)*m_flow_nominal)
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
protected
  parameter Modelica.SIunits.TemperatureDifference dT1_nominal = 10
    "Nominal Delta-T: change default btw cooling and heating applications";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    abs(Q_flow_nominal / dT1_nominal / cpWatLiq)
    "Nominal mass flow rate";
equation
  connect(val.port_b, hex.port_a1)
    annotation (Line(points={{-110,140},{-100,140},{-100,130}},
                                                          color={0,127,255}));
  connect(conPID.y, val.y)
    annotation (Line(points={{-148,180},{-120,180},{-120,152}},
                                                          color={0,0,127}));
  connect(temSupSet.y, conPID.u_s)
    annotation (Line(points={{-218,0},{-200,0},{-200,180},{-172,180}},
                                                   color={0,0,127}));
  connect(loa.y[2], eneMasFlo.QPre_flow) annotation (Line(points={{-219,40},{0,40},
          {0,147},{8,147}},       color={0,0,127}));
  connect(hex.port_a2, senTRet.port_b) annotation (Line(points={{-88,110},{-88,100},
          {-70,100}}, color={0,127,255}));
  connect(movMea.u, add2.y)
    annotation (Line(points={{138,160},{112,160}},
                                                 color={0,0,127}));
  connect(loa.y[2], add2.u1) annotation (Line(points={{-219,40},{60,40},{60,166},
          {88,166}}, color={0,0,127}));
  connect(temSupSet.y, eneMasFlo.TSupSet) annotation (Line(points={{-218,0},{-10,
          0},{-10,143},{8,143}},      color={0,0,127}));
  connect(add2.y, int.u) annotation (Line(points={{112,160},{120,160},{120,120},
          {138,120}},
                 color={0,0,127}));
  connect(booleanExpression.y, int.trigger)
    annotation (Line(points={{141,80},{150,80},{150,108}},color={255,0,255}));
  connect(booleanExpression.y, int1.trigger) annotation (Line(points={{141,80},{
          190,80},{190,88}},   color={255,0,255}));
  connect(loa.y[2], int1.u) annotation (Line(points={{-219,40},{10,40},{10,100},
          {178,100}},color={0,0,127}));
  connect(int1.y, NMBE.u2) annotation (Line(points={{201,100},{210,100},{210,104},
          {218,104}}, color={0,0,127}));
  connect(int.y, NMBE.u1) annotation (Line(points={{161,120},{210,120},{210,116},
          {218,116}}, color={0,0,127}));
  connect(movMea1.u, add1.y) annotation (Line(points={{138,-140},{112,-140}},
                      color={0,0,127}));
  connect(loa.y[2],add1. u1) annotation (Line(points={{-219,40},{60,40},{60,-134},
          {88,-134}},color={0,0,127}));
  connect(add1.y, int2.u) annotation (Line(points={{112,-140},{130,-140},{130,-180},
          {138,-180}}, color={0,0,127}));
  connect(booleanExpression1.y, int2.trigger) annotation (Line(points={{141,-220},
          {150,-220},{150,-192}}, color={255,0,255}));
  connect(booleanExpression1.y, int3.trigger) annotation (Line(points={{141,-220},
          {190,-220},{190,-212}}, color={255,0,255}));
  connect(loa.y[2],int3. u) annotation (Line(points={{-219,40},{60,40},{60,-200},
          {178,-200}},
                     color={0,0,127}));
  connect(int3.y, NMBE1.u2) annotation (Line(points={{201,-200},{210,-200},{210,
          -196},{218,-196}}, color={0,0,127}));
  connect(int2.y, NMBE1.u1) annotation (Line(points={{161,-180},{210,-180},{210,
          -184},{218,-184}}, color={0,0,127}));
  connect(ena.y, eneMasFlo.ena) annotation (Line(points={{-218,220},{-40,220},{-40,
          149},{8,149}}, color={255,0,255}));
  connect(bou2.ports[1], hex.port_a2)
    annotation (Line(points={{-88,90},{-88,110}},  color={0,127,255}));
  connect(eneMasFlo.port_b, senTRet.port_a) annotation (Line(points={{30,140},{40,
          140},{40,100},{-50,100}}, color={0,127,255}));
  connect(hex.port_b2, senTSup.port_a) annotation (Line(points={{-88,130},{-88,140},
          {-70,140}}, color={0,127,255}));
  connect(senTSup.port_b, eneMasFlo.port_a)
    annotation (Line(points={{-50,140},{10,140}}, color={0,127,255}));
  connect(senTSup.T, conPID.u_m) annotation (Line(points={{-60,151},{-60,160},{-160,
          160},{-160,168}},
                        color={0,0,127}));
  connect(eneMasFlo1.port_b, senTRet1.port_a) annotation (Line(points={{30,-160},
          {40,-160},{40,-200},{-50,-200}}, color={0,127,255}));
  connect(temSupSet.y, eneMasFlo1.TSupSet) annotation (Line(points={{-218,0},{-10,
          0},{-10,-157},{8,-157}},                color={0,0,127}));
  connect(ena.y, eneMasFlo1.ena) annotation (Line(points={{-218,220},{-40,220},{
          -40,-151},{8,-151}}, color={255,0,255}));
  connect(senTSup1.port_b, eneMasFlo1.port_a)
    annotation (Line(points={{-50,-160},{10,-160}}, color={0,127,255}));
  connect(serSup1.ports[1], senTSup1.port_a)
    annotation (Line(points={{-222,-160},{-70,-160}}, color={0,127,255}));
  connect(serRet1.ports[1], senTRet1.port_b)
    annotation (Line(points={{-222,-200},{-70,-200}}, color={0,127,255}));
  connect(serSup.ports[1], val.port_a)
    annotation (Line(points={{-220,140},{-130,140}},
                                                   color={0,127,255}));
  connect(serRet.ports[1], hex.port_b1) annotation (Line(points={{-220,102},{-100,
          102},{-100,110}},    color={0,127,255}));
  connect(eneMasFlo.dH_flow, add2.u2) annotation (Line(points={{32,135},{80,135},{80,154},{88,154}},
                              color={0,0,127}));
  connect(eneMasFlo1.dH_flow, add1.u2) annotation (Line(points={{32,-165},{80,-165},{80,-146},{88,-146}},
                                 color={0,0,127}));
  connect(loa.y[2], eneMasFlo1.QPre_flow) annotation (Line(points={{-219,40},{0,
          40},{0,-153},{8,-153}},     color={0,0,127}));
  connect(val1.port_b, hex1.port_a1) annotation (Line(points={{-110,-20},{-100,-20},
          {-100,-30}}, color={0,127,255}));
  connect(conPID1.y, val1.y)
    annotation (Line(points={{-148,20},{-120,20},{-120,-8}}, color={0,0,127}));
  connect(temSupSet.y, conPID1.u_s) annotation (Line(points={{-218,0},{-200,0},{
          -200,20},{-172,20}}, color={0,0,127}));
  connect(loa.y[2], eneMasFlo2.QPre_flow) annotation (Line(points={{-219,40},{0,
          40},{0,-13},{8,-13}}, color={0,0,127}));
  connect(hex1.port_a2, senTRet2.port_b) annotation (Line(points={{-88,-50},{-88,
          -60},{-70,-60}}, color={0,127,255}));
  connect(movMea2.u, add3.y)
    annotation (Line(points={{138,0},{112,0}}, color={0,0,127}));
  connect(loa.y[2],add3. u1) annotation (Line(points={{-219,40},{60,40},{60,6},{
          88,6}},    color={0,0,127}));
  connect(temSupSet.y, eneMasFlo2.TSupSet) annotation (Line(points={{-218,0},{-10,
          0},{-10,-17},{8,-17}}, color={0,0,127}));
  connect(add3.y, int4.u) annotation (Line(points={{112,0},{120,0},{120,-40},{138,
          -40}}, color={0,0,127}));
  connect(booleanExpression2.y, int4.trigger) annotation (Line(points={{141,-80},
          {150,-80},{150,-52}}, color={255,0,255}));
  connect(booleanExpression2.y, int5.trigger) annotation (Line(points={{141,-80},
          {190,-80},{190,-72}}, color={255,0,255}));
  connect(loa.y[2],int5. u) annotation (Line(points={{-219,40},{60,40},{60,-60},
          {178,-60}},color={0,0,127}));
  connect(int5.y, NMBE2.u2) annotation (Line(points={{201,-60},{210,-60},{210,-56},
          {218,-56}}, color={0,0,127}));
  connect(int4.y, NMBE2.u1) annotation (Line(points={{161,-40},{210,-40},{210,-44},
          {218,-44}}, color={0,0,127}));
  connect(ena.y, eneMasFlo2.ena) annotation (Line(points={{-218,220},{-40,220},{
          -40,-11},{8,-11}}, color={255,0,255}));
  connect(bou1.ports[1], hex1.port_a2)
    annotation (Line(points={{-88,-70},{-88,-50}}, color={0,127,255}));
  connect(eneMasFlo2.port_b, senTRet2.port_a) annotation (Line(points={{30,-20},
          {40,-20},{40,-60},{-50,-60}}, color={0,127,255}));
  connect(hex1.port_b2, senTSup2.port_a) annotation (Line(points={{-88,-30},{-88,
          -20},{-70,-20}}, color={0,127,255}));
  connect(senTSup2.port_b, eneMasFlo2.port_a)
    annotation (Line(points={{-50,-20},{10,-20}}, color={0,127,255}));
  connect(senTSup2.T, conPID1.u_m) annotation (Line(points={{-60,-9},{-60,0},{-160,
          0},{-160,8}}, color={0,0,127}));
  connect(ena.y, eneMasFlo1.ena) annotation (Line(points={{-218,220},{-28,220},{
          -28,-151},{8,-151}}, color={255,0,255}));
  connect(eneMasFlo2.dH_flow, add3.u2) annotation (Line(points={{32,-25},{80,-25},{80,-6},{88,-6}},
                            color={0,0,127}));
  connect(masFloPre.y, eneMasFlo2.mPre_flow) annotation (Line(points={{-79,20},{
          -20,20},{-20,-15},{8,-15}}, color={0,0,127}));
  connect(serSup.ports[2], val1.port_a) annotation (Line(points={{-220,136},{-140,
          136},{-140,-20},{-130,-20}}, color={0,127,255}));
  connect(hex1.port_b1, serRet.ports[2]) annotation (Line(points={{-100,-50},{-100,
          -60},{-180,-60},{-180,100},{-220,100},{-220,98}}, color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-260},{260,260}})),
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
