within Buildings.Fluid.CHPs.Rankine.Validation;
model DryFluid "Organic Rankine cycle with a dry working fluid"
  extends Modelica.Icons.Example;
  Buildings.Fluid.CHPs.Rankine.BaseClasses.Equations cyc(
    final pro=pro,
    TEva(displayUnit="K") = max(pro.T)*2/3 + min(pro.T)/3,
    TCon(displayUnit="K") = max(pro.T)/3 + min(pro.T)*2/3,
    etaExp=0.85)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable parameter
            Buildings.Fluid.CHPs.Rankine.Data.WorkingFluids.Toluene pro
    constrainedby Buildings.Fluid.CHPs.Rankine.Data.Generic
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{60,60},{80,80}})),
      choicesAllMatching=true);
end DryFluid;
