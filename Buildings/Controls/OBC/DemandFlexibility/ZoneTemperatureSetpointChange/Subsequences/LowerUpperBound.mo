within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block LowerUpperBound "Decide the zones for setpoint change"

  parameter Real dTSheThr(
    min=0,
    unit="K",
    displayUnit="K")
    "Threshold of temperature difference to trigger setpoint change during the load-shed mode (positive value)"
    annotation (Dialog(group="Temperature setpoint parameters"));
  parameter Real dT_small(
    min=0,
    unit="K",
    displayUnit="K")=0.1
    "A small temperature delta, used to reduce the effects of rounding errors when comparing the current zone temperature setpoint to the target setpoints"
    annotation (Dialog(tab="Advanced", group="Temperature setpoint parameters"));
  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode airConMod
    "Air conditioning mode";
  parameter Real TPreTarSet[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon))
    "Pre-cool or pre-heat target temperature setpoint";
  parameter Real TSheTarSet[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon))
    "Load-shed target temperature setpoint";
  parameter Real TDefSet[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon))
    "Default temperature setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSet[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Zone temperature setpoint, can be either a heating setpoint or a cooling setpoint, depending on the air conditioning mode"
    annotation (Placement(transformation(extent={{-300,200},{-260,240}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-300,100},{-260,140}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_lowUppBou[nZon]
    "True: the zone setpoint lower or upper bound is reached"
    annotation (Placement(transformation(extent={{260,10},{300,50}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  CDL.Logical.Sources.Constant con[nZon](k={TPreTarSet[i] >= TDefSet[i] for i in 1:
        nZon}) if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check whether the pre-heat target temperature setpoint is greater than or equal to the default tempearture setpoint"
    annotation (Placement(transformation(extent={{-60,-260},{-40,-240}})));
  CDL.Logical.Sources.Constant con1[nZon](k={TSheTarSet[i] <= TDefSet[i] for i in 1:
        nZon}) if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check whether the load-shed target temperature setpoint is less than or equal to the default tempearture setpoint"
    annotation (Placement(transformation(extent={{-60,-300},{-40,-280}})));
  CDL.Logical.Sources.Constant con2[nZon](k={TPreTarSet[i] <= TDefSet[i] for i in 1:
        nZon}) if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check whether the pre-cool target temperature setpoint is less than or equal to the default tempearture setpoint"
    annotation (Placement(transformation(extent={{-60,-340},{-40,-320}})));
  CDL.Logical.Sources.Constant con3[nZon](k={TSheTarSet[i] >= TDefSet[i] for i in 1:
        nZon}) if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check whether the load-shed target temperature setpoint is greater than or equal to the default tempearture setpoint"
    annotation (Placement(transformation(extent={{-60,-380},{-40,-360}})));
protected
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepShe(
    final nout=nZon) "Repeat the boolean scalar for being in the load-shed mode"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  CDL.Reals.GreaterThreshold               greTSetPreHea[nZon](t=TPreTarSet +
        fill(-dT_small, nZon),
    final h=fill(0.5*dT_small,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "The zone heating temperature setpoint is greater than the pre-heat target temperature setpoint, with a hysteresis equal to half of the small temperature delta value"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Reals.LessThreshold               lesTSetPreCoo[nZon](t=TPreTarSet + fill(
         dT_small, nZon),
    final h=fill(0.5*dT_small,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "The zone cooling temperature setpoint is less than the pre-cool target temperature setpoint, with a hysteresis equal to half of the small temperature delta value"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  CDL.Reals.LessThreshold               lesTSetSheHea[nZon](t=TSheTarSet + fill(
         dT_small, nZon),
    final h=fill(0.5*dT_small,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "The zone heating temperature setpoint is less than the load-shed heating target temperature setpoint, with a hysteresis equal to half of the small temperature delta value"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Reals.GreaterThreshold               greTSetSheCoo[nZon](t=TSheTarSet +
        fill(-dT_small, nZon),
    final h=fill(0.5*dT_small,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "The zone cooling temperature setpoint is greater than the load-shed cooling target temperature setpoint, with a hysteresis equal to half of the small temperature delta value"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  CDL.Reals.GreaterThreshold               greTSetRebHea[nZon](t=TDefSet + fill(
         -dT_small, nZon),
    final h=fill(0.5*dT_small,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "The zone heating temperature setpoint is greater than the default heating temperature setpoint during the load-rebound mode, with a hysteresis equal to half of the small temperature delta value"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  CDL.Reals.LessThreshold               lesTSetRebCoo[nZon](t=TDefSet + fill(
        dT_small, nZon),
    final h=fill(0.5*dT_small,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "The zone cooling temperature setpoint is less than the default cooling temperature setpoint during the load-rebound mode, with a hysteresis equal to half of the small temperature delta value"
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTPreTarSet[nZon]
    "In the pre-cool or pre-heat mode, the zone temperature setpoint has reached the pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTSheTarSet[nZon]
    "In the load-shed mode, the zone temperature setpoint has reached the load-shed target temperature setpoint"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTDefSet[nZon]
    "In the load-rebound mode, the zone temperature setpoint has reached the default temperature setpoint"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepPre(
    final nout=nZon)
    "Repeat the boolean scalar for being in the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepReb(
    final nout=nZon) "Repeat the boolean scalar for being in the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Logical.Or orReaLimSheReb[nZon]
    "The zone temperature setpoint has reached a setpoint limit during the load-shed mode and the load-rebound mode"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntShe(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquPre
    "Check whether it is the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntPre(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.preCondition)
    "Integer constant for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntReb(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadRebound)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.Or orReaLimSheDefPre[nZon]
    "The zone temperature setpoint has reached a setpoint limit during the load-shed mode, the load-rebound mode, or the pre-heat or pre-cool mode."
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTPreTarHeaSet[nZon](
    message=fill("Error: the pre-heat target temperature setpoint must be greater than or equal to the default temperature setpoint during the heating mode.", nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Error message for the pre-heat target temperature setpoint during the heating mode"
    annotation (Placement(transformation(extent={{0,-260},{20,-240}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTSheTarHeaSet[nZon](
    message=fill("Error: the load-shed target temperature setpoint must be less than or equal to the default temperature setpoint during the heating mode.", nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Error message for the load-shed target heating temperature setpoint during the heating mode"
    annotation (Placement(transformation(extent={{0,-300},{20,-280}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTPreTarCooSet[nZon](
    message=fill("Error: the pre-cool target temperature setpoint must be less than or equal to the default temperature setpoint during the cooling mode.", nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Error message for the pre-cool target temperature setpoint during the cooling mode"
    annotation (Placement(transformation(extent={{0,-340},{20,-320}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTSheTarCooSet[nZon](
    message=fill("Error: the load-shed target temperature setpoint must be greater than or equal to the default temperature setpoint during the cooling mode.", nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Error message for the load-shed target cooling temperature setpoint during the cooling mode"
    annotation (Placement(transformation(extent={{0,-380},{20,-360}})));
equation
  connect(demFleMod, intEquShe.u1)
    annotation (Line(points={{-280,120},{-180,120},{-180,130},{-102,130}},
      color={255,127,0}));
  connect(conIntShe.y, intEquShe.u2)
    annotation (Line(points={{-138,110},{-120,110},{-120,122},{-102,122}},
      color={255,127,0}));
  connect(intEquShe.y, booScaRepShe.u)
    annotation (Line(points={{-78,130},{-42,130}}, color={255,0,255}));
  connect(conIntPre.y, intEquPre.u2)
    annotation (Line(points={{-138,150},{-120,150},{-120,162},{-102,162}},
      color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2)
    annotation (Line(points={{-138,70},{-120,70},{-120,82},{-102,82}},
      color={255,127,0}));
  connect(demFleMod, intEquPre.u1)
    annotation (Line(points={{-280,120},{-180,120},{-180,170},{-102,170}},
      color={255,127,0}));
  connect(demFleMod, intEquReb.u1)
    annotation (Line(points={{-280,120},{-180,120},{-180,90},{-102,90}},
      color={255,127,0}));
  connect(greTSetPreHea.y, reaTPreTarSet.u2)
    annotation (Line(points={{-38,10},{-20,10},{-20,-18},{58,-18}},
      color={255,0,255}));
  connect(lesTSetPreCoo.y, reaTPreTarSet.u2)
    annotation (Line(points={{-38,-30},{-20,-30},{-20,-18},{58,-18}},
      color={255,0,255}));
  connect(intEquPre.y, booScaRepPre.u)
    annotation (Line(points={{-78,170},{-42,170}}, color={255,0,255}));
  connect(intEquReb.y, booScaRepReb.u)
    annotation (Line(points={{-78,90},{-42,90}}, color={255,0,255}));
  connect(lesTSetSheHea.y, reaTSheTarSet.u2)
    annotation (Line(points={{-38,-70},{-20,-70},{-20,-98},{38,-98}},
      color={255,0,255}));
  connect(greTSetSheCoo.y, reaTSheTarSet.u2)
    annotation (Line(points={{-38,-110},{-20,-110},{-20,-98},{38,-98}},
      color={255,0,255}));
  connect(booScaRepPre.y, reaTPreTarSet.u1)
    annotation (Line(points={{-18,170},{40,170},{40,-10},{58,-10}},
      color={255,0,255}));
  connect(booScaRepShe.y, reaTSheTarSet.u1)
    annotation (Line(points={{-18,130},{20,130},{20,-90},{38,-90}},
      color={255,0,255}));
  connect(greTSetRebHea.y, reaTDefSet.u2)
    annotation (Line(points={{-38,-150},{-20,-150},{-20,-178},{18,-178}},
      color={255,0,255}));
  connect(lesTSetRebCoo.y, reaTDefSet.u2)
    annotation (Line(points={{-38,-190},{-20,-190},{-20,-178},{18,-178}},
      color={255,0,255}));
  connect(booScaRepReb.y, reaTDefSet.u1)
    annotation (Line(points={{-18,90},{0,90},{0,-170},{18,-170}},
      color={255,0,255}));
  connect(reaTDefSet.y, orReaLimSheReb.u2)
    annotation (Line(points={{42,-170},{80,-170},{80,-118},{98,-118}},
      color={255,0,255}));
  connect(reaTSheTarSet.y, orReaLimSheReb.u1)
    annotation (Line(points={{62,-90},{80,-90},{80,-110},{98,-110}},
      color={255,0,255}));
  connect(reaTPreTarSet.y, orReaLimSheDefPre.u1)
    annotation (Line(points={{82,-10},{120,-10},{120,-30},{138,-30}},
      color={255,0,255}));
  connect(orReaLimSheReb.y, orReaLimSheDefPre.u2)
    annotation (Line(points={{122,-110},{130,-110},{130,-38},{138,-38}},
      color={255,0,255}));
  connect(orReaLimSheDefPre.y, reach_lowUppBou) annotation (Line(points={{162,
          -30},{220,-30},{220,30},{280,30}}, color={255,0,255}));
  connect(TZonSet, greTSetPreHea.u) annotation (Line(points={{-280,220},{-200,220},
          {-200,10},{-62,10}}, color={0,0,127}));
  connect(TZonSet, lesTSetPreCoo.u) annotation (Line(points={{-280,220},{-200,220},
          {-200,-30},{-62,-30}}, color={0,0,127}));
  connect(lesTSetSheHea.u, TZonSet) annotation (Line(points={{-62,-70},{-200,-70},
          {-200,220},{-280,220}}, color={0,0,127}));
  connect(greTSetSheCoo.u, TZonSet) annotation (Line(points={{-62,-110},{-200,-110},
          {-200,220},{-280,220}}, color={0,0,127}));
  connect(greTSetRebHea.u, TZonSet) annotation (Line(points={{-62,-150},{-200,-150},
          {-200,220},{-280,220}}, color={0,0,127}));
  connect(lesTSetRebCoo.u, TZonSet) annotation (Line(points={{-62,-190},{-200,-190},
          {-200,220},{-280,220}}, color={0,0,127}));
  connect(con.y, assMesTPreTarHeaSet.u)
    annotation (Line(points={{-38,-250},{-2,-250}}, color={255,0,255}));
  connect(con1.y, assMesTSheTarHeaSet.u)
    annotation (Line(points={{-38,-290},{-2,-290}}, color={255,0,255}));
  connect(con2.y, assMesTPreTarCooSet.u)
    annotation (Line(points={{-38,-330},{-2,-330}}, color={255,0,255}));
  connect(con3.y, assMesTSheTarCooSet.u)
    annotation (Line(points={{-38,-370},{-2,-370}}, color={255,0,255}));
  annotation (defaultComponentName="lowUppBou",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,180}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-180},{100,180}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-102,220},{98,180}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-260,-400},{260,400}},
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
July 16, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block serves to determine whether a zone is enabled to participate in the
setpoint change operation. It can be used for either the heating mode
(<code>airConMod = Heating</code>) or the cooling mode (<code>airConMod = Cooling</code>).
</p>
<p>
The demand flexibility mode input <code>demFleMod</code> can be: <i>0</i> (pre-cool or
pre-heat mode), <i>1</i> (default mode), <i>2</i> (load-shed mode), or <i>3</i>
(load-rebound mode).
</p>
<p>
The zone temperature setpoint input <code>TZonSet</code> must be a
heating setpoint when <code>airConMod = Heating</code>, and it must be a cooling
setpoint when <code>airConMod = Cooling</code>. <code>TPreTarSet &gt;= TDefSet &gt;=
TSheTarSet</code> must hold if it is in the heating mode
(<code>airConMod = Heating</code>), and <code>TPreTarSet &lt;= TDefSet &lt;=
TSheTarSet</code> must hold if it is in the cooling mode
(<code>airConMod = Cooling</code>).
</p>
<p>
The following <i>4</i> conditions are used to determine if a zone should be enabled
to participate in the setpoint change operation. The enabled flag <code>reach_lowUppBou</code>
for a zone is set to <code>true</code> only if all applicable conditions are met for
that zone.
</p>
<p>
Below is a detailed discussion of each of the <i>4</i> conditions:
</p>
<h4>Condition 4</h4>
<p>
Condition <i>4</i> is met if the zone temperature setpoint <code>TZonSet</code>
satisfies any of the following, where <code>dT_small</code> is a small temperature
delta that is used to reduce the effects of rounding errors when comparing
<code>TZonSet</code> to the target setpoints:
</p>
<ul>
<li>
<code>demFleMod = 1</code>
</li>
<li>
or: <code>airConMod = Heating</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &lt; TPreTarSet - dT_small</code>
</li>
<li>
or: <code>airConMod = Heating</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &gt; TSheTarSet + dT_small</code>
</li>
<li>
or: <code>airConMod = Heating</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &lt; TDefSet - dT_small</code>
</li>
<li>
or: <code>airConMod = Cooling</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &gt; TPreTarSet + dT_small</code>
</li>
<li>
or: <code>airConMod = Cooling</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &lt; TSheTarSet - dT_small</code>
</li>
<li>
or: <code>airConMod = Cooling</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &gt; TDefSet + dT_small</code>
</li>
</ul>
</html>"));
end LowerUpperBound;
