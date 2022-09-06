within Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary;
model None "No secondary pumping"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.Interfaces.PartialSecondaryPump(
      final nPum=1, final typ=Buildings.Templates.ChilledWaterPlants.Components.Types.SecondaryPump.None);
  // FIXME : nPum above should be 0, but record for pum[nPum] is not valid with size 0

  Buildings.Templates.Components.Pumps.None pum(
    redeclare final package Medium = Medium,
    final m_flow_nominal = dat.m_flow_nominal,
    final dat=dat.pum)
    "Secondary pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(busCon.pumSec, pum.bus) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
