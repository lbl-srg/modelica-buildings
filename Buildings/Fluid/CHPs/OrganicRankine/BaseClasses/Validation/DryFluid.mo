within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation;
model DryFluid
  "Organic Rankine cycle with a dry working fluid"
  extends Modelica.Icons.Example;
  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates intSta(
    final pro=pro,
    etaExp=0.85) "Interpolate working fluid states"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable parameter
            Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.Toluene pro
    constrainedby Buildings.Fluid.CHPs.OrganicRankine.Data.Generic
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{60,60},{80,80}})),
      choicesAllMatching=true);
  Modelica.Blocks.Sources.TimeTable TEva(table=[0,330; 1,360])
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.TimeTable TCon(table=[0,300; 1,330])
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(TEva.y, intSta.TEva) annotation (Line(points={{-59,30},{-22,30},{-22,
          4},{-12,4}}, color={0,0,127}));
  connect(TCon.y, intSta.TCon) annotation (Line(points={{-59,-30},{-22,-30},{-22,
          -4},{-12,-4}}, color={0,0,127}));
annotation(experiment(StopTime=1, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/BaseClasses/Validation/DryFluid.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model demonstrates the basic use of
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Equations\">
Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Equations</a>.
</p>
</html>",revisions="<html>
<ul>
<li>
June 13, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end DryFluid;
