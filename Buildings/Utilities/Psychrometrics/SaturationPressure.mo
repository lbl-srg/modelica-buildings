within Buildings.Utilities.Psychrometrics;
block SaturationPressure "Saturation pressure as a function of temperature"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput TSat(unit="K",
                                            displayUnit="degC",
                                            nominal=300)
    "Saturation temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput pSat(unit="Pa",
                                             displayUnit="Pa",
                                             nominal=1000)
    "Saturation pressure"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  pSat = Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TSat);
    annotation (
    defaultComponentName="pSat",
    Documentation(info="<html>
<p>
Saturation pressure of water, computed from temperature,
according to Wagner <i>et al.</i> (1993).
The range of validity is between
<i>190</i> and <i>373.16</i> Kelvin.
</p>
<h4>References</h4>
<p>
Wagner W., A. Saul, A. Pruss.
 <i>International equations for the pressure along the melting and along the sublimation curve of ordinary water substance</i>,
equation 3.5. 1993.
<a href=\"http://aip.scitation.org/doi/pdf/10.1063/1.555947?class=pdf\">
http://aip.scitation.org/doi/pdf/10.1063/1.555947?class=pdf</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 20, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-92,22},{-56,-24}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"), Text(
          extent={{54,34},{90,-22}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="p"),
        Polygon(
          points={{-58,80},{-66,58},{-67.0723,52.6387},{-68,46},{-62,40},{-56,
              40},{-50,42},{-48,48},{-48,52},{-50,58},{-58,80},{-58,80}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{2,-38},{-6,-60},{-7.0723,-65.3613},{-8,-72},{-2,-78},{4,-78},
              {10,-76},{12,-70},{12,-66},{10,-60},{2,-38},{2,-38}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{-12,20},{-20,-2},{-21.0723,-7.3613},{-22,-14},{-16,-20},{-10,
              -20},{-4,-18},{-2,-12},{-2,-8},{-4,-2},{-12,20},{-12,20}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{2,86},{-6,64},{-7.0723,58.6387},{-8,52},{-2,46},{4,46},{10,
              48},{12,54},{12,58},{10,64},{2,86},{2,86}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{-56,-22},{-64,-44},{-65.0723,-49.3613},{-66,-56},{-60,-62},{
              -54,-62},{-48,-60},{-46,-54},{-46,-50},{-48,-44},{-56,-22},{-56,
              -22}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{58,72},{50,50},{48.9277,44.6387},{48,38},{54,32},{60,32},{66,
              34},{68,40},{68,44},{66,50},{58,72},{58,72}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{60,-34},{52,-56},{50.9277,-61.3613},{50,-68},{56,-74},{62,
              -74},{68,-72},{70,-66},{70,-62},{68,-56},{60,-34},{60,-34}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));
end SaturationPressure;
