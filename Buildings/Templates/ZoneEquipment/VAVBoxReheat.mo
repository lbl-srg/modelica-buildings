within Buildings.Templates.ZoneEquipment;
model VAVBoxReheat "VAV terminal unit with reheat"
  extends Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal(
    redeclare Buildings.Templates.ZoneEquipment.Data.VAVBox dat(
      typCoiHea=coiHea.typ,
      typValCoiHea=coiHea.typVal,
      typDamVAV=damVAV.typ,
      have_CO2Sen=ctl.have_CO2Sen,
      typCtl=ctl.typ),
    final typ=Buildings.Templates.ZoneEquipment.Types.Configuration.SingleDuct,

    final have_souCoiHea=coiHea.have_sou);

  inner replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
      redeclare final package MediumAir = MediumAir,
      final dat=datCoiHea)
    "Heating coil"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare final package MediumHea = MediumHea)
        "Hot water coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating coiHea
        "Electric heating coil")),
    Dialog(group="Heating coil"),
    Placement(transformation(extent={{-10,-210},{10,-190}})));

  inner replaceable Buildings.Templates.Components.Dampers.PressureIndependent damVAV
    constrainedby
    Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
      redeclare final package Medium = MediumAir,
      final dat=datDamVAV)
    "VAV damper"
    annotation (Dialog(group="VAV damper"),
      choices(
      choice(redeclare replaceable Buildings.Templates.Components.Dampers.Modulating damVAV
        "Modulating damper"),
      choice(redeclare replaceable Buildings.Templates.Components.Dampers.PressureIndependent damVAV
        "Pressure independent damper")),
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-200})));

  inner replaceable Buildings.Templates.ZoneEquipment.Components.Controls.OpenLoop ctl
    constrainedby
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController(
      final dat=dat.ctl)
    "Terminal unit controller"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxReheat ctl
        "Guideline 36 controller for VAV terminal unit with reheat"),
      choice(redeclare replaceable Buildings.Templates.ZoneEquipment.Components.Controls.OpenLoop ctl
        "Open loop control")),
    Dialog(group="Controller"),
    Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Templates.Components.Sensors.Temperature TAirDis(
    redeclare final package Medium = MediumAir,
    final have_sen=ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat,
    final m_flow_nominal=mAir_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard)
    "Discharge air temperature sensor"
    annotation (Placement(transformation(extent={{90,-210},{110,-190}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VAirDis_flow(
    redeclare final package Medium = MediumAir,
    final have_sen=ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat,
    final m_flow_nominal=mAir_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowCross)
    "Airflow sensor"
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
protected
  parameter Buildings.Templates.Components.Data.Damper datDamVAV(
    final typ=damVAV.typ,
    final m_flow_nominal=dat.damVAV.m_flow_nominal,
    final dp_nominal=dat.damVAV.dp_nominal,
    final dpFixed_nominal=if damVAV.typ == Buildings.Templates.Components.Types.Damper.None
         then 0 else dat.coiHea.dpAir_nominal)
    "Local record for VAV damper with lumped flow resistance";
  parameter Buildings.Templates.Components.Data.Coil datCoiHea(
    final typ=coiHea.typ,
    final typVal=coiHea.typVal,
    final have_sou=coiHea.have_sou,
    final mAir_flow_nominal=dat.coiHea.mAir_flow_nominal,
    final mWat_flow_nominal=dat.coiHea.mWat_flow_nominal,
    final dpWat_nominal=dat.coiHea.dpWat_nominal,
    final dpValve_nominal=dat.coiHea.dpValve_nominal,
    final cap_nominal=dat.coiHea.cap_nominal,
    final TWatEnt_nominal=dat.coiHea.TWatEnt_nominal,
    final TAirEnt_nominal=dat.coiHea.TAirEnt_nominal,
    final dpAir_nominal=if damVAV.typ == Buildings.Templates.Components.Types.Damper.None
         then dat.coiHea.dpAir_nominal else 0)
    "Local record for coil with lumped flow resistance";
equation
  /* Control point connection - start */
  connect(damVAV.bus, bus.damVAV);
  connect(coiHea.bus, bus.coiHea);
  connect(TAirDis.y, bus.TAirDis);
  connect(VAirDis_flow.y, bus.VAirDis_flow);
  /* Control point connection - end */
  connect(port_coiHeaSup,coiHea. port_aSou) annotation (Line(points={{20,-280},{
          20,-260},{5,-260},{5,-210}},     color={0,127,255}));
  connect(coiHea.port_bSou,port_coiHeaRet)  annotation (Line(points={{-5,-210},{
          -5,-260},{-20,-260},{-20,-280}},
                                        color={0,127,255}));
  connect(damVAV.port_b,coiHea. port_a)
    annotation (Line(points={{-110,-200},{-10,-200}}, color={0,127,255}));
  connect(bus,ctl. bus) annotation (Line(
      points={{-300,0},{-10,0}},
      color={255,204,51},
      thickness=0.5));
  connect(coiHea.port_b, TAirDis.port_a)
    annotation (Line(points={{10,-200},{90,-200}}, color={0,127,255}));
  connect(TAirDis.port_b, port_Dis)
    annotation (Line(points={{110,-200},{300,-200}}, color={0,127,255}));

  connect(port_Sup, VAirDis_flow.port_a)
    annotation (Line(points={{-300,-200},{-200,-200}}, color={0,127,255}));
  connect(VAirDis_flow.port_b, damVAV.port_a)
    annotation (Line(points={{-180,-200},{-130,-200}}, color={0,127,255}));
  annotation (Diagram(graphics={
        Line(points={{300,-190},{-300,-190}},
                                            color={0,0,0}),
        Line(points={{300,-210},{-300,-210}},
                                            color={0,0,0})}));
end VAVBoxReheat;
