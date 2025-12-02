within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater;
block Controller "Condenser water pump controller"

  parameter Boolean have_heaPum = true
    "Flag of headered condenser water pumps design: true=headered, false=dedicated";
  parameter Boolean have_WSE = true
    "Flag of waterside economizer: true=have WSE, false=no WSE";
  parameter Boolean fixSpe = false
    "Flag to indicate if the plant has fix speed condenser water pump";
  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable"
    annotation (Dialog(group="Stage design speed"));
  parameter Integer nChiSta = 3
    "Total number of chiller stages, including stage zero but not the stages with a WSE, if applicable";
  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(group="Stage design speed"));
  parameter Real desConWatPumSpe[totSta]={0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(group="Stage design speed", enable=not fixSpe));
  parameter Integer desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Stage design speed"));
  parameter Integer desChiNum[nChiSta]={0,1,2}
    "Design number of chiller that should be ON, according to current chiller stage"
    annotation (Dialog(group="Stage design speed", enable=fixSpe));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal[nChi]
    if have_heaPum
    "Chiller condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna
    "Lead chiller enabling status: true=lead chiller is enabled"
    annotation (Placement(transformation(extent={{-160,50},{-120,90}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta
    "Lead chiller status: true=lead chiller proven on"
    annotation (Placement(transformation(extent={{-162,20},{-122,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatReq
    "Status indicating if chiller is requesting condenser water"
    annotation (Placement(transformation(extent={{-162,-10},{-122,30}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-160,-40},{-120,0}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage that does not include WSE"
    annotation (Placement(transformation(extent={{-160,-76},{-120,-36}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-110},{-120,-70}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead pump status setpoint"
    annotation (Placement(transformation(extent={{120,60},{160,100}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesConWatPumSpe
    if not fixSpe
    "Condenser water pump design speed at current stage"
    annotation (Placement(transformation(extent={{120,-10},{160,30}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{120,-50},{160,-10}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.EnableLead_headered
    enaLeaHeaPum(final have_WSE=have_WSE) if have_heaPum
    "Enable lead pumps for plants with headered condenser water pump"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.EnableLead_dedicated
    enaLeaDedPum if not have_heaPum
    "Enable lead pumps for plants with dedicated condenser water pump"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.Speed
    pumSpe(
    final have_WSE=have_WSE,
    final fixSpe=fixSpe,
    final totSta=totSta,
    final nChiSta=nChiSta,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final desChiNum=desChiNum)
    "Design pump speed of condenser water pump at current stage"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    if not fixSpe
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,-8},{-40,12}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,-48},{-40,-28}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi if not fixSpe
    "Real switch"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi "Integer switch"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not have_WSE
    "Logical true"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

equation
  connect(uWSE, enaLeaHeaPum.uWseConIsoVal)
    annotation (Line(points={{-140,-90},{0,-90},{0,80},{18,80}},
      color={255,0,255}));
  connect(enaLeaDedPum.uLeaChiSta, uLeaChiSta)
    annotation (Line(points={{18,26},{-90,26},{-90,40},{-142,40}}, color={255,0,255}));
  connect(enaLeaDedPum.uLeaConWatReq, uLeaConWatReq)
    annotation (Line(points={{18,22},{-80,22},{-80,10},{-142,10}},
      color={255,0,255}));
  connect(uWSE, pumSpe.uWSE)
    annotation (Line(points={{-140,-90},{0,-90},{0,-64},{18,-64}}, color={255,0,255}));
  connect(enaLeaHeaPum.yLea, yLeaPum)
    annotation (Line(points={{42,80},{140,80}},   color={255,0,255}));
  connect(enaLeaDedPum.yLea, yLeaPum)
    annotation (Line(points={{42,30},{50,30},{50,80},{140,80}},   color={255,0,255}));
  connect(uChiSta, pumSpe.uChiSta)
    annotation (Line(points={{-140,-56},{18,-56}}, color={255,127,0}));
  connect(swi.y,yDesConWatPumSpe)
    annotation (Line(points={{102,10},{140,10}}, color={0,0,127}));
  connect(enaLeaDedPum.yLea, swi.u2)
    annotation (Line(points={{42,30},{50,30},{50,10},{78,10}}, color={255,0,255}));
  connect(enaLeaHeaPum.yLea, swi.u2)
    annotation (Line(points={{42,80},{50,80},{50,10},{78,10}},   color={255,0,255}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-38,2},{78,2}}, color={0,0,127}));
  connect(enaLeaHeaPum.yLea, intSwi.u2)
    annotation (Line(points={{42,80},{50,80},{50,-30},{78,-30}}, color={255,0,255}));
  connect(enaLeaDedPum.yLea, intSwi.u2)
    annotation (Line(points={{42,30},{50,30},{50,-30},{78,-30}}, color={255,0,255}));
  connect(pumSpe.yConWatPumNum, intSwi.u1)
    annotation (Line(points={{42,-60},{68,-60},{68,-22},{78,-22}}, color={255,127,0}));
  connect(intSwi.y, yConWatPumNum)
    annotation (Line(points={{102,-30},{140,-30}}, color={255,127,0}));
  connect(zer1.y, intSwi.u3)
    annotation (Line(points={{-38,-38},{78,-38}}, color={255,127,0}));
  connect(pumSpe.yDesConWatPumSpe, swi.u1)
    annotation (Line(points={{42,-54},{60,-54},{60,18},{78,18}}, color={0,0,127}));
  connect(con.y, enaLeaHeaPum.uWseConIsoVal)
    annotation (Line(points={{-38,60},{-20,60},{-20,80},{18,80}},
      color={255,0,255}));
  connect(con.y, pumSpe.uWSE)
    annotation (Line(points={{-38,60},{-20,60},{-20,-64},{18,-64}},
      color={255,0,255}));
  connect(uLeaChiEna, enaLeaDedPum.uLeaChiEna)
    annotation (Line(points={{-140,70},{-80,70},{-80,34},{18,34}},
      color={255,0,255}));
  connect(enaLeaHeaPum.uChiConIsoVal, uChiConIsoVal) annotation (Line(points={{18,86},
          {-40,86},{-40,100},{-140,100}},  color={255,0,255}));
  connect(uEnaPla, enaLeaHeaPum.uEnaPla) annotation (Line(points={{-140,-20},{10,
          -20},{10,74},{18,74}},  color={255,0,255}));
  connect(uEnaPla, enaLeaDedPum.uEnaPla) annotation (Line(points={{-140,-20},{10,
          -20},{10,38},{18,38}},color={255,0,255}));

annotation (defaultComponentName="conWatPumCon",
  Icon(coordinateSystem(grid={2,2}, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(grid={2,2}, extent={{-120,-120},{120,120}})),
  Documentation(info="<html>
<p>
Block that generates control signals for condenser water pumps control, 
according to ASHRAE Guideline 36-2021, section 5.20.9 Condenser water pumps. 
</p>
<p>
This sequence contains three subsequences:
</p>
<ul>
<li>
Enabling and disabling the lead pump should be controlled based on if the pumps
are configured as headered or dedicated. If it is headered, 
<code>have_heaPum</code> = true, then use block <code>enaLeaHeaPum</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.EnableLead_headered</a>
for a description. Otherwise, use block <code>enaLeaDedPum</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.EnableLead_dedicated</a>
for a description.
</li>
<li>
The design pump speed at current stage <code>yDesConWatPumSpe</code> and the number of 
operating pumps <code>yConWatPumNum</code> should be output from block 
<code>pumSpe</code>. See 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.Speed\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Pumps.CondenserWater.Subsequences.Speed</a>
for a description. 
</li>
<li>
The last section of the sequence is to check if current pump speed is running on
the setpoint.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
Febuary 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
