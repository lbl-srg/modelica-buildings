within Buildings.Obsolete.DistrictHeatingCooling.Examples;
model HeatingCoolingHotWater3Clusters
  "Validation model for a system with three clusters of buildings"
  extends
    Buildings.Obsolete.DistrictHeatingCooling.Examples.BaseClasses.HeatingCoolingHotWater3Clusters(
      PHea(nu=17), PCoo(nu=9));
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 2.5E6
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+12
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+16
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea-TSetHeaLea
    "Temperature difference between warm and cold pipe"
    annotation(Dialog(group="Design parameter"));

  parameter Real R_nominal(unit="Pa/m") = 100
    "Pressure drop per meter at nominal flow rate";

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/4200/dT_nominal
    "Nominal mass flow rate";
  Plants.HeatingCoolingCarnot_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal = m_flow_nominal) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-510,100},{-490,120}})));

  Plants.LakeWaterHeatExchanger_T bayWatHex(
    dpHex_nominal=0,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    show_T=true) "Bay water heat exchanger"
    annotation (Placement(transformation(extent={{-400,18},{-380,60}})));

  Buildings.Fluid.Sources.Boundary_pT pSet(redeclare package Medium = Medium,
      nPorts=1) "Model to set the reference pressure"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-562,110})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-360,130},{-340,150}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-340,10},{-360,30}})));
  Buildings.Fluid.FixedResistances.Pipe pip2(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Fluid.FixedResistances.Pipe pip3(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{160,10},{140,30}})));
  Buildings.Fluid.FixedResistances.Pipe pip4(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Fluid.FixedResistances.Pipe pip5(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{160,-210},{140,-190}})));

  Buildings.Fluid.FixedResistances.Junction splSup1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-330,130},{-310,150}})));
  Buildings.Fluid.FixedResistances.Junction splRet1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-250,30},{-230,10}})));
  Buildings.Fluid.FixedResistances.Junction splSup2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-210,130},{-190,150}})));
  Buildings.Fluid.FixedResistances.Junction splRet2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-130,30},{-110,10}})));
  Buildings.Fluid.FixedResistances.Junction splSup3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-90,130},{-70,150}})));
  Buildings.Fluid.FixedResistances.Junction splRet3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-10,30},{10,10}})));
  Buildings.Fluid.FixedResistances.Junction splSup5(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{190,130},{210,150}})));
  Buildings.Fluid.FixedResistances.Junction splRet5(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{270,30},{290,10}})));
  Buildings.Fluid.FixedResistances.Junction splSup6(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{330,130},{350,150}})));
  Buildings.Fluid.FixedResistances.Junction splRet6(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{410,30},{430,10}})));
  Buildings.Fluid.FixedResistances.Junction splSup4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{50,130},{70,150}})));
  Buildings.Fluid.FixedResistances.Junction splRet4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Buildings.Fluid.FixedResistances.Junction splSup7(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{180,-90},{200,-70}})));
  Buildings.Fluid.FixedResistances.Junction splRet7(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{270,-190},{290,-210}})));
protected
  Modelica.Blocks.Sources.Constant TSetC(k=TSetCooLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-560,160},{-540,180}})));

  Modelica.Blocks.Sources.Constant TSetH(k=TSetHeaLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-560,190},{-540,210}})));

public
  Modelica.Blocks.Sources.CombiTimeTable watTem(
    tableOnFile=true,
    tableName="tab1",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    y(each unit="K"),
    fileName=Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(
      "modelica://Buildings/Resources/Data/Obsolete/DistrictHeatingCooling/Plants/AlamedaOceanT.mos"))
    "Temperature of the water reservoir (such as a river, lake or ocean)"
    annotation (Placement(transformation(extent={{-460,48},{-440,68}})));
equation
  connect(splSup1.port_2, splSup2.port_1) annotation (Line(points={{-310,140},{-260,
          140},{-210,140}}, color={0,127,255}));
  connect(splSup2.port_2, splSup3.port_1) annotation (Line(points={{-190,140},{-140,
          140},{-90,140}}, color={0,127,255}));
  connect(splSup1.port_3, larOff1.port_a) annotation (Line(points={{-320,130},{-320,
          130},{-320,84},{-320,80},{-300,80}}, color={0,127,255}));
  connect(larOff1.port_b, splRet1.port_3) annotation (Line(points={{-260.143,80},
          {-240,80},{-240,30}}, color={0,127,255}));
  connect(splSup2.port_3, ret1.port_a) annotation (Line(points={{-200,130},{-200,
          130},{-200,94},{-200,80},{-180,80}}, color={0,127,255}));
  connect(splSup3.port_3, larOff2.port_a) annotation (Line(points={{-80,130},{-80,
          130},{-80,80},{-60,80}}, color={0,127,255}));
  connect(ret1.port_b, splRet2.port_3) annotation (Line(points={{-140.143,80},{
          -120,80},{-120,30}},
                          color={0,127,255}));
  connect(splRet1.port_2, splRet2.port_1) annotation (Line(points={{-230,20},{-180,
          20},{-130,20}}, color={0,127,255}));
  connect(splRet2.port_2, splRet3.port_1)
    annotation (Line(points={{-110,20},{-60,20},{-10,20}}, color={0,127,255}));
  connect(larOff2.port_b, splRet3.port_3)
    annotation (Line(points={{-20.1429,80},{0,80},{0,30}}, color={0,127,255}));
  connect(pip2.port_b, splSup5.port_1) annotation (Line(points={{160,140},{175,140},
          {190,140}}, color={0,127,255}));
  connect(splSup5.port_2, splSup6.port_1)
    annotation (Line(points={{210,140},{330,140}}, color={0,127,255}));
  connect(splSup5.port_3, apa1.port_a) annotation (Line(points={{200,130},{200,130},
          {200,90},{200,80},{220,80}}, color={0,127,255}));
  connect(splSup6.port_3, larOff3.port_a) annotation (Line(points={{340,130},{340,
          130},{340,82},{340,80},{360,80}}, color={0,127,255}));
  connect(splSup6.port_2,larOff4. port_a) annotation (Line(points={{350,140},{408,
          140},{480,140},{480,80},{500,80}}, color={0,127,255}));
  connect(pip3.port_a, splRet5.port_1)
    annotation (Line(points={{160,20},{270,20}}, color={0,127,255}));
  connect(splRet5.port_2, splRet6.port_1)
    annotation (Line(points={{290,20},{410,20}}, color={0,127,255}));
  connect(apa1.port_b, splRet5.port_3) annotation (Line(points={{259.857,80},{
          259.857,80},{280,80},{280,30}},
                                  color={0,127,255}));
  connect(larOff3.port_b, splRet6.port_3) annotation (Line(points={{399.857,80},
          {420,80},{420,30}}, color={0,127,255}));
  connect(splRet6.port_2,larOff4. port_b) annotation (Line(points={{430,20},{
          482,20},{560,20},{560,80},{539.857,80}},
                                               color={0,127,255}));
  connect(splSup3.port_2, splSup4.port_1)
    annotation (Line(points={{-70,140},{50,140},{50,140}}, color={0,127,255}));
  connect(splSup4.port_2, pip2.port_a) annotation (Line(points={{70,140},{140,140},
          {140,140}}, color={0,127,255}));
  connect(splSup4.port_3, pip4.port_a) annotation (Line(points={{60,130},{60,130},
          {60,-26},{60,-80},{140,-80}}, color={0,127,255}));
  connect(splRet3.port_2, splRet4.port_1)
    annotation (Line(points={{10,20},{90,20}}, color={0,127,255}));
  connect(splRet4.port_2, pip3.port_b)
    annotation (Line(points={{110,20},{110,20},{140,20}}, color={0,127,255}));
  connect(splRet4.port_3, pip5.port_b) annotation (Line(points={{100,10},{100,10},
          {100,-200},{140,-200}}, color={0,127,255}));
  connect(pip4.port_b, splSup7.port_1) annotation (Line(points={{160,-80},{170,-80},
          {170,-80},{180,-80}}, color={0,127,255}));
  connect(splSup7.port_3, apa2.port_a) annotation (Line(points={{190,-90},{190,-90},
          {190,-140},{220,-140}}, color={0,127,255}));
  connect(apa2.port_b, splRet7.port_3) annotation (Line(points={{259.857,-140},
          {280,-140},{280,-190}},color={0,127,255}));
  connect(splSup7.port_2, ret2.port_a) annotation (Line(points={{200,-80},{252,-80},
          {340,-80},{340,-140},{360,-140}}, color={0,127,255}));
  connect(pip5.port_a, splRet7.port_1) annotation (Line(points={{160,-200},{216,
          -200},{270,-200}}, color={0,127,255}));
  connect(splRet7.port_2, ret2.port_b) annotation (Line(points={{290,-200},{342,
          -200},{420,-200},{420,-140},{399.857,-140}}, color={0,127,255}));
  connect(pip.port_b, splSup1.port_1)
    annotation (Line(points={{-340,140},{-330,140}}, color={0,127,255}));
  connect(pip1.port_a, splRet1.port_1)
    annotation (Line(points={{-340,20},{-250,20}}, color={0,127,255}));
  connect(pla.TSetHea, TSetH.y) annotation (Line(points={{-512,118},{-512,118},
          {-530,118},{-530,200},{-539,200}},           color={0,0,127}));
  connect(TSetC.y, pla.TSetCoo) annotation (Line(points={{-539,170},{-534,170},
          {-534,114},{-512,114}},color={0,0,127}));
  connect(bayWatHex.TSetHea, TSetH.y) annotation (Line(points={{-402,45.3},{
          -470,45.3},{-470,200},{-539,200}},
                                      color={0,0,127}));
  connect(TSetC.y,bayWatHex. TSetCoo) annotation (Line(points={{-539,170},{-476,
          170},{-476,96},{-476,96},{-476,41.1},{-402,41.1}},
                                            color={0,0,127}));
  connect(bayWatHex.port_b1, pip.port_a) annotation (Line(points={{-380,34.8},{-370,
          34.8},{-370,36},{-370,36},{-370,140},{-360,140}},          color={0,
          127,255}));
  connect(bayWatHex.port_a2, pip1.port_b) annotation (Line(points={{-380,22.2},{
          -370,22.2},{-370,20},{-360,20}},              color={0,127,255}));
  connect(bayWatHex.port_b2, pla.port_a) annotation (Line(points={{-400,22.2},{-488,
          22.2},{-488,82},{-540,82},{-540,110},{-510,110}},          color={0,
          127,255}));
  connect(pla.port_b, bayWatHex.port_a1) annotation (Line(points={{-490,110},{-490,
          110},{-480,110},{-480,34.8},{-400,34.8}},            color={0,127,255}));
  connect(pSet.ports[1], pla.port_a) annotation (Line(points={{-552,110},{-552,
          110},{-510,110}}, color={0,127,255}));
  connect(pla.TSink, weaBus.TDryBul) annotation (Line(points={{-512,104},{-520,
          104},{-520,160},{-340,160},{-340,190}}, color={0,0,127}));

//////

////

  connect(pla.PComHea, PHea.u[17]) annotation (Line(points={{-489,119},{-486,
          119},{-486,370},{604,370}}, color={0,0,127}));
  connect(pla.PComCoo, PCoo.u[9]) annotation (Line(points={{-489,117},{-484,117},
          {-484,330},{604,330}}, color={0,0,127}));
  connect(bayWatHex.TSouWat, watTem.y[1]) annotation (Line(points={{-402,57.9},
          {-422,57.9},{-422,58},{-439,58}},                    color={0,0,127}));
  connect(bayWatHex.TSouHea, weaBus.TDryBul) annotation (Line(points={{-402,
          53.7},{-410,53.7},{-410,58},{-410,160},{-340,160},{-340,190}}, color=
          {0,0,127}));
  connect(bayWatHex.TSouCoo, weaBus.TDryBul) annotation (Line(points={{-402,
          49.5},{-410,49.5},{-410,50},{-410,50},{-410,160},{-340,160},{-340,190}},
        color={0,0,127}));
  annotation(experiment(Tolerance=1E-06, StopTime=31536000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/DistrictHeatingCooling/Examples/HeatingCoolingHotWater3Clusters.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates a small ideal bi-directional heating and cooling network.
The heating and cooling heat flow rates extracted from the district supply
are prescribed by time series.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 20, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-580,-260},{780,
            400}})));
end HeatingCoolingHotWater3Clusters;
