within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function erf "Error function, using the external c-function"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

external"C" y = erf(u);
  annotation (
    Include="#include <erf.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources",
    Documentation(info="<html>
    <p>Error function, using the external c-function of Haruhiko Okumura: C-gengo niyoru saishin algorithm jiten
            (New Algorithm handbook in C language) (Gijyutsu hyouron
            sha, Tokyo, 1991) p.227 [in Japanese].</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end erf;
