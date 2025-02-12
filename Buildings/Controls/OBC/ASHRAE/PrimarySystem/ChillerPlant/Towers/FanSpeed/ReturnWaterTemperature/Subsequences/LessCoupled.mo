within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences;
block LessCoupled
  "Sequence of defining cooling tower fan speed when the plant is not close coupled"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Integer nConWatPum = 2 "Total number of condenser water pumps";
  parameter Real pumSpeChe = 0.01
    "Lower threshold value to check if condenser water pump is proven on";
  parameter Real fanSpeMin(
     final unit="1",
     final min=0,
     final max=1)= 0.1
    "Minimum cooling tower fan speed";

  parameter Real samplePeriod(
    final quantity="Time",
    final unit="s",
    final max=30) = 30
    "Period of sampling condenser water supply and return temperature difference"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Real iniPlaTim(
    final quantity="Time",
    final unit="s") = 300
    "Threshold time to hold the initial temperature difference at the plant initial stage"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Real TConWatSup_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi)) = {293.15, 293.15}
    "Design condenser water supply temperature (condenser entering) of each chiller"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Real TConWatRet_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi)) = {303.15, 303.15}
    "Design condenser water return temperature (condenser leaving) of each chiller"
    annotation (Dialog(group="Return water temperature controller"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Supply water temperature controller"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Real kSupCon=1 "Gain of controller"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Real TiSupCon(
    final quantity="Time",
    final unit="s")=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Real TdSupCon(
    final quantity="Time",
    final unit="s")=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Supply water temperature controller", enable=
          supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(group="Supply water temperature controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRetSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-220,160},{-180,200}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature (condenser leaving)"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature (condenser entering)"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-220,-110},{-180,-70}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput plrTowMaxSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower maximum speed that reset based on plant partial load ratio"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{160,130},{200,170}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1") "Fan speed setpoint of each cooling tower cell"
    annotation (Placement(transformation(extent={{160,-160},{200,-120}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset supCon(
    final controllerType=supWatCon,
    final k=kSupCon,
    final Ti=TiSupCon,
    final Td=TdSupCon,
    final yMax=ySupConMax,
    final yMin=ySupConMin,
    final reverseActing=false,
    final y_reset=ySupConMin) "Condenser water supply temperature controller"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis proOn[nConWatPum](
    final uLow=fill(pumSpeChe, nConWatPum),
    final uHigh=fill(2*pumSpeChe, nConWatPum))
    "Check if the condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyProOn(
    final nin=nConWatPum)
    "Check if any condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant  minTowSpe(
    final k=fanSpeMin) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1(
    final k=ySupConMin)
    "Zero constant"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one1(
    final k=ySupConMax) "Maximum speed"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Line CWSTSpd
    "Fan speed calculated based on supply water temperature control"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin maxSpe(final nin=nChi)
    "Lowest value of the maximum cooling tower speed from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin fanSpe(final nin=3)
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer2(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one2[nChi](
    final k=fill(1,nChi)) "Constant one"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert chiller status to real number, true becomes 1 and false becomes 0"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter enaDesConWatRet[nChi](
    final k=TConWatRet_nominal)
    "Design condenser water return temperature of the enabled chiller"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter enaDesConWatSup[nChi](
    final k=TConWatSup_nominal)
    "Design condenser water supply temperature of the enabled chiller"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2[nChi]
    "Difference of the design supply and return condenser water temperature"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax(nin=nChi)
    "Difference of the design supply and return condenser water temperature of the enabled chiller"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=iniPlaTim,
    final delayOnInit=true)
    "Count the time after plant being enabled"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch delTem "Temperature difference value"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract meaTemDif
    "Difference of the condenser return and supply water temperature"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage movMea(
    final delta=300)
    "Moving average of the sampled temperature difference"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(
    final samplePeriod=samplePeriod)
    "Sample the temperature difference"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract conWatSupSet
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[nChi](
    final k=fill(0.5, nChi))
    "Gain factor"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));

equation
  connect(proOn.y,anyProOn. u)
    annotation (Line(points={{-118,-20},{-102,-20}}, color={255,0,255}));
  connect(uConWatPumSpe, proOn.u)
    annotation (Line(points={{-200,-20},{-142,-20}}, color={0,0,127}));
  connect(zer1.y, CWSTSpd.x1)
    annotation (Line(points={{62,0},{80,0},{80,-22},{98,-22}}, color={0,0,127}));
  connect(minTowSpe.y, CWSTSpd.f1)
    annotation (Line(points={{2,0},{20,0},{20,-26},{98,-26}},
      color={0,0,127}));
  connect(supCon.y, CWSTSpd.u)
    annotation (Line(points={{2,-30},{98,-30}},   color={0,0,127}));
  connect(TConWatSup, supCon.u_m)
    annotation (Line(points={{-200,-60},{-10,-60},{-10,-42}}, color={0,0,127}));
  connect(one1.y, CWSTSpd.x2)
    annotation (Line(points={{2,-80},{20,-80},{20,-34},{98,-34}}, color={0,0,127}));
  connect(one1.y, CWSTSpd.f2)
    annotation (Line(points={{2,-80},{20,-80},{20,-38},{98,-38}}, color={0,0,127}));
  connect(CWSTSpd.y, fanSpe.u[1])
    annotation (Line(points={{122,-30},{140,-30},{140,-80},{40,-80},{40,
          -120.667},{58,-120.667}},
                          color={0,0,127}));
  connect(maxSpe.y, fanSpe.u[2])
    annotation (Line(points={{22,-120},{58,-120}},color={0,0,127}));
  connect(plrTowMaxSpe, fanSpe.u[3])
    annotation (Line(points={{-200,-180},{40,-180},{40,-119.333},{58,-119.333}},
      color={0,0,127}));
  connect(anyProOn.y, supCon.trigger)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,-50},{-16,-50},{-16,-42}},
                  color={255,0,255}));
  connect(fanSpe.y, swi.u1)
    annotation (Line(points={{82,-120},{100,-120},{100,-132},{118,-132}},
      color={0,0,127}));
  connect(anyProOn.y, swi.u2)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,-140},{118,-140}},
      color={255,0,255}));
  connect(zer2.y, swi.u3)
    annotation (Line(points={{82,-170},{100,-170},{100,-148},{118,-148}},
      color={0,0,127}));
  connect(swi1.y, maxSpe.u)
    annotation (Line(points={{-18,-120},{-2,-120}},
      color={0,0,127}));
  connect(uChi, swi1.u2)
    annotation (Line(points={{-200,-120},{-42,-120}}, color={255,0,255}));
  connect(uMaxTowSpeSet, swi1.u1)
    annotation (Line(points={{-200,-90},{-120,-90},{-120,-112},{-42,-112}},
      color={0,0,127}));
  connect(one2.y, swi1.u3)
    annotation (Line(points={{-138,-150},{-120,-150},{-120,-128},{-42,-128}},
      color={0,0,127}));
  connect(swi.y,ySpeSet)
    annotation (Line(points={{142,-140},{180,-140}},color={0,0,127}));
  connect(uChi, booToRea.u) annotation (Line(points={{-200,-120},{-170,-120},{-170,
          50},{-142,50}}, color={255,0,255}));
  connect(booToRea.y, enaDesConWatRet.u) annotation (Line(points={{-118,50},{-100,
          50},{-100,70},{-82,70}}, color={0,0,127}));
  connect(booToRea.y, enaDesConWatSup.u) annotation (Line(points={{-118,50},{-100,
          50},{-100,30},{-82,30}}, color={0,0,127}));
  connect(enaDesConWatRet.y, sub2.u1) annotation (Line(points={{-58,70},{-50,70},
          {-50,56},{-42,56}}, color={0,0,127}));
  connect(enaDesConWatSup.y, sub2.u2) annotation (Line(points={{-58,30},{-50,30},
          {-50,44},{-42,44}}, color={0,0,127}));
  connect(uPla, truDel.u)
    annotation (Line(points={{-200,100},{-142,100}}, color={255,0,255}));
  connect(multiMax.y, delTem.u3) annotation (Line(points={{42,50},{50,50},{50,92},
          {58,92}}, color={0,0,127}));
  connect(TConWatSup, meaTemDif.u2) annotation (Line(points={{-200,-60},{-160,-60},
          {-160,134},{-142,134}}, color={0,0,127}));
  connect(TConWatRet, meaTemDif.u1) annotation (Line(points={{-200,150},{-160,150},
          {-160,146},{-142,146}}, color={0,0,127}));
  connect(meaTemDif.y, sam.u)
    annotation (Line(points={{-118,140},{-102,140}}, color={0,0,127}));
  connect(sam.y, movMea.u)
    annotation (Line(points={{-78,140},{-62,140}}, color={0,0,127}));
  connect(movMea.y, delTem.u1) annotation (Line(points={{-38,140},{50,140},{50,108},
          {58,108}}, color={0,0,127}));
  connect(conWatSupSet.y, TConWatSupSet)
    annotation (Line(points={{122,150},{180,150}}, color={0,0,127}));
  connect(TConWatRetSet, conWatSupSet.u1) annotation (Line(points={{-200,180},{80,
          180},{80,156},{98,156}}, color={0,0,127}));
  connect(delTem.y, conWatSupSet.u2) annotation (Line(points={{82,100},{90,100},
          {90,144},{98,144}}, color={0,0,127}));
  connect(conWatSupSet.y, supCon.u_s) annotation (Line(points={{122,150},{140,150},
          {140,20},{-40,20},{-40,-30},{-22,-30}}, color={0,0,127}));
  connect(sub2.y, gai.u)
    annotation (Line(points={{-18,50},{-12,50}}, color={0,0,127}));
  connect(gai.y, multiMax.u)
    annotation (Line(points={{12,50},{18,50}}, color={0,0,127}));

  connect(truDel.y, delTem.u2)
    annotation (Line(points={{-118,100},{58,100}}, color={255,0,255}));
annotation (
  defaultComponentName="lesCouTowSpe",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-200},{160,200}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-20,80},{20,80},{0,10},{-20,80}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,10},{40,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-10},{-20,-80},{20,-80},{0,-10}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Block that outputs cooling tower fan speed <code>ySpeSet</code> based on the control
of condenser water return temperature for the plant that is not closed coupled.
This is implemented according to ASHRAE Guideline36-2021, section 5.20.12.2,
item a.8-10.
</p>
<ul>
<li>
When any condenser water pump is proven on (<code>uConWatPumSpe</code> &gt; 0),
condenser water supply temperature setpoint <code>TConWatSupSet</code> shall be
set equal to the condenser water return temperature setpoint <code>TConWatRetSet</code>
minus a temperature difference. The temperature difference is the 5 minute rolling
average of common condenser water return temperature <code>TConWatRet</code> less
condenser water supply temperature <code>TConWatSup</code>, sampled at minimum once
every 30 seconds. When the plant is first enabled, the temperature difference shall
be fixed equal to 50% of the difference between design condenser water supply
(<code>TConWatSup_nominal</code>) and return (<code>TConWatRet_nominal</code>) temperature
of the enabled chiller for 5 minutes (<code>iniPlaTim</code>).
</li>
<li>
When any condenser water pump is proven on (<code>uConWatPumSpe</code> &gt; 0),
condenser water supply temperature <code>TConWatSup</code> shall be maintained at
setpoint by a direct acting PID loop. The loop output shall be mapped to the
variable tower speed. Reset the tower speed from minimum tower speed <code>fanSpeMin</code>
at 0% loop output to 100% speed at 100% loop output.
</li>
<li>
Tower speed <code>ySpeSet</code> shall be the lowest value of tower speed
from loop mapping, maximum cooling tower speed setpoint from each chiller head
pressure control loop <code>uMaxTowSpeSet</code>, and tower maximum speed that reset
based on plant partial load ratio <code>plrTowMaxSpe</code>. All operating fans shall
receive the same speed signal.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 9, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end LessCoupled;
