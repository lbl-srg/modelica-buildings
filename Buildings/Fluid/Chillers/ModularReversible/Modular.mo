within Buildings.Fluid.Chillers.ModularReversible;
model Modular
  "Grey-box model for reversible and non-reversible chillers"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine(
    final use_COP=use_rev,
    final use_EER=true,
    con(preDro(m_flow(nominal=-QCoo_flow_nominal/1000/10))),
    eva(preDro(m_flow(nominal=-QCoo_flow_nominal/1000/10))),
    safCtr(redeclare
        Buildings.Fluid.Chillers.ModularReversible.Controls.Safety.OperationalEnvelope
        opeEnv),
    final PEle_nominal=refCyc.refCycChiCoo.PEle_nominal,
    mEva_flow_nominal=-QCoo_flow_nominal/(dTEva_nominal*cpEva),
    mCon_flow_nominal=(PEle_nominal - QCoo_flow_nominal)/(dTCon_nominal*cpCon),
    use_rev=false,
    redeclare final Buildings.Fluid.Chillers.ModularReversible.BaseClasses.RefrigerantCycle refCyc(
        redeclare model RefrigerantCycleChillerCooling =
          RefrigerantCycleChillerCooling, redeclare model
        RefrigerantCycleChillerHeating = RefrigerantCycleChillerHeating));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(max=0)
    "Nominal cooling capcaity"
      annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=0
    "Nominal heating capacity"
      annotation(Dialog(group="Nominal condition - Heating", enable=use_rev));

  replaceable model RefrigerantCycleChillerCooling =
      Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle
      (PEle_nominal=0)
    constrainedby
    Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle(
       final useInChi=true,
       final TCon_nominal=TConCoo_nominal,
       final TEva_nominal=TEvaCoo_nominal,
       final QCoo_flow_nominal=QCoo_flow_nominal,
       final cpCon=cpCon,
       final cpEva=cpEva)
  "Refrigerant cycle module for the cooling mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleChillerHeating =
      Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating
      (PEle_nominal=PEle_nominal)
       constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
       final useInHeaPum=false,
       final TCon_nominal=TEvaHea_nominal,
       final TEva_nominal=TConHea_nominal,
       final QHea_flow_nominal=QHea_flow_nominal,
       final cpCon=cpCon,
       final cpEva=cpEva)
  "Refrigerant cycle module for the heating mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "Nominal temperature of the cooled fluid"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "Nominal temperature of the heated fluid"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TEvaHea_nominal
    "Nominal temperature of the heated fluid"
    annotation (Dialog(enable=use_rev, group="Nominal condition - Heating"));
  parameter Modelica.Units.SI.Temperature TConHea_nominal
    "Nominal temperature of the cooled fluid"
    annotation (Dialog(enable=use_rev, group="Nominal condition - Heating"));


  Modelica.Blocks.Interfaces.BooleanInput coo if not use_busConOnl and use_rev
    "=true for cooling, =false for heating"
    annotation (Placement(transformation(extent={{-172,-86},{-140,-54}}),
        iconTransformation(extent={{-120,-30},{-102,-12}})));
  Modelica.Blocks.Sources.BooleanConstant conCoo(final k=true)
    if not use_busConOnl and not use_rev
    "Locks the device in cooling mode if designated to be not reversible" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-130})));
  Modelica.Blocks.Logical.Not notCoo "Not cooling is heating" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,50})));
equation
  connect(conCoo.y, sigBus.coo)
    annotation (Line(points={{-99,-130},{-76,-130},{-76,-40},{-138,-40},{-138,-42},
          {-140,-42},{-140,-41},{-141,-41}},
                                color={255,0,255}));
  connect(coo, sigBus.coo)
    annotation (Line(points={{-156,-70},{-128,-70},{-128,-40},{-134,-40},{-134,
          -41},{-141,-41}},
                       color={255,0,255}));
  connect(eff.QUse_flow, refCycIneEva.y) annotation (Line(points={{98,37},{48,37},
          {48,0},{26,0},{26,-68},{0,-68},{0,-61}}, color={0,0,127}));
  connect(eff.hea, notCoo.y) annotation (Line(points={{98,30},{90,30},{90,50},{81,
          50}}, color={255,0,255}));
  connect(notCoo.u, sigBus.coo) annotation (Line(points={{58,50},{48,50},{48,0},{
          26,0},{26,-30},{-20,-30},{-20,-41},{-141,-41}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>May 22, 2019,</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model of a reversible, modular chiller.
  This models allows combining any of the available modules
  for refrigerant heating or cooling cycles, inertias,
  heat losses, and safety controls.
  All features are optional.
</p>
<p>
  Adding to the partial model (
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine\">
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine</a>),
  this model has the <code>coo</code> signal to choose
  the operation mode of the chiller.
</p>
<p>
  For more information, see
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide</a>.
</p>
</html>"));
end Modular;
