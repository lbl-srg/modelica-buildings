within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses.Examples;
model ierf "Test for the error function"
  extends Modelica.Icons.Example;

  parameter Integer lim=5000;
  Real y_ierf;
algorithm
  y_ierf := BaseClasses.ierf(u=time*lim);
        annotation (Documentation(info="<html>
        <p>Test implementation of ierf function.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end ierf;
