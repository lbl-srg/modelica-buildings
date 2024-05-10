within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation;
model DryFluid
  "Organic Rankine cycle with a dry working fluid"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.ThermodynamicTemperature TEva = 450
    "Evaporating temperature";
  parameter Modelica.Units.SI.ThermodynamicTemperature TCon = 310
    "Condensing temperature";
  parameter Modelica.Units.SI.Efficiency etaExp = 0.85
    "Expander efficiency";
  parameter Modelica.Units.SI.Efficiency etaPum = 0.7
    "Pump efficiency";

  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates cyc(
    final pro = pro,
    final TEva = TEva,
    final TCon = TCon,
    final etaExp = etaExp,
    final etaPum = etaPum) "Interpolate working fluid states in the cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable parameter
            Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.Toluene pro
    constrainedby Buildings.Fluid.CHPs.OrganicRankine.Data.Generic
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{60,60},{80,80}})),
      choicesAllMatching=true);

annotation(experiment(StopTime=1, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/BaseClasses/Validation/DryFluid.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the basic use of
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates\">
Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates</a>.
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
