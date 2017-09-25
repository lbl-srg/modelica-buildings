within Buildings.Fluid.Chillers.BaseClasses;
partial model PartialCarnot_T
  "Partial model for chiller with performance curve adjusted based on Carnot efficiency"
  extends Buildings.Fluid.Chillers.BaseClasses.Carnot;

protected
  Modelica.Blocks.Sources.RealExpression PEle "Electrical power consumption"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(PEle.y, P)
    annotation (Line(points={{61,0},{110,0},{110,0}}, color={0,0,127}));
  annotation (
Documentation(info="<html>
<p>
This is a partial model of a chiller whose coefficient of performance (COP) changes
with temperatures in the same way as the Carnot efficiency changes.
This base class is used for the Carnot chiller and Carnot heat pump
that uses the compressor part load ratio as the control signal.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 26, 2016, by Michael Wetter:<br/>
First implementation of this base class.
</li>
</ul>
</html>"));
end PartialCarnot_T;
