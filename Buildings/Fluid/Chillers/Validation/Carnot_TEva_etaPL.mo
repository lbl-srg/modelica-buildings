within Buildings.Fluid.Chillers.Validation;
model Carnot_TEva_etaPL
  "Test model for the part load efficiency curve with evaporator leaving temperature as input signal"
  extends Examples.Carnot_TEva(
    chi(a={0.7,0.3},
    QEva_flow_min=-100000));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Validation/Carnot_TEva_etaPL.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example extends from
<a href=\"modelica://Buildings.Fluid.Chillers.Examples.Carnot_TEva\">
Buildings.Fluid.Chillers.Examples.Carnot_TEva</a>
but has a part load efficiency that varies with the load.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TEva_etaPL;
