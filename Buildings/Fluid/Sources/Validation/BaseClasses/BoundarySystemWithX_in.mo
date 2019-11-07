within Buildings.Fluid.Sources.Validation.BaseClasses;
model BoundarySystemWithX_in
  "System model for testing boundary condition with mass fraction input"
  extends Buildings.Fluid.Sources.Validation.BaseClasses.BoundarySystem(sou(use_X_in=true));
  Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX]
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  for i in 1:Medium.nXi loop
    assert(abs(Xi[i] - X_in[i]) < 1E-6, "Error in implementation of mass fraction");
  end for;
  connect(sou.X_in, X_in) annotation (Line(points={{-62,-4},{-82,-4},{-82,0},{-120,
          0}},      color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
System model used to test the boundary conditions for different media
with prescribed mass fraction <code>X</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2019 by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1205\">Buildings, #1205</a>.
</li>
</ul>
</html>"));
end BoundarySystemWithX_in;
