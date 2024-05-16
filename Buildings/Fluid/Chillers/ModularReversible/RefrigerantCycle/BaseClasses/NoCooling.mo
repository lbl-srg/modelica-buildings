within Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses;
model NoCooling
  "Placeholder to disable cooling"
  extends PartialChillerCycle(
    TEva_nominal=273.15,
    TCon_nominal=273.15,
    cpEva=4184,
    cpCon=4184,
    PEle_nominal=0,
    redeclare final
      Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
      iceFacCal,
    devIde="NoCooling",
    QCoo_flow_nominal=0);

  Modelica.Blocks.Sources.Constant const(final k=0) "Zero energy flows"
    annotation (Placement(transformation(extent={{-88,16},{-68,36}})));
equation
  connect(const.y, redQCon.u2) annotation (Line(points={{-67,26},{64,26},{64,-78}},
                               color={0,0,127}));
  connect(const.y, PEle)
    annotation (Line(points={{-67,26},{0,26},{0,-130}}, color={0,0,127}));
  connect(const.y, proRedQEva.u2)
    annotation (Line(points={{-67,26},{-24,26},{-24,-78}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  Using this model, the chiller will always be off.
  This option is mainly used to avoid warnings about
  partial model which must be replaced.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end NoCooling;
