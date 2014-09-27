within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function erf "Error function"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

algorithm
  if u >= 0 then
    y :=p_gamma(
      0.5,
      u*u,
      0.572364942924700087071713675675);
  else
    y :=-p_gamma(
      0.5,
      u*u,
      0.572364942924700087071713675675);
  end if;
  annotation (Documentation(info="<html>
  <p>Error function according to the c-implementation of Haruhiko Okumura. </p>
<h4>References</h4>
<p>
Haruhiko Okumura: <i>C-gengo niyoru saishin algorithm jiten </i>
            (New Algorithm handbook in C language) (Gijyutsu hyouron
            sha, Tokyo, 1991) p.227 [in Japanese] .
</p>
</html>", revisions="<html>
<ul>
<li>
September 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end erf;
