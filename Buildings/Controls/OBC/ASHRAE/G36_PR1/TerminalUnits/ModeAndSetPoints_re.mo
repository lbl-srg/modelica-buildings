within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
block ModeAndSetPoints_re
  "Output zone setpoint with operation mode selection"

  parameter Real preWarCooTim(
    final unit="s",
    final quantity="Time")=10800
    "Maximum cool-down/warm-up time"
    annotation (Dialog(tab="Operation mode", group="Parameters"));

  parameter Real TZonFreProOn=277.55
    "Threshold zone temperature value to activate freeze protection mode"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real TZonFreProOff=280.35
    "Threshold zone temperature value to finish the freeze protection mode"
    annotation (Dialog(tab="Operation mode", group="Parameters"));

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
  parameter Real TZonCooOnMax=300.15
    "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonCooOnMin=295.15
    "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaOnMax=295.15
    "Maximum heating setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaOnMin=291.15
    "Minimum heating setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonCooSetWinOpe=322.15
    "Cooling setpoint when window is open"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaSetWinOpe=277.15
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
    quantity="Time") "Time to next occupied period for the zone group"
    annotation (Placement(transformation(extent={{-200,200},{-160,240}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period for the zone group, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-200,170},{-160,210.5}}),
      iconTransformation(extent={{-140,60},{-100,100.5}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonMin(
    final unit="K",
    final displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Minimum zone temperature in the zone group" annotation (Placement(
        transformation(extent={{-200,-70},{-160,-30}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if (cooAdj or sinAdj)
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-180,
            -130}),
      iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-180,
            -160}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccSen if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-200,-210},{-160,-170}}),
      iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta if have_winSen
    "Window status (open=true, close=false)"
    annotation (Placement(transformation(extent={{-200,-240},{-160,-200}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    final displayUnit="degC",
    quantity="ThermodynamicTemperature") "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{160,90},{200,130}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    final displayUnit="degC",
    quantity="ThermodynamicTemperature") "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{160,-30},{200,10}}),
      iconTransformation(extent={{100,-90},{140,-50}})));

  CDL.Interfaces.RealInput TZonMax(
    final unit="K",
    final displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Maximum zone temperature in the zone group" annotation (Placement(
        transformation(extent={{-200,-40},{-160,0}}), iconTransformation(extent=
           {{-140,-80},{-100,-40}})));
  CDL.Interfaces.RealInput maxCooDowTim(
    final unit="s",
    final quantity="Time")
    "Maximum cool-down time among all the zones"
    annotation (Placement(transformation(extent={{-200,140},{-160,180}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.RealInput maxWarUpTim(
    final unit="s",
    final quantity="Time")
    "Maximum warm-up time among all the zones"
    annotation (Placement(transformation(extent={{-200,110},{-160,150}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.BooleanInput uOccHeaHig
    "True when the occupied heating setpoint temperature is higher than the zone temperature"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  CDL.Interfaces.BooleanInput uHigOccCoo
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-200,50},{-160,90}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.IntegerInput totColZon
    "Total number of cold zone"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.BooleanInput unoHeaHigMin
    "True when the unoccupied heating setpoint is higher than minimum zone temperature"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.IntegerInput totHotZon
    "Total number of hot zone"
    annotation (Placement(transformation(extent={{-200,-90},{-160,-50}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  CDL.Interfaces.BooleanInput maxHigUnoCoo
    "True when the maximum zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  CDL.Interfaces.RealInput TZonCooSetOcc(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-200,-270},{-160,-230}}),
        iconTransformation(extent={{-140,-240},{-100,-200}})));
  CDL.Interfaces.RealInput TZonCooSetUno(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-200,-300},{-160,-260}}),
        iconTransformation(extent={{-140,-260},{-100,-220}})));
  CDL.Interfaces.RealInput TZonHeaSetOcc(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Occupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-200,-332},{-160,-292}}),
        iconTransformation(extent={{-140,-280},{-100,-240}})));
  CDL.Interfaces.RealInput TZonHeaSetUno(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-200,-362},{-160,-322}}),
        iconTransformation(extent={{-140,-300},{-100,-260}})));
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
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    final k=heaDemLimLevCon) "Heating demand limit level"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(
    final have_winSen=have_winSen,
    final numZon=1,
    final preWarCooTim=preWarCooTim,
    final TZonFreProOn=TZonFreProOn,
    final TZonFreProOff=TZonFreProOff) "Operation mode selector"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

equation
  connect(TZonSet.uCooDemLimLev,cooDemLimLev. y)
    annotation (Line(points={{78,-94},{36,-94},{36,-110},{-18,-110}},
      color={255,127,0}));
  connect(heaDemLimLev.y,TZonSet. uHeaDemLimLev)
    annotation (Line(points={{-18,-150},{40,-150},{40,-98},{78,-98}},
      color={255,127,0}));
  connect(TZonSet.TZonCooSet, TZonCooSet)
    annotation (Line(points={{122,-72},{132,-72},{132,110},{180,110}},
      color={0,0,127}));
  connect(TZonSet.TZonHeaSet, TZonHeaSet)
    annotation (Line(points={{122,-80},{140,-80},{140,60},{180,60}},
      color={0,0,127}));
  connect(setAdj, TZonSet.setAdj)
    annotation (Line(points={{-180,-130},{-100,-130},{-100,-83},{78,-83}},
      color={0,0,127}));
  connect(heaSetAdj, TZonSet.heaSetAdj)
    annotation (Line(points={{-180,-160},{-96,-160},{-96,-87},{78,-87}},
      color={0,0,127}));
  connect(TZonSet.uOccSen, uOccSen)
    annotation (Line(points={{94,-102},{94,-190},{-180,-190}},
      color={255,0,255}));
  connect(TZonSet.uWinSta, uWinSta)
    annotation (Line(points={{106,-102},{106,-180},{-72,-180},{-72,-220},{-180,-220}},
      color={255,0,255}));
  connect(uOcc, opeModSel.uOcc) annotation (Line(points={{-180,190.25},{-136,190.25},
          {-136,2},{38,2}}, color={255,0,255}));
  connect(tNexOcc, opeModSel.tNexOcc) annotation (Line(points={{-180,220},{-140,
          220},{-140,0},{38,0}},   color={0,0,127}));
  connect(opeModSel.yOpeMod, TZonSet.uOpeMod) annotation (Line(points={{62,-10},
          {70,-10},{70,-62},{78,-62}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, yOpeMod)
    annotation (Line(points={{62,-10},{180,-10}}, color={255,127,0}));
  connect(uWinSta, opeModSel.uWinSta) annotation (Line(points={{-180,-220},{-72,
          -220},{-72,-10},{38,-10}}, color={255,0,255}));

  connect(maxCooDowTim, opeModSel.maxCooDowTim) annotation (Line(points={{-180,160},
          {-132,160},{-132,-2},{38,-2}}, color={0,0,127}));
  connect(maxWarUpTim, opeModSel.maxWarUpTim) annotation (Line(points={{-180,130},
          {-128,130},{-128,-4},{38,-4}}, color={0,0,127}));
  connect(uOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={{-180,100},
          {-124,100},{-124,-6},{38,-6}}, color={255,0,255}));
  connect(uHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={{-180,70},{
          -120,70},{-120,-8},{38,-8}}, color={255,0,255}));
  connect(totColZon, opeModSel.totColZon) annotation (Line(points={{-180,40},{-142,
          40},{-142,-12},{38,-12}}, color={255,127,0}));
  connect(unoHeaHigMin, opeModSel.unoHeaHigMin) annotation (Line(points={{-180,10},
          {-146,10},{-146,-14},{38,-14}}, color={255,0,255}));
  connect(TZonMax, opeModSel.TZonMax) annotation (Line(points={{-180,-20},{-152,
          -20},{-152,-16},{38,-16}}, color={0,0,127}));
  connect(TZonMin, opeModSel.TZonMin) annotation (Line(points={{-180,-50},{-148,
          -50},{-148,-18},{38,-18}}, color={0,0,127}));
  connect(maxHigUnoCoo, opeModSel.maxHigUnoCoo) annotation (Line(points={{-180,-100},
          {-140,-100},{-140,-22},{38,-22}}, color={255,0,255}));
  connect(totHotZon, opeModSel.totHotZon) annotation (Line(points={{-180,-70},{-144,
          -70},{-144,-20},{38,-20}}, color={255,127,0}));
  connect(TZonCooSetOcc, TZonSet.TZonCooSetOcc) annotation (Line(points={{-180,-250},
          {60,-250},{60,-67},{78,-67}}, color={0,0,127}));
  connect(TZonCooSetUno, TZonSet.TZonCooSetUno) annotation (Line(points={{-180,-280},
          {64,-280},{64,-71.2},{78,-71.2}}, color={0,0,127}));
  connect(TZonHeaSetOcc, TZonSet.TZonHeaSetOcc) annotation (Line(points={{-180,-312},
          {68,-312},{68,-75.2},{78,-75.2}}, color={0,0,127}));
  connect(TZonHeaSetUno, TZonSet.TZonHeaSetUno) annotation (Line(points={{-180,-342},
          {72,-342},{72,-79},{78,-79}}, color={0,0,127}));
annotation (defaultComponentName="modSetPoi",
  Diagram(coordinateSystem(extent={{-160,-360},{160,220}})),
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
end ModeAndSetPoints_re;
