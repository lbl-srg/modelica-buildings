within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block ModeAndSetPoints
  "Output zone setpoint with operation mode selection"

  parameter Boolean have_winSen
    "Check if the zone has window status sensor";
  parameter Boolean have_occSen
    "Check if the zone has occupancy sensor";
  parameter Boolean have_locAdj
    "True: the zone has local setpoint adjustment knob"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Boolean sepAdj
    "True: cooling and heating setpoint can be adjusted separately"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings", enable=have_locAdj));
  parameter Boolean ignDemLim
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Real TActCoo_max(
    unit="K",
    displayUnit="degC")=300.15
    "Maximum active cooling setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TActCoo_min(
    unit="K",
    displayUnit="degC")=295.15
    "Minimum active cooling setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TActHea_max(
    unit="K",
    displayUnit="degC")=295.15
    "Maximum active heating setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TActHea_min(
    unit="K",
    displayUnit="degC")=291.15
    "Minimum active heating setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TWinOpeCooSet(
    unit="K",
    displayUnit="degC")=322.15
    "Cooling setpoint when window is open"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TWinOpeHeaSet(
    unit="K",
    displayUnit="degC")=277.15
    "Heating setpoint when window is open"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real incTSetDem_1=0.5
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real incTSetDem_2=1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real incTSetDem_3=2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_1=0.5
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_2=1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_3=2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real bouLim=1
    "Threshold of temperature difference for indicating the end of setback or setup mode"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced"));
  parameter Real uLow=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced"));
  parameter Real uHigh=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced"));
  parameter Real preWarCooTim(unit="s")=10800
    "Maximum cool-down or warm-up time"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Operating mode"));
  parameter Real TZonFreProOn(
    unit="K",
    displayUnit="degC")=277.15
    "Threshold temperature to activate the freeze protection mode"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Operating mode"));
  parameter Real TZonFreProOff(
    unit="K",
    displayUnit="degC")=280.15
    "Threshold temperature to end the freeze protection mode"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Operating mode"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-200,190},{-160,230}}),
      iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time") "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-200,130},{-160,170}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-200,70},{-160,110}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-200,50},{-160,90}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-200,10},{-160,50}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ
    "Zone occupancy status according to the schedule: true=occupied, false=unoccupied"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    final quantity="Time") "Time to next occupied period"
    annotation (Placement(transformation(extent={{-200,-50},{-160,-10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj
    if have_locAdj and not sepAdj
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooSetAdj
    if have_locAdj and sepAdj
    "Cooling setpoint adjustment value"
    annotation (Placement(transformation(extent={{-200,-110},{-160,-70}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj
    if have_locAdj and sepAdj "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OccSen if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-200,-170},{-160,-130}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-200,-200},{-160,-160}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-200,-230},{-160,-190}}),
      iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod "Operation mode"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{160,-180},{200,-140}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode opeModSel(
    final nZon=1,
    final preWarCooTim=preWarCooTim,
    final TZonFreProOn=TZonFreProOn,
    final TZonFreProOff=TZonFreProOff) "Operation mode"
    annotation (Placement(transformation(extent={{60,4},{80,36}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints TZonSet(
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final have_locAdj=have_locAdj,
    final sepAdj=sepAdj,
    final ignDemLim=ignDemLim,
    final TActCoo_max=TActCoo_max,
    final TActCoo_min=TActCoo_min,
    final TActHea_max=TActHea_max,
    final TActHea_min=TActHea_min,
    final TWinOpeCooSet=TWinOpeCooSet,
    final TWinOpeHeaSet=TWinOpeHeaSet,
    final incTSetDem_1=incTSetDem_1,
    final incTSetDem_2=incTSetDem_2,
    final incTSetDem_3=incTSetDem_3,
    final decTSetDem_1=decTSetDem_1,
    final decTSetDem_2=decTSetDem_2,
    final decTSetDem_3=decTSetDem_3) "Adjust setpoint temperature"
    annotation (Placement(transformation(extent={{100,-140},{120,-100}})));
  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus zonSta(
    final bouLim=bouLim,
    final have_winSen=have_winSen,
    final uLow=uLow,
    final uHigh=uHigh) "Zone temperature status"
    annotation (Placement(transformation(extent={{-80,80},{-60,108}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger colZon
    "Check if the zone is cold"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger hotZon
    "Check if the zone is hot"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta(
    final k=true)
    if not have_winSen
    "Assume window is closed when there is no windows status sensor"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSta(
    final k=true) if not have_occSen
    "Assume the zone is occupied when there is no occupancy sensor"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not winOpe "Window is open"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
equation
  connect(zonSta.cooDowTim, cooDowTim) annotation (Line(points={{-82,105},{-110,
          105},{-110,210},{-180,210}}, color={0,0,127}));
  connect(zonSta.warUpTim, warUpTim) annotation (Line(points={{-82,102},{-120,102},
          {-120,180},{-180,180}}, color={0,0,127}));
  connect(zonSta.u1Win, u1Win) annotation (Line(points={{-82,99},{-130,99},{-130,
          150},{-180,150}}, color={255,0,255}));
  connect(zonSta.TZon, TZon) annotation (Line(points={{-82,96.2},{-140,96.2},{-140,
          120},{-180,120}}, color={0,0,127}));
  connect(zonSta.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{-58,107},
          {40,107},{40,31.2},{58,31.2}},  color={0,0,127}));
  connect(zonSta.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-58,105},
          {38,105},{38,28},{58,28}}, color={0,0,127}));
  connect(zonSta.yHigOccCoo, opeModSel.u1HigOccCoo) annotation (Line(points={{-58,
          95},{34,95},{34,29.6},{58,29.6}}, color={255,0,255}));
  connect(zonSta.yOccHeaHig, opeModSel.u1OccHeaHig) annotation (Line(points={{-58,
          100},{36,100},{36,26.4},{58,26.4}}, color={255,0,255}));
  connect(zonSta.yUnoHeaHig, colZon.u) annotation (Line(points={{-58,90},{-48,90},
          {-48,-60},{-42,-60}}, color={255,0,255}));
  connect(colZon.y, opeModSel.totColZon) annotation (Line(points={{-18,-60},{26,
          -60},{26,21.6},{58,21.6}}, color={255,127,0}));
  connect(zonSta.yHigUnoCoo, hotZon.u) annotation (Line(points={{-58,83},{-52,83},
          {-52,-90},{-42,-90}}, color={255,0,255}));
  connect(hotZon.y, opeModSel.totHotZon) annotation (Line(points={{-18,-90},{28,
          -90},{28,10.4},{58,10.4}}, color={255,127,0}));
  connect(zonSta.yUnoHeaHig, opeModSel.u1SetBac) annotation (Line(points={{-58,90},
          {-28,90},{-28,18.4},{58,18.4}}, color={255,0,255}));
  connect(zonSta.yEndSetBac, opeModSel.u1EndSetBac) annotation (Line(points={{-58,
          88},{32,88},{32,16.8},{58,16.8}}, color={255,0,255}));
  connect(TZon, opeModSel.TZonMin) annotation (Line(points={{-180,120},{-140,120},
          {-140,13.6},{58,13.6}}, color={0,0,127}));
  connect(zonSta.yHigUnoCoo, opeModSel.u1SetUp) annotation (Line(points={{-58,83},
          {-32,83},{-32,7.2},{58,7.2}}, color={255,0,255}));
  connect(zonSta.yEndSetUp, opeModSel.u1EndSetUp) annotation (Line(points={{-58,
          81},{30,81},{30,5.6},{58,5.6}}, color={255,0,255}));
  connect(opeModSel.u1Occ, u1Occ) annotation (Line(points={{58,34.4},{-40,34.4},
          {-40,0},{-180,0}}, color={255,0,255}));
  connect(opeModSel.tNexOcc, tNexOcc) annotation (Line(points={{58,32.8},{-130,32.8},
          {-130,-30},{-180,-30}}, color={0,0,127}));
  connect(opeModSel.yOpeMod, TZonSet.uOpeMod) annotation (Line(points={{82,20},{
          92,20},{92,-102},{98,-102}}, color={255,127,0}));
  connect(TZonSet.uCooDemLimLev, uCooDemLimLev) annotation (Line(points={{98,-128},
          {16,-128},{16,-180},{-180,-180}}, color={255,127,0}));
  connect(TZonSet.uHeaDemLimLev, uHeaDemLimLev) annotation (Line(points={{98,-131},
          {20,-131},{20,-210},{-180,-210}},  color={255,127,0}));
  connect(opeModSel.yOpeMod, yOpeMod)
    annotation (Line(points={{82,20},{180,20}}, color={255,127,0}));
  connect(TZonSet.TCooSet, TCooSet) annotation (Line(points={{122,-112},{140,-112},
          {140,-60},{180,-60}}, color={0,0,127}));
  connect(TZonSet.THeaSet, THeaSet) annotation (Line(points={{122,-120},{140,-120},
          {140,-160},{180,-160}}, color={0,0,127}));
  connect(booToInt.y, opeModSel.uOpeWin) annotation (Line(points={{12,-20},{24,-20},
          {24,23.2},{58,23.2}},       color={255,127,0}));
  connect(TZonSet.setAdj, setAdj) annotation (Line(points={{98,-120},{-64,-120},
          {-64,-60},{-180,-60}}, color={0,0,127}));
  connect(TZonSet.heaSetAdj, heaSetAdj) annotation (Line(points={{98,-124},{-80,
          -124},{-80,-120},{-180,-120}}, color={0,0,127}));
  connect(u1OccSen, TZonSet.u1Occ) annotation (Line(points={{-180,-150},{80,-150},
          {80,-135},{98,-135}}, color={255,0,255}));
  connect(occSta.y, TZonSet.u1Occ) annotation (Line(points={{62,-180},{80,-180},
          {80,-135},{98,-135}}, color={255,0,255}));
  connect(u1Win, TZonSet.u1Win) annotation (Line(points={{-180,150},{-130,150},{
          -130,40},{-60,40},{-60,-138},{98,-138}}, color={255,0,255}));
  connect(cooSetAdj, TZonSet.cooSetAdj) annotation (Line(points={{-180,-90},{-72,
          -90},{-72,-122},{98,-122}}, color={0,0,127}));
  connect(TOccHeaSet,zonSta.TOccHeaSet)  annotation (Line(points={{-180,90},{-120,
          90},{-120,92},{-82,92}}, color={0,0,127}));
  connect(TOccCooSet,zonSta.TOccCooSet)  annotation (Line(points={{-180,70},{-116,
          70},{-116,89},{-82,89}}, color={0,0,127}));
  connect(TUnoHeaSet,zonSta.TUnoHeaSet)  annotation (Line(points={{-180,50},{-112,
          50},{-112,86},{-82,86}}, color={0,0,127}));
  connect(TUnoCooSet,zonSta.TUnoCooSet)  annotation (Line(points={{-180,30},{-108,
          30},{-108,83},{-82,83}}, color={0,0,127}));
  connect(TOccHeaSet, TZonSet.TOccHeaSet) annotation (Line(points={{-180,90},{-120,
          90},{-120,-114},{98,-114}}, color={0,0,127}));
  connect(TOccCooSet, TZonSet.TOccCooSet) annotation (Line(points={{-180,70},{-116,
          70},{-116,-106},{98,-106}}, color={0,0,127}));
  connect(TUnoHeaSet, TZonSet.TUnoHeaSet) annotation (Line(points={{-180,50},{-112,
          50},{-112,-117},{98,-117}}, color={0,0,127}));
  connect(TUnoCooSet, TZonSet.TUnoCooSet) annotation (Line(points={{-180,30},{-108,
          30},{-108,-109},{98,-109}}, color={0,0,127}));
  connect(winSta.y, winOpe.u)
    annotation (Line(points={{-78,-20},{-42,-20}}, color={255,0,255}));
  connect(winOpe.y, booToInt.u)
    annotation (Line(points={{-18,-20},{-12,-20}}, color={255,0,255}));
  connect(u1Win, winOpe.u) annotation (Line(points={{-180,150},{-130,150},{-130,
          40},{-60,40},{-60,-20},{-42,-20}}, color={255,0,255}));
annotation (defaultComponentName="modSetPoi",
  Diagram(coordinateSystem(extent={{-160,-220},{160,220}})),
  Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
       graphics={Text(
        extent={{-100,240},{100,200}},
        textString="%name",
        textColor={0,0,255}),
      Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,-32},{-58,-46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-98,-12},{-70,-26}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-100,106},{-74,94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=have_locAdj and not sepAdj,
          extent={{-100,-60},{-66,-74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="setAdj"),
        Text(
          visible=have_locAdj and sepAdj,
          extent={{-98,-102},{-52,-116}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="heaSetAdj"),
        Text(
          visible=have_occSen,
          extent={{-98,-132},{-52,-146}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1OccSen"),
        Text(
          visible=have_winSen,
          extent={{-100,136},{-74,124}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win"),
        Text(
          extent={{46,8},{96,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{44,-72},{96,-88}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{52,88},{100,76}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeMod"),
        Text(
          extent={{-98,188},{-50,174}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooDowTim"),
        Text(
          extent={{-98,168},{-50,154}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="warUpTim"),
        Text(
          extent={{-96,-152},{-28,-166}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uCooDemLimLev"),
        Text(
          extent={{-98,-172},{-28,-186}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uHeaDemLimLev"),
        Text(
          visible=have_locAdj and sepAdj,
          extent={{-98,-82},{-52,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooSetAdj"),
        Text(
          extent={{-98,78},{-48,64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOccHeaSet"),
        Text(
          extent={{-98,58},{-48,44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOccCooSet"),
        Text(
          extent={{-98,18},{-48,4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TUnoCooSet"),
        Text(
          extent={{-98,38},{-48,24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TUnoHeaSet")}),
Documentation(info="<html>
<p>
Block that outputs the zone setpoint temperature (<code>TCooSet</code>,
<code>THeaSet</code>) and system operation mode (<code>yOpeMod</code>).
</p>
<p>The sequence consists of the following two subsequences.</p>
<h4>Operation mode selector</h4>
<p>
The subsequence outputs one of seven types of system operation mode (occupied, warm-up,
cooldown, setback, freeze protection setback, setup, unoccupied) according
to current time, the time to next occupied hours <code>tNexOcc</code> and
current zone temperature <code>TZon</code>.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode</a>.
</p>
<h4>Zone setpoint temperature reset</h4>
<p>
It sets the zone temperature setpoint according to the globally specified setpoints,
the local setpoint adjustments, the demand limits adjustment, the window status
and the occupancy status. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints</a>.
</p>
<h4>Usage</h4>
<p>
This version is for a single zone only to be used in the Single Zone VAV sequence.
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
Upgraded according to G36 official release.
</li>
</ul>
</html>"));
end ModeAndSetPoints;
