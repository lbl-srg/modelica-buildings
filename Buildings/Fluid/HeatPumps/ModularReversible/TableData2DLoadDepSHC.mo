within Buildings.Fluid.HeatPumps.ModularReversible;
model TableData2DLoadDepSHC
  "Grey-box model for multipipe heat pumps"
  extends Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialReversibleRefrigerantMachine(
    final use_busConOnl=true,
    final use_COP=true,
    final use_EER=true,
    final PEle_nominal=refCyc.refCycHeaPumHea.PEle_nominal,
    final dpEva_nominal=if use_preDro then dpChw_nominal else 0,
    final dpCon_nominal=if use_preDro then dpHw_nominal else 0,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.TableData2DLoadDep safCtrPar(
      final use_maxCycRat=false,
      use_opeEnv=false,
      use_antFre=false,
      use_minFlowCtr=false,
      tabUppHea=[273.15, 273.15],
      tabLowCoo=[273.15, 273.15]),
    dTEva_nominal=abs(QCoo_flow_nominal) / cpEva / mEva_flow_nominal,
    dTCon_nominal=QHea_flow_nominal / cpCon / mCon_flow_nominal,
    GEvaIns=0,
    GEvaOut=0,
    CEva=0,
    use_evaCap=false,
    GConIns=0,
    GConOut=0,
    CCon=0,
    use_conCap=false,
    mEva_flow_nominal=dat.mEva_flow_nominal * scaFacCoo,
    mCon_flow_nominal=dat.mCon_flow_nominal * scaFacHea,
    final use_rev=false,
    final use_intSafCtr=false,
    final calEff=false,
    redeclare final Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycleConditional refCyc(
      redeclare model RefrigerantCycleHeatPumpHeating=
        RefrigerantCycleHeatPumpHeating,
      redeclare model RefrigerantCycleHeatPumpCooling=
        RefrigerantCycleHeatPumpCooling,
      final allowDifferentDeviceIdentifiers=allowDifferentDeviceIdentifiers));
  final model RefrigerantCycleHeatPumpHeating=
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2DLoadDepSHC(
      final nUni=nUni,
      final use_TLoaLvgForCtl=use_TLoaLvgForCtl,
      final TCon_nominal=TConHea_nominal,
      final TEva_nominal=TEvaHea_nominal,
      final TConCoo_nominal=TConCoo_nominal,
      final TEvaCoo_nominal=TEvaCoo_nominal,
      final QCoo_flow_nominal=QCoo_flow_nominal,
      final QHea_flow_nominal=QHea_flow_nominal,
      final QCooShc_flow_nominal=QCooShc_flow_nominal,
      final QHeaShc_flow_nominal=QHeaShc_flow_nominal,
      final cpCon=cpCon,
      final cpEva=cpEva,
      final dat=dat,
      final P_min=P_min,
      final dtRun=dtRun,
      final dtMea=dtMea,
      final SPLR=SPLR,
      final dTSaf=dTSaf)
    "Refrigerant cycle module for the heating mode";
  final model RefrigerantCycleHeatPumpCooling=
    Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling(
      final useInChi=false,
      final cpCon=cpCon,
      final cpEva=cpEva,
      final TCon_nominal=TEvaCoo_nominal,
      final TEva_nominal=TConCoo_nominal,
      final QCoo_flow_nominal=QCoo_flow_nominal)
    "Refrigerant cycle module for the cooling mode";
  // The following parameter is for future support of 6-pipe systems.
  // Currently only 4-pipe systems are implemented.
  final parameter Buildings.Fluid.HeatPumps.ModularReversible.Types.HeatPump
    typ=Buildings.Fluid.HeatPumps.ModularReversible.Types.HeatPump.AirToWater
    "System type" annotation (Evaluate=true);
  parameter Integer nUni(min=1)=1
    "Number of modules";
  parameter Boolean use_TLoaLvgForCtl=true
    "Set to true for leaving temperature control, false for entering temperature control"
    annotation (Evaluate=true);
  parameter Boolean use_preDro=true
    "Set to true to model HW/CHW pressure drop, false for external calculation by valve component"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dpHw_nominal =
    dat.dpCon_nominal * scaFacHea ^ 2
    "HW pressure drop - Only modeled in component if use_preDro=true"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChw_nominal =
    dat.dpEva_nominal * scaFacCoo ^ 2
    "CHW pressure drop - Only modeled in component if use_preDro=true"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal
    "Heating heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal
    "Cooling heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaShc_flow_nominal
    "Heating heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - SHC"));
  parameter Modelica.Units.SI.HeatFlowRate QCooShc_flow_nominal
    "Cooling heat flow rate - All modules"
    annotation (Dialog(group="Nominal condition - SHC"));
  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDepSHC.Generic dat
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDepSHC.Generic
    "Performance data"
    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{82,-18},{98,-2}})));
  parameter Modelica.Units.SI.Power P_min(final min=0)=0
    "Remaining power when system is enabled with all compressors cycled off";
  parameter Modelica.Units.SI.Temperature TConHea_nominal
    "HW temperature: leaving if dat.use_TConOutForTab=true, entering otherwie"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TEvaHea_nominal
    "Evaporator heating fluid temperature: leaving if dat.use_TAmbOutForTab=true, entering otherwie"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConCoo_nominal
    "CHW temperature: leaving if dat.use_TEvaOutForTab=true, entering otherwise"
    annotation (Dialog(group="Nominal condition - Cooling"));
  parameter Modelica.Units.SI.Temperature TEvaCoo_nominal
    "Condenser cooling fluid temperature: leaving if dat.use_TAmbOutForTab=true, entering otherwise"
    annotation (Dialog(group="Nominal condition - Cooling"));
  parameter Boolean allowFlowReversalAmb = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for ambient-side medium"
    annotation(Dialog(tab="Assumptions", enable=typ == Buildings.Fluid.HeatPumps.ModularReversible.Types.HeatPump.WaterToWater),
    Evaluate=true);
  final parameter Real scaFacHea(
    unit="1")=refCyc.refCycHeaPumHea.calQUseP.scaFacHea
    "Scaling factor for interpolated heat flow rate and power - Heating mode";
  final parameter Real scaFacCoo(
    unit="1")=refCyc.refCycHeaPumHea.calQUseP.scaFacCoo
    "Scaling factor for interpolated heat flow rate and power - Cooling mode";
  parameter Real dpValIso_nominal = Buildings.Templates.Data.Defaults.dpValIso
    "HW/CHW isolation valve pressure drop at nominal flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  final parameter Buildings.Fluid.Actuators.Valves.Data.Generic chaValHwIso =
    Buildings.Fluid.Actuators.Valves.Data.Generic(
      y={i / nUni for i in 0:nUni},
      phi={sqrt((i / nUni)^2 * dpValIso_nominal /
        (dpValIso_nominal + dpHw_nominal * (1 - (i / nUni)^2)))
        for i in 0:nUni})
    "Equivalent HW isolation valve flow characteristic"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  final parameter Buildings.Fluid.Actuators.Valves.Data.Generic chaValChwIso =
    Buildings.Fluid.Actuators.Valves.Data.Generic(
      y={i / nUni for i in 0:nUni},
      phi={sqrt((i / nUni)^2 * dpValIso_nominal /
        (dpValIso_nominal + dpChw_nominal * (1 - (i / nUni)^2)))
        for i in 0:nUni})
    "Equivalent CHW isolation valve flow characteristic"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Real dtRun(
    final min=0,
    final unit="s") = 300
    "Minimum stage runtime"
    annotation (Dialog(tab="Advanced - Staging logic"));
  parameter Real dtMea(
    final min=0,
    final unit="s") = 120
    "Load averaging time window"
    annotation (Dialog(tab="Advanced - Staging logic"));
  parameter Real SPLR(
    max=1,
    min=0) = 0.9
    "Staging part load ratio"
    annotation (Dialog(tab="Advanced - Staging logic"));
  parameter Modelica.Units.SI.TemperatureDifference dTSaf(
    final min=0) = 2
    "Maximum temperature deviation from setpoint before limiting demand for safety (>0)"
    annotation (Dialog(tab="Advanced - Safeties"));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "On/off command: true to enable heat pump, false to disable heat pump"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-138,-38},{-102,-2}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode
    "System operating mode command"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
        iconTransformation(extent={{-138,-58},{-102,-22}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THwSet(
    final unit="K",
    displayUnit="degC")
    "HW temperature setpoint - Supply or return depending on use_TLoaLvgForCtl"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-138,22},{-102,58}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChwSet(
    final unit="K",
    displayUnit="degC")
    "CHW temperature setpoint - Supply or return depending on use_TLoaLvgForCtl"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-138,-18},{-102,18}})));
  BoundaryConditions.WeatherData.Bus weaBus
    if typ == Buildings.Fluid.HeatPumps.ModularReversible.Types.HeatPump.AirToWater
    "Weather bus"
    annotation (Placement(
        transformation(extent={{-20,160},{20,200}}), iconTransformation(extent={{-10,90},
            {10,110}})));
  // The following block is to prepare future support of six-pipe systems.
  Templates.Plants.Controls.Utilities.PlaceholderReal TAmbIn(final have_inp=typ
         == Buildings.Fluid.HeatPumps.ModularReversible.Types.HeatPump.AirToWater,
      have_inpPh=true) "Ambient-side fluid inlet temperature" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-16,144})));
  Modelica.Blocks.Sources.BooleanConstant conHea(final k=true)
    "Placeholder signal"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={-100,-88})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniHea(start=0)
    "Number of modules in heating mode"
    annotation (Placement(transformation(extent={{140,-80},{180,-40}}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={30,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniCoo(start=0)
    "Number of modules in cooling mode"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniShc(start=0)
    "Number of modules in SHC mode (may be cycling into single mode)"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-30,-120})));
  Modelica.Blocks.Interfaces.RealOutput yValHwIso(final unit="1")
    "Equivalent HW isolation valve command" annotation (Placement(
        transformation(extent={{140,100},{160,120}}),iconTransformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={80,110})));
  Modelica.Blocks.Interfaces.RealOutput yValChwIso(final unit="1")
    "Equivalent CHW isolation valve command" annotation (Placement(
        transformation(extent={{140,80},{160,100}}),iconTransformation(extent={{-10,-10},
            {10,10}},
        rotation=-90,
        origin={-80,-110})));
  Modelica.Blocks.Interfaces.BooleanOutput y1HwValIsoPumPri[nUni]
    "HW isolation valve or primary pump command" annotation (Placement(
        transformation(extent={{140,60},{160,80}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,110})));
  Modelica.Blocks.Interfaces.BooleanOutput y1ChwValIsoPumPri[nUni]
    "CHW isolation valve or primary pump command"
    annotation (Placement(
        transformation(extent={{140,40},{160,60}}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,-110})));
  Modelica.Blocks.Sources.BooleanExpression calY1ValChwIso[nUni](y={on and (
        mode == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.cooling
         or mode == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.shc)
         and (i == 1 or nUniShc + nUniCoo >= i) for i in 1:nUni})
    "Calculate CHW isolation valve command" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={120,50})));
  Modelica.Blocks.Sources.RealExpression calYValHwIso(y=if on and (mode ==
        Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.heating
         or mode == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.shc)
         then max(1, nUniShc + nUniHea)/nUni else 0)
    "Calculate equivalent HW isolation valve command" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={120,110})));
  Modelica.Blocks.Sources.RealExpression calYValChwIso(y=if on and (mode ==
        Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.cooling
         or mode == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.shc)
         then max(1, nUniShc + nUniCoo)/nUni else 0)
    "Calculate equivalent CHW isolation valve command" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={120,90})));
  Modelica.Blocks.Sources.BooleanExpression calY1ValHwIso[nUni](y={on and (mode
         == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.heating
         or mode == Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes.shc)
         and (i == 1 or nUniShc + nUniHea >= i) for i in 1:nUni})
    "Calculate HW isolation valve command" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={120,70})));
equation
  connect(eff.QUse_flow, refCycIneCon.y)
    annotation (Line(points={{98,37},{48,37},{48,66},{8.88178e-16,66},{8.88178e-16,61}},
      color={0,0,127}));
  connect(eff.hea, sigBus.hea)
    annotation (Line(points={{98,30},{48,30},{48,0},{26,0},{26,-30},{-20,-30},{-20,-41},{-141,-41}},
      color={255,0,255}),Text(string="%second",index=1,extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(on, sigBus.onOffMea)
    annotation (Line(points={{-160,-20},{-130,-20},{-130,-38},{-142,-38},{-142,
          -41},{-141,-41}},                                    color={255,0,255}));
  connect(THwSet, sigBus.THwSet) annotation (Line(points={{-160,60},{-122,60},{-122,
          -41},{-141,-41}}, color={0,0,127}));
  connect(TChwSet, sigBus.TChwSet) annotation (Line(points={{-160,40},{-124,40},
          {-124,-41},{-141,-41}}, color={0,0,127}));
  connect(weaBus.TDryBul, TAmbIn.u) annotation (Line(
      points={{0.1,180.1},{0.1,144},{-4,144}},
      color={255,204,51},
      thickness=0.5));
  connect(TAmbIn.y, sigBus.TAmbInMea) annotation (Line(points={{-28,144},{-34,144},
          {-34,-40},{-141,-40},{-141,-41}}, color={0,0,127}));
  connect(mode, sigBus.mode) annotation (Line(points={{-160,-80},{-130,-80},{-130,
          -41},{-141,-41}}, color={255,127,0}));
  connect(conHea.y, sigBus.hea) annotation (Line(points={{-111,-88},{-128,-88},{
          -128,-41},{-141,-41}}, color={255,0,255}));
  connect(nUniHea, sigBus.nUniHea) annotation (Line(points={{160,-60},{130,-60},
          {130,-41},{-141,-41}},                     color={255,127,0}));
  connect(nUniCoo, sigBus.nUniCoo) annotation (Line(points={{160,-80},{128,-80},
          {128,-41},{-141,-41}}, color={255,127,0}));
  connect(nUniShc, sigBus.nUniShc) annotation (Line(points={{160,-100},{126,
          -100},{126,-41},{-141,-41}}, color={255,127,0}));
  connect(calYValChwIso.y, yValChwIso)
    annotation (Line(points={{131,90},{150,90}}, color={0,0,127}));
  connect(calYValHwIso.y, yValHwIso)
    annotation (Line(points={{131,110},{150,110}}, color={0,0,127}));
  connect(calY1ValHwIso.y, y1HwValIsoPumPri)
    annotation (Line(points={{131,70},{150,70}}, color={255,0,255}));
  connect(calY1ValChwIso.y, y1ChwValIsoPumPri)
    annotation (Line(points={{131,50},{150,50}}, color={255,0,255}));
  annotation (
    defaultComponentName="hp",
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
        extent={{-140,-180},{140,180}}, grid={2,2})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 1, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a model for simultaneous heating and cooling (SHC) systems
(also called multipipe chillers or heat pumps),
where the capacity and power are interpolated from manufacturer
data along the source and sink temperature and the part load ratio (PLR).<sup>1</sup>
</p>
<p>
The model supports modeling both modular (<code>nUni > 1</code>) and
single-unit (<code>nUni = 1</code>) systems.
When modeling modular systems, the staging logic for multiple modules is
included, but the HW and CHW isolation valves are not.
However, the model includes the calculation of the flow characteristic
of an equivalent actuator model to simplify the modeling of isolation valves.
The model also provides control variables for these valves, or for primary pumps
that are not controlled based on &Delta;p.
See Section \"Implementation details\" for further precision.
</p>
<p>
The model includes ideal controls that solve for the HW or CHW supply
or return temperature setpoint within the capacity limit.
The Boolean parameter <code>use_TLoaLvgForCtl</code> is used
for toggling between supply or return temperature control.
The default setting <code>use_TLoaLvgForCtl = true</code> corresponds to
supply temperature control.
</p>
<p>
For a comprehensive description of the algorithm and underlying assumptions,
please refer to the documentation of
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC</a>.
This documentation also details the required format for the performance data file.
</p>
<h5>Footnotes</h5>
<p>
<sup>1</sup>
The part load ratio is used as a proxy variable for the actual capacity modulation observable.
A discrete observable such as the number of operating compressors
for systems with multiple on/off compressors is converted into
a continuous PLR value and the model only approximates the system
performance on a time average.
</p>
<h4>Control points</h4>
<p>
The following input points are available.
</p>
<ul>
<li>
On/off command signal: <code>on</code>
(Boolean, scalar)
</li>
<li>System operating mode command: <code>mode</code>
(integer, scalar)<br/>
Based on the mode definitions from
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Types.OperatingModes\">
Buildings.Fluid.HeatPumps.Types.OperatingModes</a>
and the logic described in
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC</a>.
</li>
<li>
HW temperature setpoint: <code>THwSet</code>
(real, scalar)<br/>
This is either the supply or return temperature setpoint
depending on the value of <code>use_TLoaLvgForCtl</code>.
</li>
<li>
CHW temperature setpoint: <code>TChwSet</code>
(real, scalar)<br/>
This is either the supply or return temperature setpoint
depending on the value of <code>use_TLoaLvgForCtl</code>.
</li>
</ul>
<p>
The following output points are available.
</p>
<ul>
<li>
HW isolation valve commanded position: <code>yValHwIso</code>
(real, scalar)<br/>
This is a real scalar signal (not a Boolean vector) that is provided to control
a single instance of
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayPolynomial\">
Buildings.Fluid.Actuators.Valves.TwoWayPolynomial</a>
as an equivalent for the modules' HW isolation valves, see Section \"Implementation details\".
</li>
<li>
CHW isolation valve commanded position: <code>yValChwIso</code>
(real, scalar)<br/>
This is a real scalar signal (not a Boolean vector) that is provided to control
a single instance of
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayPolynomial\">
Buildings.Fluid.Actuators.Valves.TwoWayPolynomial</a>
as an equivalent for the modules' CHW isolation valves, see Section \"Implementation details\".
</li>
<li>
HW isolation valve or primary pump command: <code>y1HwValIsoPumPri</code>
(Boolean, 1D-array of dimension <code>nUni</code>)<br/>
This variable is provided to control a parallel arrangement of either
HW isolation valves (two-position) or primary pumps, see Section \"Implementation details\".
</li>
<li>
CHW isolation valve or primary pump command: <code>y1ChwValIsoPumPri</code>
(Boolean, 1D-array of dimension <code>nUni</code>)<br/>
This variable is provided to control a parallel arrangement of either
CHW isolation valves (two-position) or primary pumps, see Section \"Implementation details\".
</li>
</ul>
<h4>Implementation details</h4>
<p>
Modular systems are typically installed with HW and CHW isolation valves for each module.
The model does not include these valves.
Furthermore, the model aggregates all modules into an equivalent heating or cooling system.
For integration into a plant model, the recommended approach consists of using
a single instance of
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayPolynomial\">
Buildings.Fluid.Actuators.Valves.TwoWayPolynomial</a>
to represent the parallel network of HW isolation valves in series with the
modules' condenser barrels, and another instance to represent the parallel network of
CHW isolation valves in series with the modules' evaporator barrels.
The heat pump model must then be configured with <code>use_preDro = false</code>
to inhibit the heat exchanger pressure drop calculation.
</p>
<p>
The actuator model can be parameterized with the flow characteristic
<code>chaValHwIso</code> (resp. <code>chaValChwIso</code>) which is calculated by
the current model to ensure that a fractional opening of <code>1 / i</code>
results in a mass flow rate of <code>mCon_flow_nominal / i</code>
(resp. <code>mEva_flow_nominal / i</code>) when the model is subjected to a
differential pressure of <code>dpHw_nominal</code> on the HW side
(resp. <code>dpChw_nominal</code> on the CHW side).
The flow characteristic is calculated under the assumption that the
heat pump heat exchanger flow resistance is lumped with the actuator
flow resistance, which yields the following expression for the characteristic:
</p>
<code>&phi;(y) = (y<sup>2</sup> * dpValIso_nominal /
(dpValIso_nominal + dp&lt;Hw|Chw&gt;_nominal * (1 - y<sup>2</sup>)))<sup>1/2</sup></code>,
<p>
where <code>y = 1 / i</code> is the fractional opening of the equivalent actuator
when a number of <code>i</code> modules are enabled on the HW or CHW side,
and <code>dpValIso_nominal</code> is the isolation valve pressure drop at design flow.
</p>
<p>
Note that at least one HW isolation valve (resp. CHW isolation valve) must be open
when the heat pump is in SHC or heating-only mode (resp. SHC or cooling-only mode),
irrespective of any modules being staged on. This is a requirement for proper load calculation
in the staging logic. This requirement is taken into account in the calculation of
the control variables for the equivalent actuator <code>yValHwIso</code> and <code>yValChwIso</code>.
</p>
<p>This approach is illustrated in the example models
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Examples.TableData2DLoadDepSHC1Only\">
Buildings.Fluid.HeatPumps.ModularReversible.Examples.TableData2DLoadDepSHC1Only</a>
and
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Examples.TableData2DLoadDepSHC1And2\">
Buildings.Fluid.HeatPumps.ModularReversible.Examples.TableData2DLoadDepSHC1And2</a>
that showcase the use of this heat pump model in conjunction with equivalent
actuator models in a primary-only and constant primary-secondary plant model.
</p>
<p>
Alternatively, the model also provides the Boolean array connectors <code>y1HwValIsoPumPri[nUni]</code>
and <code>y1ChwValIsoPumPri[nUni]</code> that can be used to control an explicit parallel arrangement
of isolation valves or primary pumps.
These variables use the same requirement as above and their first element is <code>true</code>
based on the system operating mode command, irrespective of any modules being staged on.
</p>
</html>"));
end TableData2DLoadDepSHC;
