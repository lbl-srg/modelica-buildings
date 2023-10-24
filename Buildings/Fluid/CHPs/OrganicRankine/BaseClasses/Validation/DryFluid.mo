within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Validation;
model DryFluid "Organic Rankine cycle with a dry working fluid"
  extends Modelica.Icons.Example;
  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Equations equ(
    final pro=pro,
    TEva(displayUnit="K") = max(pro.T)*2/3 + min(pro.T)/3,
    TCon(displayUnit="K") = max(pro.T)/3 + min(pro.T)*2/3,
    etaExp=0.85) "Thermodynamic equations of the Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable parameter
            Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.Acetone pro
    constrainedby Buildings.Fluid.CHPs.OrganicRankine.Data.Generic
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{60,60},{80,80}})),
      choicesAllMatching=true);
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
