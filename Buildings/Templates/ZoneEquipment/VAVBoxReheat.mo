within Buildings.Templates.ZoneEquipment;
model VAVBoxReheat "VAV terminal unit with reheat"
  extends Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal(
    final typ=Buildings.Templates.ZoneEquipment.Types.Configuration.SingleDuct,
    final have_souCoiHea=coiHea.have_sou);

  parameter Modelica.Units.SI.PressureDifference dpDamVAV_nominal=
    dat.getReal(varName=id + ".mechanical.dpDamVAV_nominal.value")
    "Damper pressure drop"
    annotation (Dialog(group="Nominal condition"));

  inner replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
    final mAir_flow_nominal=mAir_flow_nominal)
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil
    "Heating coil"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea
        "Hot water coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating coiHea
        "Electric heating coil")),
    Dialog(group="Heating coil"),
    Placement(transformation(extent={{-10,-210},{10,-190}})));

  inner replaceable Buildings.Templates.Components.Dampers.PressureIndependent damVAV
    constrainedby
    Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
      redeclare final package Medium = MediumAir,
      final m_flow_nominal=mAir_flow_nominal,
      final dpDamper_nominal=dpDamVAV_nominal)
    "VAV damper"
    annotation (Dialog(group="VAV damper"),
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-200})));

  inner replaceable Buildings.Templates.ZoneEquipment.Components.Controls.OpenLoop ctr
    constrainedby
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController
    "Terminal unit controller"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxReheat ctr
        "Guideline 36 controller for VAV terminal unit with reheat"),
      choice(redeclare replaceable Buildings.Templates.ZoneEquipment.Components.Controls.OpenLoop ctr
        "Open loop control")),
    Dialog(group="Controller"),
    Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Templates.Components.Sensors.Temperature TAirDis(
    redeclare final package Medium = MediumAir,
    final have_sen=ctr.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat,
    final m_flow_nominal=mAir_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard)
    "Discharge air temperature sensor"
    annotation (Placement(transformation(extent={{90,-210},{110,-190}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VAirDis_flow(
    redeclare final package Medium = MediumAir,
    final have_sen=ctr.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat,
    final m_flow_nominal=mAir_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowCross)
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
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
  connect(bus,ctr. bus) annotation (Line(
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
