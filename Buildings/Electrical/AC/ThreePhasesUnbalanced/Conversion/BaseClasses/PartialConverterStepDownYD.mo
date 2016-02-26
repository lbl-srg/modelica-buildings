within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses;
partial model PartialConverterStepDownYD "Model of a transformer with Y connection primary side and D
connection secondary side (Voltage step down)"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverter;
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToWyeGround wye_to_wyeg
    "Wye to wye grounded connection"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta delta_to_wye
    "Delta to wye connection "
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
protected
  Interfaces.Adapter3to3 ada3to3_n "Adapter for connections"
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
  Interfaces.Adapter3to3 ada3to3_p "Adapter for connections"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
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

  connect(conv1.terminal_n, ada3to3_n.terminals[1]) annotation (Line(points={{-10,52},
          {-20,52},{-20,-0.533333},{-30,-0.533333}},     color={0,0,0}));
  connect(conv2.terminal_n, ada3to3_n.terminals[2])
    annotation (Line(points={{-10,0},{-30,0},{-30,0}}, color={0,0,0}));
  connect(conv3.terminal_n, ada3to3_n.terminals[3]) annotation (Line(points={{-10,-60},
          {-20,-60},{-20,0.533333},{-30,0.533333}},      color={0,0,0}));
  connect(conv1.terminal_p, ada3to3_p.terminals[1]) annotation (Line(points={{10,52},
          {20,52},{20,-0.533333},{30,-0.533333}},     color={0,0,0}));
  connect(conv2.terminal_p, ada3to3_p.terminals[2])
    annotation (Line(points={{10,0},{20,0},{30,0}}, color={0,0,0}));
  connect(conv3.terminal_p, ada3to3_p.terminals[3]) annotation (Line(points={{10,-60},
          {20,-60},{20,0.533333},{30,0.533333}},      color={0,0,0}));
  connect(ada3to3_p.terminal, delta_to_wye.delta)
    annotation (Line(points={{50,0},{55,0},{60,0}}, color={0,120,120}));
  connect(wye_to_wyeg.wyeg, ada3to3_n.terminal)
    annotation (Line(points={{-62,0},{-56,0},{-50,0}}, color={0,120,120}));
  annotation (    Documentation(revisions="<html>
<ul>
<li>
February 26, 2016, by Michael Wetter:<br/>
Added adapter for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">#426</a>.
</li>
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
transformer with Y connection on primary and delta connection on
the secondary one. The configuration is for voltage step down.
</p>
<p>
The image below describes the connection of the windings.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Conversion/BaseClasses/YD_a.png\"/>
</p>
</html>"));
end PartialConverterStepDownYD;
