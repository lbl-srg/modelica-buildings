within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences;
block LowerUpperBound "Lower upper bound"

  parameter Integer nChi(min=1)
    "Number of chillers";
  parameter Real dT_small(
    min=0,
    final unit="K",
    displayUnit="K")=0.1
    "A small temperature delta, used to reduce the effects of rounding errors when comparing the current temperature setpoint to the temperature setpoint limit"
    annotation (Dialog(group="Temperature setpoint parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,58},{-100,98}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetCur[nChi](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current chilled water temperature setpoint"
                              annotation (Placement(transformation(extent={{-240,0},
            {-200,40}}),    iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetDef[nChi](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Default chilled water temperature setpoint"
                              annotation (Placement(transformation(extent={{-240,
            -40},{-200,0}}), iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetTarShe[nChi](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Target chilled water temperature setpoint for the load-shed mode"
                                                    annotation (Placement(
        transformation(extent={{-240,-80},{-200,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_lowUppBou[nChi]
    "Reach the lower or upper bound" annotation (Placement(transformation(
          extent={{200,-20},{240,20}}), iconTransformation(extent={{100,-20},{
            140,20}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntShe(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepShe(
    final nout=nChi)
    "Repeat the boolean scalar for being in the load-shed mode"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepReb(
    final nout=nChi)
    "Repeat the boolean scalar for being in the load-rebound mode"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntReb(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadRebound)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addDTReb[nChi](final p=fill(
        dT_small, nChi))
    "Add a small temperature delta during the load-rebound mode"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTChiSetDefReb[nChi](final h=fill(0.5*
        dT_small, nChi))
    "The current chilled water temperature setpoint is less than the default chilled water temperature setpoint during the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subDTShe[nChi](final p=fill(-
        dT_small, nChi))
    "Subtract a small temperature delta during the load-shed mode"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTChiSetTarShe[nChi](final h=fill(0.5
        *dT_small, nChi))
    "The current chilled water temperature setpoint is greater than the target chilled water temperature setpoint during the load-shed mode"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTChiSetTarShe[nChi]
    "In the load-shed mode, the current chilled water temperature setpoint has reached the target chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTChiSetDef[nChi]
    "In the load-rebound mode, the current chilled water temperature setpoint has reached the default chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or orReaLimSheReb[nChi]
    "The current chilled water temperature setpoint has reached a temperature setpoint limit during the load-shed mode and the load-rebound mode"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
equation
  connect(demFleMod, intEquShe.u1) annotation (Line(points={{-220,80},{-130,80},
          {-130,30},{-42,30}},
                            color={255,127,0}));
  connect(demFleMod, intEquReb.u1) annotation (Line(points={{-220,80},{-130,80},
          {-130,70},{-42,70}},
                            color={255,127,0}));
  connect(conIntShe.y, intEquShe.u2) annotation (Line(points={{-78,10},{-58,10},
          {-58,22},{-42,22}},
                        color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2) annotation (Line(points={{-78,50},{-60,50},
          {-60,62},{-42,62}},
                        color={255,127,0}));
  connect(intEquShe.y, booScaRepShe.u)
    annotation (Line(points={{-18,30},{-2,30}}, color={255,0,255}));
  connect(intEquReb.y, booScaRepReb.u)
    annotation (Line(points={{-18,70},{18,70}}, color={255,0,255}));
  connect(TChiSetCur, greTChiSetTarShe.u1) annotation (Line(points={{-220,20},{-160,
          20},{-160,-50},{-42,-50}}, color={0,0,127}));
  connect(subDTShe.y, greTChiSetTarShe.u2) annotation (Line(points={{-98,-70},{-68,
          -70},{-68,-58},{-42,-58}}, color={0,0,127}));
  connect(TChiSetCur, lesTChiSetDefReb.u1) annotation (Line(points={{-220,20},{-160,
          20},{-160,-10},{-42,-10}}, color={0,0,127}));
  connect(addDTReb.y, lesTChiSetDefReb.u2) annotation (Line(points={{-98,-30},{-68,
          -30},{-68,-18},{-42,-18}}, color={0,0,127}));
  connect(booScaRepReb.y, reaTChiSetDef.u1) annotation (Line(points={{42,70},{60,
          70},{60,10},{78,10}}, color={255,0,255}));
  connect(booScaRepShe.y, reaTChiSetTarShe.u1) annotation (Line(points={{22,30},
          {40,30},{40,-70},{78,-70}}, color={255,0,255}));
  connect(reaTChiSetDef.y, orReaLimSheReb.u1) annotation (Line(points={{102,10},
          {120,10},{120,-30},{138,-30}}, color={255,0,255}));
  connect(reaTChiSetTarShe.y, orReaLimSheReb.u2) annotation (Line(points={{102,-70},
          {120,-70},{120,-38},{138,-38}}, color={255,0,255}));
  connect(orReaLimSheReb.y, reach_lowUppBou) annotation (Line(points={{162,-30},
          {180,-30},{180,0},{220,0}}, color={255,0,255}));
  connect(TChiSetDef, addDTReb.u) annotation (Line(points={{-220,-20},{-140,-20},
          {-140,-30},{-122,-30}}, color={0,0,127}));
  connect(TChiSetTarShe, subDTShe.u) annotation (Line(points={{-220,-60},{-180,-60},
          {-180,-70},{-122,-70}}, color={0,0,127}));
  connect(lesTChiSetDefReb.y, reaTChiSetDef.u2) annotation (Line(points={{-18,-10},
          {20,-10},{20,2},{78,2}}, color={255,0,255}));
  connect(greTChiSetTarShe.y, reaTChiSetTarShe.u2) annotation (Line(points={{-18,
          -50},{20,-50},{20,-78},{78,-78}}, color={255,0,255}));
  annotation (defaultComponentName="lowUppBou",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-200,-100},{200,100}})),
    Documentation(revisions="<html>
<ul>
<li>
October 27, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block checks whether the current chilled water temperature setpoint
<code>TChiSetCur</code> has reached a lower bound or an upper bound.
</p>
<p>
Input variable <code>TChiSetDef</code> is the default chilled water temperature
setpoint. Input variable <code>TChiSetTarShe</code> is the target chilled water
temperature setpoint for the load-shed mode. Input variable <code>demFleMod</code>
is the demand flexibility mode. Parameter <code>dT_small</code> is a small
temperature delta that is used to reduce the effects of rounding errors.
</p>
<p>
If <code>TChiSetCur</code> satisfies any of the following, the boolean output
variable <code>reach_lowUppBou</code> will become <code>true</code>. Otherwise,
<code>reach_lowUppBou</code> will be <code>false</code>:
</p>
<ul>
<li>
<code>demFleMod = 2</code> and
<code>TChiSetCur &gt; TChiSetTarShe - dT_small</code>
</li>
<li>
or: <code>demFleMod = 3</code> and
<code>TChiSetCur &lt; TChiSetDef + dT_small</code>
</li>
</ul>
</html>"));
end LowerUpperBound;
