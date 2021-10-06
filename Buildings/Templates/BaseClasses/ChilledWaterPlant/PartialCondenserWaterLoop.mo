within Buildings.Templates.BaseClasses.ChilledWaterPlant;
model PartialCondenserWaterLoop
  replaceable package MediumCW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Condenser water medium";

  inner replaceable Buildings.Templates.BaseClasses.CoolingTowerGroup.CoolingTowerParallel cooTow
    constrainedby Buildings.Templates.Interfaces.CoolingTowerGroup(
      redeclare final package Medium = MediumCW)
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None conPum
    constrainedby Buildings.Templates.Interfaces.Pump(
      redeclare final package Medium = MediumCW)
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Fluid.FixedResistances.Junction cwSupSpl(
    redeclare final package Medium = MediumCW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Condenser water supply splitter"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Fluid.FixedResistances.Junction cwRetSpl(
    redeclare final package Medium = MediumCW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Condenser water return mixer"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-80}})));

  Fluid.Sensors.TemperatureTwoPort TCWSup(
      redeclare final package Medium = MediumCW)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(cooTow.port_b, conPum.port_a)
    annotation (Line(points={{-160,-10},{-140,-10}},
      color={0,127,255}));
  connect(cooTow.port_a, cwRetSpl.port_1)
    annotation (Line(points={{-180,-10},{-186,-10},{-186,-70},{-60,-70}},
      color={0,127,255}));
  connect(conPum.port_b, TCWSup.port_a)
    annotation (Line(points={{-120,-10},{-100,-10}}, color={0,127,255}));
  connect(TCWSup.port_b, cwSupSpl.port_1)
    annotation (Line(points={{-80,-10},{-60,-10}}, color={0,127,255}));
  connect(cwSupSpl.port_3, cwRetSpl.port_3)
    annotation (Line(points={{-50,-20},{-50,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-100},{0,20}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-200,-100},{0,20}})));
end PartialCondenserWaterLoop;
