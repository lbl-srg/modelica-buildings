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
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(
    max=0,
    start=0)
    "Nominal cooling capacity"
    annotation (Dialog(group="Nominal condition - Cooling"));
  final parameter Real scaFacCoo=refCyc.refCycChiCoo.scaFac
    "Scaling factor of power and heat flow rate";
  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic datCoo
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic
    "Cooling performance data"
    annotation (choicesAllMatching=true,
    Dialog(enable=use_rev),
  Placement(transformation(extent={{114,-18},{130,-2}})));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "Nominal temperature of the cooled fluid"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "Nominal temperature of the heated fluid"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "Enable command"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-142,-20},{-102,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-142,0},{-102,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput coo
    if have_switchover
    "Heating mode enable command"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-142,-40},{-102,0}})));
  Modelica.Blocks.Sources.BooleanConstant conHea1(
    final k=true)
    if not use_rev
    "Locks the device in heating mode if designated to be not reversible"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-110,-126})));
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.CalculateCommandSignal calYSet(
    final use_rev=false,
    final useInHeaPum=false)
    "Calculate command signal from required PLR"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(
    k=true)
    if not have_switchover
    "Placeholder signal to force cooling mode"
    annotation (Placement(transformation(extent={{-40,-80},{-60,-60}})));
  Modelica.Blocks.Logical.Not notCoo
    "Not cooling is heat recovery"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={70,50})));
  Buildings.Controls.OBC.CDL.Reals.Switch QUse_flow
    "Select useful heat flow rate depending on operating mode"
    annotation (Placement(transformation(extent={{92,-30},{72,-10}})));
equation
  if not use_intSafCtr then
    connect(calYSet.ySet, sigBus.yMea)
      annotation (Line(points={{-98,-90},{-92,-90},{-92,-40},{-136,-40},{-136,-41},{-141,-41}},
        color={0,0,127}));
  end if;
  connect(on, sigBus.onOffMea)
    annotation (Line(points={{-160,-20},{-141,-20},{-141,-41}},color={255,0,255}));
  connect(TSet, sigBus.TSet)
    annotation (Line(points={{-160,20},{-141,20},{-141,-41}},color={0,0,127}));
  connect(conHea1.y, sigBus.hea)
    annotation (Line(points={{-99,-126},{-76,-126},{-76,-41},{-141,-41}},color={255,0,255}));
  connect(coo, sigBus.coo)
    annotation (Line(points={{-160,-60},{-141,-60},{-141,-41}},color={255,0,255}),
      Text(string="%second",index=1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(calYSet.ySet, sigBus.ySet)
    annotation (Line(points={{-98,-90},{-92,-90},{-92,-44},{-138,-44},{-138,-41},{-141,-41}},
      color={0,0,127}));
  connect(calYSet.ySet, safCtr.ySet)
    annotation (Line(points={{-98,-90},{-92,-90},{-92,-28},{-120,-28},{-120,-10},
          {-113.333,-10}},
      color={0,0,127}));
  connect(sigBus.PLRCoo, calYSet.PLRCoo)
    annotation (Line(points={{-141,-41},{-141,-96},{-122,-96}},color={255,204,51},thickness=0.5));
  connect(tru.y, sigBus.coo)
    annotation (Line(points={{-62,-70},{-141,-70},{-141,-41}},color={255,0,255}));
  connect(eff.hea, notCoo.y)
    annotation (Line(points={{98,30},{90,30},{90,50},{81,50}},color={255,0,255}));
  connect(notCoo.u, sigBus.coo)
    annotation (Line(points={{58,50},{40,50},{40,-38},{-152,-38},{-152,-41},{-141,-41}},
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
<p>
The following input points are available.
</p>
<ul>
<li>
Chiller on/off command signal: <code>on</code>
(Boolean, scalar)
</li>
<li>For heat recovery chillers only (<code>have_switchover=true</code>),
chiller operating mode command signal: <code>coo</code>
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
