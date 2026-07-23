within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
model ZoneSetpointGeneration
  "Block to generate zone setpoints and setpoint targets"

  parameter Real TDefOccHeaSet(
    min=0,
    unit="K",
    displayUnit="degC")
    "Occupied heating temperature setpoint for the default mode";
  parameter Real TDefUnoHeaSet(
    min=0,
    unit="K",
    displayUnit="degC")
    "Unoccupied heating temperature setpoint for the default mode";
  parameter Real TDefOccCooSet(
    min=0,
    unit="K",
    displayUnit="degC")
    "Occupied cooling temperature setpoint for the default mode";
  parameter Real TDefUnoCooSet(
    min=0,
    unit="K",
    displayUnit="degC")
    "Unoccupied cooling temperature setpoint for the default mode";
  parameter Real dTSheHeaSet(
    min=0,
    unit="K",
    displayUnit="K")
    "Zone heating temperature setpoint delta for the load-shed mode (always positive)";
  parameter Real dTSheCooSet(
    min=0,
    unit="K",
    displayUnit="K")
    "Zone cooling temperature setpoint delta for the load-shed mode (always positive)";
  parameter Real dTPreHeaSet(
    min=0,
    unit="K",
    displayUnit="K")
    "Zone heating temperature setpoint delta for the pre-heat mode (always positive)";
  parameter Real dTPreCooSet(
    min=0,
    unit="K",
    displayUnit="K")
    "Zone cooling temperature setpoint delta for the pre-cool mode (always positive)";
  parameter Real occHouSta(
    min=0,
    max=24)
    "Starting hour for the occupancy status";
  parameter Real occHouEnd(
    min=0,
    max=24)
    "Ending hour for the occupancy status";
  parameter Boolean setChaEnaUnoFla
    "A boolean flag to enable setpoint change during the unoccupied period; true to enable";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TPreTarHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Pre-heat target heating temperature setpoint"
    annotation (Placement(transformation(extent={{120,80},{160,120}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSheTarHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Load-shed target heating temperature setpoint"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
        iconTransformation(extent={{100,26},{140,66}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDefHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Default heating temperature setpoint"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
        iconTransformation(extent={{100,-2},{140,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TPreTarCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Pre-cool target cooling temperature setpoint"
    annotation (Placement(transformation(extent={{120,-40},{160,0}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSheTarCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Load-shed target cooling temperature setpoint"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
        iconTransformation(extent={{100,-66},{140,-26}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDefCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Default cooling temperature setpoint"
    annotation (Placement(transformation(extent={{120,-120},{160,-80}}),
        iconTransformation(extent={{100,-102},{140,-62}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable occHouNotMid(
    final table=[0,0; occHouSta,1; occHouEnd,0; 24,0],
    final timeScale=3600,
    final period=86400)
    if occHouSta <= occHouEnd
    "Occupied hours that do not span the midnight"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable occHouSpaMid(
    final table=[0,1; occHouEnd,0; occHouSta,1; 24,1],
    final timeScale=3600,
    final period=86400)
    if occHouSta > occHouEnd
    "Occupied hours that span the midnight"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TDefHeaSetVal(
    final realTrue=TDefOccHeaSet,
    final realFalse=TDefUnoHeaSet)
    "Value for the default heating temperature setpoint"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TDefCooSetVal(
    final realTrue=TDefOccCooSet,
    final realFalse=TDefUnoCooSet)
    "Value for the default cooling temperature setpoint"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TPreTarHeaSetValEnaUno(
    final realTrue=TDefOccHeaSet + dTPreHeaSet,
    final realFalse=TDefUnoHeaSet + dTPreHeaSet)
    if setChaEnaUnoFla
    "Value for the pre-heat target heating temperature setpoint when setpoint change is enabled for the unoccupied period"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TPreTarHeaSetValDisUno(
    final realTrue=TDefOccHeaSet + dTPreHeaSet,
    final realFalse=TDefUnoHeaSet)
    if not setChaEnaUnoFla
    "Value for the pre-heat target heating temperature setpoint when setpoint change is disabled for the unoccupied period"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TSheTarHeaSetEnaUno(
    final realTrue=TDefOccHeaSet - dTSheHeaSet,
    final realFalse=TDefUnoHeaSet - dTSheHeaSet)
    if setChaEnaUnoFla
    "Value for the load-shed target heating temperature setpoint when setpoint change is enabled for the unoccupied period"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TSheTarHeaSetDisUno(
    final realTrue=TDefOccHeaSet - dTSheHeaSet,
    final realFalse=TDefUnoHeaSet)
    if not setChaEnaUnoFla
    "Value for the load-shed target heating temperature setpoint when setpoint change is disabled for the unoccupied period"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TPreTarCooSetValEnaUno(
    final realTrue=TDefOccCooSet - dTPreCooSet,
    final realFalse=TDefUnoCooSet - dTPreCooSet)
    if setChaEnaUnoFla
    "Value for the pre-cool target cooling temperature setpoint when setpoint change is enabled for the unoccupied period"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TPreTarCooSetValDisUno(
    final realTrue=TDefOccCooSet - dTPreCooSet,
    final realFalse=TDefUnoCooSet)
    if not setChaEnaUnoFla
    "Value for the pre-cool target cooling temperature setpoint when setpoint change is disabled for the unoccupied period"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TSheTarCooSetValEnaUno(
    final realTrue=TDefOccCooSet + dTSheCooSet,
    final realFalse=TDefUnoCooSet + dTSheCooSet)
    if setChaEnaUnoFla
    "Value for the load-shed target cooling temperature setpoint when setpoint change is enabled for the unoccupied period"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal TSheTarCooSetValDisUno(
    final realTrue=TDefOccCooSet + dTSheCooSet,
    final realFalse=TDefUnoCooSet)
    if not setChaEnaUnoFla
    "Value for the load-shed target cooling temperature setpoint when setpoint change is disabled for the unoccupied period"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
equation
  connect(occHouNotMid.y[1], TDefHeaSetVal.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,30},{18,30}},
      color={255,0,255}));
  connect(occHouNotMid.y[1], TDefCooSetVal.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,-90},{18,-90}},
      color={255,0,255}));
  connect(TDefHeaSetVal.y, TDefHeaSet)
    annotation (Line(points={{42,30},{80,30},{80,20},{140,20}},
      color={0,0,127}));
  connect(TDefCooSetVal.y, TDefCooSet)
    annotation (Line(points={{42,-90},{80,-90},{80,-100},{140,-100}},
      color={0,0,127}));
  connect(occHouNotMid.y[1], TPreTarHeaSetValEnaUno.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,110},{18,110}},
      color={255,0,255}));
  connect(occHouNotMid.y[1], TPreTarHeaSetValDisUno.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,90},{-22,90}},
      color={255,0,255}));
  connect(occHouNotMid.y[1], TSheTarHeaSetEnaUno.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,70},{18,70}},
      color={255,0,255}));
  connect(occHouNotMid.y[1], TSheTarHeaSetDisUno.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,50},{-22,50}},
      color={255,0,255}));
  connect(occHouNotMid.y[1], TPreTarCooSetValEnaUno.u)
    annotation (Line(points={{-78,-10},{18,-10}}, color={255,0,255}));
  connect(occHouNotMid.y[1], TPreTarCooSetValDisUno.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,-30},{-22,-30}},
      color={255,0,255}));
  connect(occHouNotMid.y[1], TSheTarCooSetValEnaUno.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,-50},{18,-50}},
      color={255,0,255}));
  connect(occHouNotMid.y[1], TSheTarCooSetValDisUno.u)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,-70},{-22,-70}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TPreTarHeaSetValEnaUno.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,110},{18,110}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TPreTarHeaSetValDisUno.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,90},{-22,90}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TSheTarHeaSetEnaUno.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,70},{18,70}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TSheTarHeaSetDisUno.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,50},{-22,50}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TDefHeaSetVal.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,30},{18,30}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TPreTarCooSetValEnaUno.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,-10},{18,-10}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TPreTarCooSetValDisUno.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,-30},{-22,-30}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TSheTarCooSetValEnaUno.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,-50},{18,-50}},
      color={255,0,255}));
  connect(occHouSpaMid.y[1], TSheTarCooSetValDisUno.u)
    annotation (Line(points={{-78,-70},{-22,-70}}, color={255,0,255}));
  connect(occHouSpaMid.y[1], TDefCooSetVal.u)
    annotation (Line(points={{-78,-70},{-60,-70},{-60,-90},{18,-90}},
      color={255,0,255}));
  connect(TPreTarHeaSetValEnaUno.y, TPreTarHeaSet)
    annotation (Line(points={{42,110},{80,110},{80,100},{140,100}},
      color={0,0,127}));
  connect(TPreTarHeaSetValDisUno.y, TPreTarHeaSet)
    annotation (Line(points={{2,90},{80,90},{80,100},{140,100}},
      color={0,0,127}));
  connect(TSheTarHeaSetEnaUno.y, TSheTarHeaSet)
    annotation (Line(points={{42,70},{80,70},{80,60},{140,60}},
      color={0,0,127}));
  connect(TSheTarHeaSetDisUno.y, TSheTarHeaSet)
    annotation (Line(points={{2,50},{80,50},{80,60},{140,60}},
      color={0,0,127}));
  connect(TPreTarCooSetValEnaUno.y, TPreTarCooSet)
    annotation (Line(points={{42,-10},{80,-10},{80,-20},{140,-20}},
      color={0,0,127}));
  connect(TPreTarCooSetValDisUno.y, TPreTarCooSet)
    annotation (Line(points={{2,-30},{80,-30},{80,-20},{140,-20}}, color={0,0,127}));
  connect(TSheTarCooSetValEnaUno.y, TSheTarCooSet)
    annotation (Line(points={{42,-50},{80,-50},{80,-60},{140,-60}},
      color={0,0,127}));
  connect(TSheTarCooSetValDisUno.y, TSheTarCooSet)
    annotation (Line(points={{2,-70},{80,-70},{80,-60},{140,-60}}, color={0,0,127}));
  annotation (defaultComponentName="zonSetGen",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-120,-140},{120,140}})),
    Documentation(info="<html>
<p>
This block generates zone setpoints and setpoint targets that change with time based on occupancy status.
</p>
<p>
Occupancy status is defined by two parameters: the occupancy starting hour <code>occHouSta</code>
and the occupancy ending hour <code>occHouEnd</code>. The occupied period is defined as
the hours between <code>occHouSta</code> and <code>occHouEnd</code>. The occupied period repeats every
day. If <code>occHouSta &lt;= occHouEnd</code>, the occupied period is assumed to be within a
single day and to not include the midnight point. If <code>occHouSta &gt; occHouEnd</code>,
the occupied period is assumed to span <i>2</i> different days and include the midnight point.
</p>
<p>
All output variables of this block represent zone setpoints or setpoint
targets, and their values are calculated based on the parameters of this block.
The values of the output variables are calculated based on the following table.
Note that the parameter <code>setChaEnaUnoFla</code> represents whether setpoint change is
enabled during the unoccupied period:
</p>
<table border=1>
<tr>
<th>Output variables</th>
<th>Occupied period</th>
<th>Unoccupied period, and setChaEnaUnoFla = true</th>
<th>Unoccupied period, and setChaEnaUnoFla = false</th>
</tr>
<tr>
<td>TPreTarHeaSet</td>
<td>TDefOccHeaSet + dTPreHeaSet</td>
<td>TDefUncHeaSet + dTPreHeaSet</td>
<td>TDefUnoHeaSet</td>
</tr>
<tr>
<td>TSheTarHeaSet</td>
<td>TDefOccHeaSet - dTSheHeaSet</td>
<td>TDefUncHeaSet - dTSheHeaSet</td>
<td>TDefUnoHeaSet</td>
</tr>
<tr>
<td>TDefHeaSet</td>
<td>TDefOccHeaSet</td>
<td>TDefUnoHeaSet</td>
<td>TDefUnoHeaSet</td>
</tr>
<tr>
<td>TPreTarCooSet</td>
<td>TDefOccCooSet - dTPreCooSet</td>
<td>TDefUncCooSet - dTPreCooSet</td>
<td>TDefUnoCooSet</td>
</tr>
<tr>
<td>TSheTarCooSet</td>
<td>TDefOccCooSet + dTSheCooSet</td>
<td>TDefUncCooSet + dTSheCooSet</td>
<td>TDefUnoCooSet</td>
</tr>
<tr>
<td>TDefCooSet</td>
<td>TDefOccCooSet</td>
<td>TDefUnoCooSet</td>
<td>TDefUnoCooSet</td>
</tr>
</table>
</html>", revisions="<html>
<ul>
<li>
July 22, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneSetpointGeneration;
