within Buildings.Fluid.CHPs.OrganicRankine.Validation;
model VaryingHot
  "ORC with waste heat stream with varying flow rate and temperature"
  extends
    Buildings.Fluid.CHPs.OrganicRankine.Validation.BaseClasses.PartialVarying(
    souHot(
      use_m_flow_in=true,
      use_T_in=true));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.TimeTable mHot_flow_set(table=[0,0; 50,
        mHot_flow_nominal*7; 250,mHot_flow_nominal*7; 300,0])
    "Sets the hot fluid flow rate in the evaporator"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.TimeTable THotIn_set(table=[
    0,orc.TWorEva + 20;
    100,orc.TWorEva + 20;
    150,orc.TWorEva - 5;
    200,orc.TWorEva + 20;
    300,orc.TWorEva + 20])
    "Sets the hot fluid incoming temperature in the evaporator"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(mHot_flow_set.y, souHot.m_flow_in) annotation (Line(points={{-59,50},{
          -50,50},{-50,38},{-42,38}}, color={0,0,127}));
  connect(THotIn_set.y, souHot.T_in) annotation (Line(points={{-59,10},{-50,10},
          {-50,34},{-42,34}}, color={0,0,127}));
  annotation(experiment(StopTime=300,Tolerance=1E-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/Validation/VaryingHot.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model demonstrates how the ORC model reacts to varying flow rate
and temperature of the incoming hot fluid carrying waste heat.
Normally, the working fluid flow rate of the cycle
<i>m&#775;<sub>W</sub></i> is solved from
the set point for the evaporator pinch point temperature differential
<i>&Delta;T<sub>pin,Eva</sub></i>.
This constraint is released under any of the following two conditions:
</p>
<ul>
<li>
If the hot fluid carries more heat than the cycle's capacity
(because the hot fluid's flow rate or temperature is too high),
<i>m&#775;<sub>W</sub></i> would exceed its upper limit.
<i>m&#775;<sub>W</sub></i> is then fixed at its upper limit and
<i>&Delta;T<sub>pin,Eva</sub></i> is allowed higher than its set point.
</li>
<li>
If the hot fluid carries too little heat
(because its flow rate or temperature is too low),
<i>m&#775;<sub>W</sub></i> would be lower than a threshold.
<i>m&#775;<sub>W</sub></i> is then set to zero
(effectively shutting down the cycle) and
the set point of <i>&Delta;T<sub>pin,Eva</sub></i> is ignored.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
January 26, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end VaryingHot;
