within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block ZonePrioritization
  "Zone prioritization based on the zone temperature and the zone tempearture setpoint"

  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Boolean airConMod
    "Air conditioning mode; true for the heating mode, false for the cooling mode";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZon]
    "Zone temperature"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSet[nZon]
    "Zone temperature setpoint, can be either a heating setpoint or a cooling setpoint, depending on the air conditioning mode"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEna[nZon]
    "True: enable setpoint change"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput disFla[nZon]
    "Flags to disqualify certain zones from zone temperature comparison; true to disqualify a zone"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nSel
    "Number of zones to select for prioritization"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Subtract dTZon[nZon]
    "Zone temperature difference"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SelectSmallestValues selSmaDTZon(
    final nVal=nZon)
    if airConMod
    "Select the zones with the smallest zone temperature difference"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SelectLargestValues selLarDTZon(
    final nVal=nZon)
    if not airConMod
    "Select the zones with the largest zone temperature difference"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(TZon, dTZon.u1)
    annotation (Line(points={{-140,20},{-100,20},{-100,6},{-82,6}},
      color={0,0,127}));
  connect(TZonSet, dTZon.u2)
    annotation (Line(points={{-140,-20},{-100,-20},{-100,-6},{-82,-6}},
      color={0,0,127}));
  connect(disFla, selSmaDTZon.disFla)
    annotation (Line(points={{-140,60},{0,60},{0,56},{18,56}}, color={255,0,255}));
  connect(disFla, selLarDTZon.disFla)
    annotation (Line(points={{-140,60},{0,60},{0,-44},{18,-44}}, color={255,0,255}));
  connect(dTZon.y, selSmaDTZon.u)
    annotation (Line(points={{-58,0},{-20,0},{-20,50},{18,50}}, color={0,0,127}));
  connect(dTZon.y, selLarDTZon.u)
    annotation (Line(points={{-58,0},{-20,0},{-20,-50},{18,-50}}, color={0,0,127}));
  connect(nSel, selLarDTZon.nSel)
    annotation (Line(points={{-140,-60},{-40,-60},{-40,-56},{18,-56}},
      color={255,127,0}));
  connect(nSel, selSmaDTZon.nSel)
    annotation (Line(points={{-140,-60},{-40,-60},{-40,44},{18,44}},
      color={255,127,0}));
  connect(selSmaDTZon.y, yEna)
    annotation (Line(points={{42,50},{80,50},{80,0},{140,0}}, color={255,0,255}));
  connect(selLarDTZon.y, yEna)
    annotation (Line(points={{42,-50},{80,-50},{80,0},{140,0}}, color={255,0,255}));
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
Zone temperature difference, an internal variable, is defined as the zone temperature
(<code>TZon</code>) minus the zone temperature setpoint (<code>TZonSet</code>). The
zone temperature setpoint input variable <code>TZonSet</code> must represent a
heating setpoint when <code>airConMod = true</code>, and it must represent a cooling
setpoint when <code>airConMod = false</code>.
</p>
<p>
<code>nSel</code> represents the number of zones to select for prioritization.
</p>
<p>
For the heating mode (<code>airConMod = true</code>), for <code>nSel</code> zones
with the smallest zone temperature difference, these zones will have their
<code>yEna</code> variable set to <code>true</code>, and the remaining zones will
have their <code>yEna</code> variable set to <code>false</code>. 
</p>
<p>
For the cooling mode (<code>airConMod = false</code>), for <code>nSel</code> zones
with the largest zone temperature difference, these zones will have their
<code>yEna</code> variable set to <code>true</code>, and the remaining zones will
have their <code>yEna</code> variable set to <code>false</code>. 
</p>
<p>
Setting the disqualified flag vector <code>disFla=true</code> serves to disqualify
certain zones from the zone prioritization; thus, these zones will have their
<code>yEna</code> variable set to false. If the number of zones that do not have the
disqualified flag is smaller than <code>nSel</code>, the final number of zones with
<code>yEna</code> equal to <code>true</code> will be smaller than <code>nSel</code>.
</p>
</html>"));
end ZonePrioritization;
