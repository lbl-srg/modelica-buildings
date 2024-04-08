within Buildings.Fluid.HeatPumps.ModularReversible;
model Modular
  "Grey-box model for reversible heat pumps"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine(
    final use_COP=true,
    final use_EER=use_rev,
    con(preDro(m_flow(nominal=QHea_flow_nominal/1000/10))),
    eva(preDro(m_flow(nominal=QHea_flow_nominal/1000/10))),
    final PEle_nominal=refCyc.refCycHeaPumHea.PEle_nominal,
    mCon_flow_nominal=QHea_flow_nominal/(dTCon_nominal*cpCon),
    mEva_flow_nominal=(QHea_flow_nominal - PEle_nominal)/(dTEva_nominal*cpEva),
    use_rev=true,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle refCyc(
      redeclare model RefrigerantCycleHeatPumpHeating =
          RefrigerantCycleHeatPumpHeating,
      redeclare model RefrigerantCycleHeatPumpCooling =
          RefrigerantCycleHeatPumpCooling));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)
    "Nominal heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(max=0)=0
    "Nominal cooling capacity"
      annotation(Dialog(group="Nominal condition - Cooling", enable=use_rev));

  replaceable model RefrigerantCycleHeatPumpHeating =
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
      (PEle_nominal=0)
       constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
       final useInHeaPum=true,
       final QHea_flow_nominal=QHea_flow_nominal,
       final TCon_nominal=TConHea_nominal,
       final TEva_nominal=TEvaHea_nominal,
       final cpCon=cpCon,
       final cpEva=cpEva)
  "Refrigerant cycle module for the heating mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleHeatPumpCooling =
      Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling
      constrainedby
    Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
       final useInChi=false,
       final cpCon=cpCon,
       final cpEva=cpEva,
       final TCon_nominal=TEvaCoo_nominal,
       final TEva_nominal=TConCoo_nominal,
       QCoo_flow_nominal=QCoo_flow_nominal)
  "Refrigerant cycle module for the cooling mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);
  parameter Modelica.Units.SI.Temperature TConHea_nominal
    "Nominal temperature at secondary condenser side in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TEvaHea_nominal
    "Nominal temperature at secondary evaporator side in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "Nominal temperature at secondary condenser side in cooling mode"
    annotation(Dialog(enable=use_rev, group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "Nominal temperature at secondary evaporator side in cooling mode"
    annotation(Dialog(enable=use_rev, group="Nominal condition - Cooling"));

  Modelica.Blocks.Sources.BooleanConstant conHea(final k=true)
    if not use_busConOnl and not use_rev
    "Locks the device in heating mode if designated to be not reversible" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-130})));
  Modelica.Blocks.Interfaces.BooleanInput hea if not use_busConOnl and use_rev
    "=true for heating, =false for cooling"
    annotation (Placement(transformation(extent={{-172,-86},{-140,-54}}),
        iconTransformation(extent={{-120,-28},{-102,-10}})));
equation
  connect(conHea.y, sigBus.hea)
    annotation (Line(points={{-99,-130},{-76,-130},{-76,-40},{-140,-40},{-140,-41},
          {-141,-41}},          color={255,0,255}));
  connect(hea, sigBus.hea)
    annotation (Line(points={{-156,-70},{-128,-70},{-128,-40},{-134,-40},{-134,
          -41},{-141,-41}},
                       color={255,0,255}));
  connect(eff.QUse_flow, refCycIneCon.y) annotation (Line(points={{98,37},{48,37},
          {48,66},{8.88178e-16,66},{8.88178e-16,61}}, color={0,0,127}));
  connect(eff.hea, sigBus.hea) annotation (Line(points={{98,30},{48,30},{48,0},{
          26,0},{26,-30},{-20,-30},{-20,-41},{-141,-41}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}})),
    Documentation(revisions="
<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
  <li>
    <i>November 26, 2018,</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model of a reversible, modular heat pump.
  This models allows combining any of the available modules
  for refrigerant heating or cooling cycles, inertias,
  heat losses, and safety controls.
  All features are optional.
</p>
<p>
  Adding to the partial model (
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine\">
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine</a>),
  this model has the <code>hea</code> signal to choose
  the operation mode of the heat pump.
</p>
<p>
  For more information on the approach, see
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide</a>.
</p>
</html>"));
end Modular;
