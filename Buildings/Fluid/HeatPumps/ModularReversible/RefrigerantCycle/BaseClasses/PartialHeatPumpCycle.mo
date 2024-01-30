within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialHeatPumpCycle
  "Partial model to allow selection of only heat pump options"
  extends PartialRefrigerantCycle(scaFac=QHea_flow_nominal/QHeaNoSca_flow_nominal);
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal
    "Nominal heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaNoSca_flow_nominal
    "Unscaled nominal heating capacity "
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean useInHeaPum
    "=false to indicate that this model is used in a chiller";
  Modelica.Blocks.Math.Feedback feeHeaFloEva
    "Calculates evaporator heat flow with total energy balance" annotation (
      Placement(transformation(extent={{-80,-20},{-60,0}}, rotation=0)));
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.CalculateCOP calCOP(
    PEleMin=PEle_nominal*0.1) if calEff
    "Calculate the COP"
    annotation (Placement(transformation(extent={{-60,-80},{-80,-100}})));
equation
  connect(iceFacCal.iceFac, sigBus.icefacHPMea) annotation (Line(points={{-81.2,
          -50},{-64,-50},{-64,-28},{-110,-28},{-110,120},{1,120}},
                                                              color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(feeHeaFloEva.y, proRedQEva.u2)
    annotation (Line(points={{-61,-10},{-24,-10},{-24,-78}}, color={0,0,127}));
  connect(calCOP.QUse_flow, redQCon.y) annotation (Line(points={{-58,-94},{-46,
          -94},{-46,-116},{70,-116},{70,-101}},
                                             color={0,0,127}));
  connect(calCOP.COP, sigBus.COP) annotation (Line(points={{-81,-90},{-110,-90},{
          -110,120},{1,120}},  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
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
end PartialHeatPumpCycle;
