within Buildings.Templates.BaseClasses.ChilledWaterPlant;
model PartialCondenserWaterLoop
  replaceable package MediumCW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Condenser water medium";

  inner replaceable Buildings.Templates.BaseClasses.CoolingTowerGroup.CoolingTowerParallel cooTow
    constrainedby Buildings.Templates.Interfaces.CoolingTowerGroup(
      redeclare final package Medium = MediumCW)
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None pumCon
    constrainedby Buildings.Templates.Interfaces.Pump(
      redeclare final package Medium = MediumCW)
    annotation (Placement(transformation(extent={{-150,-20},{-130,0}})));
  Fluid.FixedResistances.Junction splCWSup(
    redeclare final package Medium = MediumCW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Condenser water supply splitter"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Fluid.FixedResistances.Junction splCWRet(
    redeclare final package Medium = MediumCW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Condenser water return mixer"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-80}})));

  Sensors.Temperature              TCWSup(
      redeclare final package Medium = MediumCW)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Sensors.Temperature TCWRet(redeclare final package Medium = MediumCW)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
equation
  connect(cooTow.port_b,pumCon. port_a)
    annotation (Line(points={{-160,-10},{-150,-10}},
      color={0,127,255}));
  connect(pumCon.port_b, TCWSup.port_a)
    annotation (Line(points={{-130,-10},{-120,-10}}, color={0,127,255}));
  connect(TCWSup.port_b,splCWSup. port_1)
    annotation (Line(points={{-100,-10},{-90,-10}},color={0,127,255}));
  connect(splCWSup.port_3,splCWRet. port_3)
    annotation (Line(points={{-80,-20},{-80,-60}}, color={0,127,255}));
  connect(TCWRet.port_b, splCWRet.port_1)
    annotation (Line(points={{-120,-70},{-90,-70}}, color={0,127,255}));
  connect(TCWRet.port_a, cooTow.port_a) annotation (Line(points={{-140,-70},{
          -192,-70},{-192,-10},{-180,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-100},{-60,20}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-200,-100},{-60,20}})));
end PartialCondenserWaterLoop;
