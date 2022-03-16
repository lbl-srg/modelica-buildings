within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup;
model Headered
  extends
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.PartialPrimaryPumpGroup(
    dat(typ=Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup.Headered));

  inner replaceable Buildings.Templates.Components.Pumps.MultipleVariable pum
    constrainedby Buildings.Templates.Components.Pumps.Interfaces.PartialPump(
      redeclare final package Medium = Medium,
      final nPum=nPum,
      final have_singlePort_a=true,
      final have_singlePort_b=true,
      final dat=dat.pum) "Pumps"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.m_flow_nominal,
    nPorts=nPorVol) "Inlet node mixing volume"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Fluid.FixedResistances.Junction splByp(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=fill(dat.m_flow_nominal, 3),
    final dp_nominal=fill(0, 3))
    "Common leg or bypass splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,0})));
  Buildings.Templates.Components.Valves.TwoWayModulating valByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.m_flow_nominal,
    final dpValve_nominal=dat.dpByp_nominal) if have_byp "Bypass valve" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,-50})));
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.m_flow_nominal,
    final dpValve_nominal=dat.dpChiByp_nominal) if have_chiByp
    "Chiller chilled water side bypass valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-60})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VPCHW_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_floSen,
    final m_flow_nominal=dat.m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Primary chilled water volume flow rate"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Templates.BaseClasses.PassThroughFluid pas(redeclare each final
      package Medium = Medium) if have_comLeg annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-60})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VComLeg_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_comLegFloSen,
    final m_flow_nominal=dat.m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_comLeg
    "Common leg volume flow rate"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Templates.Components.Sensors.Temperature TPCHWSup(
    redeclare final package Medium = Medium,
    final have_sen=have_TPCHWSup,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.m_flow_nominal)
    "Primary chilled water supply temperature"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  inner replaceable Buildings.Templates.Components.Valves.TwoWayModulating valCHWChi[nChi]
    if have_parChi
    constrainedby Buildings.Templates.Components.Valves.TwoWayModulating(
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=dat.pum.m_flow_nominal,
    each final dpValve_nominal=dat.dpCHWValve_nominal)
    "Chiller chilled water-side isolation valves"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=0,origin={-80,0})));
protected
  parameter Integer nPorWSE = if have_chiByp then 1 else 0;
  parameter Integer nPorChi = if have_parChi then nChi else 1;
  parameter Integer nPorVol = nPorWSE + nPorChi + 1;
equation
  /* Control point connection - start */
  connect(valChiByp.bus, busCon.valChiByp);
  connect(valByp.bus, busCon.valByp);
  /* Control point connection - end */

  connect(splByp.port_2, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(splByp.port_3, valByp.port_a) annotation (Line(points={{80,-10},{80,
          -30},{0,-30},{0,-40}}, color={0,127,255}));
  connect(valByp.port_b, port_byp)
    annotation (Line(points={{0,-60},{0,-100}}, color={0,127,255}));
  connect(port_ChiByp, valChiByp.port_a)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(VPCHW_flow.port_b, splByp.port_1)
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(VPCHW_flow.y, busCon.VPCHW_flow) annotation (Line(points={{50,12},{50,80},
          {0,80},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(splByp.port_3, pas.port_a)
    annotation (Line(points={{80,-10},{80,-50}}, color={0,127,255}));
  connect(port_byp, VComLeg_flow.port_a)
    annotation (Line(points={{0,-100},{0,-80},{20,-80}}, color={0,127,255}));
  connect(VComLeg_flow.port_b, pas.port_b)
    annotation (Line(points={{40,-80},{80,-80},{80,-70}}, color={0,127,255}));
  connect(VComLeg_flow.y, busCon.VComLeg_flow) annotation (Line(points={{30,-68},
          {30,80},{0,80},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pum.port_b, TPCHWSup.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(TPCHWSup.port_b, VPCHW_flow.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(TPCHWSup.y, busCon.TPCHWSup) annotation (Line(points={{10,12},{10,80},
          {0,80},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(valChiByp.bus, busCon.valChiByp) annotation (Line(
      points={{-80,-50},{-80,-30},{-48,-30},{-48,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(valByp.bus, busCon.valByp) annotation (Line(
      points={{-10,-50},{-48,-50},{-48,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pum.bus, busCon.pumPri) annotation (Line(
      points={{-30,10},{-30,80},{0.1,80},{0.1,100.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ports_parallel, valCHWChi.port_b)
    annotation (Line(points={{-100,0},{-90,0}},                         color={0,127,255}));
  connect(del.ports[1],pum.port_a)
    annotation (Line(points={{-60,40},{-60,0},{-40,0}}, color={0,127,255}));
  connect(del.ports[2],port_series)
    annotation (Line(points={{-60,40},{-60,40},{-60,28},{-86,28},{-86,60},{-100,60}}, color={0,127,255}));
  connect(del.ports[2:nChi+1], valCHWChi.port_a)
    annotation (Line(points={{-60,40},{-60,0},{-70,0}}, color={0,127,255}));
  connect(del.ports[nPorVol], valChiByp.port_b)
    annotation (Line(points={{-60,40},{-60,-60},{-70,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                    Bitmap(
        extent={{-40,0},{40,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
                    Bitmap(
        extent={{-40,-80},{40,0}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{40,60},{60,60},{60,-20},{40,-20}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{60,0},{100,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-8,40},{-60,40},{-60,-40},{-8,-40}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-60,0},{-100,0}},
          color={28,108,200},
          thickness=1)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Headered;
