within Buildings.Templates.AHUs;
model VAVSingleDuct "VAV single duct with relief"
  extends Interfaces.Main(
    final typ=Types.Main.SupplyReturn,
    final typSup=Types.Supply.SingleDuct,
    final typRet=Types.Return.WithRelief);

  final parameter Types.Economizer typEco = eco.typ
    "Type of economizer"
    annotation (Evaluate=true,
      Dialog(group="Economizer"));
  final parameter Types.Coil typCoiCoo = coiCoo.typ
    "Type of cooling coil"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final parameter Types.Coil typHexCoiCoo = coiCoo.typHex
    "Type of cooling coil heat exchanger"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final parameter Types.Actuator typActCoiCoo = coiCoo.typAct
    "Type of cooling coil actuator"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final parameter Types.Fan typFanSup = if fanSupDra.typ<>Types.Fan.None then
    fanSupDra.typ else fanSupBlo.typ
    "Type of supply fan"
    annotation (Evaluate=true,
      Dialog(group="Supply fan"));
  final parameter Boolean have_souCoiCoo = coiCoo.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  parameter Boolean have_draThr = true
    "Set to true for a draw-through fan, false for a blow-through fan"
    annotation (Evaluate=true, Dialog(group="Supply fan"));

  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
    redeclare package Medium = MediumAir) if
    typEco==Types.Economizer.DedicatedDamperTandem
    "Minimum outdoor air intake"
    annotation (
      Placement(transformation(extent={{-310,
      -150},{-290,-130}}), iconTransformation(extent={{-210,-10},{-190,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
    redeclare package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil return port"
    annotation (Placement(
      transformation(extent={{10,-290},{30,-270}}),
      iconTransformation(extent={{10,-210},{30,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
    redeclare package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil supply port"
    annotation (Placement(
        transformation(extent={{-30,-290},{-10,-270}}), iconTransformation(
          extent={{-30,-210},{-10,-190}})));

  BoundaryConditions.WeatherData.Bus weaBus if
    coiCoo.typ == Types.Coil.DirectExpansion
    annotation (Placement(transformation(extent={{-20,240},{20,280}}),
      iconTransformation(extent={{-20,182},{20,218}})));

  replaceable Coils.None coiHea1
    constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Heating coil - Option 1: Preheat coil in OA branch"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Heating coil 1"),
      Placement(transformation(extent={{-278,-210},{-258,-190}})));
  replaceable Sensors.None senTemHea1
    constrainedby Interfaces.Sensor(
      redeclare final package Medium = MediumAir,
      final bra=Types.Branch.Supply)
    "Heating coil 1 leaving air temperature"
    annotation (
      choices(
        choice(redeclare Sensors.None senTemHea1
          "No sensor"),
        choice(redeclare Sensors.Temperature senTemHea1
          "Temperature sensor")),
      Dialog(group="Heating coil 1", enable=coiHea1<>Types.Coil.None),
      Placement(transformation(extent={{-250,-210},{-230,-190}})));

  replaceable Economizers.None eco
    constrainedby Interfaces.Economizer(
      redeclare final package Medium = MediumAir)
    "Economizer"
    annotation (
      choices(
        choice(redeclare Economizers.None eco
          "No economizer"),
        choice(redeclare Economizers.CommonDamperTandem eco
          "Single common OA damper - Dampers actuated in tandem"),
        choice(redeclare Economizers.CommonDamperFree  eco
          "Single common OA damper - Dampers actuated individually"),
        choice(redeclare Economizers.DedicatedDamperTandem eco
          "Separate dedicated OA damper - Dampers actuated in tandem")),
      Dialog(group="Economizer"),
      __Linkage(
        choicesConditional(
          condition=typRet==Types.Return.NoRelief,
          choices(
            choice(redeclare Economizers.None eco
              "No economizer"),
            choice(redeclare Economizers.CommonDamperTandem eco
              "Single common OA damper - Dampers actuated in tandem"),
            choice(redeclare Economizers.CommonDamperFree  eco
              "Single common OA damper - Dampers actuated individually"),
            choice(redeclare Economizers.DedicatedDamperTandem eco
              "Separate dedicated OA damper - Dampers actuated in tandem")),
          condition=typRet==Types.Return.NoRelief,
          choices(
            choice(redeclare Economizers.None eco
              "No economizer"),
            choice(redeclare Economizers.CommonDamperFreeNoRelief eco
              "Single common OA damper - Dampers actuated individually, no relief")))),
      Placement(transformation(extent={{-210,-150},{-190,-130}})));
  replaceable Sensors.Temperature senTemMix
    constrainedby Interfaces.Sensor(
      redeclare final package Medium = MediumAir,
      final bra=Types.Branch.Supply)
    "Mixed air sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None senTemMix
          "No sensor"),
        choice(redeclare Sensors.Temperature senTemMix
          "Temperature sensor")),
      Dialog(group="Economizer", enable=eco.typ<>Types.Economizer.None),
      Placement(transformation(extent={{-170,-210},{-150,-190}})));

  replaceable Fans.None fanSupBlo
    constrainedby Interfaces.Fan(
      final bra=Types.Branch.Supply,
      redeclare final package MediumAir = MediumAir)
    "Supply fan - Blow through"
    annotation (
    choicesAllMatching=true,
    Dialog(
      group="Supply fan",
      enable=not have_draThr),
    Placement(transformation(extent={{-140,-210},{-120,-190}})));

  replaceable Coils.None coiHea2
    constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Heating coil - Option 2: preheat coil in SA branch"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Heating coil 2"),
      Placement(transformation(extent={{-110,-210},{-90,-190}})));
  replaceable Sensors.None senTemHea2
    constrainedby Interfaces.Sensor(
      redeclare final package Medium = MediumAir,
      final bra=Types.Branch.Supply)
    "Heating coil 2 leaving air temperature sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None senTemHea2
          "No sensor"),
        choice(redeclare Sensors.Temperature senTemHea2
          "Temperature sensor")),
      Dialog(group="Heating coil 2", enable=coiHea2<>Types.Coil.None),
      Placement(transformation(extent={{-80,-210},{-60,-190}})));

  replaceable Coils.None coiCoo
    constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Cooling coil"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Cooling coil"),
      Placement(transformation(extent={{-10,-210},{10,-190}})));
  replaceable Sensors.None senTemCoo
    constrainedby Interfaces.Sensor(
      redeclare final package Medium = MediumAir,
      final bra=Types.Branch.Supply)
    "Cooling coil leaving air temperature sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None senTemCoo
          "No sensor"),
        choice(redeclare Sensors.Temperature senTemCoo
          "Temperature sensor")),
      Dialog(group="Cooling coil", enable=coiCoo<>Types.Coil.None),
      Placement(transformation(extent={{20,-210},{40,-190}})));

  replaceable Coils.None coiHea3
    constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Heating coil - Option 3: reheat coil"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Heating coil 3"),
      Placement(transformation(extent={{50,-210},{70,-190}})));
  replaceable Sensors.None senTemHea3
    constrainedby Interfaces.Sensor(
      redeclare final package Medium = MediumAir,
      final bra=Types.Branch.Supply)
    "Heating coil 3 leaving air temperature sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None senTemHea3
          "No sensor"),
        choice(redeclare Sensors.Temperature senTemHea3
          "Temperature sensor")),
      Dialog(group="Heating coil 3", enable=coiHea3<>Types.Coil.None),
      Placement(transformation(extent={{80,-210},{100,-190}})));

  replaceable Fans.None fanSupDra
    constrainedby Interfaces.Fan(
      final bra=Types.Branch.Supply,
      redeclare final package MediumAir = MediumAir)
    "Supply fan - Draw through"
    annotation (
    choicesAllMatching=true,
    Dialog(
      group="Supply fan",
      enable=have_draThr),
    Placement(transformation(extent={{110,-210},{130,-190}})));

  replaceable Controls.Dummy conAhu
    constrainedby Interfaces.Controller(
      final typEco=typEco,
      final typCoiCoo=typCoiCoo,
      final typHexCoiCoo=typHexCoiCoo,
      final typActCoiCoo=typActCoiCoo,
      final typFanSup=typFanSup)
    annotation (
      choicesAllMatching=true,
      Dialog(group="Controller"),
      Placement(transformation(extent={{-60,90},{-40,110}})));

  // FIXME: Dummy default values fo testing purposes only.
  Fluid.FixedResistances.PressureDrop resRet(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{160,-90},{140,-70}})));
  Fluid.FixedResistances.PressureDrop resSup(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{140,-210},{160,-190}})));

  replaceable Sensors.None senTemSup
    constrainedby Interfaces.Sensor(
      redeclare final package Medium = MediumAir,
      final bra=Types.Branch.Supply)
    "Supply air temperature sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None senTemSup
          "No sensor"),
        choice(redeclare Sensors.Temperature senTemSup
          "Temperature sensor")),
      Dialog(group="Duct sensors"),
      Placement(transformation(extent={{170,-210},{190,-190}})));
  replaceable Sensors.None senHumSup
    constrainedby Interfaces.Sensor(
      redeclare final package Medium = MediumAir,
      final bra=Types.Branch.Supply)
    "Supply air humidity ratio sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None senHumSup
          "No sensor"),
        choice(redeclare Sensors.HumidityRatio senHumSup
          "Humidity ratio sensor")),
      Dialog(group="Duct sensors"),
      Placement(transformation(extent={{200,-210},{220,-190}})));
  replaceable Sensors.None senPreSta
    constrainedby Interfaces.Sensor(
      redeclare final package Medium = MediumAir,
      final bra=Types.Branch.Supply)
    "Duct static pressure sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None senPreSta
          "No sensor"),
        choice(redeclare Sensors.DifferentialPressure senPreSta
          "Differential pressure sensor")),
      Dialog(group="Duct sensors"),
      Placement(transformation(extent={{230,-210},{250,-190}})));
equation
  connect(port_OutMin, eco.port_OutMin)
    annotation (Line(points={{-300,-140},{-210,-140}}, color={0,127,255}));
  connect(port_Exh, eco.port_Exh) annotation (Line(points={{-300,-80},{-220,-80},
          {-220,-133},{-210,-133}}, color={0,127,255}));
  connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{-20,-280},
          {-20,-220},{-4,-220},{-4,-210}}, color={0,127,255}));
  connect(coiCoo.port_bSou, port_coiCooRet) annotation (Line(points={{4,-210},{4,
          -220},{20,-220},{20,-280}}, color={0,127,255}));

  connect(eco.port_Ret, resRet.port_b) annotation (Line(points={{-190,-132.8},{
          -180,-132.8},{-180,-80},{140,-80}},
                                         color={0,127,255}));
  connect(resRet.port_a, port_Ret)
    annotation (Line(points={{160,-80},{300,-80}}, color={0,127,255}));
  connect(ahuBus, eco.ahuBus) annotation (Line(
      points={{-300,0},{-200,0},{-200,-130}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, coiCoo.weaBus) annotation (Line(
      points={{0,260},{0,80},{6,80},{6,-190},{-6,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus, coiCoo.ahuBus) annotation (Line(
      points={{-300,0},{0,0},{0,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(fanSupDra.port_b, resSup.port_a)
    annotation (Line(points={{130,-200},{140,-200}}, color={0,127,255}));
  connect(ahuBus, fanSupBlo.ahuBus) annotation (Line(
      points={{-300,0},{-130,0},{-130,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus, fanSupDra.ahuBus) annotation (Line(
      points={{-300,0},{120,0},{120,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(conAhu.ahuBus, ahuBus) annotation (Line(
      points={{-60,100},{-280,100},{-280,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(conAhu.terBus, terBus) annotation (Line(
      points={{-40,100},{280,100},{280,0},{300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(fanSupBlo.port_b, coiHea2.port_a)
    annotation (Line(points={{-120,-200},{-110,-200}}, color={0,127,255}));
  connect(port_Out, coiHea1.port_a)
    annotation (Line(points={{-300,-200},{-278,-200}}, color={0,127,255}));
  connect(eco.port_Sup, senTemMix.port_a) annotation (Line(points={{-190,-147},
          {-180,-147},{-180,-200},{-170,-200}},
        color={0,127,255}));
  connect(senTemMix.port_b, fanSupBlo.port_a)
    annotation (Line(points={{-150,-200},{-140,-200}}, color={0,127,255}));
  connect(coiHea2.port_b, senTemHea2.port_a)
    annotation (Line(points={{-90,-200},{-80,-200}}, color={0,127,255}));
  connect(senTemHea2.port_b, coiCoo.port_a)
    annotation (Line(points={{-60,-200},{-10,-200}}, color={0,127,255}));
  connect(coiHea1.port_b, senTemHea1.port_a)
    annotation (Line(points={{-258,-200},{-250,-200}}, color={0,127,255}));
  connect(senTemHea1.port_b, eco.port_Out) annotation (Line(points={{-230,-200},
          {-220,-200},{-220,-147},{-210,-147}},                   color={0,127,255}));
  connect(coiCoo.port_b, senTemCoo.port_a)
    annotation (Line(points={{10,-200},{20,-200}}, color={0,127,255}));
  connect(senTemCoo.port_b, coiHea3.port_a)
    annotation (Line(points={{40,-200},{50,-200}}, color={0,127,255}));
  connect(coiHea3.port_b, senTemHea3.port_a)
    annotation (Line(points={{70,-200},{80,-200}}, color={0,127,255}));
  connect(senTemHea3.port_b, fanSupDra.port_a)
    annotation (Line(points={{100,-200},{110,-200}}, color={0,127,255}));
  connect(senTemCoo.y, ahuBus.ahuI.TCoiCooLvg) annotation (Line(points={{30,-188},
          {30,0},{-300.1,0},{-300.1,0.1}}, color={0,0,127}));
  connect(resSup.port_b, senTemSup.port_a)
    annotation (Line(points={{160,-200},{170,-200}}, color={0,127,255}));
  connect(senTemSup.port_b, senHumSup.port_a)
    annotation (Line(points={{190,-200},{200,-200}}, color={0,127,255}));
  connect(senHumSup.port_b, senPreSta.port_a)
    annotation (Line(points={{220,-200},{230,-200}}, color={0,127,255}));
  connect(senPreSta.port_b, port_Sup)
    annotation (Line(points={{250,-200},{300,-200}}, color={0,127,255}));
  connect(senPreSta.port_bRef, port_Out) annotation (Line(points={{240,-210},{240,
          -240},{-290,-240},{-290,-200},{-300,-200}}, color={0,127,255}));
  annotation (
    defaultComponentName="ahu",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
    coordinateSystem(preserveAspectRatio=false)));
end VAVSingleDuct;
