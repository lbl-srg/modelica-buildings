within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup;
model Headered
  extends
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.PartialPrimaryPumpGroup(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup.Headered);

  parameter Modelica.Units.SI.PressureDifference dpChiByp_nominal=
    if have_ChiByp then dat.getReal(varName=id + ".WatersideEconomizer.dpByp_nominal.value")
    else 0;

  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mTot_flow_nominal,
    final nPorts=nPorVol) "Inlet node mixing volume"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Fluid.FixedResistances.Junction splByp(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=fill(mTot_flow_nominal, 3),
    final dp_nominal=fill(0, 3))
    "Common leg or bypass splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,0})));
  Buildings.Templates.Components.Valves.TwoWayModulating valByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mTot_flow_nominal,
    final dpValve_nominal=dpByp_nominal) if have_byp "Bypass valve" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,-50})));
  Buildings.Templates.ChilledWaterPlant.Components.BaseClasses.ParallelPumps pum(
    redeclare final package Medium = Medium,
    final nPum=nPum,
    final per=per,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final dpValve_nominal=dpValve_nominal)
    "Primary pumps"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpChiByp_nominal) if have_ChiByp
    "Chiller chilled water side bypass valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-60})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate V_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_floSen,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
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
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_comLeg
    "Common leg volume flow rate"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Templates.Components.Sensors.Temperature TPCHWSup(
    redeclare final package Medium = Medium,
    final have_sen=have_TPCHWSup,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m_flow_nominal)
    "Primary chilled water supply temperature"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
protected
  parameter Integer nPorWSE = if have_ChiByp then 1 else 0;
  parameter Integer nPorChi = if have_ParChi then nChi else 1;
  parameter Integer nPorVol = nPorWSE + nPorChi + 1;
equation
  /* Control point connection - start */
  connect(valChiByp.bus, busCon.valChiByp);
  connect(valByp.bus, busCon.valByp);
  /* Control point connection - end */

  connect(splByp.port_2, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(splByp.port_3, valByp.port_a) annotation (Line(points={{80,-10},{80,-30},
          {1.77636e-15,-30},{1.77636e-15,-40}}, color={0,127,255}));
  connect(valByp.port_b, port_byp)
    annotation (Line(points={{-1.83187e-15,-60},{0,-100}}, color={0,127,255}));
  connect(pum.y_actual, busCon.uStaPumPri) annotation (Line(points={{-19,8},{-10,
          8},{-10,80},{0,80},{0,100}},
                                   color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(del.ports[1],pum.port_a) annotation (Line(points={{-60,40},{-60,0},{-40,
          0}},             color={0,127,255}));
  connect(del.ports[2],port_series) annotation (Line(points={{-60,40},{-60,30},{
          -86,30},{-86,60},{-100,60}},          color={0,127,255}));
  connect(del.ports[2:(nChi+1)],ports_parallel) annotation (Line(points={{-60,40},
          {-60,0},{-100,0}},          color={0,127,255}));
  connect(del.ports[nPorVol], valChiByp.port_b) annotation (Line(points={{-60,40},
          {-60,-60},{-70,-60}},          color={0,127,255}));
  connect(port_ChiByp, valChiByp.port_a)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(V_flow.port_b, splByp.port_1)
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(V_flow.y, busCon.V_flow) annotation (Line(points={{50,12},{50,80},{0,80},
          {0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(splByp.port_3, pas.port_a)
    annotation (Line(points={{80,-10},{80,-50}}, color={0,127,255}));
  connect(busCon.ySpe, pum.y) annotation (Line(
      points={{0,100},{0,80},{-30,80},{-30,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
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
  connect(TPCHWSup.port_b, V_flow.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(TPCHWSup.y, busCon.TPCHWSup) annotation (Line(points={{10,12},{10,80},
          {0,80},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
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
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Headered;
