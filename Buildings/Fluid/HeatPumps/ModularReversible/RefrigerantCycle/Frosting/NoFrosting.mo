within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting;
model NoFrosting "Placeholder block to ignore frosting"
  extends BaseClasses.PartialIcingFactor;
protected
 Modelica.Blocks.Sources.Constant constNoFroAlw(final k=1)
    "Always disable frosting"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(constNoFroAlw.y, swi.u1)
    annotation (Line(points={{41,30},{50,30},{50,8},{58,8}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block is used to ignore frosting effects by setting the icing factor
to constant <i>1</i>.
</p>
</html>", revisions="<html>
<ul>
  <li>
    Mai 2, 2025, by Fabian Wuellhorst:<br/>
    Disable if not air souce
    <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1975\">IBPSA #1975</a>
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end NoFrosting;
