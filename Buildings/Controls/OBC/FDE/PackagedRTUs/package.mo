within Buildings.Controls.OBC.FDE;
package PackagedRTUs "Standard packaged RTU sequences"





  annotation (Documentation(info="<html>
<p>This package contains BAS interface controls for packaged factory controlled sequences.</p>
</html>", revisions="<html>
<ul>
<li>May 28, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>"),
         Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          radius=30,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                      Text(
          extent={{-98,42},{106,-46}},
          lineColor={0,0,0},
          textString="RTU")}));
end PackagedRTUs;
