within Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses;
model FanCoil4Pipe
  "Model of a sensible only four-pipe fan coil unit computing a required water mass flow rate"
  extends PartialFanCoil4Pipe(
    final have_TSen=true,
    final have_fluPor=true,
    final have_heaPor=false);
equation
  connect(TSen,conCoo.u_m)
    annotation (Line(points={{-220,140},{-40,140},{-40,160},{0,160},{0,168}},color={0,0,127}));
  connect(TSen,conHea.u_m)
    annotation (Line(points={{-220,140},{-40,140},{-40,200},{0,200},{0,208}},color={0,0,127}));
  connect(hexHea.port_b2,mulLoaMasFloOut.port_a)
    annotation (Line(points={{-80,0},{-160,0}},color={0,127,255}));
  connect(mulLoaMasFloInl.port_b,fan.port_a)
    annotation (Line(points={{160,0},{90,0}},color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a simplified model of a sensible only four-pipe fan coil unit for heating and cooling. 
It is intended to be coupled to a room model by means of fluid ports.
See 
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.PartialFanCoil4Pipe\">
Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.PartialFanCoil4Pipe</a>
for a description of the modeling principles.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end FanCoil4Pipe;
