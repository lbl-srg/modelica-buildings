within Buildings.Fluid.Chillers.Validation;
model Carnot_y_etaPL
  "Test model for the part load efficiency curve with compressor speed as input signal"
  extends Examples.Carnot_y(chi(a={0.7,0.3}));

  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Validation/Carnot_y_etaPL.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example extends from
<a href=\"modelica://Buildings.Fluid.Chillers.Examples.Carnot_y\">
Buildings.Fluid.Chillers.Examples.Carnot_y</a>
but uses a part load efficiency curve that is different from <i>1</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_y_etaPL;
