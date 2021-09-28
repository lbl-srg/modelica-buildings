within Buildings.Templates.ChilledWaterPlant;
model ChilledWaterPlant
  extends Buildings.Templates.Interfaces.ChilledWaterPlant(
    final typ=Buildings.Templates.Types.ChilledWaterPlant.WaterCooledChiller);

  parameter Boolean has_priPum "Chilled water loop has primary pumping";
  parameter Boolean has_secPum "Chilled water loop has secondary pumping";
  parameter Boolean has_comLeg "Chilled water loop has common leg";

  inner replaceable Buildings.Templates.BaseClasses.CoolingTowerGroup.CoolingTowerParallel cooTow
    constrainedby Buildings.Templates.Interfaces.CoolingTowerGroup
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None conPum
    constrainedby Buildings.Templates.Interfaces.Pump
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  inner replaceable Buildings.Templates.BaseClasses.ChillerGroup.ChillerParallel chi
    constrainedby Buildings.Templates.Interfaces.ChillerGroup
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={30,-10})));
  inner replaceable
    Buildings.Templates.BaseClasses.ChilledWaterReturnSection.NoEconomizer wse
    constrainedby Buildings.Templates.Interfaces.ChilledWaterReturnSection
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={30,-70})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None priPum if has_priPum
    constrainedby Buildings.Templates.Interfaces.Pump
    annotation (Placement(transformation(extent={{88,-20},{108,0}})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None secPum if has_secPum
    constrainedby Buildings.Templates.Interfaces.Pump
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  inner replaceable Buildings.Templates.BaseClasses.Valve.None comLeg if has_comLeg
    constrainedby Buildings.Templates.Interfaces.Valve
    "Common leg valve or passthrough"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Fluid.FixedResistances.Junction cwSupSpl(redeclare package Medium = MediumCW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Condenser water supply splitter"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Fluid.FixedResistances.Junction cwRetSpl(redeclare package Medium = MediumCW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Condenser water return mixer"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-80}})));
  Fluid.FixedResistances.Junction comLegMix(redeclare package Medium = MediumCHW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Common leg mixer"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={36,-40})));
  Fluid.FixedResistances.Junction comLegSpl(redeclare package Medium = MediumCHW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Common leg splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-10})));

  Fluid.Sensors.TemperatureTwoPort TCHWRet(
      redeclare final package Medium = MediumCHW)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Fluid.Sensors.TemperatureTwoPort TCWSup(
      redeclare final package Medium = MediumCW)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,80},{20,120}}),
      iconTransformation(extent={{-20,182},{20,218}})));
equation
  connect(cooTow.port_b, conPum.port_a)
    annotation (Line(points={{-160,-10},{-140,-10}},
                                                   color={0,127,255}));
  connect(chi.port_b2, priPum.port_a) annotation (Line(points={{36,0},{36,10},{
          60,10},{60,-10},{88,-10}},color={0,127,255}));
  connect(secPum.port_b, port_a) annotation (Line(points={{180,-10},{200,-10}},
                               color={0,127,255}));
  connect(chwCon, chi.busCon) annotation (Line(
      points={{200,40},{8,40},{8,-10},{20,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chwCon, priPum.busCon) annotation (Line(
      points={{200,40},{170,40},{170,6},{98,6},{98,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chwCon, secPum.busCon) annotation (Line(
      points={{200,40},{170,40},{170,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(wse.busCon, chwCon) annotation (Line(
      points={{20,-70},{8,-70},{8,40},{200,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(cwSupSpl.port_2, chi.port_a1) annotation (Line(points={{-40,-10},{-20,
          -10},{-20,10},{24,10},{24,0}},
                                   color={0,127,255}));
  connect(cooTow.port_a, cwRetSpl.port_1) annotation (Line(points={{-180,-10},{-186,
          -10},{-186,-70},{-60,-70}},    color={0,127,255}));
  connect(chi.port_b1, cwRetSpl.port_3) annotation (Line(points={{24,-20},{24,
          -30},{-20,-30},{-20,-50},{-50,-50},{-50,-60}},     color={0,127,255}));
  connect(cooTow.busCon, cwCon) annotation (Line(
      points={{-170,0},{-170,40},{-200,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conPum.busCon, cwCon) annotation (Line(
      points={{-130,0},{-130,40},{-200,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(priPum.port_b,comLegSpl. port_1)
    annotation (Line(points={{108,-10},{120,-10}},color={0,127,255}));
  connect(comLegSpl.port_2, secPum.port_a)
    annotation (Line(points={{140,-10},{160,-10}}, color={0,127,255}));
  connect(comLeg.port_b,comLegSpl. port_3) annotation (Line(points={{80,-50},{
          130,-50},{130,-20}}, color={0,127,255}));
  connect(comLegMix.port_1, chi.port_a2)
    annotation (Line(points={{36,-30},{36,-20}}, color={0,127,255}));
  connect(comLegMix.port_3, comLeg.port_a)
    annotation (Line(points={{46,-40},{52,-40},{52,-50},{60,-50}},
                                                 color={0,127,255}));
  connect(comLeg.busCon, chwCon.comLeg) annotation (Line(
      points={{70,-40},{70,40},{200,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(wse.port_b2, comLegMix.port_2)
    annotation (Line(points={{36,-60},{36,-50}}, color={0,127,255}));
  connect(cwRetSpl.port_2, wse.port_b1) annotation (Line(points={{-40,-70},{-20,
          -70},{-20,-92},{24,-92},{24,-80}}, color={0,127,255}));
  connect(cwSupSpl.port_3, wse.port_a1) annotation (Line(points={{-50,-20},{-50,
          -40},{24,-40},{24,-60}}, color={0,127,255}));
  connect(TCHWRet.port_b, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));
  connect(TCHWRet.port_a, wse.port_a2) annotation (Line(points={{140,-70},{60,
          -70},{60,-92},{36,-92},{36,-80}}, color={0,127,255}));
  connect(TCHWRet.T, chwCon.inp.TCHWRet) annotation (Line(points={{150,-59},{150,
          40.1},{200.1,40.1}},
                             color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conPum.port_b, TCWSup.port_a)
    annotation (Line(points={{-120,-10},{-100,-10}}, color={0,127,255}));
  connect(TCWSup.port_b, cwSupSpl.port_1)
    annotation (Line(points={{-80,-10},{-60,-10}}, color={0,127,255}));
  connect(weaBus, cooTow.weaBus) annotation (Line(
      points={{0,100},{0,80},{-165,80},{-165,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end ChilledWaterPlant;
