within Buildings.Applications.DHC.Loads.Examples;
model CouplingGeojsonSpawn1And2Loop
  "Example illustrating the coupling of a multizone RC model to a fluid loop"
  import Buildings;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.MassFlowRate m_flowChiWat_nominal = Q_flowCooTot_nominal / 2 / 5 / 4190;
  parameter Modelica.SIunits.MassFlowRate m_flowHeaWat_nominal = Q_flowHeaTot_nominal / 2 / 5 / 4190;
  parameter Modelica.SIunits.MassFlowRate m_flowChiWat1_nominal = m_flowChiWat_nominal;
  parameter Modelica.SIunits.MassFlowRate m_flowHeaWat1_nominal = m_flowHeaWat_nominal;
  parameter Modelica.SIunits.MassFlowRate m_flowChiWatTot_nominal = m_flowChiWat_nominal + m_flowChiWat1_nominal;
  parameter Modelica.SIunits.MassFlowRate m_flowHeaWatTot_nominal = m_flowHeaWat_nominal + m_flowHeaWat1_nominal;
  parameter Real loaFac = 0.7;
  parameter Modelica.SIunits.HeatFlowRate Q_flowHeaTot_nominal = loaFac * 88000 * 2;
  parameter Modelica.SIunits.HeatFlowRate Q_flowCooTot_nominal = loaFac * 140000 * 2;

  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonSpawnBuilding1
                                                                        bui(Q_flowCoo_nominal={30000,5000,5000,5000,5000,
        20000})
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow
                                           supHea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowHeaWat_nominal,
    redeclare Buildings.Fluid.Movers.Data.Generic per,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
    "Supply for heating water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-32,30})));
  Buildings.Fluid.Movers.FlowControlled_m_flow
                                           supCoo(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowChiWat_nominal,
    redeclare Buildings.Fluid.Movers.Data.Generic per,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
   "Supply for chilled water"
   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-70})));
  Modelica.Blocks.Sources.RealExpression m_flowHeaVal(y=couHea.m_flowReq)
    annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
  Modelica.Blocks.Sources.RealExpression m_flowCooVal(y=couCoo.m_flowReq)
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatingOrCooling couHea(
    redeclare package Medium = Medium,
    nLoa=bui.nHeaLoa,
    flowRegime=bui.floRegHeaLoa,
    T1_a_nominal=318.15,
    T1_b_nominal=313.15,
    Q_flow_nominal=bui.Q_flowHea_nominal,
    T2_nominal=bui.THeaLoa_nominal,
    m_flow2_nominal=bui.m_flowHeaLoa_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,40},{20,20}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatingOrCooling couCoo(
    redeclare package Medium = Medium,
    nLoa=bui.nCooLoa,
    flowRegime=bui.floRegCooLoa,
    T1_a_nominal=280.15,
    T1_b_nominal=285.15,
    Q_flow_nominal=bui.Q_flowCoo_nominal,
    T2_nominal=bui.TCooLoa_nominal,
    m_flow2_nominal=bui.m_flowCooLoa_nominal,
    reverseAction=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonSpawnBuilding2
                                                                        bui1
    annotation (Placement(transformation(extent={{40,-240},{60,-220}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow
                                           supHea1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowHeaWat1_nominal,
    redeclare Buildings.Fluid.Movers.Data.Generic per,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
    "Supply for heating water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-32,-170})));
  Buildings.Fluid.Movers.FlowControlled_m_flow
                                           supCoo1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowChiWat1_nominal,
    redeclare Buildings.Fluid.Movers.Data.Generic per,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
   "Supply for chilled water"
   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-290})));
  Modelica.Blocks.Sources.RealExpression m_flowHeaVal1(y=couHea1.m_flowReq)
    annotation (Placement(transformation(extent={{-80,-154},{-60,-134}})));
  Modelica.Blocks.Sources.RealExpression m_flowCooVal1(y=couCoo1.m_flowReq)
    annotation (Placement(transformation(extent={{-80,-274},{-60,-254}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatingOrCooling couHea1(
    redeclare package Medium = Medium,
    nLoa=bui1.nHeaLoa,
    flowRegime=bui1.floRegHeaLoa,
    T1_a_nominal=318.15,
    T1_b_nominal=313.15,
    Q_flow_nominal=bui1.Q_flowHea_nominal,
    T2_nominal=bui1.THeaLoa_nominal,
    m_flow2_nominal=bui1.m_flowHeaLoa_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,-160},{20,-180}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatingOrCooling couCoo1(
    redeclare package Medium = Medium,
    nLoa=bui1.nCooLoa,
    flowRegime=bui1.floRegCooLoa,
    T1_a_nominal=280.15,
    T1_b_nominal=285.15,
    Q_flow_nominal=bui1.Q_flowCoo_nominal,
    T2_nominal=bui1.TCooLoa_nominal,
    m_flow2_nominal=bui1.m_flowCooLoa_nominal,
    reverseAction=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,-300},{20,-280}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volChiWat(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowChiWatTot_nominal,
    V=5*60*m_flowChiWatTot_nominal/1000,
    nPorts=4) annotation (Placement(transformation(extent={{-134,-170},{-114,-150}})));
  Buildings.Fluid.FixedResistances.PressureDrop resChiWat(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowChiWatTot_nominal,
    dp_nominal=100000) annotation (Placement(transformation(extent={{-162,-180},{-142,-160}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volHeaWat(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowHeaWatTot_nominal,
    V=5*60*m_flowHeaWatTot_nominal/1000,
    nPorts=4) annotation (Placement(transformation(extent={{-134,-110},{-114,-90}})));
  Buildings.Fluid.FixedResistances.PressureDrop resHeaWat(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowHeaWatTot_nominal,
    dp_nominal=100000) annotation (Placement(transformation(extent={{-162,-120},{-142,-100}})));
  Buildings.Fluid.Sources.Boundary_pT bouHeaWat(redeclare package Medium = Medium, nPorts=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-124,-132})));
  Buildings.Fluid.Sources.Boundary_pT bouChiWat(redeclare package Medium = Medium, nPorts=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-124,-190})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowHeaWatTot_nominal,
    dp_nominal=0,
    Q_flow_nominal=Q_flowHeaTot_nominal)
                                      annotation (Placement(transformation(extent={{-258,-120},{-238,-100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSupHeaWat(redeclare package Medium = Medium, m_flow_nominal=
        m_flowHeaWatTot_nominal) annotation (Placement(transformation(extent={{-234,-120},{-214,-100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSupChiWat(redeclare package Medium = Medium, m_flow_nominal=
        m_flowChiWatTot_nominal) annotation (Placement(transformation(extent={{-236,-160},{-216,-180}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u coo(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flowChiWatTot_nominal,
    dp_nominal=0,
    Q_flow_nominal=Q_flowCooTot_nominal)
                                      annotation (Placement(transformation(extent={{-260,-180},{-240,-160}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{-160,-60},{-180,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupHeaWatSet(k=45) "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-118,-60},{-138,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDTSupHeaWat(
    k=0.1,
    Ti=120,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each reverseAction=false,
    each yMin=0,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    y_reset=0)   "PID controller for supply temperature"
    annotation (Placement(transformation(extent={{-214,-60},{-234,-40}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-160,-240},{-180,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDTSupChiWat(
    k=0.1,
    Ti=120,
    each yMax=0,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each reverseAction=false,
    each yMin=-1,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    y_reset=0) "PID controller for supply temperature"
    annotation (Placement(transformation(extent={{-216,-220},{-236,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupHeaWatSet1(k=7) "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-240},{-140,-220}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-190,-120},{-170,-100}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-190,-160},{-170,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=0.1, uHigh=0.3)
    annotation (Placement(transformation(extent={{-190,-90},{-210,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=0.1, uHigh=0.3)
    annotation (Placement(transformation(extent={{-190,-210},{-210,-190}})));
equation
  connect(supHea.m_flow_in, m_flowHeaVal.y)
    annotation (Line(points={{-32,42},{-32,56},{-59,56}},          color={0,0,127}));
  connect(m_flowCooVal.y, supCoo.m_flow_in)
    annotation (Line(points={{-59,-44},{-30,-44},{-30,-58}},           color={0,0,127}));
  connect(bui.Q_flowHeaReq, couHea.Q_flowReq)
    annotation (Line(points={{61,-24},{80,-24},{80,0},{-10,0},{-10,22},{-2,22}}, color={0,0,127}));
  connect(bui.heaPorHea, couHea.heaPorLoa) annotation (Line(points={{40,-23},{10,-23},{10,20}}, color={191,0,0}));
  connect(bui.Q_flowCooReq, couCoo.Q_flowReq)
    annotation (Line(points={{61,-36},{80,-36},{80,-40},{-10,-40},{-10,-62},{-2,-62}}, color={0,0,127}));
  connect(bui.heaPorCoo, couCoo.heaPorLoa) annotation (Line(points={{40,-37},{10,-37},{10,-60}}, color={191,0,0}));
  connect(bui.m_flowHeaLoa, couHea.m_flow2)
    annotation (Line(points={{61,-27},{82,-27},{82,52},{-10,52},{-10,38},{-2,38}}, color={0,0,127}));
  connect(bui.m_flowCooLoa, couCoo.m_flow2)
    annotation (Line(points={{61,-33},{82,-33},{82,-94},{-10,-94},{-10,-78},{-2,-78}},   color={0,0,127}));
  connect(bui.fraLatCooReq, couCoo.fraLat)
    annotation (Line(points={{61,-31},{84,-31},{84,-98},{-12,-98},{-12,-74},{-2,-74}},   color={0,0,127}));
  connect(supHea1.m_flow_in, m_flowHeaVal1.y)
    annotation (Line(points={{-32,-158},{-32,-144},{-59,-144}},            color={0,0,127}));
  connect(m_flowCooVal1.y, supCoo1.m_flow_in)
    annotation (Line(points={{-59,-264},{-30,-264},{-30,-278}},            color={0,0,127}));
  connect(bui1.Q_flowHeaReq, couHea1.Q_flowReq)
    annotation (Line(points={{61,-224},{80,-224},{80,-200},{-10,-200},{-10,-178},{-2,-178}},
                                                                                          color={0,0,127}));
  connect(bui1.heaPorHea, couHea1.heaPorLoa) annotation (Line(points={{40,-223},{10,-223},{10,-180}}, color={191,0,0}));
  connect(bui1.Q_flowCooReq, couCoo1.Q_flowReq)
    annotation (Line(points={{61,-236},{80,-236},{80,-260},{-10,-260},{-10,-282},{-2,-282}},
                                                                                          color={0,0,127}));
  connect(bui1.heaPorCoo, couCoo1.heaPorLoa) annotation (Line(points={{40,-237},{10,-237},{10,-280}}, color={191,0,0}));
  connect(bui1.m_flowHeaLoa, couHea1.m_flow2)
    annotation (Line(points={{61,-227},{82,-227},{82,-148},{-10,-148},{-10,-162},{-2,-162}},
                                                                                          color={0,0,127}));
  connect(bui1.m_flowCooLoa, couCoo1.m_flow2)
    annotation (Line(points={{61,-233},{82,-233},{82,-314},{-10,-314},{-10,-298},{-2,-298}},
                                                                                          color={0,0,127}));
  connect(bui1.fraLatCooReq, couCoo1.fraLat)
    annotation (Line(points={{61,-231},{84,-231},{84,-318},{-12,-318},{-12,-294},{-2,-294}},color={0,0,127}));
  connect(resChiWat.port_b,volChiWat. ports[1]) annotation (Line(points={{-142,-170},{-127,-170}}, color={0,127,255}));
  connect(supHea.port_b, couHea.port_a) annotation (Line(points={{-22,30},{0,30}}, color={0,127,255}));
  connect(supCoo.port_b, couCoo.port_a) annotation (Line(points={{-20,-70},{0,-70}}, color={0,127,255}));
  connect(supCoo1.port_b, couCoo1.port_a)
    annotation (Line(points={{-20,-290},{-10,-290},{-10,-290},{0,-290}}, color={0,127,255}));
  connect(supHea1.port_b, couHea1.port_a) annotation (Line(points={{-22,-170},{0,-170}}, color={0,127,255}));
  connect(hea.port_b, senTSupHeaWat.port_a) annotation (Line(points={{-238,-110},{-234,-110}},
                                                                                             color={0,127,255}));
  connect(senTSupHeaWat.T, conPIDTSupHeaWat.u_m) annotation (Line(points={{-224,-99},{-224,-62}}, color={0,0,127}));
  connect(from_degC.y, conPIDTSupHeaWat.u_s) annotation (Line(points={{-182,-50},{-212,-50}}, color={0,0,127}));
  connect(TSupHeaWatSet.y, from_degC.u) annotation (Line(points={{-140,-50},{-158,-50}}, color={0,0,127}));
  connect(senTSupChiWat.T, conPIDTSupChiWat.u_m) annotation (Line(points={{-226,-181},{-226,-218}}, color={0,0,127}));
  connect(TSupHeaWatSet1.y, from_degC1.u) annotation (Line(points={{-142,-230},{-158,-230}}, color={0,0,127}));
  connect(from_degC1.y, conPIDTSupChiWat.u_s) annotation (Line(points={{-182,-230},{-214,-230}}, color={0,0,127}));
  connect(couHea.port_b, hea.port_a)
    annotation (Line(points={{20,30},{100,30},{100,80},{-300,80},{-300,-110},{-258,-110}},
                                                                                         color={0,127,255}));
  connect(couHea1.port_b, hea.port_a)
    annotation (Line(points={{20,-170},{100,-170},{100,80},{-300,80},{-300,-110},{-258,-110}},
                                                                                             color={0,127,255}));
  connect(couCoo1.port_b, coo.port_a)
    annotation (Line(points={{20,-290},{120,-290},{120,-340},{-300,-340},{-300,-170},{-260,-170}}, color={0,127,255}));
  connect(couCoo.port_b, coo.port_a)
    annotation (Line(points={{20,-70},{120,-70},{120,-340},{-300,-340},{-300,-170},{-260,-170}}, color={0,127,255}));
  connect(coo.port_b, senTSupChiWat.port_a) annotation (Line(points={{-240,-170},{-236,-170}}, color={0,127,255}));
  connect(resHeaWat.port_a, senMasFlo.port_b) annotation (Line(points={{-162,-110},{-170,-110}}, color={0,127,255}));
  connect(senTSupHeaWat.port_b, senMasFlo.port_a)
    annotation (Line(points={{-214,-110},{-190,-110}}, color={0,127,255}));
  connect(senTSupChiWat.port_b, senMasFlo1.port_a)
    annotation (Line(points={{-216,-170},{-190,-170}}, color={0,127,255}));
  connect(senMasFlo1.port_b,resChiWat. port_a) annotation (Line(points={{-170,-170},{-162,-170}}, color={0,127,255}));
  connect(volHeaWat.ports[1], supHea.port_a)
    annotation (Line(points={{-127,-110},{-90,-110},{-90,30},{-42,30}}, color={0,127,255}));
  connect(bouHeaWat.ports[1], volHeaWat.ports[2])
    annotation (Line(points={{-124,-122},{-124,-116},{-124,-110},{-125,-110}}, color={0,127,255}));
  connect(bouChiWat.ports[1], volChiWat.ports[2])
    annotation (Line(points={{-124,-180},{-124,-176},{-124,-170},{-125,-170}}, color={0,127,255}));
  connect(resHeaWat.port_b, volHeaWat.ports[3]) annotation (Line(points={{-142,-110},{-123,-110}}, color={0,127,255}));
  connect(volHeaWat.ports[4], supHea1.port_a)
    annotation (Line(points={{-121,-110},{-90,-110},{-90,-170},{-42,-170}}, color={0,127,255}));
  connect(volChiWat.ports[3], supCoo.port_a)
    annotation (Line(points={{-123,-170},{-100,-170},{-100,-70},{-40,-70}}, color={0,127,255}));
  connect(volChiWat.ports[4], supCoo1.port_a)
    annotation (Line(points={{-121,-170},{-100,-170},{-100,-290},{-40,-290}},   color={0,127,255}));
  connect(senMasFlo.m_flow, hys.u) annotation (Line(points={{-180,-99},{-180,-80},{-188,-80}}, color={0,0,127}));
  connect(hys.y, conPIDTSupHeaWat.trigger)
    annotation (Line(points={{-212,-80},{-216,-80},{-216,-62}}, color={255,0,255}));
  connect(conPIDTSupHeaWat.y, hea.u)
    annotation (Line(points={{-236,-50},{-280,-50},{-280,-104},{-260,-104}}, color={0,0,127}));
  connect(senMasFlo1.m_flow, hys1.u) annotation (Line(points={{-180,-181},{-180,-200},{-188,-200}}, color={0,0,127}));
  connect(hys1.y, conPIDTSupChiWat.trigger)
    annotation (Line(points={{-212,-200},{-218,-200},{-218,-218}}, color={255,0,255}));
  connect(conPIDTSupChiWat.y, coo.u)
    annotation (Line(points={{-238,-230},{-280,-230},{-280,-164},{-262,-164}}, color={0,0,127}));
  annotation (
  experiment(
      StopTime=86000,
      Tolerance=1e-06),
  Documentation(info="<html>
  <p>
  This example illustrates the use of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>
  to transfer heat from a fluid stream to a simplified multizone RC model resulting
  from the translation of a GeoJSON model specified within Urbanopt UI, see
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding</a>.
  </p>
  </html>"),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-320,-360},{140,100}}), graphics={Text(
          extent={{-496,-106},{-436,-146}},
          lineColor={28,108,200},
          fontSize=18,
          textString="Model with multiple EnergyPlus thermal zones:
can only be simulated with Dymola 2020x or JModelica.")}),
    __Dymola_Commands);
end CouplingGeojsonSpawn1And2Loop;
