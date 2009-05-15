within Buildings.Controls.Continuous;
block NumberOfRequests
  "Outputs the number of signals that are above/below a certain threshold"
   extends Modelica.Blocks.Interfaces.BlockIcon;

  annotation (Documentation(info="<html>
<p>
Block whose output is equal to the number of inputs
that exceed a threshold.
</p>
<p>
This model may be used to check how many rooms
exceed a temperature threshold.
</html>",
revisions="<html>
<ul>
<li>
November 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Text(
          extent={{-128,88},{-6,28}},
          lineColor={0,0,255},
          textString="%threShold"),
        Line(points={{-62,-6},{-4,24}}, color={0,0,255}),
        Line(points={{-4,24},{64,60}}, color={255,0,0}),
        Line(
          points={{-78,24},{78,24}},
          color={0,0,0},
          pattern=LinePattern.Dot),
        Line(points={{-86,4},{-18,24}}, color={0,0,255}),
        Line(points={{-18,24},{66,54}}, color={255,0,0}),
        Line(points={{-78,-50},{78,-50}}, color={0,0,0}),
        Line(points={{70,-46},{78,-50}}, color={0,0,0}),
        Line(points={{70,-54},{78,-50}}, color={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics));

  parameter Integer nin "Number of inputs";
  parameter Real threShold = 0 "Threshold";
  parameter Integer kind
    "Set to 0 for u>threShold, to 1 for >=, to 2 for <= or to 3 for <";
  Modelica.Blocks.Interfaces.IntegerOutput y
    "Number of input signals that violate the threshold" 
    annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
            0)));
  Modelica.Blocks.Interfaces.RealInput u[nin] "Input signals" 
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0)));
algorithm
  y := 0;
  for i in 1:nin loop
    if kind == 0 then
      if u[i] > threShold then
        y := y+1;
      end if;
    end if;
    if kind == 1 then
      if u[i] >= threShold then
        y := y+1;
      end if;
    end if;
    if kind == 2 then
      if u[i] <= threShold then
        y := y+1;
      end if;
    end if;
    if kind == 3 then
      if u[i] < threShold then
        y := y+1;
      end if;
    end if;
  end for;
end NumberOfRequests;
