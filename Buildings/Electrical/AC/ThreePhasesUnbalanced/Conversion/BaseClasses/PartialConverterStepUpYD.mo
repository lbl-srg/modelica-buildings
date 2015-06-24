within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses;
partial model PartialConverterStepUpYD "Model of a transformer with Y connection primary side and D connection
  secondary side (Voltage step up)"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverter;
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToWyeGround wye_to_wyeg
    "Wye to wye grounded connection"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta delta_to_wye
    "Delta to wye connection"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
equation

  connect(delta_to_wye.wye, terminal_p) annotation (Line(
      points={{80,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(wye_to_wyeg.wye, terminal_n) annotation (Line(
      points={{-82,6.66134e-16},{-84,6.66134e-16},{-84,0},{-86,0},{-86,4.44089e-16},
          {-100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(wye_to_wyeg.wyeg.phase[1], conv1.terminal_n) annotation (Line(
      points={{-62,0},{-38,0},{-38,52},{-10,52}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(wye_to_wyeg.wyeg.phase[2], conv2.terminal_n) annotation (Line(
      points={{-62,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(wye_to_wyeg.wyeg.phase[3], conv3.terminal_n) annotation (Line(
      points={{-62,0},{-38,0},{-38,-60},{-10,-60}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(delta_to_wye.delta.phase[1], conv2.terminal_p) annotation (Line(
      points={{60,4.44089e-16},{36,4.44089e-16},{36,0},{10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(delta_to_wye.delta.phase[2], conv3.terminal_p) annotation (Line(
      points={{60,4.44089e-16},{36,4.44089e-16},{36,-60},{10,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(delta_to_wye.delta.phase[3], conv1.terminal_p) annotation (Line(
      points={{60,4.44089e-16},{36,4.44089e-16},{36,52},{10,52}},
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
transformer with Y connection on the primary and delta connection on
the secondary side. The configuration is for voltage step up.
</p>
<p>
The image below describes the connection of the windings.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Conversion/BaseClasses/YD_b.png\"/>
</p>
</html>"));
end PartialConverterStepUpYD;
