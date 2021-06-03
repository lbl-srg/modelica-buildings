within Buildings.Templates.AHUs;
model VAVMultiZone "Multiple-Zone VAV"
  extends Buildings.Templates.Interfaces.AHU(
    final typ=Buildings.Templates.Types.AHU.SingleDuct,
    final have_porRel=secOutRel.typ<>Templates.Types.OutdoorReliefReturnSection.NoRelief);

  replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)"
    annotation(Dialog(enable=have_souCoiCoo));
  replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)"
    annotation(Dialog(enable=have_souCoiHea or have_souCoiReh));

  final inner parameter Boolean have_souCoiCoo = coiCoo.have_sou
    "Set to true if cooling coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  final parameter Boolean have_souCoiHea = coiHea.have_sou
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Heating coil"));
  final parameter Boolean have_souCoiReh=coiReh.have_sou
    "Set to true if reheat coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Reheat coil"));

  final inner parameter Templates.Types.Fan typFanSup=
    if fanSupDra.typ <> Templates.Types.Fan.None then fanSupDra.typ
    elseif fanSupBlo.typ <> Templates.Types.Fan.None then fanSupBlo.typ
    else Templates.Types.Fan.None
    "Type of supply fan"
    annotation (Evaluate=true);
  final inner parameter Templates.Types.Fan typFanRet = secOutRel.typFanRet
    "Type of return fan"
    annotation (Evaluate=true);

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
        transformation(extent={{10,-290},{30,-270}}), iconTransformation(
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
    "Reheat coil supply port"
    annotation (Placement(transformation(extent={{70,-290},
            {90,-270}}), iconTransformation(extent={{100,-208},{120,-188}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,260},{20,300}}),
      iconTransformation(extent={{-20,182},{20,218}})));

  inner replaceable Templates.BaseClasses.OutdoorReliefReturnSection.Economizer secOutRel
    constrainedby Templates.Interfaces.OutdoorReliefReturnSection(
      redeclare final package MediumAir = MediumAir)
    "Outdoor/relief/return air section"
    annotation (
      choicesAllMatching=true,
      Dialog(
        group="Outdoor/relief/return air section"),
      Placement(transformation(extent={{-178,-104},{-142,-76}})));

  // FIXME: bind typ to control option.
  Buildings.Templates.BaseClasses.Sensors.Wrapper TMix(
    redeclare final package Medium = MediumAir,
    typ=Types.Sensor.Temperature,
    final loc=Types.Location.Supply)
    "Mixed air temperature sensor"
    annotation (
      Dialog(
        group="Supply air section",
        enable=false),
      Placement(transformation(extent={{-100,-210},{-80,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Fans.None fanSupBlo
    constrainedby Buildings.Templates.Interfaces.Fan(
      redeclare final package Medium = MediumAir,
      final loc=Templates.Types.Location.Supply)
    "Supply fan - Blow through"
    annotation (
      choicesAllMatching=true,
      Dialog(
        group="Supply air section",
        enable=fanSupDra==Buildings.Templates.Types.Fan.None),
      Placement(transformation(extent={{-70,-210},{-50,-190}})));

  inner replaceable Templates.BaseClasses.Coils.None coiHea
    constrainedby Templates.Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumHea)
    "Heating coil"
    annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Coils.None coiHea "No coil"),
        choice(redeclare Templates.BaseClasses.Coils.WaterBasedHeating coiHea "Water-based")),
      Dialog(group="Heating coil"),
      Placement(transformation(extent={{-40,-210},{-20,-190}})));

  BaseClasses.Sensors.Wrapper THea(
    redeclare final package Medium = MediumAir,
    final typ=if coiHea.typ<>Templates.Types.Coil.None and
      coiCoo.typ<>Templates.Types.Coil.None then Types.Sensor.Temperature
      else Types.Sensor.None,
    final loc=Types.Location.Supply)
    "Heating coil leaving air temperature sensor"
    annotation (Dialog(group="Supply air section",
        enable=false), Placement(transformation(extent={{-10,-210},{10,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Coils.None coiCoo
    constrainedby Buildings.Templates.Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Cooling coil"
    annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Coils.None coiCoo "No coil"),
        choice(redeclare Templates.BaseClasses.Coils.WaterBasedCooling coiCoo "Water-based")),
      Dialog(group="Cooling coil"),
      Placement(transformation(extent={{20,-210},{40,-190}})));

  BaseClasses.Sensors.Wrapper TCoo(
    redeclare final package Medium = MediumAir,
    final typ=if coiCoo.typ<>Buildings.Templates.Types.Coil.None and
      coiReh.typ<>Buildings.Templates.Types.Coil.None then Types.Sensor.Temperature
      else Types.Sensor.None,
    final loc=Types.Location.Supply)
    "Cooling coil leaving air temperature sensor" annotation (Dialog(group="Supply air section",
        enable=false), Placement(transformation(extent={{50,-210},{70,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Coils.None coiReh
    constrainedby Buildings.Templates.Interfaces.Coil(
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumHea)
    "Reheat coil"
    annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Coils.None coiReh "No coil"),
        choice(redeclare Templates.BaseClasses.Coils.WaterBasedHeating coiReh "Water-based")),
      Dialog(group="Reheat coil"),
      Placement(transformation(extent={{80,-210},{100,-190}})));

  inner replaceable Buildings.Templates.BaseClasses.Fans.None fanSupDra
    constrainedby Buildings.Templates.Interfaces.Fan(
      redeclare final package Medium = MediumAir,
      final loc=Templates.Types.Location.Supply)
    "Supply fan - Draw through"
    annotation (
      choicesAllMatching=true,
      Dialog(
        group="Supply air section",
        enable=fanSupBlo==Buildings.Templates.Types.Fan.None),
      Placement(transformation(extent={{110,-210},{130,-190}})));

  // FIXME: bind typ to control option.
  Buildings.Templates.BaseClasses.Sensors.Wrapper VSup_flow(
    redeclare final package Medium = MediumAir,
    final loc=Templates.Types.Location.Supply,
    typ=Types.Sensor.VolumeFlowRate)
    "Supply air volume flow rate sensor"
    annotation (
      Dialog(
        group="Supply air section",
        enable=false),
      Placement(transformation(extent={{142,-210},{162,-190}})));

  inner replaceable Controls.OpenLoop conAHU constrainedby Buildings.Templates.Interfaces.ControllerAHU
    "AHU controller"
    annotation (
      choicesAllMatching=true,
      Dialog(group="Controller"),
      Placement(transformation(extent={{-260,110},{-240,130}})));

  /* FIXME: Dummy default values fo testing purposes only.
  Compute based on design pressure drop of each piece of equipment
  in case of a lumped pressure drop.
  */
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

  Buildings.Templates.BaseClasses.Sensors.Wrapper TSup(
    redeclare final package Medium = MediumAir,
    typ=Types.Sensor.Temperature,
    final loc=Types.Location.Supply)
    "Supply air temperature sensor"
    annotation (
      Dialog(
        group="Supply air section",
        enable=false),
      Placement(transformation(extent={{200,-210},{220,-190}})));

  // FIXME: bind typ to control option.
  Buildings.Templates.BaseClasses.Sensors.Wrapper xSup(
    redeclare final package Medium = MediumAir,
    typ=Types.Sensor.None,
    final loc=Types.Location.Supply)
    "Supply air humidity ratio sensor"
    annotation (
      Dialog(
        group="Supply air section",
        enable=false),
      Placement(transformation(extent={{230,-210},{250,-190}})));

  // FIXME: bind typ to control option.
  Buildings.Templates.BaseClasses.Sensors.Wrapper pSup_rel(
    redeclare final package Medium = MediumAir,
    typ=Types.Sensor.None,
    final loc=Types.Location.Supply)
    "Duct static pressure sensor"
    annotation (
      Dialog(
        group="Supply air section",
        enable=false),
      Placement(transformation(extent={{260,-210},{280,-190}})));

  Fluid.Sensors.RelativePressure pInd_rel(
    redeclare final package Medium=MediumAir)
    "Building static pressure"
    annotation (Placement(transformation(extent={{30,230},{10,250}})));

  Fluid.Sources.Outside out(
    redeclare final package Medium=MediumAir,
    final nPorts=1 +
      (if secOutRel.have_porPre then 1 else 0))
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,250})));

  Fluid.Sources.Boundary_pT ind(
    redeclare final package Medium = MediumAir,
    final use_p_in=true,
    final nPorts=1 +
      (if pSup_rel.typ==Templates.Types.Sensor.DifferentialPressure then 1 else 0))
    "Indoor pressure"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,250})));

  // FIXME: bind typ to control option.
  BaseClasses.Sensors.Wrapper TRet(
    redeclare final package Medium = MediumAir,
    typ=Types.Sensor.None,
    final loc=Types.Location.Return)
    "Return air temperature sensor"
    annotation (
      Dialog(
        group="Exhaust/relief/return section",
        enable=false),
      Placement(transformation(extent={{222,-90},{202,-70}})));

  // FIXME: bind typ to control option.
  BaseClasses.Sensors.Wrapper hRet(
    redeclare final package Medium = MediumAir,
    typ=Types.Sensor.None,
    final loc=Types.Location.Return)
    "Return air enthalpy sensor"
    annotation (
      Dialog(
      group="Exhaust/relief/return section",
        enable=false),
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
  connect(coiReh.port_b, fanSupDra.port_a)
    annotation (Line(points={{100,-200},{110,-200}}, color={0,127,255}));
  connect(fanSupDra.port_b, VSup_flow.port_a)
    annotation (Line(points={{130,-200},{142,-200}}, color={0,127,255}));
  connect(VSup_flow.port_b, resSup.port_a)
    annotation (Line(points={{162,-200},{172,-200}}, color={0,127,255}));
  connect(fanSupBlo.port_b, coiHea.port_a)
    annotation (Line(points={{-50,-200},{-40,-200}}, color={0,127,255}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{0,280},{0,276},{-40,276},{-40,260},{-39.8,260}},
      color={255,204,51},
      thickness=0.5));
  connect(pInd_rel.port_b, out.ports[1])
    annotation (Line(points={{10,240},{-40,240}}, color={0,127,255}));
  connect(ind.ports[1], pInd_rel.port_a)
    annotation (Line(points={{40,240},{30,240}},      color={0,127,255}));
  connect(ind.ports[2], pSup_rel.port_bRef) annotation (Line(points={{40,240},{288,
          240},{288,-220},{270,-220},{270,-210}}, color={0,127,255}));

  connect(pInd_rel.p_rel, busAHU.inp.pInd_rel) annotation (Line(points={{20,231},
          {20,0},{-300.1,0},{-300.1,0.1}},     color={0,0,127}));
  connect(conAHU.busTer, busTer) annotation (Line(
      points={{-240,120},{-220,120},{-220,0},{300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conAHU.busAHU, busAHU) annotation (Line(
      points={{-260,120},{-280,120},{-280,0},{-300,0}},
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

  connect(fanSupBlo.busCon, busAHU) annotation (Line(
      points={{-60,-190},{-60,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(fanSupDra.busCon, busAHU) annotation (Line(
      points={{120,-190},{120,0},{-300,0}},
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
  connect(TRet.busCon, busAHU) annotation (Line(
      points={{212,-70},{212,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(hRet.busCon, busAHU) annotation (Line(
      points={{242,-70},{242,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(coiHea.port_b, THea.port_a)
    annotation (Line(points={{-20,-200},{-10,-200}}, color={0,127,255}));
  connect(THea.port_b, coiCoo.port_a)
    annotation (Line(points={{10,-200},{20,-200}}, color={0,127,255}));
  connect(coiCoo.port_b, TCoo.port_a)
    annotation (Line(points={{40,-200},{50,-200}}, color={0,127,255}));
  connect(TCoo.port_b, coiReh.port_a)
    annotation (Line(points={{70,-200},{80,-200}}, color={0,127,255}));
  connect(THea.busCon, busAHU) annotation (Line(
      points={{0,-190},{0,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TCoo.busCon, busAHU) annotation (Line(
      points={{60,-190},{60,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  connect(port_Rel, secOutRel.port_Rel)
    annotation (Line(points={{-300,-80},{-178,-80}}, color={0,127,255}));
  connect(secOutRel.port_Out, port_Out) annotation (Line(points={{-178,-100},{-200,
          -100},{-200,-200},{-300,-200}}, color={0,127,255}));
  connect(secOutRel.port_Sup, TMix.port_a) annotation (Line(points={{-142,-100},
          {-120,-100},{-120,-200},{-100,-200}}, color={0,127,255}));
  connect(secOutRel.port_Ret, resRet.port_b)
    annotation (Line(points={{-142,-80},{170,-80}}, color={0,127,255}));
  connect(secOutRel.port_bPre, out.ports[2]) annotation (Line(points={{-152,-76},
          {-152,-60},{-40,-60},{-40,240},{-40,240}}, color={0,127,255}));
  connect(secOutRel.busCon, busAHU) annotation (Line(
      points={{-160,-76},{-160,0},{-300,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    defaultComponentName="ahu",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
    coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-86,230},{124,210}},
          lineColor={0,127,255},
          pattern=LinePattern.Dash,
          textString="No further connection allowed to those two boundary conditions")}),
    Documentation(info="<html>

Requires building indoor _absolute_ pressure as input


Economizer and fan options options


Common economizer/minimum OA damper

- AFMS required

Dedicated OA damper

- AFMS => modulated OAMin damper
- dp sensor => two-position OAMin damper


Relief fan => Two position relief damper

Return fan

- Modulated relief (exhaust) damper
- For AHUs with return fans, the outdoor air damper remains
fully open whenever the AHU is on. But AO point specified nevertheless.
- Control either return fan discharge pressure (fan) and building pressure (damper),
or airflow (fan) and exhaust damper modulated in tandem with return damper

Modulateded relief damper

- No relief fan
- Control building static pressure



</html>"));
end VAVMultiZone;
