within Buildings.Fluid.Examples.Performance;
model Example7
  "Example 7 model of Modelica code that is more efficiently compiled into C-code"
  extends Modelica.Icons.Example;
  parameter Integer nTem = 500;
  parameter Real R = 0.001;
  parameter Real C = 1000;
  parameter Real tauInv = 1/(R*C);

  Real[nTem] T;
initial equation
  T = fill(273.15, nTem);
equation
  der(T[1])= ((273.15+sin(time))-2*T[1] + T[2])*tauInv;
  for i in 2:nTem-1 loop
    der(T[i])=(T[i+1]+T[i-1]-2*T[i])*tauInv;
  end for;
  der(T[nTem])= (T[nTem-1]-T[nTem])*tauInv;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics={Text(
          extent={{-62,24},{-18,-4}},
          lineColor={0,0,255},
          textString="See code")}),
    experiment(
      StopTime=100),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    Documentation(revisions="<html>
<ul>
<li>
July 14, 2015, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
See 
<a href=\"modelica://Buildings.Fluid.Examples.PerformanceExamples.Example6\"> 
Buildings.Fluid.Examples.PerformanceExamples.Example6</a>.
</p>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/Performance/Example7.mos"
        "Simulate and plot"));
end Example7;
