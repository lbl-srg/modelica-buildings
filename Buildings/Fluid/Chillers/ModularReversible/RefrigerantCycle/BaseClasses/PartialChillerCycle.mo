within Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialChillerCycle
  "Partial model of refrigerant cycle used for chiller applications"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle;
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal
    "Nominal cooling capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean useInChi
    "=false to indicate that this model is used as a heat pump";
equation
  connect(iceFacCal.iceFac, sigBus.iceFacChiMea) annotation (Line(points={{-81.2,-50},
          {-72,-50},{-72,-30},{-110,-30},{-110,120},{1,120}},      color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(
  info="<html>
<p>
  Partial refrigerant cycle model for chillers.
  It adds the specification for frosting calculation
  and restricts to the intended choices under
  <code>choicesAllMatching</code>.</p>
</html>", revisions="<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adapted based on Buildings implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialChillerCycle;
