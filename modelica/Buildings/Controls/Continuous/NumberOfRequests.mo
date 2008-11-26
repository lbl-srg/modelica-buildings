block NumberOfRequests 
  "Outputs the number of signals that are above/below a certain threshold" 
   extends Modelica.Blocks.Interfaces.BlockIcon;
  
  annotation (Documentation(info="<html>
<p>
Block whose output is equal to the number of inputs
that exceed a threshold.
</p>
<p>
This model may for example be used to check how many rooms
exceed a temperature threshold.
</html>",
revisions="<html>
<ul>
<li>
November 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(
      Text(
        extent=[-128,88; -6,28],
        style(color=3, rgbcolor={0,0,255}),
        string="%threShold"),
      Line(points=[-62,-6; -4,24],style(color=3, rgbcolor={0,0,255})),
      Line(points=[-4,24; 64,60], style(color=1, rgbcolor={255,0,0})),
      Line(points=[-78,24; 78,24], style(
          color=0,
          rgbcolor={0,0,0},
          pattern=3)),
      Line(points=[-86,4; -18,24],  style(color=3, rgbcolor={0,0,255})),
      Line(points=[-18,24; 66,54], style(color=1, rgbcolor={255,0,0})),
      Line(points=[-78,-50; 78,-50], style(color=0, rgbcolor={0,0,0})),
      Line(points=[70,-46; 78,-50], style(color=0, rgbcolor={0,0,0})),
      Line(points=[70,-54; 78,-50], style(color=0, rgbcolor={0,0,0}))),
    Diagram);
  
  parameter Integer nin "Number of inputs";
  parameter Real threShold = 0 "Threshold";
  parameter Integer kind 
    "Set to 0 for u>threShold, to 1 for >=, to 2 for <= or to 3 for <";
  Modelica.Blocks.Interfaces.IntegerOutput y 
    "Number of input signals that violate the threshold" 
    annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Interfaces.RealInput u[nin] "Input signals" 
    annotation (extent=[-140,-20; -100,20]);
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
