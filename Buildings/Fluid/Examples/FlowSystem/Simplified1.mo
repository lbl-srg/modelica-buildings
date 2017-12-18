within Buildings.Fluid.Examples.FlowSystem;
model Simplified1 "Aggregated pressure drops"
  extends Basic(
    tabsSouth1(each dp_nominal=0),
    tabsSouth2(each dp_nominal=0),
    tabsNorth1(each dp_nominal=0),
    tabsNorth2(each dp_nominal=0),
    valSouth1(each dpFixed_nominal=50000),
    valSouth2(each dpFixed_nominal=50000),
    valNorth1(each dpFixed_nominal=50000),
    valNorth2(each dpFixed_nominal=50000));
  annotation (Documentation(info="<html>
<p>
The model is simplified: series pressure drop components are aggregated into the valve model.
</p>
</html>", revisions="<html>
<ul>
<li>
September 22, 2017, by Filip Jorissen:<br/>
Revised simulation duration since otherwise
the model only operates in the laminar region.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/825\">#825</a>.
</li>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StopTime=50, Tolerance=1e-09),
__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Simplified1.mos"
        "Simulate and plot"));
end Simplified1;
