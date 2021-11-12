within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup;
model Centralized "Centralized secondary pumping"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.SecondaryPumpGroup(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup.None);

  BaseClasses.ParallelPumps pumSec(final nPum=nPum)
                                   "Secondary pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, pumSec.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pumSec.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(pumSec.y_actual, busCon.uStaPumSec) annotation (Line(points={{11,8},
          {20,8},{20,80},{0,80},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.ySpe, pumSec.y) annotation (Line(
      points={{0,100},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
end Centralized;
