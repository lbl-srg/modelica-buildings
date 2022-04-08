within Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps;
model Headered "Headered condenser pumps"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Interfaces.PartialCondenserPump(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserPump.Headered,
      pum(final have_singlePort_b=true));

  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.m_flow_nominal,
    nPorts=nPorVol)
    "Outlet node mixing volume"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));

protected
  parameter Integer nPorEco = if have_eco then 1 else 0;
  parameter Integer nPorVol = nPorEco + nChi + 1;

equation

  connect(del.ports[1], pum.port_b)
    annotation (Line(points={{40,40},{40,40},{40,0},{10,0}},
    color={0,127,255}));
  connect(del.ports[2:nChi+1], ports_b)
    annotation (Line(points={{40,40},{40,0},{100,0}}, color={0,127,255}));
  connect(del.ports[nPorVol], port_wse)
    annotation (Line(points={{40,40},{40,-60},{100,-60}}, color={0,127,255}));

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
