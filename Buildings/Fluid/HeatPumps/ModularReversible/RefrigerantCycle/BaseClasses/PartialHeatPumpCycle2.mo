within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialHeatPumpCycle2
  "Partial model to allow selection of only heat pump options"
  extends PartialRefrigerantCycle;
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal
    "Nominal heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean useInHeaPum
    "=false to indicate that this model is used in a chiller";
  Modelica.Blocks.Math.Feedback feeHeaFloEva
    "Calculates evaporator heat flow with total energy balance" annotation (
      Placement(transformation(extent={{-80,-20},{-60,0}}, rotation=0)));
equation
  connect(feeHeaFloEva.y, proRedQEva.u2)
    annotation (Line(points={{-61,-10},{-24,-10},{-24,-78}}, color={0,0,127}));
  connect(iceFacCal.iceFac, proRedQEva.u1) annotation (Line(points={{-81.2,-50},
          {-36,-50},{-36,-78}}, color={0,0,127}));
  connect(iceFacCal.iceFac, sigBus.iceFacHPMea2) annotation (Line(points={{
          -81.2,-50},{-60,-50},{-60,-32},{-110,-32},{-110,120},{1,120}}, color=
          {0,0,127}));
  annotation (Documentation(info="<html>
<p>
  Partial refrigerant cycle model for heat pumps.
  It adds the specification for frosting calculation
  and restricts to the intended choices under
  <code>choicesAllMatching</code>.
</p>
</html>",
revisions="<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adapted based on Buildings implementation. Mainly, the iceFac is added directly
    in this partial model (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialHeatPumpCycle2;
