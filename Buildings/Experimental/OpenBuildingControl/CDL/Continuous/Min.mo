within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Min "Pass through the smallest signal"
  extends Modelica.Blocks.Interfaces.SI2SO;
equation
  y = min(u1, u2);
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-90,36},{90,-36}},
          lineColor={160,160,164},
          textString="min()")}), Documentation(info="<html>
<p>
This block computes the output <code>y</code> as <i>minimum</i> of
the two Real inputs <code>u1</code> and <code>u2</code>:
</p>
<pre>    y = <code>min</code> ( u1 , u2 );
</pre>
</html>"));
end Min;
