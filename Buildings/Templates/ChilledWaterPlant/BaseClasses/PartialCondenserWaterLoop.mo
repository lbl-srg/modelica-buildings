within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model PartialCondenserWaterLoop
  replaceable package MediumCW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Condenser water medium";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
    cooTow constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.CoolingTowerGroup(
      redeclare final package Medium = MediumCW)
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Headered
    pumCon constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.CondenserWaterPumpGroup
    "Condenser water pump group"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Templates.Components.Sensors.Temperature              TCWSup(
      redeclare final package Medium = MediumCW)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Templates.Components.Sensors.Temperature TCWRet(redeclare final
      package Medium =                                                                       MediumCW)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Fluid.FixedResistances.Junction mixCW(redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Condenser water return mixer" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-90,-70})));
equation
  connect(TCWRet.port_a, cooTow.port_a) annotation (Line(points={{-140,-70},{
          -192,-70},{-192,-10},{-180,-10}}, color={0,127,255}));
  connect(cooTow.port_b, TCWSup.port_a)
    annotation (Line(points={{-160,-10},{-140,-10}}, color={0,127,255}));
  connect(TCWSup.port_b,pumCon. port_a)
    annotation (Line(points={{-120,-10},{-100,-10}}, color={0,127,255}));
  connect(TCWRet.port_b, mixCW.port_1)
    annotation (Line(points={{-120,-70},{-100,-70}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-100},{-60,20}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-200,-100},{-60,20}})));
end PartialCondenserWaterLoop;
