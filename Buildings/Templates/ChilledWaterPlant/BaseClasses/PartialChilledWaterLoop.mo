within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model PartialChilledWaterLoop
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.ChilledWaterPlant(
    redeclare final package Medium=MediumCHW);

  replaceable package MediumCHW=Buildings.Media.Water "Chilled water medium";

  parameter Boolean has_byp = false "Chilled water loop has bypass"
    annotation(Dialog(enable=not pumSec.is_none));
  parameter Boolean has_WSEByp = false "Waterside economizer has a bypass to supply chilled water"
    annotation(Dialog(enable=not WSE.is_none));

  parameter Integer nPumPri = nChi "Number of primary pumps"
    annotation(Dialog(enable=not pumPri.is_dedicated));
  parameter Integer nPumSec "Number of secondary pumps"
    annotation(Dialog(enable=not pumSec.is_none));

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
    chiGro constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.ChillerGroup(
     redeclare final package MediumCHW = MediumCHW,
     final nChi=nChi,
     final is_airCoo=is_airCoo)
    "Chiller group"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=90,origin={-40,10})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.NoEconomizer
    WSE(final is_airCoo = is_airCoo) constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.ChilledWaterReturnSection(
      redeclare final package Medium2 = MediumCHW)
    "Chilled water return section"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=90,origin={-40,-72})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Headered
    pumPri constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.PrimaryPumpGroup(
      redeclare final package Medium = MediumCHW,
      final nChi=nChi,
      final nPum=nPumPri,
      final has_ParChi=chiGro.typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel,
      final has_byp=has_byp)
    "Chilled water primary pump group"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.None
    pumSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.SecondaryPumpGroup(
      redeclare final package Medium = MediumCHW,
      final nPum=nPumSec)
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
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=0,origin={30,-50})));
  Fluid.FixedResistances.Junction mixByp(
    redeclare package Medium = MediumCHW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Bypass mixer"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},rotation=0,origin={-10,-50})));
  Fluid.FixedResistances.Junction splWSEByp(
    redeclare package Medium = MediumCHW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Splitter for waterside economizer bypass"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},rotation=0,origin={-20,-20})));

  inner replaceable
    Components.Controls.OpenLoop
    con(final nChi=nChi,
    final nPumPri=nPumPri,
    final nPumSec=nPumSec,
    final is_airCoo=is_airCoo)
        constrainedby Components.Controls.OpenLoop
      annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,60})));
equation
  connect(TCHWRet.port_a,WSE. port_a2)
    annotation (Line(points={{140,-70},{-24,-70},{-24,-86},{-34,-86},{-34,-82}},
      color={0,127,255}));
  connect(dpCHW.port_bRef, TCHWRet.port_b)
    annotation (Line(points={{180,0},{180,-70},{160,-70}}, color={0,127,255}));
  connect(WSE.port_b2,mixByp. port_2)
    annotation (Line(points={{-34,-62},{-34,-50},{-20,-50}},color={0,127,255}));
  connect(TCHWSup.port_b, dpCHW.port_a)
    annotation (Line(points={{140,10},{170,10}}, color={0,127,255}));
  connect(mixByp.port_1, TCHWRetByp.port_a)
    annotation (Line(points={{0,-50},{20,-50}}, color={0,127,255}));
  connect(chiGro.ports_b2, pumPri.ports_parallel)
    annotation (Line(points={{-30,16},{-20,16},{-20,10},{-8.88178e-16,10}},
      color={0,127,255}));
  connect(chiGro.port_b2, pumPri.port_series)
    annotation (Line(points={{-34,20},{-34,30},{-10,30},{-10,16},{0,16}},
      color={0,127,255}));
  connect(splWSEByp.port_2, chiGro.port_a2)
    annotation (Line(points={{-30,-20},{-34,-20},{-34,0}}, color={0,127,255}));
  connect(splWSEByp.port_3,pumPri. port_WSEByp)
    annotation (Line(points={{-20,-10},{-20,4},{0,4}}, color={0,127,255}));
  connect(pumPri.port_b, pumSec.port_a)
    annotation (Line(points={{20,10},{60,10}}, color={0,127,255}));
  connect(pumSec.port_b, TCHWSup.port_a)
    annotation (Line(points={{80,10},{120,10}}, color={0,127,255}));
  connect(TCHWRetByp.port_b, splWSEByp.port_1)
    annotation (Line(points={{40,-50},{60,-50},{60,-20},{-10,-20}},
    color={0,127,255}));
  connect(mixByp.port_3, pumPri.port_byp)
    annotation (Line(points={{-10,-40},{-10,-34},{10,-34},{10,0}},
    color={0,127,255}));
  connect(dpCHW.port_b, port_a)
    annotation (Line(points={{190,10},{200,10}}, color={0,127,255}));
  connect(TCHWRet.port_b, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));

  connect(TCHWRetByp.y, chwCon.TRetByp);
  connect(TCHWSup.y, chwCon.TSup);
  connect(TCHWRet.y, chwCon.TRet);
  connect(dpCHW.y, chwCon.dp);
  connect(pumPri.busCon, chwCon.pumPri);
  connect(chiGro.busCon, chwCon.chiGro);
  connect(WSE.busCon, chwCon.wse);
  connect(pumSec.busCon, chwCon.pumSec);
  connect(con.busCW, cwCon) annotation (Line(
      points={{60,60},{-200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.busCHW, chwCon) annotation (Line(
      points={{80,60},{200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
end PartialChilledWaterLoop;
