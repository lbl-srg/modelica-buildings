within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps;
model Headered "Headered primary pumps"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Interfaces.PartialPrimaryPump(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPump.Headered,
    final have_conSpePum=pum.typ == Buildings.Templates.Components.Types.Pump.Constant,
    pum(final have_singlePort_a=true));

  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.m_flow_nominal,
    nPorts=nPorVol)
    "Inlet node mixing volume"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.m_flow_nominal,
    final dpValve_nominal=dat.dpChiByp_nominal) if have_chiByp
    "Chiller chilled water side bypass valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-60})));

  inner replaceable Buildings.Templates.Components.Valves.TwoWayModulating valChiWatChi[nChi]
    if have_parChi
    constrainedby Buildings.Templates.Components.Valves.TwoWayModulating(
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=dat.pum.m_flow_nominal,
    each final dpValve_nominal=dat.dpChiWatChiValve_nominal)
    "Chiller chilled water-side isolation valves"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=0,origin={-80,0})));
protected
  parameter Integer nPorEco = if have_chiByp then 1 else 0;
  parameter Integer nPorChi = if have_parChi then nChi else 1;
  parameter Integer nPorVol = nPorEco + nPorChi + 1;
equation
  connect(port_ChiByp, valChiByp.port_a)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(valChiByp.bus, busCon.valChiByp) annotation (Line(
      points={{-80,-50},{-80,-40},{-20,-40},{-20,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ports_parallel, valChiWatChi.port_b)
    annotation (Line(points={{-100,0},{-90,0}},color={0,127,255}));

  connect(del.ports[1], pum.port_a)
    annotation (Line(points={{-60,40},{-60,0},{-50,0}}, color={0,127,255}));
  connect(del.ports[2],port_series)
    annotation (Line(
      points={{-60,40},{-60,40},{-60,28},{-86,28},{-86,60},{-100,60}},
      color={0,127,255}));
  connect(del.ports[2:nChi+1], valChiWatChi.port_a)
    annotation (Line(points={{-60,40},{-60,0},{-70,0}}, color={0,127,255}));
  connect(del.ports[nPorVol], valChiByp.port_b)
    annotation (Line(points={{-60,40},{-60,-60},{-70,-60}},
      color={0,127,255}));

  connect(valChiWatChi.bus, busCon.valChiWatChi)
    annotation (Line(
      points={{-80,10},{-80,80},{0.1,80},{0.1,100.1}},
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
