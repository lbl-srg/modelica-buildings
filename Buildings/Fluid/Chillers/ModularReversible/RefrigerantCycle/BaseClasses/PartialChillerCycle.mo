within Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialChillerCycle
  "Partial model of refrigerant cycle used for chiller applications"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle(
      scaFac=QCoo_flow_nominal/QCooNoSca_flow_nominal);
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal
    "Nominal cooling capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCooNoSca_flow_nominal
    "Unscaled nominal cooling capacity "
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean useInChi
    "=false to indicate that this model is used as a heat pump";
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.CalculateCOP
    calEER(PEleMin=PEle_nominal*0.1)  if calEff
                                      "Calculate the EER"
    annotation (Placement(transformation(extent={{-90,-80},{-110,-100}})));
  Modelica.Blocks.Math.Gain gain(final k=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,-90})));
equation
  connect(iceFacCal.iceFac, sigBus.iceFacChiMea) annotation (Line(points={{-81.2,-50},
          {-72,-50},{-72,-30},{-110,-30},{-110,120},{1,120}},      color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(calEER.COP, sigBus.EER) annotation (Line(points={{-111,-90},{-116,-90},
          {-116,-30},{-110,-30},{-110,120},{1,120}},
                               color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(calEER.QUse_flow, gain.y) annotation (Line(points={{-88,-94},{-84,-94},
          {-84,-90},{-81,-90}}, color={0,0,127}));
  connect(gain.u, proRedQEva.y) annotation (Line(points={{-58,-90},{-50,-90},{-50,
          -108},{-30,-108},{-30,-101}}, color={0,0,127}));
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
