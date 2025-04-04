within Buildings.Fluid.HeatPumps.ModularReversible;
model Modular4Pipe
  "Grey-box model for reversible and non-reversible heat pumps"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine4Pipe(
    con1(preDro(m_flow(nominal=QHea_flow_nominal/1000/10))),
    final use_COP=false,
    final use_EER=false,
    con(preDro(m_flow(nominal=QHea_flow_nominal/1000/10))),
    eva(preDro(m_flow(nominal=QHea_flow_nominal/1000/10))),
    final PEle_nominal=refCyc.refCycHeaPumAmbHea.PEle_nominal,
    mCon_flow_nominal=QHea_flow_nominal/(dTCon_nominal*cpCon),
    mCon1_flow_nominal=QHeaCoo_flow_nominal/(dTCon1_nominal*cpCon1),
    mEva_flow_nominal=(QHea_flow_nominal - PEle_nominal)/(dTEva_nominal*cpEva),
    use_rev=false,
    redeclare final
      Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle4Pipe
      refCyc(
      redeclare model RefrigerantCycleHeatPumpHeating =
          RefrigerantCycleHeatPumpHeating,
      redeclare model RefrigerantCycleHeatPumpCooling =
          RefrigerantCycleHeatPumpCooling,
      redeclare model RefrigerantCycleHeatPumpHeatingCooling =
          RefrigerantCycleHeatPumpHeatingCooling,
      final allowDifferentDeviceIdentifiers=allowDifferentDeviceIdentifiers));

  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)
    "Nominal heating capacity"
    annotation (Dialog(group="Nominal condition - Ambient Heating"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaCoo_flow_nominal(min=Modelica.Constants.eps)
    "Nominal heating capacity"
    annotation (Dialog(group="Nominal condition - Heating Cooling"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(max=0)=0
    "Nominal cooling capacity"
      annotation(Dialog(group="Nominal condition - Ambient Cooling", enable=use_rev));

  replaceable model RefrigerantCycleHeatPumpHeating =
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating
      (PEle_nominal=0)
       constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
       final useInHeaPum=true,
       final QHea_flow_nominal=QHea_flow_nominal,
       final TCon_nominal=TConHea_nominal,
       final TEva_nominal=TEvaHea_nominal,
       final cpCon=cpCon1,
       final cpEva=cpEva)
  "Refrigerant cycle module for the heating mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleHeatPumpHeatingCooling =
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.HeatingCooling
      (PEle_nominal=0)
       constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle(
       final useInHeaPum=true,
       final QHea_flow_nominal=QHeaCoo_flow_nominal,
       final TCon_nominal=TConHeaCoo_nominal,
       final TEva_nominal=TEvaHeaCoo_nominal,
       final cpCon=cpCon,
       final cpEva=cpEva)
  "Refrigerant cycle module for the heating cooling mode"
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
    "Nominal temperature of the heated fluid"
    annotation (Dialog(group="Nominal condition - Ambient Heating"));
  parameter Modelica.Units.SI.Temperature TEvaHea_nominal
    "Nominal temperature of the cooled fluid"
    annotation (Dialog(group="Nominal condition - Ambient Heating"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "Nominal temperature of the cooled fluid"
    annotation(Dialog(enable=use_rev, group="Nominal condition - Ambient Cooling"));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "Nominal temperature of the heated fluid"
    annotation(Dialog(enable=use_rev, group="Nominal condition - Ambient Cooling"));
  parameter Modelica.Units.SI.Temperature TConHeaCoo_nominal
    "Nominal temperature of the cooled fluid"
    annotation(Dialog(enable=use_rev, group="Nominal condition - Heating Cooling"));
  parameter Modelica.Units.SI.Temperature TEvaHeaCoo_nominal
    "Nominal temperature of the heated fluid"
    annotation(Dialog(enable=use_rev, group="Nominal condition - Heating Cooling"));


  Modelica.Blocks.Interfaces.IntegerInput mod if not use_busConOnl and use_rev
    annotation (Placement(transformation(extent={{-164,-82},{-140,-58}}),
        iconTransformation(extent={{-120,-30},{-102,-12}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    final uLow=0.001,
    final uHigh=ySet_small,
    final pre_y_start=false)
    "Outputs whether the device is on based on the relative speed"
    annotation (Placement(
      transformation(extent={{10,10},{-10,-10}}, rotation=180, origin={-110,-96})));
  Modelica.Blocks.Sources.BooleanConstant conHea(final k=true)
    "Locks the device in heating mode if designated to be not reversible" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,-66})));
equation
  connect(hys.y, sigBus.onOffMea) annotation (Line(points={{-99,-96},{-88,-96},{
          -88,-54},{-124,-54},{-124,-40},{-136,-40},{-136,-41},{-141,-41}},
                                           color={255,0,255}));
  connect(hys.u, sigBus.yMea) annotation (Line(points={{-122,-96},{-132,-96},{-132,
          -40},{-136,-40},{-136,-41},{-141,-41}},
                       color={0,0,127}));
  connect(conHea.y, sigBus.hea) annotation (Line(points={{-45,-66},{-32,-66},{-32,
          -41},{-141,-41}}, color={255,0,255}));
  connect(mod, sigBus.mod) annotation (Line(points={{-152,-70},{-128,-70},{-128,
          -41},{-141,-41}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
          Text(
          extent={{-100,-12},{-72,-30}},
          textColor={255,85,255},
          visible=not use_busConOnl and use_rev,
          textString="hea")}),
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}})),
    Documentation(revisions="<html>
<ul>
  <li>
    February 25, 2025, by Antoine Gautier:<br/>
    Added hysteresis that was removed from base class.<br/>
    This is for
    <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1977\">IBPSA #1977</a>.
  </li>
  <li>
    May 2, 2024, by Michael Wetter:<br/>
    Refactored check for device identifiers.<br/>
    This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">IBPSA, #1576</a>.
  </li>
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
end Modular4Pipe;
