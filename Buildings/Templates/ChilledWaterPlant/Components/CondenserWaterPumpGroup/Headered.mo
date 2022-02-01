within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup;
model Headered
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.PartialCondenserWaterPumpGroup(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup.Headered);

  parameter Modelica.Units.SI.PressureDifference dpWSEValve_nominal=
    if have_WSE then
    dat.getReal(varName=id + ".WatersideEconomizer.dpCW_nominal.value")
    else 0
    "Waterside economizer bypass valve pressure drop";

  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mTot_flow_nominal,
    final nPorts=nPorVol) "Outlet node mixing volume"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));

  inner replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition valCWChi[nChi]
    constrainedby Buildings.Templates.Components.Valves.Interfaces.PartialValve(
    redeclare each final package Medium = Medium,
    each final m_flow_nominal=mTot_flow_nominal/nChi,
    each final dpValve_nominal=dpValve_nominal)
    "Chiller condenser water-side isolation valves" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})),
      choices(
        choice(redeclare replaceable Buildings.Templates.Components.Valves.TwoWayModulating valCWChi
          "Modulating"),
        choice(redeclare replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition valCWChi
          "Two-positions")));
  inner replaceable Buildings.Templates.Components.Pumps.MultipleVariable pum(
    final nPum=nPum,
    final per=per)
    constrainedby Buildings.Templates.Components.Pumps.Interfaces.PartialPump(
      redeclare final package Medium = Medium,
      final has_singlePort_a=true,
      final has_singlePort_b=true,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal,
      final dpValve_nominal=dpValve_nominal)
    "Condenser pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Buildings.Templates.Components.Valves.TwoWayModulating valCWWSE if have_WSE
    constrainedby Buildings.Templates.Components.Valves.Interfaces.PartialValve(
      redeclare final package Medium = Medium,
      final m_flow_nominal=mTot_flow_nominal,
      final dpValve_nominal=dpWSEValve_nominal)
    "Waterside economizer valve on condenser water side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-60})));
protected
  parameter Integer nPorWSE = if have_WSE then 1 else 0;
  parameter Integer nPorVol = nPorWSE + nChi + 1;
equation
  connect(valCWChi.port_b, ports_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(del.ports[1], pum.port_b) annotation (Line(points={{40,40},{40,40},{40,
          0},{10,0}}, color={0,127,255}));
  connect(del.ports[2:(nChi + 1)], valCWChi.port_a) annotation (Line(points={{40,
          40},{40,40},{40,0},{60,0}}, color={0,127,255}));
  connect(del.ports[nPorVol], valCWWSE.port_a)
    annotation (Line(points={{40,40},{40,40},{40,-60},{60,-60}},
    color={0,127,255}));
  connect(valCWWSE.port_b, port_wse)
    annotation (Line(points={{80,-60},{100,-60}}, color={0,127,255}));
  connect(busCon.valCWChi, valCWChi.bus) annotation (Line(
      points={{0.1,100.1},{0.1,80},{70,80},{70,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.valCWWSE, valCWWSE.bus) annotation (Line(
      points={{0,100},{0,80},{-40,80},{-40,-40},{70,-40},{70,-50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.pum, pum.bus) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-60,0},{-100,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-8,40},{-60,40},{-60,-40},{-8,-40}},
          color={28,108,200},
          thickness=1),
                    Bitmap(
        extent={{-40,0},{40,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{40,60},{60,60},{60,-20},{40,-20}},
          color={28,108,200},
          thickness=1),
                    Bitmap(
        extent={{-40,-80},{40,0}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{60,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Headered;
