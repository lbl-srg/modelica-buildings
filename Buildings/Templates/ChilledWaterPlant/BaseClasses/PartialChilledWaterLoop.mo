within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model PartialChilledWaterLoop
  replaceable package MediumCHW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Chilled water medium";

  parameter Boolean is_airCoo
    "= true, chillers in group are air cooled, 
    = false, chillers in group are water cooled";
  parameter Boolean has_byp = false "Chilled water loop has bypass"
    annotation(Dialog(enable=not secPum.is_none));
  parameter Boolean has_WSEByp = false "Waterside economizer has a bypass to supply chilled water"
    annotation(Dialog(enable=not wse.is_none));

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
    chi constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.ChillerGroup(
      redeclare final package Medium2 = MediumCHW,
      final is_airCoo=is_airCoo)
      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,10})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.NoEconomizer
    WSE constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.ChilledWaterReturnSection(
      redeclare final package Medium = MediumCHW) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-72})));
  inner replaceable Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Headered pumPri constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.PrimaryPumpGroup(
    redeclare final package Medium = MediumCHW,
    final has_parChi=chi.typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel,
    final has_byp=has_byp) "Chilled water primary pump group"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  inner replaceable Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.None pumSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.SecondaryPumpGroup(
    redeclare final package Medium = MediumCHW)
    "Chilled water secondary pump group"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Templates.Components.Sensors.Temperature TCHWRet(
      redeclare final package Medium = MediumCHW,
      final have_sen=true)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpCHW(
    redeclare final package Medium = MediumCHW,
    final have_sen=true)
    "Chilled water demand side differential pressure"
    annotation (Placement(transformation(extent={{170,0},{190,20}})));
  Buildings.Templates.Components.Sensors.Temperature TCHWSup(
    redeclare final package Medium = MediumCHW,
    final have_sen=true)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Templates.Components.Sensors.Temperature TCHWRetByp(
    redeclare final package Medium = MediumCHW,
    final have_sen = has_byp)
    "Chilled water return temperature after bypass"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-50})));

  Fluid.FixedResistances.Junction mixByp(
    redeclare package Medium = MediumCHW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Bypass mixer"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-10,-50})));
  Fluid.FixedResistances.Junction splWSEByp(
    redeclare package Medium = MediumCHW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Splitter for waterside economizer bypass"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-20,-20})));

equation
  connect(TCHWRet.port_a,WSE. port_a2)
    annotation (Line(points={{140,-70},{-24,-70},{-24,-86},{-34,-86},{-34,-82}},
      color={0,127,255}));
  connect(dpCHW.port_bRef, TCHWRet.port_b)
    annotation (Line(points={{180,0},{180,-70},{160,-70}}, color={0,127,255}));
  connect(WSE.port_b2,mixByp. port_2)
    annotation (Line(points={{-34,-62},{-34,-50},{-20,-50}},color={0,127,255}));
  connect(headeredPrimary.port_byp, mixByp.port_3)
    annotation (Line(points={{0,0},{10,0},{10,-30},{-10,-30},{-10,-40}},color={0,127,255}));
  connect(TCHWSup.port_b, dpCHW.port_a)
    annotation (Line(points={{140,10},{170,10}}, color={0,127,255}));
  connect(mixByp.port_1, TCHWRetByp.port_a)
    annotation (Line(points={{0,-50},{20,-50}}, color={0,127,255}));
  connect(chi.ports_b2,pumPri. ports_parallel)
    annotation (Line(points={{-30,16},{-20,16},{-20,10},{-8.88178e-16,10}},
      color={0,127,255}));
  connect(chi.port_b2,pumPri. port_series) annotation (Line(points={{-34,20},{-34,
          30},{-10,30},{-10,16},{0,16}}, color={0,127,255}));
  connect(splWSEByp.port_2, chi.port_a2)
    annotation (Line(points={{-30,-20},{-34,-20},{-34,0}}, color={0,127,255}));
  connect(splWSEByp.port_3,pumPri. port_WSEByp)
    annotation (Line(points={{-20,-10},{-20,4},{0,4}}, color={0,127,255}));
  connect(pumPri.port_b, pumSec.port_a)
    annotation (Line(points={{20,10},{60,10}}, color={0,127,255}));
  connect(pumSec.port_b, TCHWSup.port_a)
    annotation (Line(points={{80,10},{120,10}}, color={0,127,255}));
  connect(TCHWRetByp.port_b, splWSEByp.port_1) annotation (Line(points={{40,-50},
          {60,-50},{60,-20},{-10,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-60,-100},{200,40}})),
    Diagram(
      coordinateSystem(preserveAspectRatio=false,
      extent={{-60,-100},{200,40}})));
end PartialChilledWaterLoop;
