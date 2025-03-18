within Buildings.Fluid.HeatPumps.ModularReversible;
model TableData2DLoadDep
  "Grey-box model for reversible and non-reversible heat pumps"
  extends Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine(
    final use_busConOnl=true,
    final use_COP=true,
    final use_EER=use_rev,
    final PEle_nominal=refCyc.refCycHeaPumHea.PEle_nominal,
    dpEva_nominal=datHea.dpEva_nominal * scaFacHea ^ 2,
    dpCon_nominal=datHea.dpCon_nominal * scaFacHea ^ 2,
    redeclare replaceable
      Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.TableData2DLoadDep safCtrPar
      constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
        final use_maxCycRat=false,
        final tabUppHea=datHea.tabUppBou,
        final tabLowCoo=datCoo.tabLowBou,
        final use_TConOutHea=datHea.use_TConOutForOpeEnv,
        final use_TEvaOutHea=datHea.use_TEvaOutForOpeEnv,
        final use_TConOutCoo=datCoo.use_TConOutForOpeEnv,
        final use_TEvaOutCoo=datCoo.use_TEvaOutForOpeEnv),
    dTEva_nominal=(QHea_flow_nominal - PEle_nominal) / cpEva / mEva_flow_nominal,
    dTCon_nominal=QHea_flow_nominal / cpCon / mCon_flow_nominal,
    GEvaIns=0,
    GEvaOut=0,
    CEva=0,
    use_evaCap=false,
    GConIns=0,
    GConOut=0,
    CCon=0,
    use_conCap=false,
    mEva_flow_nominal=datHea.mEva_flow_nominal * scaFacHea,
    mCon_flow_nominal=datHea.mCon_flow_nominal * scaFacHea,
    use_rev=false,
    redeclare final Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycleConditional refCyc(
      redeclare final model RefrigerantCycleHeatPumpHeating=
        RefrigerantCycleHeatPumpHeating,
      redeclare final model RefrigerantCycleHeatPumpCooling=
        RefrigerantCycleHeatPumpCooling,
      final allowDifferentDeviceIdentifiers=allowDifferentDeviceIdentifiers));
  final model RefrigerantCycleHeatPumpHeating=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2DLoadDep(
    final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
    final useInHeaPum=true,
    final QHea_flow_nominal=QHea_flow_nominal,
    final TCon_nominal=TConHea_nominal,
    final TEva_nominal=TEvaHea_nominal,
    final cpCon=cpCon,
    final cpEva=cpEva,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
    final dat=datHea)
    "Refrigerant cycle module for the heating mode";
  final model RefrigerantCycleHeatPumpCooling=Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2DLoadDep(
    final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
    final useInChi=false,
    final have_switchover=false,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final TCon_nominal=TEvaCoo_nominal,
    final TEva_nominal=TConCoo_nominal,
    final cpCon=cpCon,
    final cpEva=cpEva,
    redeclare final Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
    final dat=datCoo)
    "Refrigerant cycle module for the cooling mode";
  parameter Boolean use_TLoaLvgForCtl=true
    "Set to true for leaving temperature control, false for entering temperature control"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)
    "Nominal heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(
    max=0,
    start=0)
    "Nominal cooling capacity"
    annotation (Dialog(group="Nominal condition - Cooling",
      enable=use_rev));
  final parameter Real scaFacHea=refCyc.refCycHeaPumHea.scaFac
    "Scaling factor of heat pump";
  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump datHea
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump
    "Heating performance data"
    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{82,-18},{98,-2}})));
  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic datCoo(
    devIde="",
    dpCon_nominal=0,
    dpEva_nominal=0,
    fileName="",
    mCon_flow_nominal=0,
    mEva_flow_nominal=0,
    PLRSup={1.0},
    tabLowBou=fill(0.0, 0, 2),
    use_TConOutForTab=datHea.use_TConOutForTab,
    use_TEvaOutForTab=datHea.use_TEvaOutForTab)
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic
    "Cooling performance data"
    annotation (choicesAllMatching=true,
    Dialog(enable=use_rev),
  Placement(transformation(extent={{114,-18},{130,-2}})));
  parameter Modelica.Units.SI.Temperature TConHea_nominal
    "Nominal temperature of the heated fluid"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TEvaHea_nominal
    "Nominal temperature of the cooled fluid"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "Nominal temperature of the cooled fluid"
    annotation (Dialog(enable=use_rev,group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "Nominal temperature of the heated fluid"
    annotation (Dialog(enable=use_rev,group="Nominal condition - Cooling"));
  Modelica.Blocks.Sources.BooleanConstant conHea(
    final k=true)
    if not use_busConOnl and not use_rev
    "Locks the device in heating mode if designated to be not reversible"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-110,-130})));
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.CalculateCommandSignal
    calYSet(
      final use_rev=use_rev,
      final useInHeaPum=true) "Calculate command signal from required PLR"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput hea
    if use_rev
    "Heating mode enable command"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
      iconTransformation(extent={{-142,-40},{-102,0}})));
  Modelica.Blocks.Sources.BooleanConstant conHea1(
    final k=true)
    if not use_rev
    "Locks the device in heating mode if designated to be not reversible"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-110,-126})));
equation
  if not use_intSafCtr then
    connect(calYSet.ySet, sigBus.yMea)
      annotation (Line(points={{-98,-90},{-92,-90},{-92,-40},{-136,-40},{-136,-41},{-141,-41}},
        color={0,0,127}));
  end if;
  connect(conHea.y, sigBus.hea)
    annotation (Line(points={{-99,-130},{-76,-130},{-76,-40},{-140,-40},{-140,-41},{-141,-41}},
      color={255,0,255}));
  connect(hea, sigBus.hea)
    annotation (Line(points={{-160,-70},{-128,-70},{-128,-40},{-134,-40},{-134,-41},{-141,-41}},
      color={255,0,255}));
  connect(eff.QUse_flow, refCycIneCon.y)
    annotation (Line(points={{98,37},{48,37},{48,66},{8.88178e-16,66},{8.88178e-16,61}},
      color={0,0,127}));
  connect(eff.hea, sigBus.hea)
    annotation (Line(points={{98,30},{48,30},{48,0},{26,0},{26,-30},{-20,-30},{-20,-41},{-141,-41}},
      color={255,0,255}),Text(string="%second",index=1,extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigBus.PLRHea, calYSet.PLRHea)
    annotation (Line(points={{-141,-41},{-141,-84},{-122,-84}},color={255,204,51},thickness=0.5));
  connect(calYSet.ySet, sigBus.ySet)
    annotation (Line(points={{-98,-90},{-92,-90},{-92,-44},{-138,-44},{-138,-41},{-141,-41}},
      color={0,0,127}));
  connect(calYSet.ySet, safCtr.ySet)
    annotation (Line(points={{-98,-90},{-92,-90},{-92,-28},{-120,-28},{-120,-10},
          {-113.333,-10}},
      color={0,0,127}));
  connect(sigBus.PLRCoo, calYSet.PLRCoo)
    annotation (Line(points={{-141,-41},{-141,-96},{-122,-96}},color={255,204,51},thickness=0.5));
  connect(on, sigBus.onOffMea)
    annotation (Line(points={{-160,-20},{-141,-20},{-141,-41}},color={255,0,255}));
  connect(TSet, sigBus.TSet)
    annotation (Line(points={{-160,20},{-141,20},{-141,-41}},color={0,0,127}));
  connect(conHea1.y, sigBus.hea)
    annotation (Line(points={{-99,-126},{-76,-126},{-76,-41},{-141,-41}},color={255,0,255}));
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
This is a model for reversible or non-reversible heat pumps
where the capacity and power are interpolated from manufacturer
data along three variables.
</p>
<ul>
<li>Condenser entering or leaving temperature: the choice
between the entering or leaving temperature depends on the
value of the parameter <code>use_TCondOutForTab</code>
specified in the parameter record
(<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump\">
Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump</a>
or
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic\">
Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic</a>).
</li>
<li>Evaporator entering or leaving temperature: the choice
between the entering or leaving temperature depends on the
value of the parameter <code>use_TEvaOutForTab</code>
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
The model includes ideal controls that solve for the HW or CHW supply
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
Heat pump on/off command signal: <code>on</code>
(Boolean, scalar)
</li>
<li>For reversible heat pumps only (<code>use_rev=true</code>),
heat pump operating mode command signal: <code>hea</code>
(Boolean, scalar)<br/>
Set <code>hea=true</code> for heating mode, <code>hea=false</code> for cooling mode.
</li>
<li>
Heat pump temperature setpoint: <code>TSet</code>
(real, scalar)<br/>
This is the supply or return temperature setpoint
depending on the value of <code>use_TLoaLvgForCtl</code>.
For reversible heat pumps, the active setpoint must be
switched externally between HW and CHW temperature.
</li>
</ul>
<h4>Implementation details</h4>
<p>
This model introduces structural changes compared to other models within
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible\">
Buildings.Fluid.HeatPumps.ModularReversible</a>.
</p>
<p>First, the Boolean parameter <code>use_rev</code> is used
for toggling between reversible and non-reversible systems.
This differs from other models which require <i>redeclaring</i> the
component modeling the reversed cycle.
</p>
<p>
Second, the model includes new input variables that match
the control points found in heat pump onboard controllers
(see the previous section for their description).
</p>
</html>"));
end TableData2DLoadDep;
