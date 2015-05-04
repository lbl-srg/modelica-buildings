within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses;
partial model PartialConverterStepUpDY "Model of a transformer with D connection primary side and Y connection
  secondary side (Voltage step up)"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverter;
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToWyeGround wye_to_wyeg
    "Wye to wye grounded connection"
    annotation (Placement(transformation(extent={{78,-10},{58,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta delta_to_wye
    "Delta to wye connection"
    annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
equation

  connect(delta_to_wye.wye, terminal_n) annotation (Line(
      points={{-76,4.44089e-16},{-80,4.44089e-16},{-80,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(wye_to_wyeg.wye, terminal_p) annotation (Line(
      points={{78,6.66134e-16},{82,6.66134e-16},{82,0},{92,0},{92,4.44089e-16},{100,
          4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(wye_to_wyeg.wyeg.phase[1], conv1.terminal_p) annotation (Line(
      points={{58,6.66134e-16},{44,6.66134e-16},{44,52},{10,52}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(wye_to_wyeg.wyeg.phase[2], conv2.terminal_p) annotation (Line(
      points={{58,6.66134e-16},{10,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(wye_to_wyeg.wyeg.phase[3], conv3.terminal_p) annotation (Line(
      points={{58,6.66134e-16},{44,6.66134e-16},{44,-60},{10,-60}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(delta_to_wye.delta.phase[1], conv1.terminal_n) annotation (Line(
      points={{-56,4.44089e-16},{-48,4.44089e-16},{-48,52},{-10,52}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(delta_to_wye.delta.phase[2], conv2.terminal_n) annotation (Line(
      points={{-56,4.44089e-16},{-48,4.44089e-16},{-48,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(delta_to_wye.delta.phase[3], conv3.terminal_n) annotation (Line(
      points={{-56,4.44089e-16},{-48,4.44089e-16},{-48,-60},{-10,-60}},
      color={0,120,120},
      smooth=Smooth.None));

  annotation (    Documentation(revisions="<html>
<ul>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model that represents a three-phase unbalanced
transformer with delta connection on the primary and Y connection on
the secondary side. The configuration is for voltage step up.
</p>
<p>
The image below describes the connection of the windings.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Conversion/BaseClasses/DY_b.png\"/>
</p>
</html>"));
end PartialConverterStepUpDY;
