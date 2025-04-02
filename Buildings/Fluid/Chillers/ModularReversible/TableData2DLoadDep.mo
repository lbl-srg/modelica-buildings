within Buildings.Fluid.Chillers.ModularReversible;
model TableData2DLoadDep
  "Grey-box model for chillers"
  extends Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine(
    final use_busConOnl=true,
    final use_COP=have_switchover,
    final use_EER=true,
    final use_rev=false,
    final PEle_nominal=refCyc.refCycChiCoo.PEle_nominal,
    dpEva_nominal=datCoo.dpEva_nominal * scaFacCoo ^ 2,
    dpCon_nominal=datCoo.dpCon_nominal * scaFacCoo ^ 2,
    safCtr(
      redeclare Buildings.Fluid.Chillers.ModularReversible.Controls.Safety.OperationalEnvelope opeEnv),
    redeclare replaceable
      Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.TableData2DLoadDep safCtrPar
      constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
        final use_maxCycRat=false,
        final tabUppHea=[0, 0],
        final tabLowCoo=datCoo.tabLowBou,
        final use_TConOutCoo=datCoo.use_TConOutForOpeEnv,
        final use_TEvaOutCoo=datCoo.use_TEvaOutForOpeEnv),
    dTEva_nominal=abs(QCoo_flow_nominal) / cpEva / mEva_flow_nominal,
    dTCon_nominal=(abs(QCoo_flow_nominal) + PEle_nominal) / cpCon /
      mCon_flow_nominal,
    GEvaIns=0,
    GEvaOut=0,
    CEva=0,
    use_evaCap=false,
    GConIns=0,
    GConOut=0,
    CCon=0,
    use_conCap=false,
    mEva_flow_nominal=datCoo.mEva_flow_nominal * scaFacCoo,
    mCon_flow_nominal=datCoo.mCon_flow_nominal * scaFacCoo,
    redeclare final Buildings.Fluid.Chillers.ModularReversible.BaseClasses.RefrigerantCycleHeatRecovery refCyc(
      redeclare final model RefrigerantCycleChillerCooling=
        RefrigerantCycleChillerCooling));
  final model RefrigerantCycleChillerCooling=Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2DLoadDep(
    final useInChi=true,
    final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
    final have_switchover=have_switchover,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final TCon_nominal=TConCoo_nominal,
    final TEva_nominal=TEvaCoo_nominal,
    final cpCon=cpCon,
    final cpEva=cpEva,
    redeclare final Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
    final dat=datCoo)
    "Refrigerant cycle module for the cooling mode";
  parameter Boolean have_switchover=false
    "Set to true for heat recovery chiller with built-in switchover"
    annotation (Evaluate=true);
  parameter Boolean use_TLoaLvgForCtl=true
    "Set to true for leaving temperature control, false for entering temperature control"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(final max=0, start=0)
    "Nominal cooling capacity"
    annotation (Dialog(group="Nominal condition"));
  final parameter Real scaFacCoo=refCyc.refCycChiCoo.scaFac
    "Scaling factor of power and heat flow rate";
  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic datCoo
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic
    "Cooling performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{114,-18},{130,-2}})));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "CHW temperature: leaving if datCoo.use_TEvaOutForTab=true, entering otherwise"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "Condenser cooling fluid temperature: leaving if datCoo.use_TConOutForTab=true, entering otherwise"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "On/off command: true to enable chiller, false to disable chiller"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-142,-20},{-102,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-142,0},{-102,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput coo
    if have_switchover "Switchover signal: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
      iconTransformation(extent={{-142,-40},{-102,0}})));
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.CalculateCommandSignal calYSet(
    final use_rev=false,
    final useInHeaPum=false)
    "Calculate command signal from required PLR"
    annotation (Placement(transformation(extent={{-50,-20},{-70,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conCoo(k=true)
    if not have_switchover
    "Locks the device in cooling mode if have_switchover=false"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Modelica.Blocks.Logical.Not notCoo
    "Not cooling is heat recovery"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={70,50})));
  Buildings.Controls.OBC.CDL.Reals.Switch QUse_flow
    "Select useful heat flow rate depending on operating mode"
    annotation (Placement(transformation(extent={{92,-30},{72,-10}})));
  Modelica.Blocks.Interfaces.RealOutput PLR(final unit="1")
    "Compressor part load ratio" annotation (Placement(transformation(extent={{
            140,-70},{160,-50}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-110})));
equation
  if not use_intSafCtr then
    connect(calYSet.ySet, sigBus.yMea)
      annotation (Line(points={{-72,-10},{-74,-10},{-74,-34},{-136,-34},{-136,-41},
            {-141,-41}}, color={0,0,127}));
  end if;
  connect(on, sigBus.onOffMea)
    annotation (Line(points={{-160,-20},{-132,-20},{-132,-38},{-141,-38},{-141,
          -41}},                                               color={255,0,255}));
  connect(TSet, sigBus.TSet)
    annotation (Line(points={{-160,40},{-120,40},{-120,-38},{-141,-38},{-141,-41}},
                                                             color={0,0,127}));
  connect(coo, sigBus.coo)
    annotation (Line(points={{-160,-80},{-132,-80},{-132,-42},{-142,-42},{-142,-41},
          {-141,-41}},                                         color={255,0,255}),
      Text(string="%second",index=1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(calYSet.ySet, sigBus.ySet)
    annotation (Line(points={{-72,-10},{-74,-10},{-74,-34},{-138,-34},{-138,-41},
          {-141,-41}},
      color={0,0,127}));
  connect(calYSet.ySet, safCtr.ySet)
    annotation (Line(points={{-72,-10},{-74,-10},{-74,-28},{-118,-28},{-118,-10},
          {-113.333,-10}},
      color={0,0,127}));
  connect(conCoo.y, sigBus.coo) annotation (Line(points={{-98,-90},{-84,-90},{-84,
          -42},{-141,-42},{-141,-41}}, color={255,0,255}));
  connect(eff.hea, notCoo.y)
    annotation (Line(points={{98,30},{90,30},{90,50},{81,50}},color={255,0,255}));
  connect(notCoo.u, sigBus.coo)
    annotation (Line(points={{58,50},{40,50},{40,-38},{-140,-38},{-140,-41},{
          -141,-41}},
      color={255,0,255}),Text(string="%second",index=1,extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(QUse_flow.u2, sigBus.coo)
    annotation (Line(points={{94,-20},{100,-20},{100,-38},{-140,-38},{-140,-41},{-141,-41}},
      color={255,0,255}));
  connect(QEva_flow, QUse_flow.u1)
    annotation (Line(points={{150,-130},{108,-130},{108,-12},{94,-12}},color={0,0,127}));
  connect(QCon_flow, QUse_flow.u3)
    annotation (Line(points={{150,130},{134,130},{134,-28},{94,-28}},color={0,0,127}));
  connect(QUse_flow.y, eff.QUse_flow)
    annotation (Line(points={{70,-20},{66,-20},{66,37},{98,37}},color={0,0,127}));
  connect(PLR, sigBus.yMea) annotation (Line(points={{150,-60},{130,-60},{130,
          -36},{-138,-36},{-138,-40},{-140,-40},{-140,-41},{-141,-41}}, color={
          0,0,127}));
  connect(sigBus.PLRCoo, calYSet.PLRCoo) annotation (Line(
      points={{-141,-41},{-44,-41},{-44,-16},{-48,-16}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-100,-12},{-72,-30}},
          textColor={255,85,255},
          visible=not use_busConOnl and use_rev,
          textString="hea")}),
    Diagram(
      coordinateSystem(
        extent={{-140,-160},{140,160}})),
    Documentation(
      revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a model for cooling-only or heat recovery chillers
where the capacity and power are interpolated from manufacturer
data along three variables.
</p>
<ul>
<li>Evaporator entering or leaving temperature: the choice
between the entering or leaving temperature depends on the
value of the parameter <code>use_TEvaOutForTab</code>
specified in the parameter record
(<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic\">
Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic</a>).
</li>
<li>Condenser entering or leaving temperature: the choice
between the entering or leaving temperature depends on the
value of the parameter <code>use_TConOutForTab</code>
specified in the parameter record.
</li>
<li>Compressor part load ratio (PLR): the part load ratio is used as
a proxy variable for the actual capacity modulation observable.
A discrete observable such as the number of operating compressors
for systems with multiple on/off compressors is converted into
a continuous PLR value and the model only approximates the system
performance on a time average.
</li>
</ul>
<p>
The model includes ideal controls that solve for the CHW or HW supply
or return temperature setpoint within the capacity limit.
The Boolean parameter <code>use_TLoaLvgForCtl</code> is used
for toggling between supply or return temperature control.
The default setting <code>use_TLoaLvgForCtl=true</code> corresponds to
supply temperature control.
</p>
<p>
For a comprehensive description of the algorithm and the calculations
for capacity and power, please refer to the documentation of
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>.
This documentation also details the required format for the performance data file.
</p>
<h4>Control points</h4>
<p>
The following input points are available.
</p>
<ul>
<li>
Chiller on/off command signal: <code>on</code>
(Boolean, scalar)
</li>
<li>For heat recovery chillers only (<code>have_switchover=true</code>),
chiller switchover signal: <code>coo</code>
(Boolean, scalar)<br/>
Set <code>coo=true</code> for cooling mode,
<code>coo=false</code> for heating mode.
</li>
<li>
Chiller temperature setpoint: <code>TSet</code>
(real, scalar)<br/>
This is the supply or return temperature setpoint
depending on the value of <code>use_TLoaLvgForCtl</code>.
For heat recovery chillers, the active setpoint must be
switched externally between CHW and HW temperature.
</li>
</ul>
<h4>Implementation details</h4>
<p>
This model introduces structural changes compared to other models within
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible\">
Buildings.Fluid.Chillers.ModularReversible</a>.
</p>
<p>First, there is no replaceable heating cycle component.
Instead, the Boolean parameter <code>have_switchover</code> is used
for toggling between cooling-only and heat recovery chillers.
A major implication is that a single performance data file is used
to represent heating and cooling modes in the case of heat recovery
chillers. This data file only provides the maximum cooling heat flow
rate and input power.
</p>
<p>
Second, the model includes new input variables that match
the control points found in chiller onboard controllers
(see the previous section for their description).
</p>
</html>"));
end TableData2DLoadDep;
