within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses;
partial model PartialConverterYY "Model of a transformer with Y connection primary side and Y
  connection secondary side"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverter;
  Interfaces.Connection3to4_n connection3to4_n
    "Conversion between 3 to 4 connectors"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Interfaces.Connection3to4_p connection3to4_p
    "Conversion between 3 to 4 connectors"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  OnePhase.Basics.Ground ground_n "Ground reference"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  OnePhase.Basics.Ground ground_p "Ground reference"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
equation

  connect(connection3to4_n.terminal4.phase[1],conv1. terminal_n) annotation (Line(
      points={{-60,6.66134e-16},{-50,6.66134e-16},{-50,52},{-10,52}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_n.terminal4.phase[2],conv2. terminal_n) annotation (Line(
      points={{-60,6.66134e-16},{-36,6.66134e-16},{-36,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_n.terminal4.phase[3],conv3. terminal_n) annotation (Line(
      points={{-60,6.66134e-16},{-50,6.66134e-16},{-50,-60},{-10,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conv1.terminal_p, connection3to4_p.terminal4.phase[1]) annotation (Line(
      points={{10,52},{50,52},{50,6.66134e-16},{60,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conv2.terminal_p, connection3to4_p.terminal4.phase[2]) annotation (Line(
      points={{10,0},{36,0},{36,6.66134e-16},{60,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conv3.terminal_p, connection3to4_p.terminal4.phase[3]) annotation (Line(
      points={{10,-60},{50,-60},{50,6.66134e-16},{60,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_p, connection3to4_p.terminal3) annotation (Line(
      points={{100,0},{80,0},{80,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n, connection3to4_n.terminal3) annotation (Line(
      points={{-100,4.44089e-16},{-80,4.44089e-16},{-80,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_n.terminal4.phase[4], ground_n.terminal) annotation (Line(
      points={{-60,0},{-60,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_p.terminal4.phase[4], ground_p.terminal) annotation (Line(
      points={{60,0},{60,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (    Documentation(revisions="<html>
<ul>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model that represents a three-phase unbalanced
transformer with Y connection on both primary and secondary side.
</p>
<p>
The image below describes the connection of the windings.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Conversion/BaseClasses/YY.png\"/>
</p>
</html>"));
end PartialConverterYY;
