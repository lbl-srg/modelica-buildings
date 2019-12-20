within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences;
block EnableCells_sim "Sequence for identifying enabing and disabling cells"

  parameter Boolean hasWSE = true
    "Flag to indicate if the plant has waterside economizer";
  parameter Integer nTowCel = 4
    "Total number of cooling tower cells";
  parameter Integer totChiSta = 6
    "Total number of stages, stage zero should be counted as one stage";
  parameter Real staVec[totChiSta] = {0, 0.5, 1, 1.5, 2, 2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE";
  parameter Real towCelOnSet[totChiSta] = {0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Setpoint according to stage"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-520,360},{-480,400}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta if
                                                             hasWSE
    "Water side economizer status: true = ON, false = OFF" annotation (
      Placement(transformation(extent={{-520,220},{-480,260}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Plant stage up status: true=stage-up"
    annotation (Placement(transformation(extent={{-520,-40},{-480,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaUp
    "Cooling tower stage-up command from plant staging process"
    annotation (Placement(transformation(extent={{-520,-80},{-480,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Plant stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-520,-120},{-480,-80}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaDow
    "Cooling tower stage-down command from plant staging process"
    annotation (Placement(transformation(extent={{-520,-160},{-480,-120}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTarTowSta[nTowCel]
    "New array of cooling tower enabling status to be achieved"
    annotation (Placement(transformation(extent={{480,410},{520,450}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaCel
    "If true, indicate that it should start enabling new cells"
    annotation (Placement(transformation(extent={{480,360},{522,402}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDisCel
    "If true, indicate that it should start disabling existing cells"
    annotation (Placement(transformation(extent={{480,130},{520,170}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yEnaCelInd[nTowCel]
    "Non-zero elements indicate the cells to be enabled"
    annotation (Placement(transformation(extent={{480,-120},{520,-80}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDisCelInd[nTowCel]
    "Non-zero elements indicate the cells to be disabled"
    annotation (Placement(transformation(extent={{480,-230},{520,-190}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

  CDL.Interfaces.RealInput uConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Current condenser water pump speed" annotation (Placement(
        transformation(extent={{-520,20},{-480,60}}), iconTransformation(extent
          ={{-140,80},{-100,120}})));
  CDL.Interfaces.BooleanInput uLeaConWatPum
    "Enabling status of lead condenser water pump" annotation (Placement(
        transformation(extent={{-520,60},{-480,100}}), iconTransformation(
          extent={{-140,-50},{-100,-10}})));
  CDL.Logical.Latch leaCel "Lead cell status"
    annotation (Placement(transformation(extent={{-360,70},{-340,90}})));
  CDL.Logical.Not conPumOff "All condenser water pumps are off"
    annotation (Placement(transformation(extent={{-420,30},{-400,50}})));
protected
  final parameter Integer twoCelInd[nTowCel]={i for i in 1:nTowCel}
    "Tower cell index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.And enaCel "Enable more cells"
    annotation (Placement(transformation(extent={{-440,-30},{-420,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And disCel "Disable cell"
    annotation (Placement(transformation(extent={{-440,-110},{-420,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-300,150},{-280,170}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer input to real"
    annotation (Placement(transformation(extent={{-440,350},{-420,370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-440,250},{-420,270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false) if not hasWSE
    "Constant false"
    annotation (Placement(transformation(extent={{-460,190},{-440,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Add real inputs"
    annotation (Placement(transformation(extent={{-400,330},{-380,350}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=totChiSta) "Replicate real input"
    annotation (Placement(transformation(extent={{-360,330},{-340,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4[totChiSta](
    final k=staVec) "Stage indicator array"
    annotation (Placement(transformation(extent={{-360,290},{-340,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4[totChiSta](
    final k1=fill(1, totChiSta),
    final k2=fill(-1,totChiSta)) "Sum of real inputs"
    annotation (Placement(transformation(extent={{-320,310},{-300,330}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[totChiSta](
    final threshold=fill(-0.1,totChiSta)) "Check stage indicator"
    annotation (Placement(transformation(extent={{-380,210},{-360,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[totChiSta]
    "Convert boolean input to integer"
    annotation (Placement(transformation(extent={{-340,210},{-320,230}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=totChiSta) "Sun of input vector "
    annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor celOnNum(
    final nin=totChiSta)
    "Number of cells should be enabled at current stage"
    annotation (Placement(transformation(extent={{-340,150},{-320,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5[totChiSta](
    final k=towCelOnSet)
    "Number of enabling cells at each stage"
    annotation (Placement(transformation(extent={{-380,150},{-360,170}})));

  CDL.Continuous.Hysteresis proOn(final uLow=pumSpeChe, final uHigh=2*pumSpeChe)
    "Check if the condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-460,30},{-440,50}})));
equation
  connect(uStaUp, enaCel.u1)
    annotation (Line(points={{-500,-20},{-442,-20}}, color={255,0,255}));
  connect(uTowStaUp, enaCel.u2) annotation (Line(points={{-500,-60},{-460,-60},
          {-460,-28},{-442,-28}}, color={255,0,255}));
  connect(uStaDow, disCel.u1)
    annotation (Line(points={{-500,-100},{-442,-100}}, color={255,0,255}));
  connect(uTowStaDow, disCel.u2) annotation (Line(points={{-500,-140},{-460,
          -140},{-460,-108},{-442,-108}}, color={255,0,255}));
  connect(uChiSta, intToRea.u)
    annotation (Line(points={{-500,380},{-460,380},{-460,360},{-442,360}},
      color={255,127,0}));
  connect(uWseSta, booToRea1.u) annotation (Line(points={{-500,240},{-460,240},
          {-460,260},{-442,260}},color={255,0,255}));
  connect(con2.y, booToRea1.u)
    annotation (Line(points={{-438,200},{-420,200},{-420,228},{-460,228},{-460,
          260},{-442,260}},   color={255,0,255}));
  connect(booToRea1.y, add3.u2)
    annotation (Line(points={{-418,260},{-410,260},{-410,334},{-402,334}},
      color={0,0,127}));
  connect(intToRea.y, add3.u1)
    annotation (Line(points={{-418,360},{-410,360},{-410,346},{-402,346}},
      color={0,0,127}));
  connect(add3.y, reaRep.u)
    annotation (Line(points={{-378,340},{-362,340}}, color={0,0,127}));
  connect(reaRep.y, add4.u1)
    annotation (Line(points={{-338,340},{-330,340},{-330,326},{-322,326}},
      color={0,0,127}));
  connect(con4.y, add4.u2)
    annotation (Line(points={{-338,300},{-330,300},{-330,314},{-322,314}},
      color={0,0,127}));
  connect(greEquThr.y, booToInt.u)
    annotation (Line(points={{-358,220},{-342,220}}, color={255,0,255}));
  connect(add4.y, greEquThr.u)
    annotation (Line(points={{-298,320},{-290,320},{-290,260},{-400,260},{-400,
          220},{-382,220}},   color={0,0,127}));
  connect(con5.y, celOnNum.u)
    annotation (Line(points={{-358,160},{-342,160}}, color={0,0,127}));
  connect(mulSumInt.y, celOnNum.index)
    annotation (Line(points={{-278,220},{-270,220},{-270,190},{-350,190},{-350,
          140},{-330,140},{-330,148}},   color={255,127,0}));
  connect(celOnNum.y, reaToInt.u)
    annotation (Line(points={{-318,160},{-302,160}}, color={0,0,127}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-318,220},{-302,220}},
      color={255,127,0}));

  connect(uConWatPumSpe, proOn.u)
    annotation (Line(points={{-500,40},{-462,40}}, color={0,0,127}));
  connect(proOn.y, conPumOff.u)
    annotation (Line(points={{-438,40},{-422,40}}, color={255,0,255}));
  connect(uLeaConWatPum, leaCel.u) annotation (Line(points={{-500,80},{-430,80},
          {-430,80},{-362,80}}, color={255,0,255}));
  connect(conPumOff.y, leaCel.clr) annotation (Line(points={{-398,40},{-380,40},
          {-380,74},{-362,74}}, color={255,0,255}));
annotation (
  defaultComponentName="enaTowCel",
  Icon(graphics={
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-480,-520},{480,500}}),
        graphics={
          Text(
          extent={{-434,402},{-312,382}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Identify total number of operation cells")}),
  Documentation(info="<html>
<p>
This block outputs vector of enabling tower cells according to current plant stage 
and generates boolean output to indicate if new cells should be enabled or existing
operating cells should be disabled. It is implemented according to 
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), 
section 5.2.12.1,
</p>
<ul>
<li>item 2 which specifies number of enabled cooling tower cells according to
plant stage.
</li>
<li>item 3 and 4, which specifies when the cooling tower cells should be enabled 
disabled.
</li>
</ul>
<p>
The number of enabled tower cells shall be set by chiller stage per the table below.
Note that the table would need to be edited by the system design team for each plant 
based on the condenser water flow per stage, number of towers in the plant, and 
tower minimum flow requirements.
</p>

<table summary=\"summary\" border=\"1\">
<tr>
<th>Chiller stage </th> 
<th>Number of enabled cells </th>  
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
</tr>
<tr>
<td align=\"center\">0+WSE</td>
<td align=\"center\">2</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\">2</td>
</tr>
<tr>
<td align=\"center\">1+WSE</td>
<td align=\"center\">4</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\">4</td>
</tr>
<tr>
<td align=\"center\">2+WSE</td>
<td align=\"center\">4</td>
</tr>
</table>
<br/>

<p>
If there is change of plant stage <code>uChiSta</code> or waterside economizer 
status <code>uWseSta</code>, the cells should be enabled or disabled as below:
</p>
<ul>
<li>
Lead cell(s) shall be enabled when the lead condenser water pump is enabled. Lead
cell(s) shall be disabled when all condenser water pumps are proven off.
</li>
<li>
Tower stage changes shall be initiated concurrently with condenser water pump stage
and/or condenser water pump speed changes. 
</li>
</ul>
<p>
The inputs <code>uTowStaUp</code> and <code>uTowStaDow</code> are outputs from 
the staging process. They indicate in the planting stagin process when to change 
the condenser water pump status so also change the tower status.
</p>

</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableCells_sim;
