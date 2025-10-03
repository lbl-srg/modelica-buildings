within Buildings.Fluid.Storage;
package chw_ntu "Ice tank model"
  extends Modelica.Icons.Package;

annotation (Documentation(info="<html>
<p>Package with ice thermal storage models. </p>
</html>", revisions="<html>
<ul>
<li>
October 10, 2025 by Remi Patureau:<br/>
First implementation.
</li>
</ul>
</html>
"),        Icon(graphics={Line(points={{0,80},{0,-80}},   color={0,128,255},
          thickness=0.5,
          rotation=180),
        Line(
          points={{-40,68},{0,32},{40,68}},
          color={0,128,255},
          thickness=0.5),
        Line(
          points={{-40,-68},{0,-32},{40,-68}},
          color={0,128,255},
          thickness=0.5),
        Line(
          points={{-40,-20},{-1.83697e-15,16},{40,-20}},
          color={0,128,255},
          thickness=0.5,
          origin={48,0},
          rotation=90),
        Line(
          points={{-40,20},{1.83697e-15,-16},{40,20}},
          color={0,128,255},
          thickness=0.5,
          origin={-48,0},
          rotation=90),   Line(points={{0,80},{0,-80}},   color={0,128,255},
          thickness=0.5,
          rotation=270)}));
end chw_ntu;
