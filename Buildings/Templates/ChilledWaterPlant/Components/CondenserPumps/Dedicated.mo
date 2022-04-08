within Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps;
model Dedicated "Dedicated condenser pumps"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Interfaces.PartialCondenserPump(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserPump.Dedicated,
    final nPum=nChi,
    pum(final have_singlePort_b=false));

  // FIXME : Could we have a dedicated condenser pump with WSE?

equation

  connect(pum.ports_b, ports_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
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
                    Bitmap(
        extent={{-40,-80},{40,0}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{60,20},{100,20}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{60,-20},{100,-20}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{40,60},{60,60},{60,20},{100,20}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{40,-20},{100,-20}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dedicated;
