within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup;
model Dedicated
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.PartialCondenserWaterPumpGroup(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup.Dedicated,
      final nPum=nPorEco + nChi,
      pum(final have_singlePort_b=false));


  // FIXME : Could we have a dedicated condenser pump with WSE?
  // If so, would there be a dedicated pump for the WSE?
protected
  parameter Integer nPorEco = if have_eco then 1 else 0;

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
