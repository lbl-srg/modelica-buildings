within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
model NoHeating
  "Placeholder to disable heating"
  extends PartialHeatPumpCycle(
    cpEva=4184,
    cpCon=4184,
    PEle_nominal=0,
    redeclare final
      Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
      iceFacCal,
    datSou="",
    QHeaNoSca_flow_nominal=0,
    scaFac=0,
    mEva_flow_nominal=0,
    mCon_flow_nominal=0,
    dTEva_nominal=0,
    dTCon_nominal=0,
    TEva_nominal=273.15,
    TCon_nominal=273.15,
    QHea_flow_nominal=0,
    calCOP(PEleMin=1));
  Modelica.Blocks.Sources.Constant constZer(final k=0)
    "No heating, hence, zero"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(constZer.y, feeHeaFloEva.u1) annotation (Line(points={{-79,30},{-62,30},
          {-62,4},{-94,4},{-94,-10},{-78,-10}},     color={0,0,127}));
  connect(constZer.y, feeHeaFloEva.u2) annotation (Line(points={{-79,30},{-62,
          30},{-62,4},{-94,4},{-94,-24},{-70,-24},{-70,-18}},
        color={0,0,127}));
  connect(constZer.y, redQCon.u2) annotation (Line(points={{-79,30},{-62,30},{-62,
          4},{64,4},{64,-78}}, color={0,0,127}));
  connect(constZer.y, PEle)
    annotation (Line(points={{-79,30},{0,30},{0,-130}}, color={0,0,127}));
  connect(calCOP.PEle, constZer.y) annotation (Line(points={{-58,-86},{-50,-86},{
          -50,30},{-79,30}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  Using this model, the heat pump will always be off.
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
end NoHeating;
