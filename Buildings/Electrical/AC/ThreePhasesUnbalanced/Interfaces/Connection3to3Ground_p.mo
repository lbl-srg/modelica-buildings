within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
model Connection3to3Ground_p
  "Adapter between Terminal4 (3 phases and ground) and Terminal3 P"

  Terminal_p terminal4 "Connector with neutral" annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_p ground4
    "Connector for neutral"
    annotation (Placement(transformation(extent={{-114,-70},{-94,-50}}),
                        iconTransformation(extent={{-114,-70},{-94,-50}})));
  Terminal_p terminal3 "Connector without neutral" annotation (Placement(transformation(extent={{90,-10},{110,
            10}}), iconTransformation(extent={{90,-10},{110,10}})));
equation

  // Connection branches required to propagate the reference angle
  Connections.branch(terminal4.phase[1].theta, ground4.theta);
  terminal4.phase[1].theta = ground4.theta;
  for i in 1:3 loop
    Connections.branch(terminal3.phase[i].theta, terminal4.phase[i].theta);
    terminal3.phase[i].theta = terminal4.phase[i].theta;
  end for;

  // KVL and KCL
  terminal3.phase[1].v[:] = terminal4.phase[1].v[:] - ground4.v[:];
  terminal3.phase[2].v[:] = terminal4.phase[2].v[:] - ground4.v[:];
  terminal3.phase[3].v[:] = terminal4.phase[3].v[:] - ground4.v[:];

  terminal4.phase[1].i[:] + terminal4.phase[2].i[:] = -terminal4.phase[3].i[:] - ground4.i[:];
  terminal4.phase[1].i[:] = - terminal3.phase[1].i[:];
  terminal4.phase[2].i[:] = - terminal3.phase[2].i[:];
  terminal4.phase[3].i[:] = - terminal3.phase[3].i[:];

  annotation ( Icon(graphics={               Polygon(
          points={{-80,110},{-80,70},{0,70},{0,110},{-80,110}},
          lineColor={127,0,127},
          fillColor={127,0,127},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-80,50},{-80,10},{0,10},{0,50},{-80,50}},
          lineColor={127,0,127},
          fillColor={127,0,127},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-80,-10},{-80,-50},{0,-50},{0,-10},{-80,-10}},
          lineColor={127,0,127},
          fillColor={127,0,127},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-80,-70},{-80,-110},{0,-110},{0,-70},{-80,-70}},
          lineColor={127,0,127},
          fillColor={127,0,127},
          fillPattern=FillPattern.Solid),    Polygon(
              points={{0,80},{0,40},{80,40},{80,80},{0,80}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid),Polygon(
              points={{0,20},{0,-20},{80,-20},{80,20},{0,20}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid),Polygon(
              points={{0,-40},{0,-80},{80,-80},{80,-40},{0,-40}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
February 25, 2016, by Michael Wetter:<br/>
First implementation based on previous
<code>Buildings.Electrical.AC.ThreePhasesUnbalanced.InterfacesConnection3to4_p</code>
which did not conform to the Modelica Language Definition.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Adapter between electric connectors type p for AC three-phase unbalanced systems.
This adapter connects a connector without neutral cable to a connector without
neutral cable.
</p>
</html>"));
end Connection3to3Ground_p;
