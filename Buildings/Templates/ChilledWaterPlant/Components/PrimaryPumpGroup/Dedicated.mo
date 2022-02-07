within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup;
model Dedicated
  extends
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.PartialPrimaryPumpGroup(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup.Dedicated,
    final nPum=nChi);
  Fluid.FixedResistances.Junction splByp(redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=fill(mTot_flow_nominal, 3),
    final dp_nominal=fill(0, 3))
    "Bypass splitter"               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,0})));
  Buildings.Templates.Components.Valves.TwoWayModulating valByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mTot_flow_nominal,
    final dpValve_nominal=dpByp_nominal) if have_byp
    "Bypass valve" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,-50})));
  inner replaceable Buildings.Templates.Components.Pumps.MultipleVariable pum(
    final nPum=nPum,
    final per=per)
    constrainedby Buildings.Templates.Components.Pumps.Interfaces.PartialPump(
      redeclare final package Medium = Medium,
      final have_singlePort_a=false,
      final have_singlePort_b=true,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal,
      final dpValve_nominal=dpValve_nominal)
                     "Pumps"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VPCHW_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_floSen,
    final m_flow_nominal=m_flow_nominal,
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
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter) if have_comLeg
    "Common leg volume flow rate"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Templates.Components.Sensors.Temperature TPCHWSup(
    redeclare final package Medium = Medium,
    final have_sen=have_TPCHWSup,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m_flow_nominal)
    "Primary chilled water supply temperature"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  /* Control point connection - start */
  connect(valByp.bus, busCon.valByp);
  /* Control point connection - end */
  connect(splByp.port_2, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(splByp.port_3, valByp.port_a) annotation (Line(points={{80,-10},{80,
          -30},{1.77636e-15,-30},{1.77636e-15,-40}},
                                                color={0,127,255}));
  connect(valByp.port_b, port_byp)
    annotation (Line(points={{-1.77636e-15,-60},{0,-100}}, color={0,127,255}));
  connect(ports_parallel, pum.ports_a)
    annotation (Line(points={{-100,0},{-40,0}}, color={0,127,255}));
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
  connect(pum.port_b,TPCHWSup. port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(TPCHWSup.port_b, VPCHW_flow.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(TPCHWSup.y, busCon.TPCHWSup) annotation (Line(points={{10,12},{10,80},
          {0,80},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(valByp.bus, busCon.valByp) annotation (Line(
      points={{-10,-50},{-60,-50},{-60,80},{0,80},{0,100}},
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                    Bitmap(
        extent={{-40,0},{40,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
                    Bitmap(
        extent={{-40,-80},{40,0}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{-100,20},{-60,20},{-60,40},{-6,40}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-100,-20},{-60,-20},{-60,-40},{-6,-40}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{40,60},{60,60},{60,-20},{40,-20}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{60,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dedicated;
