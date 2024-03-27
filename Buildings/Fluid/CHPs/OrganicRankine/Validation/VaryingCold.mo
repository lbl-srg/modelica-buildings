within Buildings.Fluid.CHPs.OrganicRankine.Validation;
model VaryingCold
  "ORC with cooling water stream with varying flow rate and temperature"
  extends
    Buildings.Fluid.CHPs.OrganicRankine.Validation.BaseClasses.PartialVarying(orc(
          useCondensingPressure=true,
          pWorCon_min = 1.2E5),
    souCol(
      use_T_in=true));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.TimeTable TColIn_set(table=[
    0,300;
    100,300;
    150,274;
    200,300;
    300,300]) "Sets the cooling fluid incoming temperature in the condenser"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
equation
  connect(TColIn_set.y, souCol.T_in) annotation (Line(points={{59,-30},{52,-30},
          {52,-26},{42,-26}}, color={0,0,127}));
  annotation(experiment(StopTime=300,Tolerance=1E-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/Validation/VaryingCold.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model demonstrates how the ORC model reacts to varying flow rate
and temperature of the incoming cold fluid carrying cooling water.
Normally, the working fluid condensing temperature of the cycle
<i>T<sub>w,Con</sub></i> is solved from
the set point for the condenser pinch point temperature differential
<i>&Delta;T<sub>pin,Con</sub></i>.
This constraint is released under the following condition:
</p>
<ul>
<li>
If the cold fluid carries so much cooling capacity
(because the cold fluid's flow rate is too high or temperature is too low)
that <i>T<sub>w,Con</sub></i> would be lower than a lower limit,
<i>T<sub>w,Con</sub></i> is then fixed at its lower limit and
<i>&Delta;T<sub>pin,Con</sub></i> is allowed higher than its set point.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
February 20, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end VaryingCold;
