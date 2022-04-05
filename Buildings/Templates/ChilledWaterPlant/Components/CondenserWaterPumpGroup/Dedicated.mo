within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup;
model Dedicated
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.PartialCondenserWaterPumpGroup(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup.Dedicated,
      final have_WSE = false,
      final nPum=nChi);

  inner replaceable Buildings.Templates.Components.Pumps.MultipleVariable pum
    constrainedby Buildings.Templates.Components.Pumps.Interfaces.PartialPump(
      redeclare final package Medium = Medium,
      final nPum=nPum,
      final have_singlePort_a=true,
      final have_singlePort_b=false,
      final dat=dat.pum)
    "Condenser pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(busCon.pumCon, pum.bus) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
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
