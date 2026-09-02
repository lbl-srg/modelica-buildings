within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block Prioritization
  "Zone prioritization based on the zone temperature and the zone tempearture setpoint"

  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode airConMod
    "Air conditioning mode";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint, can be either a heating setpoint or a cooling setpoint, depending on the air conditioning mode"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEna[nZon]
    "True: enable setpoint change"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput disFla[nZon]
    "Flags to disable certain zones from zone temperature comparison; true to disable a zone"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nSel
    "Number of zones to select for prioritization"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Subtract dTZonHea[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Zone temperature difference during the heating mode"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTZonCoo[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Zone temperature difference during the cooling mode"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SelectSmallestValues selSmaDTZon(
    final nVal=nZon)
    "Select the zones with the smallest zone temperature difference"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  connect(TZon, dTZonHea.u1)
    annotation (Line(points={{-140,20},{-100,20},{-100,36},{-42,36}},
      color={0,0,127}));
  connect(TZonSet, dTZonHea.u2)
    annotation (Line(points={{-140,-20},{-60,-20},{-60,24},{-42,24}},
      color={0,0,127}));
  connect(disFla, selSmaDTZon.disFla)
    annotation (Line(points={{-140,60},{60,60},{60,6},{78,6}}, color={255,0,255}));
  connect(dTZonHea.y, selSmaDTZon.u)
    annotation (Line(points={{-18,30},{20,30},{20,0},{78,0}}, color={0,0,127}));
  connect(nSel, selSmaDTZon.nSel)
    annotation (Line(points={{-140,-60},{60,-60},{60,-6},{78,-6}},
      color={255,127,0}));
  connect(selSmaDTZon.y, yEna)
    annotation (Line(points={{102,0},{140,0}}, color={255,0,255}));
  connect(TZonSet, dTZonCoo.u1)
    annotation (Line(points={{-140,-20},{-60,-20},{-60,-24},{-42,-24}},
      color={0,0,127}));
  connect(TZon, dTZonCoo.u2)
    annotation (Line(points={{-140,20},{-100,20},{-100,-36},{-42,-36}},
      color={0,0,127}));
  connect(dTZonCoo.y, selSmaDTZon.u)
    annotation (Line(points={{-18,-30},{20,-30},{20,0},{78,0}}, color={0,0,127}));
  annotation (defaultComponentName="zonPri",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}},
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block compares the zone temperatures and setpoints in order to prioritize zones
to enable zone temperature setpoint change.
</p>
<p>
Zone temperature difference <code>dTZon</code>, an internal variable, is defined as
the zone temperature <code>TZon</code> minus the zone temperature setpoint
<code>TZonSet</code> during the heating mode (<code>airConMod = Heating</code>). On the
other hand, <code>dTZon</code> is defined as <code>TZonSet</code> minus
<code>TZon</code> during the cooling mode (<code>airConMod = Cooling</code>). The zone
temperature setpoint input variable <code>TZonSet</code> must represent a heating
setpoint when <code>airConMod = Heating</code>, and it must represent a cooling
setpoint when <code>airConMod = Cooling</code>.
</p>
<p>
The parameter <code>nSel</code> represents the number of zones to select for
prioritization.
</p>
<p>
For <code>nSel</code> zones with the smallest <code>dTZon</code>, these zones will
have their <code>yEna</code> variable set to <code>true</code>, and the remaining
zones will have their <code>yEna</code> variable set to <code>false</code>. 
</p>
<p>
Setting the disabled flag vector <code>disFla=true</code> serves to exclude certain
zones from the ranking of the zone temperature difference of each zone to determine
which zones are prioritized for the setpoint change operation. Thus, these zones
will have their <code>yEna</code> variable set to <code>false</code>. If the number
of zones that do not have <code>disFla=true</code> is smaller than <code>nSel</code>,
the final number of zones with <code>yEna</code> equal to <code>true</code> will be
smaller than <code>nSel</code>.
</p>
</html>"));
end Prioritization;
