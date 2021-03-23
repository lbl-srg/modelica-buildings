within Buildings.Templates.AHUs;
model VAVSingleDuct "VAV single duct with relief"
  extends Buildings.Templates.Interfaces.AHU(
    final typ=Buildings.Templates.Types.AHU.SupplyReturn,
    final typSup=Buildings.Templates.Types.Supply.SingleDuct,
    final typRet=Buildings.Templates.Types.Return.WithRelief);

  replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)"
    annotation(Dialog(enable=have_souCoiCoo));
  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)"
    annotation(Dialog(enable=have_souCoiHea or have_souCoiReh));

  final inner parameter Boolean have_souCoiCoo = coiCoo.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  final parameter Boolean have_souCoiHea = coiHea.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Heating coil"));
  final parameter Boolean have_souCoiReh=coiReh.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Reheat coil"));

  Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
    redeclare final package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil return port"
    annotation (Placement(
      transformation(extent={{30,-290},{50,-270}}),
      iconTransformation(extent={{50,-208},{70,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
    redeclare final package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil supply port"
    annotation (Placement(
        transformation(extent={{10,-290},{30,-270}}),   iconTransformation(
          extent={{10,-208},{30,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHeaRet(
    redeclare final package Medium =MediumHea) if have_souCoiHea
    "Heating coil return port"
    annotation (Placement(transformation(extent={{-30,
            -290},{-10,-270}}), iconTransformation(extent={{-40,-208},{-20,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHeaSup(
    redeclare final package Medium =MediumHea) if have_souCoiHea
    "Heating coil supply port"
    annotation (Placement(transformation(extent={{-50,
            -290},{-30,-270}}), iconTransformation(extent={{-80,-208},{-60,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiRehRet(
    redeclare final package Medium =MediumHea) if have_souCoiReh
    "Reheat coil return port"
    annotation (Placement(transformation(extent={{90,-290},
            {110,-270}}), iconTransformation(extent={{140,-208},{160,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiRehSup(
    redeclare final package Medium = MediumHea) if have_souCoiReh
    "Reheat coil supply port" annotation (Placement(transformation(extent={{70,-290},
            {90,-270}}), iconTransformation(extent={{100,-208},{120,-188}})));

  BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,260},{20,300}}),
      iconTransformation(extent={{-20,182},{20,218}})));


  inner replaceable Buildings.Templates.BaseClasses.Dampers.NoPath damRet
    constrainedby Buildings.Templates.Interfaces.Damper(redeclare final package
      Medium = MediumAir) "Return air damper" annotation (
    choices(choice(redeclare BaseClasses.Dampers.NoPath damRet "No fluid path"),
        choice(redeclare BaseClasses.Dampers.Modulated damRet
          "Modulated damper")),
    Dialog(group="Economizer"),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,-140})));
  inner replaceable Buildings.Templates.BaseClasses.Dampers.NoPath damOutMin
    constrainedby Buildings.Templates.Interfaces.Damper(
      redeclare final package Medium = MediumAir)
    "Minimum outdoor air damper"
    annotation (
    choices(
      choice(redeclare BaseClasses.Dampers.NoPath damOutMin
        "No fluid path"),
      choice(redeclare BaseClasses.Dampers.Modulated damOutMin
        "Modulated damper"),
      choice(redeclare BaseClasses.Dampers.TwoPosition damOutMin
        "Two-position damper")),
    Dialog(group="Economizer"),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-232,-140})));
  inner replaceable Buildings.Templates.BaseClasses.Dampers.None damOut
    constrainedby Buildings.Templates.Interfaces.Damper(redeclare final package
      Medium = MediumAir) "Outdoor air damper" annotation (
    choices(
      choice(redeclare BaseClasses.Dampers.None damOut "No damper"),
      choice(redeclare BaseClasses.Dampers.Modulated damOut "Modulated damper"),
      choice(redeclare BaseClasses.Dampers.TwoPosition damOut
          "Two-position damper")),
    Dialog(group="Economizer"),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-230,-200})));

  inner replaceable Buildings.Templates.BaseClasses.Dampers.None damRel
    constrainedby Buildings.Templates.Interfaces.Damper(redeclare final package
      Medium = MediumAir) "Relief air damper" annotation (
    choices(
      choice(redeclare BaseClasses.Dampers.None damRel "No damper"),
      choice(redeclare BaseClasses.Dampers.Modulated damRel "Modulated damper"),
      choice(redeclare BaseClasses.Dampers.TwoPosition damRel
          "Two-position damper")),
    Dialog(group="Economizer"),
    Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-234,-80})));

  replaceable Buildings.Templates.BaseClasses.Sensors.None TOut constrainedby
    Buildings.Templates.Interfaces.Sensor(redeclare final package Medium =
        MediumAir) "Outdoor air temperature sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None TOut "No sensor"), choice(
          redeclare BaseClasses.Sensors.Temperature TOut "Temperature sensor")),
    Dialog(group="Sensors"),
    Placement(transformation(extent={{-210,-210},{-190,-190}})));

  replaceable Buildings.Templates.BaseClasses.Sensors.None TOut1 constrainedby
    Buildings.Templates.Interfaces.Sensor(redeclare final package Medium =
        MediumAir) "Outdoor air temperature sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None TOut1 "No sensor"),
        choice(redeclare BaseClasses.Sensors.Temperature TOut1
          "Temperature sensor")),
    Dialog(group="Sensors", enable=damOutMin.typ <> Buildings.Templates.Types.Damper.NoPath),
    Placement(transformation(extent={{-212,-150},{-192,-130}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None VOut_flow
    constrainedby Buildings.Templates.Interfaces.Sensor(redeclare final package
      Medium = MediumAir) "Outdoor air volume flow rate sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None VOut_flow "No sensor"), choice(
          redeclare BaseClasses.Sensors.VolumeFlowRate VOut_flow
          "Volume flow rate sensor")),
    Dialog(group="Economizer"),
    Placement(transformation(extent={{-180,-210},{-160,-190}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None VOut1_flow
    constrainedby Buildings.Templates.Interfaces.Sensor(redeclare final package
      Medium = MediumAir) "Outdoor air volume flow rate sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None VOut1_flow "No sensor"),
        choice(redeclare BaseClasses.Sensors.VolumeFlowRate VOut1_flow
          "Volume flow rate sensor")),
    Dialog(group="Economizer", enable=damOutMin.typ <> Buildings.Templates.Types.Damper.NoPath),
    Placement(transformation(extent={{-182,-150},{-162,-130}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None dpOut constrainedby
    Buildings.Templates.Interfaces.Sensor(redeclare final package Medium =
        MediumAir) "Outdoor air damper differential pressure" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None dpOut "No sensor"),
        choice(redeclare BaseClasses.Sensors.DifferentialPressure dpOut
          "Differential pressure sensor")),
    Dialog(group="Economizer", enable=damOutMin.typ <> Buildings.Templates.Types.Damper.NoPath),
    Placement(transformation(extent={{-270,-150},{-250,-130}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None TMix constrainedby
    Buildings.Templates.Interfaces.Sensor(redeclare final package Medium =
        MediumAir) "Mixed air temperature sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None TMix "No sensor"), choice(
          redeclare BaseClasses.Sensors.Temperature TMix "Temperature sensor")),
    Dialog(group="Economizer"),
    Placement(transformation(extent={{-100,-210},{-80,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Fans.None fanSupBlo
    constrainedby Buildings.Templates.Interfaces.Fan(redeclare final package
      Medium = MediumAir) "Supply fan - Blow through" annotation (
    choicesAllMatching=true,
    Dialog(group="Supply fan", enable=fanSupDra == Buildings.Templates.Types.Fan.None),
    Placement(transformation(extent={{-70,-210},{-50,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Coils.None coiHea
    constrainedby Buildings.Templates.Interfaces.Coil(redeclare final package
      MediumAir = MediumAir, redeclare final package MediumSou = MediumHea)
    "Heating coil" annotation (
    choicesAllMatching=true,
    Dialog(group="Heating coil"),
    Placement(transformation(extent={{-40,-210},{-20,-190}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None THea constrainedby
    Buildings.Templates.Interfaces.Sensor(redeclare final package Medium =
        MediumAir) "Heating coil leaving air temperature sensor"
                                  annotation (
    choices(choice(redeclare BaseClasses.Sensors.None THea "No sensor"), choice(
          redeclare BaseClasses.Sensors.Temperature THea "Temperature sensor")),
    Dialog(group="Heating coil", enable=coiHea <> Buildings.Templates.Types.Coil.None),
    Placement(transformation(extent={{-10,-210},{10,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Coils.None coiCoo
    constrainedby Buildings.Templates.Interfaces.Coil(redeclare final package
      MediumAir = MediumAir, redeclare final package MediumSou = MediumCoo)
    "Cooling coil" annotation (
    choicesAllMatching=true,
    Dialog(group="Cooling coil"),
    Placement(transformation(extent={{20,-210},{40,-190}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None TCoo constrainedby
    Buildings.Templates.Interfaces.Sensor(redeclare final package Medium =
        MediumAir) "Cooling coil leaving air temperature sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None TCoo "No sensor"), choice(
          redeclare BaseClasses.Sensors.Temperature TCoo "Temperature sensor")),
    Dialog(group="Cooling coil", enable=coiCoo <> Buildings.Templates.Types.Coil.None),
    Placement(transformation(extent={{50,-210},{70,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Coils.None coiReh
    constrainedby Buildings.Templates.Interfaces.Coil(redeclare final package
      MediumAir = MediumAir, redeclare final package MediumSou = MediumHea)
    "Reheat coil" annotation (
    choicesAllMatching=true,
    Dialog(group="Reheat coil"),
    Placement(transformation(extent={{80,-210},{100,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Fans.None fanSupDra
    constrainedby Buildings.Templates.Interfaces.Fan(redeclare final package
      Medium = MediumAir) "Supply fan - Draw through" annotation (
    choicesAllMatching=true,
    Dialog(group="Supply fan", enable=fanSupBlo == Buildings.Templates.Types.Fan.None),
    Placement(transformation(extent={{110,-210},{130,-190}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None VSup_flow
    constrainedby Buildings.Templates.Interfaces.Sensor(redeclare final package
      Medium = MediumAir) "Supply air volume flow rate sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None VSup "No sensor"), choice(
          redeclare BaseClasses.Sensors.VolumeFlowRate VSup
          "Volume flow rate sensor")),
    Dialog(group="Supply fan"),
    Placement(transformation(extent={{142,-210},{162,-190}})));

  inner replaceable Controls.Dummy conAHU constrainedby
    Buildings.Templates.Interfaces.ControllerAHU
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
    annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
  Fluid.FixedResistances.PressureDrop resSup(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{172,-210},{192,-190}})));

  replaceable Buildings.Templates.BaseClasses.Sensors.None TSup constrainedby
    Buildings.Templates.Interfaces.Sensor(redeclare final package Medium =
        MediumAir) "Supply air temperature sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None TSup "No sensor"), choice(
          redeclare BaseClasses.Sensors.Temperature TSup "Temperature sensor")),
    Dialog(group="Sensors"),
    Placement(transformation(extent={{200,-210},{220,-190}})));

  replaceable Buildings.Templates.BaseClasses.Sensors.None xSup constrainedby
    Buildings.Templates.Interfaces.Sensor(redeclare final package Medium =
        MediumAir) "Supply air humidity ratio sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None xSup "No sensor"), choice(
          redeclare BaseClasses.Sensors.HumidityRatio xSup
          "Humidity ratio sensor")),
    Dialog(group="Sensors"),
    Placement(transformation(extent={{230,-210},{250,-190}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None pSup_rel
    constrainedby Buildings.Templates.Interfaces.Sensor(redeclare final package
      Medium = MediumAir) "Duct static pressure sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None pSup_rel "No sensor"),
        choice(redeclare BaseClasses.Sensors.DifferentialPressure pSup_rel
          "Differential pressure sensor")),
    Dialog(group="Sensors"),
    Placement(transformation(extent={{260,-210},{280,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Fans.None fanRet
    constrainedby Buildings.Templates.Interfaces.Fan(redeclare final package
      Medium = MediumAir) "Return fan" annotation (
    choicesAllMatching=true,
    Dialog(group="Return/relief fan", enable=fanRel.typ == Buildings.Templates.BaseClasses.Fans.None),
    Placement(transformation(extent={{20,-90},{0,-70}})));

  inner replaceable Buildings.Templates.BaseClasses.Fans.None fanRel
    constrainedby Buildings.Templates.Interfaces.Fan(redeclare final package
      Medium = MediumAir) "Relief fan" annotation (
    choicesAllMatching=true,
    Dialog(group="Return/relief fan", enable=fanRet.typ == Buildings.Templates.BaseClasses.Fans.None),
    Placement(transformation(extent={{-140,-90},{-160,-70}})));

  replaceable Buildings.Templates.BaseClasses.Sensors.None VRet_flow
    constrainedby Buildings.Templates.Interfaces.Sensor(redeclare final package
      Medium = MediumAir) "Return air volume flow rate sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None VRet "No sensor"), choice(
          redeclare BaseClasses.Sensors.VolumeFlowRate VRet
          "Volume flow rate sensor")),
    Dialog(group="Return/relief fan"),
    Placement(transformation(extent={{-10,-90},{-30,-70}})));
  Fluid.Sensors.RelativePressure pInd_rel(
    redeclare final package Medium=MediumAir)
    "Building static pressure"
    annotation (Placement(transformation(extent={{30,230},{10,250}})));
  replaceable Buildings.Templates.BaseClasses.Sensors.None pRet_rel
    constrainedby Buildings.Templates.Interfaces.Sensor(redeclare final package
      Medium = MediumAir) "Return static pressure sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None pRet_rel "No sensor"),
        choice(redeclare BaseClasses.Sensors.DifferentialPressure pRet_rel
          "Differential pressure sensor")),
    Dialog(group="Return/relief fan"),
    Placement(transformation(extent={{-60,-90},{-80,-70}})));

  Fluid.Sources.Outside out(
    redeclare final package Medium=MediumAir,
    final nPorts=1)
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,250})));
  Fluid.Sources.Boundary_pT ind(
    redeclare final package Medium = MediumAir,
    final use_p_in=true,
    final nPorts=1 + (if pSup_rel.typ == Buildings.Templates.Types.Sensor.DifferentialPressure
         then 1 else 0) + (if pRet_rel.typ == Buildings.Templates.Types.Sensor.DifferentialPressure
         then 1 else 0)) "Indoor pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,250})));

  replaceable BaseClasses.Sensors.None TRet constrainedby
    BaseClasses.Sensors.None(redeclare final package Medium = MediumAir)
    "Return air temperature sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None tret "No sensor"), choice(
          redeclare BaseClasses.Sensors.Temperature tret "Temperature sensor")),
    Dialog(group="Sensors"),
    Placement(transformation(extent={{222,-90},{202,-70}})));

  replaceable BaseClasses.Sensors.None hRet constrainedby
    BaseClasses.Sensors.None(redeclare final package Medium = MediumAir)
    "Return air enthalpy sensor" annotation (
    choices(choice(redeclare BaseClasses.Sensors.None hRet "No sensor"), choice(
          redeclare BaseClasses.Sensors.Temperature hRet "Enthalpy sensor")),
    Dialog(group="Sensors"),
    Placement(transformation(extent={{252,-90},{232,-70}})));

equation

  connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{20,-280},{
          20,-220},{26,-220},{26,-210}},   color={0,127,255}));
  connect(coiCoo.port_bSou, port_coiCooRet) annotation (Line(points={{34,-210},{
          34,-220},{40,-220},{40,-280}}, color={0,127,255}));
  connect(weaBus, coiCoo.weaBus) annotation (Line(
      points={{0,280},{0,80},{24,80},{24,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(TMix.port_b, fanSupBlo.port_a)
    annotation (Line(points={{-80,-200},{-70,-200}},   color={0,127,255}));
  connect(THea.port_b, coiCoo.port_a)
    annotation (Line(points={{10,-200},{20,-200}}, color={0,127,255}));
  connect(coiCoo.port_b, TCoo.port_a)
    annotation (Line(points={{40,-200},{50,-200}}, color={0,127,255}));
  connect(TCoo.port_b, coiReh.port_a)
    annotation (Line(points={{70,-200},{80,-200}}, color={0,127,255}));
  connect(resSup.port_b, TSup.port_a)
    annotation (Line(points={{192,-200},{200,-200}}, color={0,127,255}));
  connect(TSup.port_b, xSup.port_a)
    annotation (Line(points={{220,-200},{230,-200}}, color={0,127,255}));
  connect(xSup.port_b, pSup_rel.port_a)
    annotation (Line(points={{250,-200},{260,-200}}, color={0,127,255}));
  connect(pSup_rel.port_b, port_Sup)
    annotation (Line(points={{280,-200},{300,-200}}, color={0,127,255}));
  connect(port_coiHeaSup, coiHea.port_aSou) annotation (Line(points={{-40,-280},
          {-40,-220},{-34,-220},{-34,-210}}, color={0,127,255}));
  connect(coiHea.port_bSou, port_coiHeaRet) annotation (Line(points={{-26,-210},
          {-26,-220},{-20,-220},{-20,-280}}, color={0,127,255}));
  connect(port_coiRehSup, coiReh.port_aSou) annotation (Line(points={{80,-280},{
          80,-220},{86,-220},{86,-210}}, color={0,127,255}));
  connect(coiReh.port_bSou, port_coiRehRet) annotation (Line(points={{94,-210},{
          94,-220},{100,-220},{100,-280}}, color={0,127,255}));
  connect(damRel.port_b, port_Exh)
    annotation (Line(points={{-244,-80},{-300,-80}}, color={0,127,255}));
  connect(fanRel.port_b, damRel.port_a)
    annotation (Line(points={{-160,-80},{-224,-80}}, color={0,127,255}));
  connect(resRet.port_b, fanRet.port_a) annotation (Line(points={{170,-80},{20,-80}},
                               color={0,127,255}));
  connect(damRet.port_b, TMix.port_a) annotation (Line(points={{-120,-150},{-120,
          -200},{-100,-200}},      color={0,127,255}));
  connect(coiReh.port_b, fanSupDra.port_a)
    annotation (Line(points={{100,-200},{110,-200}}, color={0,127,255}));
  connect(damOutMin.port_b, TOut1.port_a)
    annotation (Line(points={{-222,-140},{-212,-140}}, color={0,127,255}));
  connect(TOut1.port_b, VOut1_flow.port_a)
    annotation (Line(points={{-192,-140},{-182,-140}}, color={0,127,255}));
  connect(port_Out, dpOut.port_a) annotation (Line(points={{-300,-200},{-280,-200},
          {-280,-140},{-270,-140}}, color={0,127,255}));
  connect(dpOut.port_b, damOutMin.port_a)
    annotation (Line(points={{-250,-140},{-242,-140}}, color={0,127,255}));
  connect(VOut1_flow.port_b, TMix.port_a) annotation (Line(points={{-162,-140},
          {-140,-140},{-140,-200},{-100,-200}}, color={0,127,255}));
  connect(dpOut.port_bRef, TMix.port_a) annotation (Line(points={{-260,-150},{-260,
          -160},{-140,-160},{-140,-200},{-100,-200}}, color={0,127,255}));
  connect(fanSupDra.port_b, VSup_flow.port_a)
    annotation (Line(points={{130,-200},{142,-200}}, color={0,127,255}));
  connect(VSup_flow.port_b, resSup.port_a)
    annotation (Line(points={{162,-200},{172,-200}}, color={0,127,255}));
  connect(fanRet.port_b, VRet_flow.port_a)
    annotation (Line(points={{0,-80},{-10,-80}}, color={0,127,255}));
  connect(fanSupBlo.port_b, coiHea.port_a)
    annotation (Line(points={{-50,-200},{-40,-200}}, color={0,127,255}));
  connect(coiHea.port_b, THea.port_a)
    annotation (Line(points={{-20,-200},{-10,-200}}, color={0,127,255}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{0,280},{0,276},{-40,276},{-40,260},{-39.8,260}},
      color={255,204,51},
      thickness=0.5));
  connect(damOut.port_b, TOut.port_a)
    annotation (Line(points={{-220,-200},{-210,-200}}, color={0,127,255}));
  connect(TOut.port_b, VOut_flow.port_a)
    annotation (Line(points={{-190,-200},{-180,-200}}, color={0,127,255}));
  connect(port_Out, damOut.port_a)
    annotation (Line(points={{-300,-200},{-240,-200}}, color={0,127,255}));
  connect(VOut_flow.port_b, TMix.port_a)
    annotation (Line(points={{-160,-200},{-100,-200}}, color={0,127,255}));
  connect(pInd_rel.port_b, out.ports[1])
    annotation (Line(points={{10,240},{-40,240}}, color={0,127,255}));
  connect(ind.ports[1], pInd_rel.port_a)
    annotation (Line(points={{40,240},{30,240}},      color={0,127,255}));
  connect(ind.ports[2], pSup_rel.port_bRef) annotation (Line(points={{40,240},{288,
          240},{288,-220},{270,-220},{270,-210}}, color={0,127,255}));
  connect(pRet_rel.port_b, fanRel.port_a)
    annotation (Line(points={{-80,-80},{-140,-80}}, color={0,127,255}));
  connect(pRet_rel.port_b, damRet.port_a) annotation (Line(points={{-80,-80},{-120,
          -80},{-120,-130}}, color={0,127,255}));
  connect(VRet_flow.port_b, pRet_rel.port_a)
    annotation (Line(points={{-30,-80},{-60,-80}}, color={0,127,255}));
  connect(pRet_rel.port_bRef, ind.ports[3]) annotation (Line(points={{-70,-90},{
          -70,-100},{40,-100},{40,240}},           color={0,127,255}));

  connect(pInd_rel.p_rel, busAHU.inp.pInd_rel) annotation (Line(points={{20,231},
          {20,0},{-300.1,0},{-300.1,0.1}},     color={0,0,127}));
  connect(conAHU.busTer, busTer) annotation (Line(
      points={{-40,100},{-20,100},{-20,0},{300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conAHU.busAHU, busAHU) annotation (Line(
      points={{-60,100},{-80,100},{-80,0},{-300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busAHU.inp.pInd, ind.p_in) annotation (Line(
      points={{-300.1,0.1},{60,0.1},{60,268},{48,268},{48,262}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

  connect(busAHU, damRel.busCon) annotation (Line(
      points={{-300,0},{-234,0},{-234,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU, dpOut.busCon) annotation (Line(
      points={{-300,0},{-260,0},{-260,-130}},
      color={255,204,51},
      thickness=0.5));
  connect(busAHU, fanRel.busCon) annotation (Line(
      points={{-300,0},{-150,0},{-150,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(fanSupBlo.busCon, busAHU) annotation (Line(
      points={{-60,-190},{-60,-96},{-62,-96},{-62,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(fanSupDra.busCon, busAHU) annotation (Line(
      points={{120,-190},{120,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(damRet.busCon, busAHU) annotation (Line(
      points={{-110,-140},{-100,-140},{-100,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(VOut1_flow.busCon, busAHU) annotation (Line(
      points={{-172,-130},{-172,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TOut1.busCon, busAHU) annotation (Line(
      points={{-202,-130},{-202,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(VOut_flow.busCon, busAHU) annotation (Line(
      points={{-170,-190},{-170,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TOut.busCon, busAHU) annotation (Line(
      points={{-200,-190},{-200,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(damOut.busCon, busAHU) annotation (Line(
      points={{-230,-190},{-230,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(damOutMin.busCon, busAHU) annotation (Line(
      points={{-232,-130},{-232,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(coiHea.busCon, busAHU) annotation (Line(
      points={{-30,-190},{-30,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TMix.busCon, busAHU) annotation (Line(
      points={{-90,-190},{-90,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TCoo.busCon, busAHU) annotation (Line(
      points={{60,-190},{60,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(coiReh.busCon, busAHU) annotation (Line(
      points={{90,-190},{90,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(VSup_flow.busCon, busAHU) annotation (Line(
      points={{152,-190},{152,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TSup.busCon, busAHU) annotation (Line(
      points={{210,-190},{210,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(xSup.busCon, busAHU) annotation (Line(
      points={{240,-190},{240,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(pSup_rel.busCon, busAHU) annotation (Line(
      points={{270,-190},{270,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(coiCoo.busCon, busAHU) annotation (Line(
      points={{30,-190},{30,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(resRet.port_a, TRet.port_b)
    annotation (Line(points={{190,-80},{202,-80}}, color={0,127,255}));
  connect(port_Ret, hRet.port_a)
    annotation (Line(points={{300,-80},{252,-80}}, color={0,127,255}));
  connect(hRet.port_b, TRet.port_a)
    annotation (Line(points={{232,-80},{222,-80}}, color={0,127,255}));
  connect(pRet_rel.busCon, busAHU) annotation (Line(
      points={{-70,-70},{-70,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(VRet_flow.busCon, busAHU) annotation (Line(
      points={{-20,-70},{-20,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(fanRet.busCon, busAHU) annotation (Line(
      points={{10,-70},{10,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TRet.busCon, busAHU) annotation (Line(
      points={{212,-70},{212,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(hRet.busCon, busAHU) annotation (Line(
      points={{242,-70},{242,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(THea.busCon, busAHU) annotation (Line(
      points={{0,-190},{0,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    defaultComponentName="ahu",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
    coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-86,230},{124,210}},
          lineColor={0,127,255},
          pattern=LinePattern.Dash,
          textString="No further connection allowed to those two boundary conditions")}));
end VAVSingleDuct;
