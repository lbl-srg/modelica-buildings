within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
block ModeAndSetPoints
  "Output zone setpoint with operation mode selection"

  parameter Real TZonHeaOn(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=293.15
    "Heating setpoint during on";
  parameter Real TZonHeaOff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=285.15
    "Heating setpoint during off";
  parameter Real TZonCooOn(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Cooling setpoint during on";
  parameter Real TZonCooOff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=303.15
    "Cooling setpoint during off";
  parameter Real preWarCooTim(
    final unit="s",
    final quantity="Time")=10800
    "Maximum cool-down/warm-up time"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real bouLim(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1
    "Value limit to indicate the end of setback/setup mode"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real TZonFreProOn(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.55
    "Threshold zone temperature value to activate freeze protection mode"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real TZonFreProOff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=280.35
    "Threshold zone temperature value to finish the freeze protection mode"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real warCooTim(
    final unit="s",
    final quantity="Time")=1800
    "Defined cool-down/warm-up time"
    annotation (Dialog(tab="Operation mode", group="Test setting"));
  parameter Boolean have_occSen=false
    "Check if the zone has occupancy sensor"
    annotation (Dialog(tab="Setpoint adjust", group="Sensors"));
  parameter Boolean have_winSen=false
    "Check if the zone has window status sensor"
    annotation (Dialog(tab="Setpoint adjust", group="Sensors"));
  parameter Boolean cooAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable separately"
    annotation (Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean heaAdj=false
    "Flag, set to true if heating setpoint is adjustable"
    annotation (Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean sinAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
    annotation (Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean ignDemLim=true
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Real TZonCooOnMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=300.15
    "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonCooOnMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaOnMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Maximum heating setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaOnMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Minimum heating setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonCooSetWinOpe(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=322.15
    "Cooling setpoint when window is open"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaSetWinOpe(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Heating setpoint when window is open"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real incTSetDem_1(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.56
    "Cooling setpoint increase value when cooling demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real incTSetDem_2(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1
    "Cooling setpoint increase value when cooling demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real incTSetDem_3(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.2
    "Cooling setpoint increase value when cooling demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decTSetDem_1(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.56
    "Heating setpoint decrease value when heating demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decTSetDem_2(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1
    "Heating setpoint decrease value when heating demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decTSetDem_3(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.2
    "Heating setpoint decrease value when heating demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Integer cooDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.DemandLimitLevels.cooling0
    "Cooling demand limit level"
    annotation (Dialog(tab="Setpoint adjust"));
  parameter Integer heaDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.DemandLimitLevels.heating0
    "Heating demand limit level"
    annotation (Dialog(tab="Setpoint adjust"));
  parameter Boolean winStaCon=false
    "Window status, set to true if window is open"
    annotation (Dialog(tab="Setpoint adjust"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30.5}}),
      iconTransformation(extent={{-140,40},{-100,80.5}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if (cooAdj or sinAdj)
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-180,-80}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-180,-120}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccSen if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta if have_winSen
    "Window status (open=true, close=false)"
    annotation (Placement(transformation(extent={{-200,-220},{-160,-180}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature") "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{160,90},{200,130}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature") "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{160,-30},{200,10}}),
      iconTransformation(extent={{100,-90},{140,-50}})));

protected
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
    TZonSet(
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final cooAdj=cooAdj,
    final heaAdj=heaAdj,
    final sinAdj=sinAdj,
    final ignDemLim=ignDemLim,
    final TZonCooOnMax=TZonCooOnMax,
    final TZonCooOnMin=TZonCooOnMin,
    final TZonHeaOnMax=TZonHeaOnMax,
    final TZonHeaOnMin=TZonHeaOnMin,
    final TZonCooSetWinOpe=TZonCooSetWinOpe,
    final TZonHeaSetWinOpe=TZonHeaSetWinOpe,
    final incTSetDem_1=incTSetDem_1,
    final incTSetDem_2=incTSetDem_2,
    final incTSetDem_3=incTSetDem_3,
    final decTSetDem_1=decTSetDem_1,
    final decTSetDem_2=decTSetDem_2,
    final decTSetDem_3=decTSetDem_3) "Zone set point temperature"
    annotation (Placement(transformation(extent={{80,-100},{120,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
    final k=cooDemLimLevCon)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    final k=heaDemLimLevCon) "Heating demand limit level"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=TZonHeaOn)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOff(
    final k=TZonHeaOff)
    "Heating off set point"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=TZonCooOn)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOff(
    final k=TZonCooOff)
    "Cooling off set point"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(
    final have_winSen=have_winSen,
    final numZon=1,
    final preWarCooTim=preWarCooTim,
    final TZonFreProOn=TZonFreProOn,
    final TZonFreProOff=TZonFreProOff) "Operation mode selector"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tCooDowHeaUp(
    final k=warCooTim) "Cool down and heat up time (simplified as constant)"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta(
    final have_winSen=have_winSen) "Check zone temperature status"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger colZon
    "Check if the zone is cold zone"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger hotZon
    "Check if the zone is hot zone"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

equation
  connect(TZonSet.uCooDemLimLev,cooDemLimLev. y)
    annotation (Line(points={{78,-94},{36,-94},{36,-140},{22,-140}},
      color={255,127,0}));
  connect(heaDemLimLev.y,TZonSet. uHeaDemLimLev)
    annotation (Line(points={{22,-200},{40,-200},{40,-98},{78,-98}},
      color={255,127,0}));
  connect(TZonSet.TZonCooSet, TZonCooSet)
    annotation (Line(points={{122,-72},{132,-72},{132,110},{180,110}},
      color={0,0,127}));
  connect(TZonSet.TZonHeaSet, TZonHeaSet)
    annotation (Line(points={{122,-80},{140,-80},{140,60},{180,60}},
      color={0,0,127}));
  connect(setAdj, TZonSet.setAdj)
    annotation (Line(points={{-180,-80},{-100,-80},{-100,-83},{78,-83}},
      color={0,0,127}));
  connect(heaSetAdj, TZonSet.heaSetAdj)
    annotation (Line(points={{-180,-120},{-100,-120},{-100,-87},{78,-87}},
      color={0,0,127}));
  connect(TZonSet.uOccSen, uOccSen)
    annotation (Line(points={{94,-102},{94,-160},{-180,-160}},
      color={255,0,255}));
  connect(TZonSet.uWinSta, uWinSta)
    annotation (Line(points={{106,-102},{106,-170},{-72,-170},{-72,-200},{-180,-200}},
      color={255,0,255}));
  connect(tCooDowHeaUp.y, zonSta.cooDowTim) annotation (Line(points={{-98,190},{
          -74,190},{-74,59},{-62,59}}, color={0,0,127}));
  connect(tCooDowHeaUp.y, zonSta.warUpTim) annotation (Line(points={{-98,190},{-74,
          190},{-74,57},{-62,57}}, color={0,0,127}));
  connect(uWinSta, zonSta.uWinSta) annotation (Line(points={{-180,-200},{-72,-200},
          {-72,55},{-62,55}}, color={255,0,255}));
  connect(TSetRooHeaOn.y, zonSta.TZonHeaSetOcc) annotation (Line(points={{-98,150},
          {-76,150},{-76,53},{-62,53}}, color={0,0,127}));
  connect(TSetRooCooOn.y, zonSta.TZonCooSetOcc) annotation (Line(points={{-98,110},
          {-78,110},{-78,51},{-62,51}}, color={0,0,127}));
  connect(TZon, zonSta.TZonMax) annotation (Line(points={{-180,-50},{-68,-50},{-68,
          49},{-62,49}}, color={0,0,127}));
  connect(TZon, zonSta.TZon) annotation (Line(points={{-180,-50},{-68,-50},{-68,
          47},{-62,47}}, color={0,0,127}));
  connect(TZon, zonSta.TZonMin) annotation (Line(points={{-180,-50},{-68,-50},{-68,
          45},{-62,45}}, color={0,0,127}));
  connect(TSetRooHeaOff.y, zonSta.TZonHeaSetUno) annotation (Line(points={{-98,70},
          {-80,70},{-80,43},{-62,43}}, color={0,0,127}));
  connect(TSetRooCooOff.y, zonSta.TZonCooSetUno) annotation (Line(points={{-98,30},
          {-66,30},{-66,41},{-62,41}}, color={0,0,127}));
  connect(uOcc, opeModSel.uOcc) annotation (Line(points={{-180,10.25},{-136,10.25},
          {-136,2},{38,2}}, color={255,0,255}));
  connect(tNexOcc, opeModSel.tNexOcc) annotation (Line(points={{-180,140},{-140,
          140},{-140,0},{38,0}},   color={0,0,127}));
  connect(zonSta.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{-38,59},
          {30,59},{30,-2},{38,-2}},     color={0,0,127}));
  connect(zonSta.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-38,57},
          {28,57},{28,-4},{38,-4}}, color={0,0,127}));
  connect(zonSta.yOccHeaHigMin, opeModSel.occHeaHigMin) annotation (Line(points={{-38,53},
          {26,53},{26,-6},{38,-6}},          color={255,0,255}));
  connect(zonSta.yMaxHigOccCoo, opeModSel.maxHigOccCoo) annotation (Line(points={{-38,51},
          {24,51},{24,-8},{38,-8}},          color={255,0,255}));
  connect(zonSta.yUnoHeaHigMin, opeModSel.unoHeaHigMin) annotation (Line(points={{-38,45},
          {22,45},{22,-14},{38,-14}},          color={255,0,255}));
  connect(TZon, opeModSel.TZonMax) annotation (Line(points={{-180,-50},{-68,-50},
          {-68,-16},{38,-16}}, color={0,0,127}));
  connect(TZon, opeModSel.TZonMin) annotation (Line(points={{-180,-50},{-68,-50},
          {-68,-18},{38,-18}}, color={0,0,127}));
  connect(zonSta.yMaxHigUnoCoo, opeModSel.maxHigUnoCoo) annotation (Line(points={{-38,43},
          {20,43},{20,-22},{38,-22}},          color={255,0,255}));
  connect(zonSta.yLowUnoHea, colZon.u) annotation (Line(points={{-38,49},{-26,49},
          {-26,20},{-22,20}}, color={255,0,255}));
  connect(zonSta.yHigUnoCoo, hotZon.u) annotation (Line(points={{-38,41},{-28,41},
          {-28,-40},{-22,-40}}, color={255,0,255}));
  connect(colZon.y, opeModSel.totColZon) annotation (Line(points={{2,20},{18,20},
          {18,-12},{38,-12}}, color={255,127,0}));
  connect(hotZon.y, opeModSel.totHotZon) annotation (Line(points={{2,-40},{18,-40},
          {18,-20},{38,-20}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, TZonSet.uOpeMod) annotation (Line(points={{62,-10},
          {70,-10},{70,-62},{78,-62}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, yOpeMod)
    annotation (Line(points={{62,-10},{180,-10}}, color={255,127,0}));
  connect(TSetRooCooOn.y, TZonSet.TZonCooSetOcc) annotation (Line(points={{-98,110},
          {-78,110},{-78,-67},{78,-67}}, color={0,0,127}));
  connect(TSetRooCooOff.y, TZonSet.TZonCooSetUno) annotation (Line(points={{-98,30},
          {-74,30},{-74,-71.2},{78,-71.2}},     color={0,0,127}));
  connect(TSetRooHeaOn.y, TZonSet.TZonHeaSetOcc) annotation (Line(points={{-98,150},
          {-76,150},{-76,-75.2},{78,-75.2}}, color={0,0,127}));
  connect(TSetRooHeaOff.y, TZonSet.TZonHeaSetUno) annotation (Line(points={{-98,70},
          {-80,70},{-80,-79},{78,-79}},     color={0,0,127}));

  connect(uWinSta, opeModSel.uWinSta) annotation (Line(points={{-180,-200},{-72,
          -200},{-72,-10},{38,-10}}, color={255,0,255}));
annotation (defaultComponentName="modSetPoi",
  Diagram(coordinateSystem(extent={{-160,-220},{160,220}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Text(
        extent={{-100,140},{98,102}},
        textString="%name",
        lineColor={0,0,255}),
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,98},{-48,82}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-100,70},{-68,56}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-100,40},{-62,24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=cooAdj or sinAdj,
          extent={{-100,12},{-56,-8}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="setAdj"),
        Text(
          visible=heaAdj,
          extent={{-98,-20},{-34,-40}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="heaSetAdj"),
        Text(
          visible=have_occSen,
          extent={{-98,-50},{-50,-68}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOccSen"),
        Text(
          visible=have_winSen,
          extent={{-98,-80},{-56,-98}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWinSta"),
        Text(
          extent={{34,80},{98,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{34,10},{98,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          extent={{36,-60},{100,-76}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeMod")}),
Documentation(info="<html>
<p>
Block that outputs the zone setpoint temperature (<code>TZonCooSet</code>, <code>TZonHeaSet</code>)
and system operation mode (<code>yOpeMod</code>). When operation mode is in freeze
protection setback mode, it also outputs a level 3 freeze protection alarm
<code>yFreProSta</code>. The sequences are implemented according to ASHRAE
Guideline 36, Part 5.B.3 and 5.C.6.
</p>
<p>The sequence consists of the following two subsequences.</p>
<h4>Operation mode selector</h4>
<p>
The subsequence outputs one of seven types of system operation mode (occupied, warmup,
cool-down, setback, freeze protection setback, setup, unoccupied) according
to current time, the time to next occupied hours <code>tNexOcc</code> and
current zone temperature <code>TZon</code>.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode</a>.
</p>
<h4>Zone setpoint temperature reset</h4>
<p>
This sequence is implemented according to Part 5.B.3. It sets the zone temperature setpoint
according to the globally specified setpoints, the local setpoint adjustments, the demand
limits adjustment, the window status and the occupancy status.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures</a>.
</p>
<h4>Usage</h4>
<p>
This version is for a single zone only to be used in the Single Zone VAV sequence.
For multizone systems, use
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 11, 2020, by Jianjun Hu:<br/>
Reimplemented to avoid vector-valued calculations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">issue 1709</a>.
</li>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ModeAndSetPoints;
