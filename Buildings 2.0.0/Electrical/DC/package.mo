within Buildings.Electrical;
package DC "Package for analog direct current (DC) electrical circuits"
  extends Modelica.Icons.Package;


  annotation (Documentation(info="<html>
<p>
Package with models for direct current (DC) systems.<br/>
The models contained in this package use the phase system <a href=\"modelica://Buildings.Electrical.PhaseSystems.TwoConductor\">Buildings.Electrical.PhaseSystems.TwoConductor</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 28, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
      Line(
        points={{-82,20},{58,20}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{-82,-18},{-52,-18},{-42,-18}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{-22,-18},{-2,-18},{-2,-18}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{18,-18},{48,-18},{58,-18}},
        color={0,0,0},
        smooth=Smooth.None)}));
end DC;
