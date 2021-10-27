within Buildings.Templates.BaseClasses.ChilledWaterPlant;
model PartialChilledWaterLoop
  replaceable package MediumCHW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Chilled water medium";

  parameter Boolean has_secPum=pumSec.typ   <> Buildings.Templates.Types.Pump.None
    "Chilled water loop has secondary pumping";
  parameter Boolean has_byp "Chilled water loop has bypass";
  parameter Boolean is_airCoo
    "= true, chillers in group are air cooled, 
    = false, chillers in group are water cooled";

  // TODO - fix syntax
//   parameter Boolean has_WSEByp = false
//     annotation(dialog(enable=wse.typ == Types.WatersideEconomizer));

  inner replaceable Buildings.Templates.BaseClasses.ChillerGroup.ChillerParallel chi
    constrainedby Buildings.Templates.Interfaces.ChillerGroup(
      redeclare final package Medium2 = MediumCHW,
      final is_airCoo=is_airCoo)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,10})));
  inner replaceable
    Buildings.Templates.BaseClasses.ChilledWaterReturnSection.NoEconomizer WSE
    constrainedby Buildings.Templates.Interfaces.ChilledWaterReturnSection(
      redeclare final package Medium = MediumCHW)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-72})));
  inner replaceable ChilledWaterPumpGroup.HeaderedPrimary pumGro
    constrainedby Buildings.Templates.Interfaces.ChilledWaterPumpGroup(
      redeclare final package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Fluid.FixedResistances.Junction mixByp(redeclare package Medium = MediumCHW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Common leg or bypass mixer" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-34,-44})));

  Sensors.Temperature TCHWRet(
      redeclare final package Medium = MediumCHW)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Sensors.DifferentialPressure dpCHW(redeclare final package Medium = MediumCHW)
    "Chilled water demand side differential pressure"
    annotation (Placement(transformation(extent={{170,0},{190,20}})));
  Sensors.Temperature TCHWSup(redeclare final package Medium = MediumCHW)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Sensors.Temperature temperature annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-34,-16})));
equation
  connect(TCHWRet.port_a,WSE. port_a2)
    annotation (Line(points={{140,-70},{-24,-70},{-24,-86},{-34,-86},{-34,-82}},
      color={0,127,255}));
  connect(dpCHW.port_bRef, TCHWRet.port_b) annotation (Line(points={{180,0},{
          180,-70},{160,-70}}, color={0,127,255}));
  connect(WSE.port_b2,mixByp. port_2)
    annotation (Line(points={{-34,-62},{-34,-54}},
                                                 color={0,127,255}));
  connect(headeredPrimary.port_byp, mixByp.port_3)
    annotation (Line(points={{10,0},{10,-44},{-24,-44}}, color={0,127,255}));
  connect(pumGro.port_b, TCHWSup.port_a)
    annotation (Line(points={{20,10},{120,10}}, color={0,127,255}));
  connect(TCHWSup.port_b, dpCHW.port_a)
    annotation (Line(points={{140,10},{170,10}}, color={0,127,255}));
  connect(mixByp.port_1, temperature.port_a)
    annotation (Line(points={{-34,-34},{-34,-26}}, color={0,127,255}));
  connect(temperature.port_b, chi.port_a2)
    annotation (Line(points={{-34,-6},{-34,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-60,-100},{200,40}})),
    Diagram(
      coordinateSystem(preserveAspectRatio=false,
      extent={{-60,-100},{200,40}})));
end PartialChilledWaterLoop;
