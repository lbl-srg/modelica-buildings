within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses;
partial model PartialConverterYY "Model of a transformer with Y connection primary side and Y
  connection secondary side"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverter;
  Interfaces.Connection3to3Ground_n connection3to4_n
    "Conversion between 3 to 4 connectors"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Interfaces.Connection3to3Ground_p connection3to4_p
    "Conversion between 3 to 4 connectors"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  OnePhase.Basics.Ground ground_n "Ground reference"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  OnePhase.Basics.Ground ground_p "Ground reference"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
protected
  Interfaces.Adapter3to3 ada3to3_n "Adapter for connections"
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
  Interfaces.Adapter3to3 ada3to3_p "Adapter for connections"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation

  connect(terminal_p, connection3to4_p.terminal3) annotation (Line(
      points={{100,0},{80,0},{80,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n, connection3to4_n.terminal3) annotation (Line(
      points={{-100,4.44089e-16},{-80,4.44089e-16},{-80,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_p.ground4, ground_p.terminal)
    annotation (Line(points={{59.6,-6},{60,-6},{60,-70}}, color={0,120,120}));
  connect(ground_n.terminal, connection3to4_n.ground4) annotation (Line(points={
          {-60,-70},{-60,-6},{-60.1,-6}}, color={0,120,120}));
  connect(connection3to4_n.terminal4, ada3to3_n.terminal)
    annotation (Line(points={{-60,0},{-55,0},{-50,0}}, color={0,120,120}));
  connect(ada3to3_n.terminals[1], conv1.terminal_n) annotation (Line(points={{-30,
          -0.533333},{-26,-0.533333},{-20,-0.533333},{-20,52},{-10,52}}, color={
          0,0,0}));
  connect(ada3to3_n.terminals[2], conv2.terminal_n)
    annotation (Line(points={{-30,0},{-20,0},{-10,0}}, color={0,0,0}));
  connect(ada3to3_n.terminals[3], conv3.terminal_n) annotation (Line(points={{-30,
          0.533333},{-20,0.533333},{-20,-60},{-10,-60}}, color={0,0,0}));
  connect(conv1.terminal_p, ada3to3_p.terminals[1]) annotation (Line(points={{10,52},
          {20,52},{20,-0.533333},{30,-0.533333}},     color={0,0,0}));
  connect(conv2.terminal_p, ada3to3_p.terminals[2])
    annotation (Line(points={{10,0},{20,0},{30,0}}, color={0,0,0}));
  connect(conv3.terminal_p, ada3to3_p.terminals[3]) annotation (Line(points={{10,-60},
          {20,-60},{20,0.533333},{30,0.533333}},      color={0,0,0}));
  connect(ada3to3_p.terminal, connection3to4_p.terminal4)
    annotation (Line(points={{50,0},{55,0},{60,0}}, color={0,120,120}));
  annotation (    Documentation(revisions="<html>
<ul>
<li>
February 26, 2016, by Michael Wetter:<br/>
Added adapters for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
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
