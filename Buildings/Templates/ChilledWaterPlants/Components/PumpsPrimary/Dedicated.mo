within Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary;
model Dedicated "Dedicated primary pumps"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.Interfaces.PartialPrimaryPump(
    final typ=Buildings.Templates.ChilledWaterPlants.Components.Types.PrimaryPump.Dedicated,
    final nPum=nChi,
    final have_conSpePum=pum.typ == Buildings.Templates.Components.Types.Pump.Constant,
    final have_singlePort_a=false,
    final typValChiWatChiIso=fill(Buildings.Templates.Components.Types.Valve.None,
        nChi),
    pum(final have_singlePort_a=false));

equation
  connect(pum.ports_a, ports_a)
    annotation (Line(points={{-50,0},{-100,0}}, color={0,127,255}));
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
