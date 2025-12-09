within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging;
block Controller "Sequence of staging cooling tower cells"

  parameter Boolean have_WSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable";
  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Plant stage vector with size of total number of stages, element value like x.5 means chiller stage x plus WSE";
  parameter Integer towCelOnSet[totSta]={0,2,2,4,4,4}
    "Design number of tower fan cells that should be enabled, according to current chiller stage and WSE status";
  parameter Boolean have_endSwi=false
    "True: tower cells isolation valve have end switch"
    annotation (Dialog(group="Isolation valves"));
  parameter Boolean have_outIsoVal=false
    "True: tower cells also have outlet isolation valve"
    annotation (Dialog(group="Isolation valves", enable=have_endSwi));
  parameter Real chaTowCelIsoTim=90
    "Nominal time needed for open isolation valve of the tower cells"
    annotation (Dialog(group="Isolation valves", enable=not have_endSwi));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
      iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiStaSet
    "Current chiller stage setpoint"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
      iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaCha
    "Cooling tower stage change command from plant staging process"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAnyConWatPum
    "True: there is condenser water pump on"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1InIsoValOpe[nTowCel]
    if have_endSwi
    "Tower cells inlet isolation valve open end switch. True: the isolation valve is fully open"
    annotation (Placement(transformation(extent={{-140,-78},{-100,-38}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OutIsoValOpe[nTowCel]
    if have_endSwi and have_outIsoVal
    "Tower cells outlet isolation valve open end switch. True: the isolation valve is fully open"
    annotation (Placement(transformation(extent={{-140,-98},{-100,-58}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1InIsoValClo[nTowCel]
    if have_endSwi
    "Tower cells inlet isolation valve close end switch. True: the isolation valve is fully closed"
    annotation (Placement(transformation(extent={{-140,-128},{-100,-88}}),
        iconTransformation(extent={{-140,-102},{-100,-62}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OutIsoValClo[nTowCel]
    if have_endSwi and have_outIsoVal
    "Tower cells outlet isolation valve close end switch. True: the isolation valve is fully closed"
    annotation (Placement(transformation(extent={{-140,-148},{-100,-108}}),
        iconTransformation(extent={{-140,-122},{-100,-82}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells proven on status: true=proven on"
    annotation (Placement(transformation(extent={{-140,-180},{-100,-140}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaCel
    "Lead tower cell status"
    annotation (Placement(transformation(extent={{100,94},{140,134}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1IsoVal[nTowCel]
    "Vector of tower cells isolation valve position"
    annotation (Placement(transformation(extent={{100,16},{140,56}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSta
    "Rising edge to indicate the staging process is done"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.CellsNumber
    enaCel(
    final have_WSE=have_WSE,
    final nConWatPum=nConWatPum,
    final nTowCel=nTowCel,
    final totSta=totSta,
    final staVec=staVec,
    final towCelOnSet=towCelOnSet)
    "Total number of enabled cells"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses
    staPro(
    final have_endSwi=have_endSwi,
    final have_outIsoVal=have_outIsoVal,
    final nTowCel=nTowCel,
    final chaTowCelIsoTim=chaTowCelIsoTim) "Tower staging process"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.ChangeCells ideChaCel(
    final nTowCel=nTowCel)
    "Identify which cell should change status"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

equation
  connect(uChiSta, enaCel.uChiSta) annotation (Line(points={{-120,160},{-74,160},
          {-74,129},{-42,129}}, color={255,127,0}));
  connect(uChiStaSet, enaCel.uChiStaSet) annotation (Line(points={{-120,130},{-80,
          130},{-80,126},{-42,126}}, color={255,127,0}));
  connect(enaCel.uTowStaCha, uTowStaCha) annotation (Line(points={{-42,122},{-80,
          122},{-80,100},{-120,100}}, color={255,0,255}));
  connect(uWse, enaCel.uWse) annotation (Line(points={{-120,70},{-74,70},{-74,119},
          {-42,119}},color={255,0,255}));
  connect(enaCel.yLeaCel, yLeaCel) annotation (Line(points={{-18,114},{120,114}},
          color={255,0,255}));
  connect(staPro.yTowSta, yTowSta) annotation (Line(points={{62,-20},{80,-20},{80,
          -30},{120,-30}}, color={255,0,255}));
  connect(uTowSta, staPro.uTowSta) annotation (Line(points={{-120,-160},{-40,
          -160},{-40,-28},{38,-28}}, color={255,0,255}));
  connect(staPro.yEndSta, yEndSta) annotation (Line(points={{62,-26},{70,-26},{70,
          -70},{120,-70}}, color={255,0,255}));
  connect(uEnaPla, enaCel.uEnaPla) annotation (Line(points={{-120,40},{-68,40},{
          -68,117},{-42,117}}, color={255,0,255}));
  connect(enaCel.yNumCel, ideChaCel.uCelNum) annotation (Line(points={{-18,120},
          {-10,120},{-10,54},{-2,54}}, color={255,127,0}));
  connect(uTowSta, ideChaCel.uTowSta) annotation (Line(points={{-120,-160},{-40,
          -160},{-40,46},{-2,46}}, color={255,0,255}));
  connect(ideChaCel.yChaCel, staPro.uChaCel) annotation (Line(points={{22,46},{30,
          46},{30,-12},{38,-12}}, color={255,0,255}));
  connect(uPla, enaCel.uPla) annotation (Line(points={{-120,10},{-62,10},{-62,113},
          {-42,113}}, color={255,0,255}));
  connect(uAnyConWatPum, enaCel.uAnyConWatPum) annotation (Line(points={{-120,-20},
          {-56,-20},{-56,111},{-42,111}}, color={255,0,255}));
  connect(staPro.y1IsoVal, y1IsoVal)
    annotation (Line(points={{62,-14},{80,-14},{80,36},{120,36}}, color={255,0,255}));
  connect(u1InIsoValOpe, staPro.u1InIsoValOpe) annotation (Line(points={{-120,
          -58},{0,-58},{0,-16},{38,-16}}, color={255,0,255}));
  connect(u1OutIsoValOpe, staPro.u1OutIsoValOpe) annotation (Line(points={{-120,
          -78},{6,-78},{6,-18},{38,-18}}, color={255,0,255}));
  connect(u1InIsoValClo, staPro.u1InIsoValClo) annotation (Line(points={{-120,
          -108},{12,-108},{12,-22},{38,-22}}, color={255,0,255}));
  connect(u1OutIsoValClo, staPro.u1OutIsoValClo) annotation (Line(points={{-120,
          -128},{18,-128},{18,-24},{38,-24}}, color={255,0,255}));
annotation (
  defaultComponentName="towSta",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-180},{100,180}})),
    Icon(coordinateSystem(extent={{-100,-140},{100,140}}),
         graphics={
        Rectangle(
          extent={{-100,-140},{100,140}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,180},{100,140}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,116},{-46,104}},
          textColor={255,127,0},
          textString="uChiStaSet"),
        Text(
          extent={{-98,136},{-60,124}},
          textColor={255,127,0},
          textString="uChiSta"),
        Text(
          extent={{-100,86},{-40,74}},
          textColor={255,0,255},
          textString="uTowStaCha"),
        Text(
          extent={{-100,66},{-70,54}},
          textColor={255,0,255},
          textString="uWse",
          visible=have_WSE),
        Text(
          extent={{-98,-122},{-58,-136}},
          textColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{56,-22},{98,-34}},
          textColor={255,0,255},
          textString="yTowSta"),
        Text(
          extent={{60,88},{98,76}},
          textColor={255,0,255},
          textString="yLeaCel"),
        Text(
          extent={{58,-72},{100,-84}},
          textColor={255,0,255},
          textString="yEndSta"),
        Text(
          extent={{-96,46},{-58,32}},
          textColor={255,0,255},
          textString="uEnaPla"),
        Text(
          extent={{-100,26},{-70,14}},
          textColor={255,0,255},
          visible=have_WSE,
          textString="uPla"),
        Text(
          extent={{-98,8},{-18,-6}},
          textColor={255,0,255},
          textString="uAnyConWatPum"),
        Text(
          extent={{-100,-22},{-32,-36}},
          textColor={255,0,255},
          textString="u1InIsoValOpe",
          visible=have_endSwi),
        Text(
          extent={{-96,-42},{-28,-56}},
          textColor={255,0,255},
          textString="u1OutIsoValOpe",
          visible=have_endSwi and have_outIsoVal),
        Text(
          extent={{-96,-94},{-28,-108}},
          textColor={255,0,255},
          textString="u1OutIsoValClo",
          visible=have_endSwi and have_outIsoVal),
        Text(
          extent={{-100,-74},{-32,-88}},
          textColor={255,0,255},
          textString="u1InIsoValClo",
          visible=have_endSwi),
        Text(
          extent={{60,36},{98,24}},
          textColor={255,0,255},
          textString="y1IsoVal")}),
Documentation(info="<html>
<p>
Block controls cooling tower fan staging. This is implemented accoding to 
ASHRAE Guideline 36-2021, section 5.20.12.1, 
which specifies tower fan staging process. It includes two subsequences:
</p>
<ul>
<li>
Sequence of identifying total number of enabled cells. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.CellsNumber\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.CellsNumber</a>
for a description.
</li>
<li>
Sequence of identifying cells that should change status. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.ChangeCells\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.ChangeCells</a>
for a description.
</li>
<li>
Sequence of process for enabling cells. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Subsequences.StageProcesses</a>
for a description.
</li>
</ul>
<p>
Note that in this implementation, input <code>uTowStaCha</code>
is from chiller staging process sequence. The input is also used for the 
condenser water pump staging. Thus, the tower stage changes are initiated concurrentlyl
with condenser water pump stage.
</p>
<p>
The sequence also assumes the cells are enabled in order as it is labelled, meaning
that it enabled the cells as cell 1, 2, 3, etc.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
