within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses;
partial model PartialConverterStepDownYD "Model of a transformer with Y connection primary side and D 
connection secondary side (Voltage step down)"
  replaceable Buildings.Electrical.Interfaces.PartialConversion
                                    conv1(
    redeclare package PhaseSystem_p =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    "Trasformer phase 1"
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  replaceable Buildings.Electrical.Interfaces.PartialConversion
                                    conv2(
    redeclare package PhaseSystem_p =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    "Trasformer phase 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Buildings.Electrical.Interfaces.PartialConversion
                                    conv3(
    redeclare package PhaseSystem_p =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    "Trasformer phase 3"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Interfaces.Terminal_n terminal_n "Electrical connector side N"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Terminal_p terminal_p "Electrical connector side P"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToWyeGround wye_to_wyeg
    "Wye to wye grounded connection"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta delta_to_wye
    "Delta to wye connection "
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

  connect(delta_to_wye.delta.phase[1], conv1.terminal_p) annotation (Line(
      points={{60,4.44089e-16},{36,4.44089e-16},{36,52},{10,52}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(delta_to_wye.delta.phase[2], conv2.terminal_p) annotation (Line(
      points={{60,4.44089e-16},{10,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(delta_to_wye.delta.phase[3], conv3.terminal_p) annotation (Line(
      points={{60,4.44089e-16},{36,4.44089e-16},{36,-60},{10,-60}},
      color={0,120,120},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics),
    Documentation(revisions="<html>
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
Partial model that represents a three phases unbalanced
trasformer with Y connection on primary and delta connection on
the secondary one. The configuration is for voltage step down.
</p>
<p>
The image belod describe the connection of the windings.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Conversion/BaseClasses/YD_a.png\"/>
</p>
</html>"));
end PartialConverterStepDownYD;
