within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block ZonePriorization
  "Zone priorization based on the zone temperature and the zone tempearture setpoint"

  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Boolean airConMod
    "Air conditioning mode; true for the heating mode, false for the cooling mode";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZon] "Zone temperature"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  CDL.Interfaces.BooleanOutput yEna[nZon] "True: enable setpoint change"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  CDL.Interfaces.RealInput TZonSet[nZon]
    "Zone temperature setpoint, can be either a heating setpoint or a cooling setpoint, depending on the air conditioning mode"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.IntegerInput
                           nSel "Number of zones to select for prioritization"
                                                 annotation (Placement(
        transformation(extent={{-160,-80},{-120,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.BooleanInput disFla[nZon]
    "Flags to disqualify certain zones from zone temperature comparison; true to disqualify a zone"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Reals.Subtract sub[nZon]
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Generic.SelectSmallestValues selSmaVal(
    final nVal=nZon)
    if airConMod
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Generic.SelectLargestValues selLarVal(
    final nVal=nZon)
    if not airConMod
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(TZon, sub.u1) annotation (Line(points={{-140,20},{-112,20},{-112,6},{-82,
          6}}, color={0,0,127}));
  connect(TZonSet, sub.u2) annotation (Line(points={{-140,-20},{-112,-20},{-112,
          -6},{-82,-6}}, color={0,0,127}));
  connect(disFla, selSmaVal.disFla) annotation (Line(points={{-140,60},{0,60},{
          0,56},{18,56}}, color={255,0,255}));
  connect(disFla, selLarVal.disFla) annotation (Line(points={{-140,60},{0,60},{
          0,-44},{18,-44}}, color={255,0,255}));
  connect(sub.y, selSmaVal.u) annotation (Line(points={{-58,0},{-20,0},{-20,50},
          {18,50}}, color={0,0,127}));
  connect(sub.y, selLarVal.u) annotation (Line(points={{-58,0},{-20,0},{-20,-50},
          {18,-50}}, color={0,0,127}));
  connect(nSel, selLarVal.nSel) annotation (Line(points={{-140,-60},{-40,-60},{
          -40,-56},{18,-56}}, color={255,127,0}));
  connect(nSel, selSmaVal.nSel) annotation (Line(points={{-140,-60},{-40,-60},{
          -40,44},{18,44}}, color={255,127,0}));
  connect(selSmaVal.y, yEna) annotation (Line(points={{42,50},{82,50},{82,0},{
          140,0}}, color={255,0,255}));
  connect(selLarVal.y, yEna) annotation (Line(points={{42,-50},{82,-50},{82,0},
          {140,0}}, color={255,0,255}));
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
This block compares the zone temperatures and setpoints in order to prioritize zones to
enable zone temperature setpoint change.
</p>
<p>
Zone temperature difference, an internal variable, is defined as the zone temperature
(TZon) minus the zone temperature setpoint (TZonSet). The zone temperature setpoint
input variable TZonSet must represent a heating setpoint when airConMod = true, and it must represent a cooling setpoint when airConMod = false.
</p>
<p>
nSel represents the number of zones to select for prioritization.
</p>
<p>
For the heating mode (airConMod = true), for nSel zones with the smallest zone
temperature difference, these zones will have their yEna variable set to true, and
the remaining zones will have their yEna variable set to false. 
</p>
<p>
For the cooling mode (airConMod = false), for nSel zones with the largest zone
temperature difference, these zones will have their yEna variable set to true,
and the remaining zones will have their yEna variable set to false. 
</p>
<p>
Setting the disqualified flag vector disFla=true serves to disqualify certain
zones from the zone prioritization; thus, these zones will have their yEna
variable set to false. If the number of zones that do not have the disqualified
flag is smaller than nSel, the final number of zones with yEna equal to true
will be smaller than nSel.
</p>
</html>"));
end ZonePriorization;
