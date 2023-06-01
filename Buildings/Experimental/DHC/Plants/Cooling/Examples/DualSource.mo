within Buildings.Experimental.DHC.Plants.Cooling.Examples;
model DualSource
  "Idealised district system model with two sources and three users"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for CHW";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, slightly larger than needed by one user load";
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal=1
    "Nominal mass flow rate for CHW tank branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal=1
    "Nominal mass flow rate for CHW chiller branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final displayUnit="Pa")=
     300000
    "Nominal pressure difference";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal(
    final displayUnit="degC")=
     12+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal(
    final displayUnit="degC")=
     7+273.15
    "Nominal temperature of CHW supply";

// First plant: chiller only
  Buildings.Fluid.Sources.PropertySource_T chi1(
    redeclare final package Medium = Medium,
    final use_T_in=true) "Chiller 1 represented by an ideal temperature source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,70})));
  Modelica.Blocks.Sources.Constant TSet1(k=T_CHWS_nominal)
    "Constant CHW leaving temperature"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pumSup1(
    redeclare final package Medium = Medium,
    final addPowerToMedium=false,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal) "CHW supply pump for chi1"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.Continuous.LimPID conPI_pumChi1(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.2,
    Ti=10,
    final reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-50,170})));

// Second plant: chiller and tank
  Buildings.Experimental.DHC.Plants.Cooling.StoragePlant stoPla(redeclare
      final package Medium = Medium,
    mTan_flow_nominal=mTan_flow_nominal,
    mChi_flow_nominal=mChi_flow_nominal,
    dp_nominal=dp_nominal,
    T_CHWS_nominal=T_CHWS_nominal,
    T_CHWR_nominal=T_CHWR_nominal)                  "Storage plant" annotation (
     Placement(transformation(rotation=0, extent={{-20,-100},{0,-80}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    p(final displayUnit="Pa") = 101325 + dp_nominal,
    redeclare final package Medium = Medium,
    nPorts=1) "Pressure boundary" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-130})));
  Buildings.Fluid.Sources.PropertySource_T chi2(
    redeclare final package Medium = Medium,
    final use_T_in=true) "Chiller represented by an ideal temperature source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-90})));
  Modelica.Blocks.Sources.Constant TSet2(final k=T_CHWS_nominal)
    "Constant CHW leaving temperature"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

// Users
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.IdealUser ideUse1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.6*m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,150})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.IdealUser ideUse2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.65*m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-10})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.IdealUser ideUse3(
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.65*m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-170})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin_dpUse(nin=3)
    "Min of pressure head measured from all users"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,130})));
  Modelica.Blocks.Sources.Constant set_dpUse(final k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,170})));
  Modelica.Blocks.Sources.TimeTable mLoa1_flow(table=[0,0; 1800,0; 1800,ideUse1.m_flow_nominal;
        7000,ideUse1.m_flow_nominal; 7000,0; 9000,0])
    "Cooling load of user 1 represented by flow rate"
    annotation (Placement(transformation(extent={{100,180},{80,200}})));
  Modelica.Blocks.Sources.TimeTable mLoa2_flow(table=[0,0; 3500,0; 3500,ideUse2.m_flow_nominal;
        6500,ideUse2.m_flow_nominal; 6500,0; 9000,0])
    "Cooling load of user 2 represented by flow rate"
    annotation (Placement(transformation(extent={{100,20},{80,40}})));
  Modelica.Blocks.Sources.TimeTable mLoa3_flow(table=[0,0; 4500,0; 4500,ideUse3.m_flow_nominal;
        6000,ideUse3.m_flow_nominal; 6000,0; 9000,0])
    "Cooling load of user 3 represented by flow rate"
    annotation (Placement(transformation(extent={{100,-140},{80,-120}})));
  Modelica.Blocks.Math.Gain gaiUse1(final k=1/ideUse1.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,170})));
  Modelica.Blocks.Math.Gain gaiUse2(final k=1/ideUse2.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,12})));
  Modelica.Blocks.Math.Gain gaiUse3(final k=1/ideUse3.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-150})));

// District pipe network
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelJunctions
    parJunPla1(
    redeclare final package Medium = Medium,
    T1_start=T_CHWS_nominal,
    T2_start=T_CHWR_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,70})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelJunctions
    parJunUse2(
    redeclare final package Medium = Medium,
    T1_start=T_CHWR_nominal,
    T2_start=T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,-10})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelJunctions
    parJunPla2(
    redeclare final package Medium = Medium,
    T1_start=T_CHWS_nominal,
    T2_start=T_CHWR_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,-90})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelPipes
    parPipS1U1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.15*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,110})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelPipes
    parPipS1U2(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    dp_nominal=0.15*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,30})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelPipes
    parPipS2U2(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    dp_nominal=0.15*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,-50})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelPipes
    parPipS2U3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.15*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,-130})));

  Modelica.Blocks.Routing.Multiplex muxDp(n=3) "Multiplexer block for routing"
    annotation (Placement(transformation(extent={{180,140},{200,160}})));
  Modelica.Blocks.Routing.Multiplex muxVal(n=3) "Multiplexer block for routing"
    annotation (Placement(transformation(extent={{180,-180},{200,-160}})));
  Modelica.Blocks.Sources.IntegerTable com(table=[0,2; 200,1; 3000,2; 4000,3;
        6000,2; 7500,1])
    "Command: 1 = charge tank, 2 = hold tank, 3 = discharge from tank"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.BooleanTable chiEnaSta(table={0,6000}, startValue=
        false) "Chiller enable status, true if chiller is enabled"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys_yVal_actual(uLow=0.05,
      uHigh=0.5) "Hysteresis for user control valve position"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal_actual(nin=3)
    "Position of the most open user control valve"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

equation
  connect(set_dpUse.y,conPI_pumChi1.u_s)
    annotation (Line(points={{-79,170},{-62,170}}, color={0,0,127}));
  connect(mLoa1_flow.y, ideUse1.mPre_flow) annotation (Line(points={{79,190},{
          74,190},{74,158},{79,158}},
                                   color={0,0,127}));
  connect(mLoa2_flow.y, ideUse2.mPre_flow) annotation (Line(points={{79,30},{74,
          30},{74,-2},{79,-2}}, color={0,0,127}));
  connect(mLoa3_flow.y, ideUse3.mPre_flow) annotation (Line(points={{79,-130},{
          74,-130},{74,-162},{79,-162}}, color={0,0,127}));
  connect(ideUse1.dp, gaiUse1.u) annotation (Line(points={{101,154},{110,154},{
          110,170},{118,170}}, color={0,0,127}));
  connect(ideUse2.dp, gaiUse2.u) annotation (Line(points={{101,-6},{110,-6},{
          110,12},{118,12}},   color={0,0,127}));
  connect(ideUse3.dp, gaiUse3.u) annotation (Line(points={{101,-166},{110,-166},
          {110,-150},{118,-150}}, color={0,0,127}));
  connect(mulMin_dpUse.y,conPI_pumChi1.u_m)
    annotation (Line(points={{-78,130},{-50,130},{-50,158}}, color={0,0,127}));
  connect(parJunUse2.port_c2, ideUse2.port_a) annotation (Line(points={{60,-4},
          {80,-4}},                     color={0,127,255}));
  connect(ideUse2.port_b,parJunUse2.port_c1)  annotation (Line(points={{80,-16},
          {60,-16}},                            color={0,127,255}));
  connect(parPipS1U1.port_b2, parJunPla1.port_a1)
    annotation (Line(points={{44,100},{44,80}}, color={0,127,255}));
  connect(parJunPla1.port_b2, parPipS1U1.port_a1)
    annotation (Line(points={{56,80},{56,100}}, color={0,127,255}));
  connect(parJunPla1.port_b1, parPipS1U2.port_a2)
    annotation (Line(points={{44,60},{44,40}}, color={0,127,255}));
  connect(parPipS1U2.port_b2, parJunUse2.port_a2)
    annotation (Line(points={{44,20},{44,0}}, color={0,127,255}));
  connect(parJunUse2.port_b1, parPipS1U2.port_a1)
    annotation (Line(points={{56,0},{56,20}}, color={0,127,255}));
  connect(parPipS1U2.port_b1, parJunPla1.port_a2)
    annotation (Line(points={{56,40},{56,60}}, color={0,127,255}));
  connect(parJunUse2.port_b2, parPipS2U2.port_a2)
    annotation (Line(points={{44,-20},{44,-40}}, color={0,127,255}));
  connect(parPipS2U2.port_b1, parJunUse2.port_a1)
    annotation (Line(points={{56,-40},{56,-20}}, color={0,127,255}));
  connect(parPipS2U2.port_a1, parJunPla2.port_b2)
    annotation (Line(points={{56,-60},{56,-80}}, color={0,127,255}));
  connect(parJunPla2.port_a1, parPipS2U2.port_b2)
    annotation (Line(points={{44,-80},{44,-60}}, color={0,127,255}));
  connect(parPipS2U3.port_a2, parJunPla2.port_b1)
    annotation (Line(points={{44,-120},{44,-100}}, color={0,127,255}));
  connect(parJunPla2.port_a2, parPipS2U3.port_b1)
    annotation (Line(points={{56,-100},{56,-120}}, color={0,127,255}));
  connect(gaiUse1.y, muxDp.u[1]) annotation (Line(points={{141,170},{160,170},{
          160,147.667},{180,147.667}},
                                   color={0,0,127}));
  connect(gaiUse2.y, muxDp.u[2]) annotation (Line(points={{141,12},{160,12},{
          160,150},{180,150}},
                           color={0,0,127}));
  connect(gaiUse3.y, muxDp.u[3]) annotation (Line(points={{141,-150},{160,-150},
          {160,152.333},{180,152.333}}, color={0,0,127}));
  connect(muxDp.y[:], mulMin_dpUse.u[:]) annotation (Line(points={{201,150},{210,
          150},{210,210},{-110,210},{-110,130},{-102,130}},         color={0,0,127}));
  connect(ideUse1.yVal_actual, muxVal.u[1]) annotation (Line(points={{101,158},
          {106,158},{106,-172.333},{180,-172.333}}, color={0,0,127}));
  connect(ideUse2.yVal_actual, muxVal.u[2]) annotation (Line(points={{101,-2},{
          106,-2},{106,-170},{180,-170}}, color={0,0,127}));
  connect(ideUse3.yVal_actual, muxVal.u[3]) annotation (Line(points={{101,-162},
          {106,-162},{106,-170},{162,-170},{162,-167.667},{180,-167.667}},
        color={0,0,127}));
  connect(com.y, stoPla.com) annotation (Line(points={{-19,30},{-8,30},{-8,-79}},
                      color={255,127,0}));
  connect(chiEnaSta.y, stoPla.chiEnaSta) annotation (Line(points={{-19,-10},{-12,
          -10},{-12,-79}},           color={255,0,255}));
  connect(mulMax_yVal_actual.y, hys_yVal_actual.u)
    annotation (Line(points={{-58,-50},{-42,-50}},   color={0,0,127}));
  connect(hys_yVal_actual.y, stoPla.hasLoa) annotation (Line(points={{-18,-50},{
          -16,-50},{-16,-79}},             color={255,0,255}));
  connect(muxVal.y, mulMax_yVal_actual.u[1:3]) annotation (Line(points={{201,
          -170},{206,-170},{206,-186},{-110,-186},{-110,-49.3333},{-82,-49.3333}},
                      color={0,0,127}));
  connect(pumSup1.port_b, parJunPla1.port_c1) annotation (Line(points={{0,90},{20,
          90},{20,76},{40,76}}, color={0,127,255}));
  connect(conPI_pumChi1.y, pumSup1.y)
    annotation (Line(points={{-39,170},{10,170},{10,112},{-10,112},{-10,102}},
                                                             color={0,0,127}));
  connect(conPI_pumChi1.y, stoPla.yPum) annotation (Line(points={{-39,170},{10,170},
          {10,-74},{-4,-74},{-4,-79}},
                                     color={0,0,127}));
  connect(pumSup1.port_a, chi1.port_b)
    annotation (Line(points={{-20,90},{-50,90},{-50,80}}, color={0,127,255}));
  connect(chi1.port_a, parJunPla1.port_c2) annotation (Line(points={{-50,60},{-50,
          54},{20,54},{20,64},{40,64}}, color={0,127,255}));
  connect(TSet1.y, chi1.T_in) annotation (Line(points={{-79,70},{-72,70},{-72,66},
          {-62,66}}, color={0,0,127}));
  connect(TSet2.y, chi2.T_in) annotation (Line(points={{-79,-90},{-72,-90},{-72,
          -94},{-62,-94}}, color={0,0,127}));
  connect(stoPla.port_b1, parJunPla2.port_c1)
    annotation (Line(points={{0,-84},{40,-84}}, color={0,127,255}));
  connect(parJunPla2.port_c2, stoPla.port_a2)
    annotation (Line(points={{40,-96},{0,-96}}, color={0,127,255}));
  connect(stoPla.port_b2, chi2.port_a) annotation (Line(points={{-20,-96},{-34,
          -96},{-34,-106},{-50,-106},{-50,-100}}, color={0,127,255}));
  connect(chi2.port_b, stoPla.port_a1) annotation (Line(points={{-50,-80},{-50,
          -74},{-34,-74},{-34,-84},{-20,-84}}, color={0,127,255}));
  connect(bou.ports[1], stoPla.port_a2) annotation (Line(points={{0,-130},{6,
          -130},{6,-96},{0,-96}}, color={0,127,255}));
  connect(parPipS1U1.port_a2, ideUse1.port_a)
    annotation (Line(points={{44,120},{44,156},{80,156}}, color={0,127,255}));
  connect(ideUse1.port_b, parPipS1U1.port_b1)
    annotation (Line(points={{80,144},{56,144},{56,120}}, color={0,127,255}));
  connect(parPipS2U3.port_b2, ideUse3.port_a) annotation (Line(points={{44,-140},
          {44,-164},{80,-164}}, color={0,127,255}));
  connect(parPipS2U3.port_a1, ideUse3.port_b) annotation (Line(points={{56,-140},
          {56,-176},{80,-176}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, StopTime=9000),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Cooling/Examples/DualSource.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),                                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-200},{220,220}})),
        Documentation(info="<html>
<p>
The modelled system is described in the documentation of
<a href=\"Modelica://Buildings.Experimental.DHC.Plants.Cooling.StoragePlant\">
Buildings.Experimental.DHC.Plants.Cooling.StoragePlant</a>.
</p>
<p>
The source blocks give the system the following operation schedule during
simulation:
</p>
<ul>
<li>
At <code>time = 0</code>, the system is all off.
</li>
<li>
At <code>time = 200</code>, the system is commanded to charge the tank.
The chiller is available and charges the tank locally.
After some time, the charging stops when the tank is cooled.
Note that at this point the tank still has capacity.
</li>
<li>
At <code>time = 1800</code>, load appears at the district network.
The storage plant starts producing CHW to the system.
Currently the system is commanded to hold the tank and
therefore the CHW is supplied by the chiller.
<ul>
<li>
Because the CHW flow needed at the storage plant is lower than that is
produced by the chiller and the constant-speed pump, the tank continues
to be charged by the overflow.
</li>
<li>
After some time, the tank reaches the overcooled status.
It then overrides the production priority of the chiller to produce CHW
for the network instead. This continues until the tank is no longer
overcooled, at which point the production priority is handed back to
the chiller.
</li>
<li>
The chiller and the tank continue to exchange the production priority
based on whether the tank is overcooled.
</li>
</ul>
</li>
<li>
At <code>time = 3500</code>, the load increases and there is no more overflow
to charge the tank.
</li>
<li>
At <code>time = 4000</code>, the system is commanded to have the tank take
priority over CHW production. After some time, the chill in the tank is
depleted and the tank stops producing. Now the chiller takes over.
</li>
<li>
At <code>time = 7000</code>, there is no longer load in the district system.
The system is back to the all-off state.
</li>
<li>
At <code>time = 7500</code>, the system in once again commanded to charge
the tank, but the chiller in the storage plant is not enabled.
The tank is therefore charged remotely by the district.
This stops once the tank is cooled.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 11, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end DualSource;
