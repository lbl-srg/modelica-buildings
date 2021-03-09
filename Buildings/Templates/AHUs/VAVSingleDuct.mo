within Buildings.Templates.AHUs;
model VAVSingleDuct "VAV single duct with relief"
  extends Interfaces.Main(
    final typ=Types.Main.SupplyReturn,
    final typSup=Types.Supply.SingleDuct,
    final typRet=Types.Return.WithRelief);

  final inner parameter Types.Economizer typEco = eco.typ
    "Type of economizer"
    annotation (Evaluate=true,
      Dialog(group="Economizer"));

  final inner parameter Types.Coil typCoiCoo = coiCoo.typ
    "Type of cooling coil"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final inner parameter Types.HeatExchanger typHexCoiCoo = coiCoo.typHex
    "Type of cooling coil heat exchanger"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final inner parameter Types.Actuator typActCoiCoo = coiCoo.typAct
    "Type of cooling coil actuator"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final inner parameter Boolean have_souCoiCoo = coiCoo.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));

  final inner parameter Types.Coil typCoiHea=
    if coiHea1.typ<>Types.Coil.None then  coiHea1.typ
    elseif coiHea2.typ<>Types.Coil.None then  coiHea2.typ
    elseif coiHea3.typ<>Types.Coil.None then  coiHea3.typ
    else Types.Coil.None
    "Type of heating coil"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final inner parameter Types.HeatExchanger typHexCoiHea=
    if coiHea1.typ<>Types.Coil.None then  coiHea1.typHex
    elseif coiHea2.typ<>Types.Coil.None then  coiHea2.typHex
    elseif coiHea3.typ<>Types.Coil.None then  coiHea3.typHex
    else Types.HeatExchanger.None
    "Type of heating coil heat exchanger"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final inner parameter Types.Actuator typActCoiHea=
    if coiHea1.typ<>Types.Coil.None then  coiHea1.typAct
    elseif coiHea2.typ<>Types.Coil.None then  coiHea2.typAct
    elseif coiHea3.typ<>Types.Coil.None then  coiHea3.typAct
    else Types.Actuator.None
    "Type of heating coil actuator"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final parameter Boolean have_souCoiHea1 = coiHea1.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Preheat coil"));
  final parameter Boolean have_souCoiHea2 = coiHea2.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Heating coil"));
  final parameter Boolean have_souCoiHea3 = coiHea3.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Reheat coil"));

  final inner parameter Types.Fan typFanSup=
    if fanSupDra.typ<>Types.Fan.None then fanSupDra.typ
    elseif fanSupBlo.typ<>Types.Fan.None then fanSupBlo.typ
    else Types.Fan.None
    "Type of supply fan"
    annotation (
      Evaluate=true,
      Dialog(group="Supply fan"));
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
      iconTransformation(extent={{50,-208},{70,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
    redeclare package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil supply port"
    annotation (Placement(
        transformation(extent={{-10,-290},{10,-270}}),  iconTransformation(
          extent={{10,-208},{30,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHea1Ret(
    redeclare package Medium = MediumHea) if have_souCoiHea1
    "Preheat coil return port"
    annotation (Placement(
      transformation(extent={{-270,-290},{-250,-270}}),
      iconTransformation(extent={{-130,-208},{-110,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHea1Sup(
    redeclare package Medium = MediumHea) if have_souCoiHea1
    "Preheat coil supply port"
    annotation (Placement(
        transformation(extent={{-290,-290},{-270,-270}}),
                                                        iconTransformation(
          extent={{-170,-208},{-150,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHea2Ret(
    redeclare package Medium = MediumHea) if have_souCoiHea2
    "Heating coil return port"
    annotation (Placement(
      transformation(extent={{-90,-290},{-70,-270}}),
      iconTransformation(extent={{-40,-208},{-20,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHea2Sup(
    redeclare package Medium = MediumHea) if have_souCoiHea2
    "Heating coil supply port"
    annotation (Placement(
        transformation(extent={{-110,-290},{-90,-270}}),iconTransformation(
          extent={{-80,-208},{-60,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHea3Ret(
    redeclare package Medium = MediumHea) if have_souCoiHea3
    "Reheat coil return port"
    annotation (Placement(
      transformation(extent={{70,-290},{90,-270}}),
      iconTransformation(extent={{140,-208},{160,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHea3Sup(
    redeclare package Medium = MediumHea) if have_souCoiHea3
    "Reheat coil supply port"
    annotation (Placement(
        transformation(extent={{50,-290},{70,-270}}),   iconTransformation(
          extent={{100,-208},{120,-188}})));

  BoundaryConditions.WeatherData.Bus weaBus if
    coiCoo.typ == Types.Coil.DirectExpansion
    annotation (Placement(transformation(extent={{-20,240},{20,280}}),
      iconTransformation(extent={{-20,182},{20,218}})));

  inner replaceable Coils.None coiHea1
    constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Heating coil - Option 1: Preheat coil in OA branch"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Heating coil 1"),
      Placement(transformation(extent={{-278,-210},{-258,-190}})));
  replaceable Sensors.None THea1 constrainedby Interfaces.Sensor(redeclare
      final package Medium = MediumAir, final bra=Types.Branch.Supply)
    "Heating coil 1 leaving air temperature" annotation (
    choices(
      choice(redeclare Sensors.None THea1 "No sensor"),
      choice(redeclare Sensors.Temperature THea1 "Temperature sensor")),
    Dialog(group="Heating coil 1", enable=coiHea1 <> Types.Coil.None),
    Placement(transformation(extent={{-250,-210},{-230,-190}})));

  inner replaceable Economizers.None eco
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
  replaceable Sensors.None TMix constrainedby Interfaces.Sensor(redeclare
      final package Medium = MediumAir, final bra=Types.Branch.Supply)
    "Mixed air temperature sensor" annotation (
    choices(
      choice(redeclare Sensors.None TMix "No sensor"),
      choice(redeclare Sensors.Temperature TMix "Temperature sensor")),
    Dialog(group="Economizer", enable=eco.typ <> Types.Economizer.None),
    Placement(transformation(extent={{-170,-210},{-150,-190}})));

  inner replaceable Fans.None fanSupBlo
    constrainedby Interfaces.Fan(
      redeclare final package MediumAir = MediumAir)
    "Supply fan - Blow through"
    annotation (
    choicesAllMatching=true,
    Dialog(
      group="Supply fan",
      enable=not have_draThr),
    Placement(transformation(extent={{-140,-210},{-120,-190}})));

  inner replaceable Coils.None coiHea2
    constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Heating coil - Option 2: preheat coil in SA branch"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Heating coil 2"),
      Placement(transformation(extent={{-110,-210},{-90,-190}})));
  replaceable Sensors.None THea2 constrainedby Interfaces.Sensor(redeclare
      final package Medium = MediumAir, final bra=Types.Branch.Supply)
    "Heating coil 2 leaving air temperature sensor" annotation (
    choices(
      choice(redeclare Sensors.None THea2 "No sensor"),
      choice(redeclare Sensors.Temperature THea2 "Temperature sensor")),
    Dialog(group="Heating coil 2", enable=coiHea2 <> Types.Coil.None),
    Placement(transformation(extent={{-80,-210},{-60,-190}})));

  inner replaceable Coils.None coiCoo
    constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Cooling coil"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Cooling coil"),
      Placement(transformation(extent={{-10,-210},{10,-190}})));
  replaceable Sensors.None TCoo constrainedby Interfaces.Sensor(redeclare
      final package Medium = MediumAir, final bra=Types.Branch.Supply)
    "Cooling coil leaving air temperature sensor" annotation (
    choices(
      choice(redeclare Sensors.None TCoo "No sensor"),
      choice(redeclare Sensors.Temperature TCoo "Temperature sensor")),
    Dialog(group="Cooling coil", enable=coiCoo <> Types.Coil.None),
    Placement(transformation(extent={{20,-210},{40,-190}})));

  inner replaceable Coils.None coiHea3
    constrainedby Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Heating coil - Option 3: reheat coil"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Heating coil 3"),
      Placement(transformation(extent={{50,-210},{70,-190}})));
  replaceable Sensors.None THea3 constrainedby Interfaces.Sensor(redeclare
      final package Medium = MediumAir, final bra=Types.Branch.Supply)
    "Heating coil 3 leaving air temperature sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None THea3 "No sensor"),
        choice(redeclare Sensors.Temperature THea3 "Temperature sensor")),
    Dialog(group="Heating coil 3", enable=coiHea3 <> Types.Coil.None),
    Placement(transformation(extent={{80,-210},{100,-190}})));

  inner replaceable Fans.None fanSupDra
    constrainedby Interfaces.Fan(
      redeclare final package MediumAir = MediumAir)
    "Supply fan - Draw through"
    annotation (
    choicesAllMatching=true,
    Dialog(
      group="Supply fan",
      enable=have_draThr),
    Placement(transformation(extent={{110,-210},{130,-190}})));

  inner replaceable Controls.Dummy conAhu
    constrainedby Interfaces.Controller
    "AHU controller"
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

  replaceable Sensors.None TSup constrainedby Interfaces.Sensor(redeclare
      final package Medium = MediumAir, final bra=Types.Branch.Supply)
    "Supply air temperature sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None TSup "No sensor"),
        choice(redeclare Sensors.Temperature TSup "Temperature sensor")),
    Dialog(group="Duct sensors"),
    Placement(transformation(extent={{170,-210},{190,-190}})));
  replaceable Sensors.None xSup constrainedby Interfaces.Sensor(redeclare
      final package Medium = MediumAir, final bra=Types.Branch.Supply)
    "Supply air humidity ratio sensor"
    annotation (
    choices(
      choice(redeclare Sensors.None xSup "No sensor"),
      choice(redeclare Sensors.HumidityRatio xSup
    "Humidity ratio sensor")),
    Dialog(group="Duct sensors"),
    Placement(transformation(extent={{200,-210},{220,-190}})));
  replaceable Sensors.None pSup constrainedby Interfaces.Sensor(redeclare
      final package Medium = MediumAir, final bra=Types.Branch.Supply)
    "Duct static pressure sensor"
    annotation (
      choices(
        choice(redeclare Sensors.None pSup "No sensor"),
        choice(redeclare Sensors.DifferentialPressure pSup
        "Differential pressure sensor")),
    Dialog(group="Duct sensors"),
    Placement(transformation(extent={{230,-210},{250,-190}})));
equation
  connect(port_OutMin, eco.port_OutMin)
    annotation (Line(points={{-300,-140},{-210,-140}}, color={0,127,255}));
  connect(port_Exh, eco.port_Exh) annotation (Line(points={{-300,-80},{-220,-80},
          {-220,-133},{-210,-133}}, color={0,127,255}));
  connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{0,-280},{0,
          -220},{-4,-220},{-4,-210}},      color={0,127,255}));
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
  connect(eco.port_Sup, TMix.port_a) annotation (Line(points={{-190,-147},{-180,
          -147},{-180,-200},{-170,-200}}, color={0,127,255}));
  connect(TMix.port_b, fanSupBlo.port_a)
    annotation (Line(points={{-150,-200},{-140,-200}}, color={0,127,255}));
  connect(coiHea2.port_b, THea2.port_a)
    annotation (Line(points={{-90,-200},{-80,-200}}, color={0,127,255}));
  connect(THea2.port_b, coiCoo.port_a)
    annotation (Line(points={{-60,-200},{-10,-200}}, color={0,127,255}));
  connect(coiHea1.port_b, THea1.port_a)
    annotation (Line(points={{-258,-200},{-250,-200}}, color={0,127,255}));
  connect(THea1.port_b, eco.port_Out) annotation (Line(points={{-230,-200},{-220,
          -200},{-220,-147},{-210,-147}}, color={0,127,255}));
  connect(coiCoo.port_b, TCoo.port_a)
    annotation (Line(points={{10,-200},{20,-200}}, color={0,127,255}));
  connect(TCoo.port_b, coiHea3.port_a)
    annotation (Line(points={{40,-200},{50,-200}}, color={0,127,255}));
  connect(coiHea3.port_b, THea3.port_a)
    annotation (Line(points={{70,-200},{80,-200}}, color={0,127,255}));
  connect(THea3.port_b, fanSupDra.port_a)
    annotation (Line(points={{100,-200},{110,-200}}, color={0,127,255}));
  connect(resSup.port_b, TSup.port_a)
    annotation (Line(points={{160,-200},{170,-200}}, color={0,127,255}));
  connect(TSup.port_b, xSup.port_a)
    annotation (Line(points={{190,-200},{200,-200}}, color={0,127,255}));
  connect(xSup.port_b, pSup.port_a)
    annotation (Line(points={{220,-200},{230,-200}}, color={0,127,255}));
  connect(pSup.port_b, port_Sup)
    annotation (Line(points={{250,-200},{300,-200}}, color={0,127,255}));
  connect(pSup.port_bRef, port_Out) annotation (Line(points={{240,-210},{240,-240},
          {-290,-240},{-290,-200},{-300,-200}}, color={0,127,255}));
  connect(port_coiHea1Sup, coiHea1.port_aSou) annotation (Line(points={{-280,-280},
          {-280,-220},{-272,-220},{-272,-210}}, color={0,127,255}));
  connect(coiHea1.port_bSou, port_coiHea1Ret) annotation (Line(points={{-264,-210},
          {-264,-220},{-260,-220},{-260,-280}}, color={0,127,255}));
  connect(port_coiHea2Sup, coiHea2.port_aSou) annotation (Line(points={{-100,-280},
          {-100,-220},{-104,-220},{-104,-210}}, color={0,127,255}));
  connect(coiHea2.port_bSou, port_coiHea2Ret) annotation (Line(points={{-96,-210},
          {-96,-220},{-80,-220},{-80,-280}}, color={0,127,255}));
  connect(port_coiHea3Sup, coiHea3.port_aSou) annotation (Line(points={{60,-280},
          {60,-220},{56,-220},{56,-210}}, color={0,127,255}));
  connect(coiHea3.port_bSou, port_coiHea3Ret) annotation (Line(points={{64,-210},
          {64,-220},{80,-220},{80,-280}}, color={0,127,255}));
  connect(ahuBus, coiHea1.ahuBus) annotation (Line(
      points={{-300,0},{-268,0},{-268,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus, coiHea2.ahuBus) annotation (Line(
      points={{-300,0},{-100,0},{-100,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus, coiHea3.ahuBus) annotation (Line(
      points={{-300,0},{60,0},{60,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(THea1.ahuBus, ahuBus) annotation (Line(
      points={{-240,-190},{-240,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TMix.ahuBus, ahuBus) annotation (Line(
      points={{-160,-190},{-160,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(THea2.ahuBus, ahuBus) annotation (Line(
      points={{-70,-190},{-70,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(THea3.ahuBus, ahuBus) annotation (Line(
      points={{90,-190},{90,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TSup.ahuBus, ahuBus) annotation (Line(
      points={{180,-190},{180,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(xSup.ahuBus, ahuBus) annotation (Line(
      points={{210,-190},{210,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(pSup.ahuBus, ahuBus) annotation (Line(
      points={{240,-190},{240,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    defaultComponentName="ahu",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
    coordinateSystem(preserveAspectRatio=false)));
end VAVSingleDuct;
