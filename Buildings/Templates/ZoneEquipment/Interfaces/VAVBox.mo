within Buildings.Templates.ZoneEquipment.Interfaces;
model VAVBox "Interface class for VAV terminal unit"
  extends Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal(
    redeclare final Buildings.Templates.ZoneEquipment.Configuration.VAVBox cfg(
      typCoiHea=coiHea.typ,
      typValCoiHea=coiHea.typVal,
      typDamVAV=damVAV.typ,
      typCtl=ctl.typ,
      stdVen=ctl.stdVen),
    redeclare Buildings.Templates.ZoneEquipment.Data.VAVBox dat,
    final have_souChiWat=false,
    final have_souHeaWat=coiHea.have_sou,
    final mAirPri_flow_nominal=mAir_flow_nominal,
    final mChiWat_flow_nominal=0,
    final mHeaWat_flow_nominal=if coiHea.have_sou then dat.coiHea.mWat_flow_nominal else 0,
    final QChiWat_flow_nominal=0,
    final QHeaWat_flow_nominal=if coiHea.have_sou then dat.coiHea.Q_flow_nominal else 0);

  inner replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
      redeclare final package MediumHeaWat = MediumHeaWat,
      redeclare final Buildings.Templates.Components.Valves.TwoWayModulating val)
    constrainedby Buildings.Templates.Components.Interfaces.PartialCoil(
      redeclare final package MediumAir = MediumAir,
      final dat=datCoiHea,
      final energyDynamics=energyDynamics,
      final allowFlowReversalAir=allowFlowReversalAir,
      final allowFlowReversalLiq=allowFlowReversalLiq,
      final show_T=show_T)
    "Heating coil"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
        redeclare final package MediumHeaWat = MediumHeaWat,
        redeclare final Buildings.Templates.Components.Valves.TwoWayModulating val)
        "Hot water coil with two-way valve"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating coiHea
        "Modulating electric heating coil")),
    Dialog(group="Configuration"),
    Placement(transformation(extent={{-10,-210},{10,-190}})));

  inner replaceable Buildings.Templates.Components.Dampers.Modulating damVAV
    constrainedby Buildings.Templates.Components.Interfaces.PartialDamper(
      redeclare final package Medium = MediumAir,
      use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
      final allowFlowReversal=allowFlowReversalAir,
      final show_T=show_T,
      final dat=datDamVAV)
    "VAV damper"
    annotation (Dialog(group="Configuration"),
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-200})));

  inner replaceable Buildings.Templates.ZoneEquipment.Components.Controls.OpenLoop ctl
    constrainedby
    Buildings.Templates.ZoneEquipment.Components.Interfaces.PartialControllerVAVBox(
      final dat=dat.ctl)
    "Control selections"
    annotation (
    Dialog(group="Controller"),
    Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Templates.Components.Sensors.Temperature TAirDis(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversalAir,
    final have_sen=ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
      ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly,
    final m_flow_nominal=mAir_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard)
    "Discharge air temperature sensor"
    annotation (Placement(transformation(extent={{90,-210},{110,-190}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VAirDis_flow(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversalAir,
    final have_sen=ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
      ctl.typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly,
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
  connect(port_aHeaWat, coiHea.port_aSou) annotation (Line(points={{20,-280},{
          20,-260},{5,-260},{5,-210}}, color={0,127,255}));
  connect(coiHea.port_bSou, port_bHeaWat) annotation (Line(points={{-5,-210},{-5,
          -260},{-20,-260},{-20,-280}}, color={0,127,255}));
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
        Line(points={{300,-190},{-300,-190}}, color={0,0,0}),
        Line(points={{300,-210},{-300,-210}}, color={0,0,0})}),
  defaultComponentName="VAVBox",
    Documentation(info="<html>
<p>
This partial class provides a standard interface for VAV terminal unit templates.
</p>
</html>", revisions="<html>
<ul>
<li>
September 5, 2023, by Antoine Gautier:<br/>
Refactored with a record class for configuration parameters.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3500\">#3500</a>.
</li>
<li>
February 11, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-200,20},{200,-20}},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,127,127},
          lineColor={0,127,127}),
        Ellipse(
          extent={{-134,4},{-126,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0}),
        Line(
          points={{-120,20},{-140,-20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{50,-200},{50,-194},{14,-194},{14,-20}},
          color={238,46,47},
          thickness=5,
          visible=have_souHeaWat),
        Line(
          points={{-50,-200},{-50,-194},{-12,-194},{-12,-20}},
          color={238,46,47},
          thickness=5,
          visible=have_souHeaWat,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-14,20},{16,-20}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          visible=coiHea.typ <> Buildings.Templates.Components.Types.Coil.None),
        Line(
          points={{16,20},{-14,-20}},
          color={0,0,0},
          thickness=0.5,
          visible=coiHea.typ <> Buildings.Templates.Components.Types.Coil.None)}));
end VAVBox;
