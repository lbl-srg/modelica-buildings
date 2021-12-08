within Buildings.Templates.AirHandlersFans;
model VAVMultiZone "Multiple-Zone VAV"
  extends Buildings.Templates.AirHandlersFans.Interfaces.AirHandler(
    nZon(min=2),
    final typ=Buildings.Templates.AirHandlersFans.Types.Configuration.SingleDuct,
    final have_porRel=secOutRel.typ <> Types.OutdoorReliefReturnSection.EconomizerNoRelief);

  inner replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)"
    annotation(Dialog(enable=have_souCoiCoo));
  inner replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)"
    annotation(Dialog(enable=have_souCoiHea or have_souCoiReh));

  parameter Modelica.SIunits.PressureDifference dpFanSup_nominal=
    if typFanSup<>Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".Mechanical.Supply fan.Total pressure rise.value")
    else 0
    "Supply fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition",
        enable=typFanSup <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.SIunits.PressureDifference dpFanRet_nominal=
    if typFanRel <> Buildings.Templates.Components.Types.Fan.None or
      typFanRet <> Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".Mechanical.Relief/return fan.Total pressure rise.value")
    else 0
    "Relief/return fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));

  final inner parameter Boolean have_souCoiCoo = coiCoo.have_sou
    "Set to true if cooling coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  final parameter Boolean have_souCoiHea = coiHea.have_sou
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Heating coil"));
  final parameter Boolean have_souCoiReh=coiReh.have_sou
    "Set to true if reheat coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Reheat coil"));

  final inner parameter Buildings.Templates.Components.Types.Fan typFanSup=if
      fanSupDra.typ <> Buildings.Templates.Components.Types.Fan.None then
      fanSupDra.typ elseif fanSupBlo.typ <> Buildings.Templates.Components.Types.Fan.None
      then fanSupBlo.typ else Buildings.Templates.Components.Types.Fan.None
    "Type of supply fan" annotation (Evaluate=true);
  final inner parameter Buildings.Templates.Components.Types.Fan typFanRet=
    secOutRel.typFanRet
    "Type of return fan"
    annotation (Evaluate=true);
  final inner parameter Buildings.Templates.Components.Types.Fan typFanRel=
    secOutRel.typFanRel
    "Type of relief fan"
    annotation (Evaluate=true);
  final parameter Buildings.Templates.AirHandlersFans.Types.ControlEconomizer typCtrEco=
    con.typCtrEco
    "Economizer control type"
    annotation (Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
    redeclare final package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil return port"
    annotation (Placement(
      transformation(extent={{50,-290},{70,-270}}),
      iconTransformation(extent={{50,-208},{70,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
    redeclare final package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil supply port"
    annotation (Placement(
        transformation(extent={{90,-290},{110,-270}}),iconTransformation(
          extent={{10,-208},{30,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHeaRet(
    redeclare final package Medium =MediumHea) if have_souCoiHea
    "Heating coil return port"
    annotation (Placement(transformation(extent={{-30,-290},{-10,-270}}),
                                iconTransformation(extent={{-40,-208},{-20,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHeaSup(
    redeclare final package Medium =MediumHea) if have_souCoiHea
    "Heating coil supply port"
    annotation (Placement(transformation(extent={{10,-290},{30,-270}}),
                                iconTransformation(extent={{-80,-208},{-60,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiRehRet(
    redeclare final package Medium =MediumHea) if have_souCoiReh
    "Reheat coil return port"
    annotation (Placement(transformation(extent={{130,-290},{150,-270}}),
                          iconTransformation(extent={{140,-208},{160,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiRehSup(
    redeclare final package Medium = MediumHea) if have_souCoiReh
    "Reheat coil supply port"
    annotation (Placement(transformation(extent={{170,-290},{190,-270}}),
                         iconTransformation(extent={{100,-208},{120,-188}})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,260},{20,300}}),
      iconTransformation(extent={{-20,182},{20,218}})));

  /*
  Currently only the configuration with economizer is supported:
  hence, no choices annotation.
  */
  inner replaceable Components.OutdoorReliefReturnSection.Economizer secOutRel
    constrainedby
    Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection(
      redeclare final package MediumAir = MediumAir,
      final mSup_flow_nominal=mSup_flow_nominal,
      final mRet_flow_nominal=mRet_flow_nominal,
      final dpFan_nominal=dpFanRet_nominal,
      final typCtrFanRet=con.typCtrFanRet,
      final typCtrEco=typCtrEco)
    "Outdoor/relief/return air section"
    annotation (
      Dialog(group="Outdoor/relief/return air section"),
      Placement(transformation(extent={{-280,-220},{-120,-60}})));

  Buildings.Templates.Components.Sensors.Temperature TMix(
    redeclare final package Medium = MediumAir,
    final have_sen=con.use_TMix,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mSup_flow_nominal)
    "Mixed air temperature sensor"
    annotation (Dialog(group=
          "Supply air section", enable=false), Placement(transformation(extent={{-110,
            -210},{-90,-190}})));

  inner replaceable Buildings.Templates.Components.Fans.None fanSupBlo
    constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
      redeclare final package Medium =  MediumAir,
      final m_flow_nominal=mSup_flow_nominal,
      final dp_nominal=dpFanSup_nominal,
      final have_senFlo=con.typCtrFanSup==
        Buildings.Templates.AirHandlersFans.Types.ControlFanSupply.Airflow)
    "Supply fan - Blow through"
    annotation (
      choices(
        choice(redeclare replaceable Buildings.Templates.Components.Fans.None fanSupBlo
          "No fan"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupBlo
          "Single fan - Variable speed"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable fanSupBlo
          "Fan array - Variable speed")),
      Dialog(group="Supply air section",
        enable=fanSupDra.typ==Buildings.Templates.Components.Types.Fan.None),
      Placement(transformation(extent={{-50,-210},{-30,-190}})));

  .Buildings.Templates.Components.Sensors.Temperature THea(
    redeclare final package Medium = MediumAir,
    final have_sen=coiHea.typ <> Buildings.Templates.Components.Types.Coil.None
         and coiCoo.typ <> Buildings.Templates.Components.Types.Coil.None,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mSup_flow_nominal)
    "Heating coil leaving air temperature sensor"
    annotation (Dialog(group="Supply air section", enable=false),
      Placement(transformation(extent={{40,-210},{60,-190}})));

  Buildings.Templates.Components.Sensors.Temperature TCoo(
    redeclare final package Medium = MediumAir,
    final have_sen=coiCoo.typ <> Buildings.Templates.Components.Types.Coil.None
         and coiReh.typ <> Buildings.Templates.Components.Types.Coil.None,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mSup_flow_nominal)
    "Cooling coil leaving air temperature sensor"
    annotation (Dialog(group=
          "Supply air section", enable=false), Placement(transformation(extent={{100,
            -210},{120,-190}})));

  inner replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupDra
    constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
      redeclare final package Medium = MediumAir,
      final m_flow_nominal=mSup_flow_nominal,
      final dp_nominal=dpFanSup_nominal,
      final have_senFlo=con.typCtrFanSup==
        Buildings.Templates.AirHandlersFans.Types.ControlFanSupply.Airflow)
    "Supply fan - Draw through"
    annotation (
      choices(
        choice(redeclare replaceable Buildings.Templates.Components.Fans.None fanSupDra
          "No fan"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupDra
          "Single fan - Variable speed"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable fanSupDra
          "Fan array - Variable speed")),
    Dialog(group="Supply air section",
      enable=fanSupBlo.typ==Buildings.Templates.Components.Types.Fan.None),
    Placement(transformation(extent={{172,-210},{192,-190}})));

  // FIXME: bind have_sen to control option.

  inner replaceable Components.Controls.OpenLoop con constrainedby
    Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialSingleDuct
    "AHU controller"
    annotation (
      choices(
        choice(redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.Guideline36 con
          "Guideline 36 control sequence"),
        choice(redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.OpenLoop con
          "Open loop control")),
    Dialog(group="Controls"),
    Placement(transformation(extent={{-260,110},{-240,130}})));

  /* FIXME: Dummy default values fo testing purposes only.
  Compute based on design pressure drop of each piece of equipment
  in case of a lumped pressure drop.
  */
  Fluid.FixedResistances.PressureDrop resRet(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mRet_flow_nominal,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
  Fluid.FixedResistances.PressureDrop resSup(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mSup_flow_nominal,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-20,-210},{0,-190}})));

  Buildings.Templates.Components.Sensors.Temperature TSup(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard,
    final m_flow_nominal=mSup_flow_nominal)
    "Supply air temperature sensor"
    annotation (Dialog(group="Supply air section", enable=false),
      Placement(transformation(extent={{210,-210},{230,-190}})));

  // FIXME: bind have_sen to control option.
  Buildings.Templates.Components.Sensors.DifferentialPressure pSup_rel(
    redeclare final package Medium = MediumAir,
    have_sen=true,
    final m_flow_nominal=mSup_flow_nominal)
    "Duct static pressure sensor"
    annotation (Dialog(group="Supply air section",
        enable=false), Placement(transformation(extent={{250,-230},{270,-210}})));

  // FIXME: condition to control option.
  Buildings.Fluid.Sensors.RelativePressure pInd_rel(
    redeclare final package Medium=MediumAir)
    "Building static pressure"
    annotation (Placement(transformation(extent={{30,230},{10,250}})));

  Buildings.Fluid.Sources.Outside out(
    redeclare final package Medium=MediumAir,
    final nPorts=2)
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,250})));
  Buildings.Fluid.Sources.Boundary_pT ind(
    redeclare final package Medium = MediumAir,
    final use_p_in=true,
    final nPorts=2)
    "Indoor pressure"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,250})));

  Buildings.Templates.Components.Sensors.Temperature TRet(
    redeclare final package Medium = MediumAir,
    final have_sen=
      con.typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialDryBulb or
      con.typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedDryBulbWithDifferentialDryBulb,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard,
    final m_flow_nominal=mRet_flow_nominal)
    "Return air temperature sensor"
    annotation (Dialog(group=
          "Exhaust/relief/return section", enable=false), Placement(
        transformation(extent={{220,-90},{200,-70}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hRet(
    redeclare final package Medium = MediumAir,
    final have_sen=
      con.typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=mRet_flow_nominal)
    "Return air enthalpy sensor"
    annotation (Dialog(group=
          "Exhaust/relief/return section", enable=false), Placement(
        transformation(extent={{250,-90},{230,-70}})));
  inner replaceable .Buildings.Templates.Components.Coils.None coiHea
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
    final fun=Buildings.Templates.Components.Types.CoilFunction.Heating)
    "Heating coil"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.None coiHea
        "No coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea
        "Water-based")),
    Dialog(group="Heating coil"),
    Placement(transformation(extent={{10,-210},{30,-190}})));
  inner replaceable Buildings.Templates.Components.Coils.None coiCoo
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
    final fun=Buildings.Templates.Components.Types.CoilFunction.Cooling)
    "Cooling coil"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.None coiCoo
        "No coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo
        "Water-based")),
    Dialog(group="Cooling coil"),
    Placement(transformation(extent={{70,-210},{90,-190}})));
  inner replaceable Buildings.Templates.Components.Coils.None coiReh
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
    final fun=Buildings.Templates.Components.Types.CoilFunction.Reheat)
    "Reheat coil"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.None coiReh
        "No coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiReh
        "Water-based")),
    Dialog(group="Reheat coil"),
    Placement(transformation(extent={{130,-210},{150,-190}})));
equation
  connect(TMix.y, bus.TMix);
  connect(THea.y, bus.THea);
  connect(TSup.y, bus.TSup);
  connect(pSup_rel.y, bus.pSup_rel);
  connect(hRet.y, bus.hRet);
  connect(TRet.y, bus.TRet);
  connect(pInd_rel.p_rel, bus.pInd_rel);
  connect(fanSupDra.bus, bus.fanSup);
  connect(fanSupBlo.bus, bus.fanSup);
  connect(coiHea.bus, bus.coiHea);
  connect(coiCoo.bus, bus.coiCoo);
  connect(coiReh.bus, bus.coiHea);
  connect(secOutRel.bus, bus);

  connect(coiHea.port_bSou, port_coiHeaRet) annotation (Line(points={{15,-210},{
          15,-260},{-20,-260},{-20,-280}},   color={0,127,255}));
  connect(port_coiHeaSup, coiHea.port_aSou) annotation (Line(points={{20,-280},{
          20,-260},{25,-260},{25,-210}},     color={0,127,255}));
  connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{100,-280},
          {100,-260},{85,-260},{85,-210}}, color={0,127,255}));
  connect(coiCoo.port_bSou, port_coiCooRet) annotation (Line(points={{75,-210},{
          75,-260},{60,-260},{60,-280}}, color={0,127,255}));
  connect(busWea,coiCoo.busWea)  annotation (Line(
      points={{0,280},{0,80},{74,80},{74,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(TMix.port_b, fanSupBlo.port_a)
    annotation (Line(points={{-90,-200},{-50,-200}},   color={0,127,255}));
  connect(port_coiRehSup, coiReh.port_aSou) annotation (Line(points={{180,-280},
          {180,-260},{145,-260},{145,-210}},
                                         color={0,127,255}));
  connect(coiReh.port_bSou, port_coiRehRet) annotation (Line(points={{135,-210},
          {135,-260},{140,-260},{140,-280}},
                                           color={0,127,255}));
  connect(coiReh.port_b, fanSupDra.port_a)
    annotation (Line(points={{150,-200},{172,-200}}, color={0,127,255}));
  connect(busWea, out.weaBus) annotation (Line(
      points={{0,280},{0,276},{-40,276},{-40,260},{-39.8,260}},
      color={255,204,51},
      thickness=0.5));
  connect(pInd_rel.port_b, out.ports[1])
    annotation (Line(points={{10,240},{-41,240}}, color={0,127,255}));
  connect(ind.ports[1], pInd_rel.port_a)
    annotation (Line(points={{39,240},{30,240}}, color={0,127,255}));

  connect(con.busTer, busTer) annotation (Line(
      points={{-240,120},{-220,120},{-220,0},{300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(con.bus, bus) annotation (Line(
      points={{-260,120},{-280,120},{-280,0},{-300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.pInd, ind.p_in) annotation (Line(
      points={{-300,0},{60,0},{60,268},{48,268},{48,262}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(resRet.port_a, TRet.port_b)
    annotation (Line(points={{190,-80},{200,-80}}, color={0,127,255}));
  connect(port_Ret, hRet.port_a)
    annotation (Line(points={{300,-80},{250,-80}}, color={0,127,255}));
  connect(hRet.port_b, TRet.port_a)
    annotation (Line(points={{230,-80},{220,-80}}, color={0,127,255}));
  connect(coiHea.port_b, THea.port_a)
    annotation (Line(points={{30,-200},{40,-200}},   color={0,127,255}));
  connect(THea.port_b, coiCoo.port_a)
    annotation (Line(points={{60,-200},{70,-200}}, color={0,127,255}));
  connect(coiCoo.port_b, TCoo.port_a)
    annotation (Line(points={{90,-200},{100,-200}},color={0,127,255}));
  connect(TCoo.port_b, coiReh.port_a)
    annotation (Line(points={{120,-200},{130,-200}},
                                                   color={0,127,255}));
  connect(secOutRel.port_Sup, TMix.port_a) annotation (Line(points={{-120,-200},
          {-110,-200}},                         color={0,127,255}));
  connect(secOutRel.port_Ret, resRet.port_b)
    annotation (Line(points={{-120,-80.2},{10,-80.2},{10,-80},{170,-80}},
                                                    color={0,127,255}));
  connect(secOutRel.port_bPre, out.ports[2]) annotation (Line(points={{-162,-60},
          {-162,-60},{-39,-60},{-39,240}},           color={0,127,255}));
  connect(port_Rel, secOutRel.port_Rel)
    annotation (Line(points={{-300,-80},{-280,-80}}, color={0,127,255}));
  connect(port_Out, secOutRel.port_Out)
    annotation (Line(points={{-300,-200},{-280,-200}}, color={0,127,255}));
  connect(ind.ports[2], pSup_rel.port_b) annotation (Line(points={{41,240},{280,
          240},{280,-220},{270,-220}}, color={0,127,255}));
  connect(TSup.port_b, port_Sup)
    annotation (Line(points={{230,-200},{300,-200}}, color={0,127,255}));
  connect(TSup.port_b, pSup_rel.port_a) annotation (Line(points={{230,-200},{240,
          -200},{240,-220},{250,-220}},     color={0,127,255}));
  connect(fanSupBlo.port_b, resSup.port_a)
    annotation (Line(points={{-30,-200},{-20,-200}}, color={0,127,255}));
  connect(resSup.port_b, coiHea.port_a)
    annotation (Line(points={{0,-200},{10,-200}}, color={0,127,255}));
  connect(fanSupDra.port_b, TSup.port_a)
    annotation (Line(points={{192,-200},{210,-200}}, color={0,127,255}));
  annotation (
    defaultComponentName="ahu",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
    coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-86,230},{124,210}},
          lineColor={0,127,255},
          pattern=LinePattern.Dash,
          textString="No further connection allowed to those two boundary conditions"),
        Line(
          points={{250,-206},{250,-220},{256,-220}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{264,-220},{270,-220}},
          color={0,0,0},
          thickness=1),
        Bitmap(extent={{-84,-210},{-76,-190}}, fileName="modelica://Buildings/Resources/Images/Templates/Components/Filters/Filter.svg"),
        Bitmap(extent={{-84,-224},{-76,-216}}, fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
        Line(
          points={{-90,-206},{-90,-220},{-84,-220}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-70,-206},{-70,-220},{-76,-220}},
          color={0,0,0},
          thickness=1),
        Line(points={{300,-70},{-120,-70}}, color={0,0,0}),
        Line(points={{300,-90},{-120,-90}}, color={0,0,0}),
        Line(points={{300,-210},{-120,-210}}, color={0,0,0}),
        Line(points={{300,-190},{-120,-190}}, color={0,0,0})}),
    Documentation(info="<html>
  connect(fanSupDra.bus, bus.fanSup);
  connect(fanSupBlo.bus, bus.fanSup);

Same for coiReh and coiHea: we can manage the same variable name for the control signal for different variants of equipment that correspond to different component names.


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
