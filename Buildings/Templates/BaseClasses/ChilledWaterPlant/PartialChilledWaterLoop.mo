within Buildings.Templates.BaseClasses.ChilledWaterPlant;
model PartialChilledWaterLoop
  replaceable package MediumCHW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Chilled water medium";

  parameter Boolean has_comLeg "Chilled water loop has common leg";
  parameter Boolean is_airCoo
    "= true, chillers in group are air cooled, 
    = false, chillers in group are water cooled";

  inner replaceable Buildings.Templates.BaseClasses.ChillerGroup.ChillerParallel chi
    constrainedby Buildings.Templates.Interfaces.ChillerGroup(
      redeclare final package Medium2 = MediumCHW,
      final is_airCoo=is_airCoo)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-2,-10})));
  inner replaceable
    Buildings.Templates.BaseClasses.ChilledWaterReturnSection.NoEconomizer wse
    constrainedby Buildings.Templates.Interfaces.ChilledWaterReturnSection(
      redeclare final package Medium = MediumCHW)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-2,-70})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None priPum
    constrainedby Buildings.Templates.Interfaces.Pump(
      redeclare final package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None secPum
    constrainedby Buildings.Templates.Interfaces.Pump(
      redeclare final package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  inner replaceable Buildings.Templates.BaseClasses.Valve.None comLeg if has_comLeg
    constrainedby Buildings.Templates.Interfaces.Valve(
      redeclare final package Medium = MediumCHW)
    "Common leg valve or passthrough"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Fluid.FixedResistances.Junction comLegMix(
      redeclare package Medium = MediumCHW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Common leg mixer"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={4,-40})));
  Fluid.FixedResistances.Junction comLegSpl(
      redeclare package Medium = MediumCHW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Common leg splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-10})));

  Fluid.Sensors.TemperatureTwoPort TCHWRet(
      redeclare final package Medium = MediumCHW)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
equation
  connect(priPum.port_b,comLegSpl. port_1)
    annotation (Line(points={{100,-10},{120,-10}},color={0,127,255}));
  connect(comLegSpl.port_2, secPum.port_a)
    annotation (Line(points={{140,-10},{160,-10}}, color={0,127,255}));
  connect(comLeg.port_b,comLegSpl. port_3)
    annotation (Line(points={{60,-40},{130,-40},{130,-20}},
      color={0,127,255}));
  connect(comLegMix.port_3, comLeg.port_a)
    annotation (Line(points={{14,-40},{40,-40}}, color={0,127,255}));
  connect(wse.port_b2, comLegMix.port_2)
    annotation (Line(points={{4,-60},{4,-50}}, color={0,127,255}));
  connect(TCHWRet.port_a, wse.port_a2)
    annotation (Line(points={{140,-70},{14,-70},{14,-84},{4,-84},{4,-80}},
      color={0,127,255}));
  connect(chi.port_a2, comLegMix.port_1)
    annotation (Line(points={{4,-20},{4,-30}}, color={0,127,255}));
  connect(chi.port_b2, priPum.port_a) annotation (Line(points={{4,0},{4,10},{60,
          10},{60,-10},{80,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-40,-100},{200,20}})),
    Diagram(
      coordinateSystem(preserveAspectRatio=false,
      extent={{-40,-100},{200,20}})));
end PartialChilledWaterLoop;
