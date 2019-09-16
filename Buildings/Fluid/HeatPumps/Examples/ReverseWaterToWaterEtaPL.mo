within Buildings.Fluid.HeatPumps.Examples;
model ReverseWaterToWaterEtaPL
  "Test model of the reverse heatpump implementing the part load efficiency curve"
 package Medium = Buildings.Media.Water "Medium model";
 extends Examples.ReverseWaterToWater(heaPum(a={0.3,0.7}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
              Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
             __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/ReverseWaterToWaterEtaPL.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=14400),
Documentation(info="<html>
  <p>
  This example extends from
  <a href=\"modelica://Buildings.Fluid.HeatPumps.Examples.ReverseWaterToWater\">
  Buildings.Fluid.HeatPumps.Examples.ReverseWaterToWater</a> but has a part load efficiency that varies with the load.
 The heat pump takes as an input the heating or the chilled leaving water temperature and an integer input to
  specify the heat pump operational mode.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
June 18, 2019, by Hagar Elarga:<br/>
First implementation.
 </li>
 </ul>
 </html>"));
end ReverseWaterToWaterEtaPL;
