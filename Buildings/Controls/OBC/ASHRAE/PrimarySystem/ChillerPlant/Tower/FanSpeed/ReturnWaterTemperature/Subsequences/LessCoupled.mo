within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences;
block LessCoupled
  "Sequence of defining cooling tower fan speed when the plant is not close coupled"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Integer nConWatPum = 2 "Total number of condenser water pumps";
  parameter Modelica.SIunits.TemperatureDifference desTemDif = 8
    "Design condenser water temperature difference";
  parameter Real pumSpeChe = 0.005
    "Lower threshold value to check if condenser water pump is proven on";
  parameter Real minSpe = 0.1
    "Minimum cooling tower fan speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController retWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Real kRetCon=1 "Gain of controller"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Modelica.SIunits.Time TiRetCon=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Modelica.SIunits.Time TdRetCon=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Return water temperature controller", enable=
          retWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          retWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yRetConMax=1 "Upper limit of output"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Real yRetConMin=0 "Lower limit of output"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Real kSupCon=1 "Gain of controller"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Modelica.SIunits.Time TiSupCon=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Modelica.SIunits.Time TdSupCon=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Supply water temperature controller", enable=
          supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(group="Supply water temperature controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRetSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-140,110},{-100,150}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput plrTowMaxSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower maximum speed that reset based on plant partial load ratio"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{100,110},{140,150}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{100,-160},{140,-120}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-2*5/9, final k=1)
    "Condenser water return temperature setpoint minus 2 degF"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-desTemDif, final k=1)
    "Condenser water return temperature setpoint minus design condenser water temperature difference"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis proOn[nConWatPum](
    final uLow=fill(pumSpeChe, nConWatPum),
    final uHigh=fill(pumSpeChe + 0.005,  nConWatPum))
    "Check if the condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyProOn(final nu=nConWatPum)
    "Check if there is any condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=retWatCon,
    final k=kRetCon,
    final Ti=TiRetCon,
    final Td=TdRetCon,
    final yMax=yRetConMax,
    final yMin=yRetConMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=0.5)  "Condenser water return temperature controller"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Line supTemSet
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID1(
    final controllerType=supWatCon,
    final k=kSupCon,
    final Ti=TiSupCon,
    final Td=TdSupCon,
    final yMax=ySupConMax,
    final yMin=ySupConMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=ySupConMin) "Condenser water supply temperature controller"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant  minTowSpe(
    final k=minSpe) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one1(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Line CWSTSpd
    "Fan speed calculated based on supply water temperature control"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin maxSpe(final nin=nChi)
    "Lowest value of the maximum cooling tower speed from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin fanSpe(final nin=3)
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));

equation
  connect(proOn.y,anyProOn. u)
    annotation (Line(points={{-58,40},{-42,40}}, color={255,0,255}));
  connect(TConWatRetSet, conPID.u_s)
    annotation (Line(points={{-120,130},{-62,130}}, color={0,0,127}));
  connect(TConWatRet, conPID.u_m)
    annotation (Line(points={{-120,100},{-50,100},{-50,118}}, color={0,0,127}));
  connect(TConWatRetSet, addPar1.u)
    annotation (Line(points={{-120,130},{-80,130},{-80,80},{-22,80}},
      color={0,0,127}));
  connect(zer.y, supTemSet.x1)
    annotation (Line(points={{22,160},{40,160},{40,138},{58,138}},
      color={0,0,127}));
  connect(TConWatRetSet, addPar.u)
    annotation (Line(points={{-120,130},{-80,130},{-80,160},{-62,160}},
      color={0,0,127}));
  connect(addPar.y, supTemSet.f1)
    annotation (Line(points={{-38,160},{-20,160},{-20,134},{58,134}},
      color={0,0,127}));
  connect(conPID.y, supTemSet.u)
    annotation (Line(points={{-38,130},{58,130}}, color={0,0,127}));
  connect(one.y, supTemSet.x2)
    annotation (Line(points={{2,110},{20,110},{20,126},{58,126}},
      color={0,0,127}));
  connect(addPar1.y, supTemSet.f2)
    annotation (Line(points={{2,80},{40,80},{40,122},{58,122}}, color={0,0,127}));
  connect(uConWatPumSpe, proOn.u)
    annotation (Line(points={{-120,40},{-82,40}}, color={0,0,127}));
  connect(supTemSet.y, conPID1.u_s)
    annotation (Line(points={{82,130},{90,130},{90,10},{-80,10},{-80,-40},{-62,-40}},
      color={0,0,127}));
  connect(zer1.y, CWSTSpd.x1)
    annotation (Line(points={{22,-10},{40,-10},{40,-32},{58,-32}}, color={0,0,127}));
  connect(minTowSpe.y, CWSTSpd.f1)
    annotation (Line(points={{-38,-10},{-20,-10},{-20,-36},{58,-36}},
      color={0,0,127}));
  connect(conPID1.y, CWSTSpd.u)
    annotation (Line(points={{-38,-40},{58,-40}}, color={0,0,127}));
  connect(TConWatSup, conPID1.u_m)
    annotation (Line(points={{-120,-70},{-50,-70},{-50,-52}},
      color={0,0,127}));
  connect(one1.y, CWSTSpd.x2)
    annotation (Line(points={{2,-60},{20,-60},{20,-44},{58,-44}}, color={0,0,127}));
  connect(one1.y, CWSTSpd.f2)
    annotation (Line(points={{2,-60},{20,-60},{20,-48},{58,-48}}, color={0,0,127}));
  connect(uMaxTowSpeSet,maxSpe. u)
    annotation (Line(points={{-120,-100},{-82,-100}}, color={0,0,127}));
  connect(CWSTSpd.y, fanSpe.u[1])
    annotation (Line(points={{82,-40},{90,-40},{90,-70},{10,-70},{10,-98.6667},
          {18,-98.6667}},
                      color={0,0,127}));
  connect(maxSpe.y, fanSpe.u[2])
    annotation (Line(points={{-58,-100},{18,-100}}, color={0,0,127}));
  connect(plrTowMaxSpe, fanSpe.u[3])
    annotation (Line(points={{-120,-130},{-20,-130},{-20,-101.333},{18,-101.333}},
      color={0,0,127}));
  connect(supTemSet.y, TConWatSupSet)
    annotation (Line(points={{82,130},{120,130}}, color={0,0,127}));
  connect(swi.y, yTowSpe)
    annotation (Line(points={{82,-140},{120,-140}}, color={0,0,127}));
  connect(anyProOn.y, conPID.trigger)
    annotation (Line(points={{-18,40},{0,40},{0,60},{-58,60},{-58,118}},
      color={255,0,255}));
  connect(anyProOn.y, conPID1.trigger)
    annotation (Line(points={{-18,40},{0,40},{0,20},{-90,20},{-90,-60},{-58,-60},
      {-58,-52}}, color={255,0,255}));
  connect(fanSpe.y, swi.u1)
    annotation (Line(points={{42,-100},{50,-100},{50,-132},{58,-132}},
      color={0,0,127}));
  connect(anyProOn.y, swi.u2)
    annotation (Line(points={{-18,40},{0,40},{0,20},{-90,20},{-90,-140},{58,-140}},
      color={255,0,255}));
  connect(zer2.y, swi.u3)
    annotation (Line(points={{2,-160},{40,-160},{40,-148},{58,-148}}, color={0,0,127}));

annotation (
  defaultComponentName="lesCouTowSpe",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,180}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
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
Block that outputs cooling tower fan speed <code>yTowSpe</code> based on the control
of condenser water return temperature for the plant that is not closed coupled. 
This is implemented according to ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 6 on July 25, 
2019), section 5.2.12.2, item 2.g-i.
</p>
<ul>
<li>
When any condenser water pump is proven on (<code>uConWatPumSpe</code> &gt; 0), 
condenser water supply temperature setpoint <code>TConWatSupSet</code> shall be reset
by a slow acting PID loop maintaining condenser water return temperature 
<code>TConWatRet</code> at setpoint <code>TConWatRetSet</code>. Reset <code>TConWatSupSet</code>
from <code>TConWatRetSet</code> minus 2 &deg;F at 0% loop output to <code>TConWatRetSet</code>
minus design condenser water temperature difference <code>desTemDif</code> at 
100% loop output. Bias loop to launch from 50% output.
</li>
<li>
When any condenser water pump is proven on (<code>uConWatPumSpe</code> &gt; 0),
condenser water supply temperature <code>TConWatSup</code> shall be maintained at
setpoint by a direct acting PID loop. The loop output shall be mapped to the 
variable tower speed. Reset the tower speed from minimum tower speed <code>minSpe</code>
at 0% loop output to 100% speed at 100% loop output.
</li>
<li>
Tower speed <code>yTowSpe</code> shall be the lowest value of tower speed
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
