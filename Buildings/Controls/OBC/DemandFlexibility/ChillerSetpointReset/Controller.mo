within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset;
block Controller "Controller"

  parameter Integer nChi(min=1)
    "Number of chillers";
  parameter Real dT_small(
    final min=0,
    final unit="K",
    displayUnit="K")=0.1
    "A small temperature delta, used to reduce the effects of rounding errors when comparing the current temperature setpoint to the temperature setpoint limit"
    annotation (Dialog(tab="Advanced", group="Temperature setpoint parameters"));
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant zonConVar
    "Zone control variant, from Variant 1 through Variant 4";
  parameter Real setChaWaiTim(
    min=0,
    unit="s")
    "Sampling period for the setpoint change";
  parameter Real PBuiRedDifMin(
    final unit="W",
    final start=1,
    final quantity="Power",
    final min=0)
    "Minimum difference between the electricity demand reduction target and the actual reduction"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4,
      group="Electricity demand parameters"));
  parameter Real PBuiRedTarCon(
    final unit="W",
    final start=0,
    final quantity="Power",
    final min=0)
    "Constant target electricity demand reduction of the building"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3,
      group="Electricity demand parameters"));
  parameter Real PBuiRed_nominal(
    final unit="W",
    final start=1,
    final quantity="Power",
    final min=0)
    "Nominal electricity demand reduction of the building"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4,
      group="Electricity demand parameters"));
  parameter Real PBuiRedHys(
    final unit="W",
    final start=1,
    final quantity="Power",
    final min=0)=0.05*PBuiRed_nominal
    "Hysteresis for the electricity demand reduction of the building"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4,
      tab="Advanced", group="Hysteresis"));
  parameter Real dTChiSetShe(
    min=0,
    start=0.5,
    final unit="K",
    displayUnit="K")
    "Chilled water temperature setpoint change amount for the load-shed mode (positive value)"
    annotation (Dialog(enable=zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,
      group="Temperature setpoint parameters"));
  parameter Real dTChiSetReb(
    min=0,
    start=0.5,
    final unit="K",
    displayUnit="K")
    "Chilled water temperature setpoint change amount for the load-rebound mode (positive value)"
    annotation (Dialog(enable=zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,
      group="Temperature setpoint parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiRed(
    final unit="W",
    final quantity="Power")
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Electricity demand reduction of the building (baseline demand minus actual demand)"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiRedTarVar(
    final unit="W",
    final quantity="Power")
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Variable target electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,58},{-100,98}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetCur[nChi](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Current chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetDef[nChi](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Default chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetTarShe[nChi](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Target chilled water temperature setpoint for the load-shed mode"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiSetCom[nChi](
    each final unit="K",
    each displayUnit="degC")
    "Commanded chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uQua[nChi]
    "True if the chiller plant is qualified for chilled water setpoint reset"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-22},{-100,18}})));

protected
  Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand eleDem(
    final PBuiRedDifMin=PBuiRedDifMin,
    final PBuiRed_nominal=PBuiRed_nominal,
    final PBuiRedHys=PBuiRedHys) if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
     or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Electricity demand check"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.LowerUpperBound lowUppBou(
    final nChi=nChi,
    final dT_small=dT_small)
    "Check if the current chilled water temperature setpoint has reached a lower bournd or an upper bound"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Adjustment adj[nChi](
    final dTChiSetShe=fill(dTChiSetShe, nChi),
    final dTChiSetReb=fill(dTChiSetReb, nChi),
    final use_mulSteSetCha=fill(zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,nChi))
    "Chiller  setpoint adjustment"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samSetCha[nChi](
    final samplePeriod=fill(setChaWaiTim, nChi))
    "Sampling block for the setpoint change"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator repDemFleMod(
    final nout=nChi)
    "Repeat the demand flexibility mode as a vector"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPBuiShe(
    final nout=nChi)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Repeat the flag of needing electricity demand shed as a vector"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conPBuiRedTar(
    final k=PBuiRedTarCon)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
    "A constant for the target electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLowUppBou[nChi]
    "Check if the current chilled water temperature setpoint has not reached a lower bournd or an upper bound"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Logical.And andQuaPBuiShe[nChi]
    "Chiller is qualified, and the building needs electricity demand shed"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Logical.And andAll[nChi]
    "All conditions are satisfied for a chiller to be enabled for setpoint change"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conNotEleDem[nChi](
    final k=fill(true, nChi))
    if zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      and zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "When the electricity demand check is disabled, output true in place of the electricity demand check logic"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
equation
  connect(PBuiRedTarVar, eleDem.PBuiRedTar) annotation (Line(points={{-180,60},{
          -140,60},{-140,76},{-102,76}}, color={0,0,127}));
  connect(PBuiRed, eleDem.PBuiRed) annotation (Line(points={{-180,20},{-120,20},
          {-120,64},{-102,64}}, color={0,0,127}));
  connect(demFleMod, lowUppBou.demFleMod) annotation (Line(points={{-180,-20},{-140,
          -20},{-140,17.8},{-62,17.8}},    color={255,127,0}));
  connect(TChiSetCur, lowUppBou.TChiSetCur) annotation (Line(points={{-180,-60},
          {-120,-60},{-120,12},{-62,12}},    color={0,0,127}));
  connect(TChiSetDef, lowUppBou.TChiSetDef) annotation (Line(points={{-180,-100},
          {-100,-100},{-100,8},{-62,8}},      color={0,0,127}));
  connect(TChiSetTarShe, lowUppBou.TChiSetTarShe) annotation (Line(points={{-180,
          -140},{-80,-140},{-80,4},{-62,4}},        color={0,0,127}));
  connect(samSetCha.y, TChiSetCom)
    annotation (Line(points={{142,20},{180,20}}, color={0,0,127}));
  connect(demFleMod, repDemFleMod.u) annotation (Line(points={{-180,-20},{-140,-20},
          {-140,-30},{-62,-30}}, color={255,127,0}));
  connect(repDemFleMod.y, adj.demFleMod) annotation (Line(points={{-38,-30},{40,
          -30},{40,-62},{78,-62}}, color={255,127,0}));
  connect(TChiSetCur, adj.TChiSetCur) annotation (Line(points={{-180,-60},{-120,
          -60},{-120,-70},{78,-70}}, color={0,0,127}));
  connect(TChiSetDef, adj.TChiSetDef) annotation (Line(points={{-180,-100},{-100,
          -100},{-100,-74},{78,-74}}, color={0,0,127}));
  connect(TChiSetTarShe, adj.TChiSetTarShe) annotation (Line(points={{-180,-140},
          {-80,-140},{-80,-78},{78,-78}}, color={0,0,127}));
  connect(eleDem.need_PBuiShe, repPBuiShe.u)
    annotation (Line(points={{-78,70},{-62,70}}, color={255,0,255}));
  connect(lowUppBou.reach_lowUppBou, notLowUppBou.u)
    annotation (Line(points={{-38,10},{-22,10}}, color={255,0,255}));
  connect(uQua, andQuaPBuiShe.u1) annotation (Line(points={{-180,140},{-40,140},
          {-40,110},{-22,110}}, color={255,0,255}));
  connect(repPBuiShe.y, andQuaPBuiShe.u2) annotation (Line(points={{-38,70},{-30,
          70},{-30,102},{-22,102}}, color={255,0,255}));
  connect(andQuaPBuiShe.y, andAll.u1) annotation (Line(points={{2,110},{20,110},
          {20,70},{38,70}}, color={255,0,255}));
  connect(notLowUppBou.y, andAll.u2) annotation (Line(points={{2,10},{20,10},{20,
          62},{38,62}}, color={255,0,255}));
  connect(andAll.y, adj.uEna) annotation (Line(points={{62,70},{70,70},{70,-66},
          {78,-66}}, color={255,0,255}));
  connect(adj.TChiSetCom, samSetCha.u) annotation (Line(points={{102,-70},{110,-70},
          {110,20},{118,20}}, color={0,0,127}));
  connect(conPBuiRedTar.y, eleDem.PBuiRedTar) annotation (Line(points={{-118,110},
          {-110,110},{-110,76},{-102,76}}, color={0,0,127}));
  connect(conNotEleDem.y, andQuaPBuiShe.u2) annotation (Line(points={{-78,110},{
          -60,110},{-60,102},{-22,102}}, color={255,0,255}));
  annotation (defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-140},{100,140}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,180},{100,140}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-160,-160},{160,160}})),
    Documentation(revisions="<html>
<ul>
<li>
October 18, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block performs chiller chilled water temperature setpoint change for all
chillers in a building. This block first checks whether a chiller is enabled for the
chilled water temperature setpoint change, then executes the setpoint change
operation by outputting new setpoints.
</p>
<h4>Parameter Definitions</h4>
<p>
The control variant parameter <code>zonConVar</code> in this block can have <i>4</i>
different values based on enumeration, from Variant <i>1</i> through Variant
<i>4</i>. Refer to the documentation of
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant\">
Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant</a>
for more information on these <i>4</i> variants.
</p>
<p>
The demand flexibility mode input <code>demFleMod</code> can be: <i>1</i> (default
mode), <i>2</i> (load-shed mode), or <i>3</i> (load-rebound mode).
</p>
<p>
The input variable <code>TChiSetCur</code> is the current chilled water temperature
setpoint, and the output variable <code>TChiSetCom</code> is the commanded chilled
water temperature setpoint.
</p>
<h4>Chiller Enablement</h4>
<p>
This block checks whether each chiller is enabled for chilled water temperature
setpoint change. There are <i>3</i> conditions to check, as follows:
</p>
<ol>
<li>
The input variable <code>uQua = true</code> for a chiller, which means that this
chiller is qualified for chilled water temperature setpoint change based on certain
qualification rules. An example of these qualification rules is represented by the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Qualification\">
Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Qualification</a>
block, where users have the option to feed the output of this block externally to
the input variable <code>uQua</code>.
</li>
<li>
The building, where the chiller is located, has not reached an electricity demand
reduction goal. Specific logic of this electricity demand check is represented by
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand\">
Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand</a>.
<li>
<code>TChiSetCur</code> has not reached a lower bound or an upper bound. Specific
logic of this lower or upper bound check is represented by
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.LowerUpperBound\">
Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.LowerUpperBound</a>.
Note that different chillers can have different lower bounds or upper bounds.
</li>
</ol>
<p>
All <i>3</i> conditions need to be met for a chiller to be enabled for chilled water
setpoint change. If <code>zonConVar</code> has a value of Variant <i>1</i> or Variant
<i>2</i>, Condition <i>2</i> is not used, thus the remaining <i>2</i> conditions
need to be met for the chilled water temperature setpoint change enablement.
</p>
<h4>Chiller Setpoint Adjustment</h4>
<p>
For all chillers that are enabled for chilled water temperature setpoint change,
this block takes the input variable <code>TChiSetCur</code>, executes the chilled
water setpoint change, and outputs the new setpoint <code>TChiSetCom</code>. The
setpoint change operation is executed every <code>setChaWaiTim</code> seconds. Refer
to the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Adjustment\">
Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Adjustment</a>
block for more detailed description.
</p>
<p>
Note that the setpoint change execution for each chiller is independent, meaning
that if different chillers are enabled for setpoint change at different times, the
chilled water temperature setpoints will be different for different chillers.
</p>
<p>
Also note that if <code>zonConVar</code> has a value of Variant <i>1</i>, the
multiple-step setpoint change flag parameter <code>use_mulSteSetCha</code> within
the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Adjustment\">
Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Adjustment</a>
block will be <code>false</code>. Otherwise, <code>use_mulSteSetCha</code> will be
<code>true</code>.
</p>
</html>"));
end Controller;
