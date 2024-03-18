within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Subsequences;
block IntegratedOperation
  "Tower fan speed control when the waterside economizer is enabled and the chillers are running"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Real chiMinCap[nChi](
    each final unit="W",
    final quantity=fill("HeatFlowRate", nChi))={1e4, 1e4}
    "Minimum cyclining load below which chiller will begin cycling";
  parameter Real fanSpeMin = 0.1 "Minimum cooling tower fan speed";
  parameter Real fanSpeMax = 1 "Maximum cooling tower fan speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController conTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Load controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Load controller"));
  parameter Real Ti(final quantity="Time", final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Load controller",
                       enable=conTyp==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                              conTyp==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(final quantity="Time", final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Load controller",
                       enable=conTyp==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                              conTyp==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax=1 "Upper limit of load controller output"
    annotation (Dialog(group="Load controller"));
  parameter Real yMin=0 "Lower limit of load controller output"
    annotation (Dialog(group="Load controller"));
  parameter Real intModTim(final quantity="Time", final unit="s")=600
    "Threshold time after switching from WSE-only mode to integrated mode"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chillers proven on status: true=ON"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiLoa[nChi](
    final unit=fill("W", nChi),
    final quantity=fill("HeatFlowRate", nChi)) "Current load of each chiller"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse
    "Waterside economizer enabling status: true=ON"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1")
    "Tower fan speed setpoint when WSE is enabled and there is any chiller running"
    annotation (Placement(transformation(extent={{160,-100},{200,-60}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Switch fanSpe
    "Switch from the holding maximum speed to regulated speed"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiMinCycLoa[nChi](
    final k=chiMinCap)
    "Minimum cycling load of each chiller"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer[nChi](
    final k=fill(0, nChi)) "Zero constant"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset loaCon(
    final controllerType=conTyp,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final reverseActing=false,
    final y_reset=yMax)
    "Controller to maintain chiller load at the sum of minimum cycling load of operating chillers"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totMinCycLoa(
    final k=fill(1.1, nChi),
    final nin=nChi)
    "Sum of minimum cycling load for the operating chillers"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum totLoa(
    final nin=nChi) "Total load of operating chillers"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum minCycLoa(final nin=nChi)
    "Sum of minimum cycling load for all chillers"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div "Output first input divided by second input"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1 "Output first input divided by second input"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr chiOn(final nin=nChi)
    "Check if there is any chiller running"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Line regFanSpe "Regulated fan speed"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1(
    final k=yMin) "Load control minimum limit"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=yMax)
    "Load control maximum limit"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTowSpe(
    final k=fanSpeMin)
    "Minimum speed"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxTowSpe(
    final k=fanSpeMax)
    "Maximum tower fan speed"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "Output true at the moment when input becomes true"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if it switches from WSE only mode to integrated operation mode"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer intOpeTim(
    final t=intModTim)
    "Count the time after plant switching from WSE-only mode to integrated operation mode"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Output true when input becomes false"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Breaks algebraic loops by an infinitesimal small time delay"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

equation
  connect(uChi, swi.u2)
    annotation (Line(points={{-180,100},{-62,100}}, color={255,0,255}));
  connect(chiMinCycLoa.y, swi.u1)
    annotation (Line(points={{-98,140},{-80,140},{-80,108},{-62,108}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-98,80},{-80,80},{-80,92},{-62,92}}, color={0,0,127}));
  connect(minCycLoa.y, div.u2)
    annotation (Line(points={{2,140},{20,140},{20,94},{38,94}}, color={0,0,127}));
  connect(minCycLoa.y, div1.u2)
    annotation (Line(points={{2,140},{20,140},{20,54},{38,54}}, color={0,0,127}));
  connect(totLoa.y, div1.u1)
    annotation (Line(points={{2,60},{10,60},{10,66},{38,66}}, color={0,0,127}));
  connect(totMinCycLoa.y, div.u1)
    annotation (Line(points={{2,100},{10,100},{10,106},{38,106}}, color={0,0,127}));
  connect(div.y, loaCon.u_s)
    annotation (Line(points={{62,100},{78,100}}, color={0,0,127}));
  connect(div1.y, loaCon.u_m)
    annotation (Line(points={{62,60},{90,60},{90,88}}, color={0,0,127}));
  connect(loaCon.y, regFanSpe.u) annotation (Line(points={{102,100},{120,100},{120,
          0},{40,0},{40,-40},{58,-40}}, color={0,0,127}));
  connect(zer1.y, regFanSpe.x1) annotation (Line(points={{22,-20},{30,-20},{30,-32},
          {58,-32}}, color={0,0,127}));
  connect(minTowSpe.y, regFanSpe.f1) annotation (Line(points={{-18,-20},{-10,-20},
          {-10,-36},{58,-36}}, color={0,0,127}));
  connect(maxTowSpe.y, regFanSpe.f2) annotation (Line(points={{22,-60},{30,-60},
          {30,-48},{58,-48}}, color={0,0,127}));
  connect(one.y, regFanSpe.x2) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -44},{58,-44}}, color={0,0,127}));
  connect(chiOn.y, edg.u)
    annotation (Line(points={{-98,20},{-90,20},{-90,-140},{-62,-140}}, color={255,0,255}));
  connect(uWse, and1.u1)
    annotation (Line(points={{-180,0},{-70,0},{-70,-110},{-2,-110}}, color={255,0,255}));
  connect(edg.y, and1.u2)
    annotation (Line(points={{-38,-140},{-20,-140},{-20,-118},{-2,-118}}, color={255,0,255}));
  connect(and1.y, lat.u)
    annotation (Line(points={{22,-110},{38,-110}}, color={255,0,255}));
  connect(lat.y, intOpeTim.u)
    annotation (Line(points={{62,-110},{78,-110}}, color={255,0,255}));
  connect(lat.y, fanSpe.u2)
    annotation (Line(points={{62,-110},{70,-110},{70,-80},{118,-80}}, color={255,0,255}));
  connect(regFanSpe.y, fanSpe.u3)
    annotation (Line(points={{82,-40},{100,-40},{100,-88},{118,-88}}, color={0,0,127}));
  connect(maxTowSpe.y, fanSpe.u1)
    annotation (Line(points={{22,-60},{30,-60},{30,-72},{118,-72}}, color={0,0,127}));
  connect(fanSpe.y,ySpeSet)
    annotation (Line(points={{142,-80},{180,-80}}, color={0,0,127}));
  connect(chiMinCycLoa.y, minCycLoa.u)
    annotation (Line(points={{-98,140},{-22,140}}, color={0,0,127}));
  connect(swi.y, totMinCycLoa.u)
    annotation (Line(points={{-38,100},{-22,100}}, color={0,0,127}));
  connect(chiLoa, totLoa.u)
    annotation (Line(points={{-180,60},{-22,60}},  color={0,0,127}));
  connect(uChi,chiOn. u)
    annotation (Line(points={{-180,100},{-140,100},{-140,20},{-122,20}},
      color={255,0,255}));
  connect(lat.y, falEdg.u)
    annotation (Line(points={{62,-110},{70,-110},{70,-80},{-140,-80},{-140,-60},
      {-122,-60}}, color={255,0,255}));
  connect(chiOn.y, and3.u1)
    annotation (Line(points={{-98,20},{-62,20}}, color={255,0,255}));
  connect(falEdg.y, and3.u2)
    annotation (Line(points={{-98,-60},{-80,-60},{-80,12},{-62,12}},
      color={255,0,255}));
  connect(pre.y, lat.clr)
    annotation (Line(points={{22,-140},{30,-140},{30,-116},{38,-116}},
      color={255,0,255}));
  connect(intOpeTim.passed, pre.u)
    annotation (Line(points={{102,-118},{120,-118},{120,-154},{-10,-154},
      {-10,-140},{-2,-140}}, color={255,0,255}));
  connect(and3.y, and2.u1)
    annotation (Line(points={{-38,20},{-2,20}}, color={255,0,255}));
  connect(uWse, and2.u2)
    annotation (Line(points={{-180,0},{-20,0},{-20,12},{-2,12}}, color={255,0,255}));
  connect(and2.y, loaCon.trigger)
    annotation (Line(points={{22,20},{84,20},{84,88}}, color={255,0,255}));
annotation (
  defaultComponentName="wseTowSpeIntOpe",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-40,10},{40,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,80},{20,80},{0,10},{-20,80}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-10},{-20,-80},{20,-80},{0,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-40},{80,-46}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-56},{80,-68}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,-46},{48,-56}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,-46},{76,-56}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-80},{76,-94}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{76,-78},{78,-96}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,-78},{80,-96}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-160},{160,160}})),
Documentation(info="<html>
<p>
Block that outputs cooling tower fan speed <code>ySpeSet</code> when both waterside 
economizer and chillers are enabled, i.e. integrated operation. This is implemented 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II – 
Central Plants and Hydronic Systems (Draft on March 23, 2020), section 5.2.12.2, 
item 4.a.
</p>
<p>
When the waterside economizer is enabled (<code>uWse=true</code>) and chillers
are running (<code>uChi=true</code>):
</p>
<ol>
<li>
Fan speed shall be equal to waterside economizer tower maximum speed.
</li>
<li>
The waterside economizer tower maximum speed shall be reset by a direct acting PID
loop maintaining the chiller load at 110% of the sum of minimum cycling load for
the operating chillers. Map the tower maximum speed from minimum speed
<code>fanSpeMin</code> at 0% loop output to 100% speed at 100% loop output.
Bias the loop to launch from 100% output.
</li>
<li>
When starting integrated operation after previously operating with only the waterside
economizer, hold the tower maximum speed at 100% for 10 minutes (<code>intModTim</code>) 
to give the chiller time to get up to speed and produce at least minimum cycling 
load, then enable the loop.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 9, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IntegratedOperation;
