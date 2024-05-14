within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting;
model NoFrosting "Placeholder block to ignore frosting"
  extends BaseClasses.PartialIcingFactor;
equation
  iceFac = 1;
  annotation (Documentation(info="<html>
<p>
This block is used to ignore frosting effects by setting the icing factor
to constant <i>1</i>.
</p>
</html>", revisions="<html>
<ul><li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li></ul>
</html>"));
end NoFrosting;
