within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences;
block LessCoupled
  "Sequence of defining cooling tower fan speed when the plant is not close coupled"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Integer nConWatPum = 2 "Total number of condenser water pumps";
  parameter Modelica.SIunits.TemperatureDifference desTemDif = 8
    "Design condenser water temperature difference";
  parameter Real pumSpeChe = 0.005
    "Lower threshold value to check if condenser water pump is proven on";
  parameter Real fanSpeMin = 0.1
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
    annotation (Placement(transformation(extent={{-140,130},{-100,170}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput plrTowMaxSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower maximum speed that reset based on plant partial load ratio"
    annotation (Placement(transformation(extent={{-140,-200},{-100,-160}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{100,130},{140,170}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{100,-150},{140,-110}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Line supTemSet
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID1(
    final controllerType=supWatCon,
    final k=kSupCon,
    final Ti=TiSupCon,
    final Td=TdSupCon,
    final yMax=ySupConMax,
    final yMin=ySupConMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=ySupConMin) "Condenser water supply temperature controller"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-2*5/9, final k=1)
    "Condenser water return temperature setpoint minus 2 degF"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-desTemDif, final k=1)
    "Condenser water return temperature setpoint minus design condenser water temperature difference"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis proOn[nConWatPum](
    final uLow=fill(pumSpeChe, nConWatPum),
    final uHigh=fill(pumSpeChe + 0.005,  nConWatPum))
    "Check if the condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyProOn(final nu=nConWatPum)
    "Check if there is any condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=retWatCon,
    final k=kRetCon,
    final Ti=TiRetCon,
    final Td=TdRetCon,
    final yMax=yRetConMax,
    final yMin=yRetConMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=0.5)  "Condenser water return temperature controller"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant  minTowSpe(
    final k=fanSpeMin) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one1(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line CWSTSpd
    "Fan speed calculated based on supply water temperature control"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin maxSpe(final nin=2)
    "Lowest value of the maximum cooling tower speed from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin fanSpe(final nin=3)
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one2[nChi](
    final k=fill(1,nChi)) "Constant one"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));

equation
  connect(proOn.y,anyProOn. u)
    annotation (Line(points={{-58,60},{-42,60}}, color={255,0,255}));
  connect(TConWatRetSet, conPID.u_s)
    annotation (Line(points={{-120,150},{-62,150}}, color={0,0,127}));
  connect(TConWatRet, conPID.u_m)
    annotation (Line(points={{-120,120},{-50,120},{-50,138}}, color={0,0,127}));
  connect(TConWatRetSet, addPar1.u)
    annotation (Line(points={{-120,150},{-80,150},{-80,100},{-22,100}},
      color={0,0,127}));
  connect(zer.y, supTemSet.x1)
    annotation (Line(points={{22,180},{40,180},{40,158},{58,158}},
      color={0,0,127}));
  connect(TConWatRetSet, addPar.u)
    annotation (Line(points={{-120,150},{-80,150},{-80,180},{-62,180}},
      color={0,0,127}));
  connect(addPar.y, supTemSet.f1)
    annotation (Line(points={{-38,180},{-20,180},{-20,154},{58,154}},
      color={0,0,127}));
  connect(conPID.y, supTemSet.u)
    annotation (Line(points={{-38,150},{58,150}}, color={0,0,127}));
  connect(one.y, supTemSet.x2)
    annotation (Line(points={{2,130},{20,130},{20,146},{58,146}},
      color={0,0,127}));
  connect(addPar1.y, supTemSet.f2)
    annotation (Line(points={{2,100},{40,100},{40,142},{58,142}}, color={0,0,127}));
  connect(uConWatPumSpe, proOn.u)
    annotation (Line(points={{-120,60},{-82,60}}, color={0,0,127}));
  connect(supTemSet.y, conPID1.u_s)
    annotation (Line(points={{82,150},{90,150},{90,30},{-80,30},{-80,-20},{-62,-20}},
      color={0,0,127}));
  connect(zer1.y, CWSTSpd.x1)
    annotation (Line(points={{22,10},{40,10},{40,-12},{58,-12}}, color={0,0,127}));
  connect(minTowSpe.y, CWSTSpd.f1)
    annotation (Line(points={{-38,10},{-20,10},{-20,-16},{58,-16}},
      color={0,0,127}));
  connect(conPID1.y, CWSTSpd.u)
    annotation (Line(points={{-38,-20},{58,-20}}, color={0,0,127}));
  connect(TConWatSup, conPID1.u_m)
    annotation (Line(points={{-120,-50},{-50,-50},{-50,-32}},
      color={0,0,127}));
  connect(one1.y, CWSTSpd.x2)
    annotation (Line(points={{2,-40},{20,-40},{20,-24},{58,-24}}, color={0,0,127}));
  connect(one1.y, CWSTSpd.f2)
    annotation (Line(points={{2,-40},{20,-40},{20,-28},{58,-28}}, color={0,0,127}));
  connect(CWSTSpd.y, fanSpe.u[1])
    annotation (Line(points={{82,-20},{90,-20},{90,-50},{10,-50},{10,-108.667},
          {18,-108.667}},
                      color={0,0,127}));
  connect(maxSpe.y, fanSpe.u[2])
    annotation (Line(points={{2,-110},{18,-110}},   color={0,0,127}));
  connect(plrTowMaxSpe, fanSpe.u[3])
    annotation (Line(points={{-120,-180},{10,-180},{10,-111.333},{18,-111.333}},
      color={0,0,127}));
  connect(supTemSet.y, TConWatSupSet)
    annotation (Line(points={{82,150},{120,150}}, color={0,0,127}));
  connect(anyProOn.y, conPID.trigger)
    annotation (Line(points={{-18,60},{0,60},{0,80},{-58,80},{-58,138}},
      color={255,0,255}));
  connect(anyProOn.y, conPID1.trigger)
    annotation (Line(points={{-18,60},{0,60},{0,40},{-90,40},{-90,-40},{-58,-40},
       {-58,-32}}, color={255,0,255}));
  connect(fanSpe.y, swi.u1)
    annotation (Line(points={{42,-110},{50,-110},{50,-122},{58,-122}},
      color={0,0,127}));
  connect(anyProOn.y, swi.u2)
    annotation (Line(points={{-18,60},{0,60},{0,40},{-90,40},{-90,-130},{58,-130}},
      color={255,0,255}));
  connect(zer2.y, swi.u3)
    annotation (Line(points={{42,-150},{50,-150},{50,-138},{58,-138}},color={0,0,127}));
  connect(swi1.y, maxSpe.u)
    annotation (Line(points={{-38,-110},{-30,-110},{-30,-110},{-22,-110}},
      color={0,0,127}));
  connect(uChi, swi1.u2)
    annotation (Line(points={{-120,-110},{-62,-110}}, color={255,0,255}));
  connect(uMaxTowSpeSet, swi1.u1)
    annotation (Line(points={{-120,-80},{-70,-80},{-70,-102},{-62,-102}},
      color={0,0,127}));
  connect(one2.y, swi1.u3)
    annotation (Line(points={{-78,-150},{-70,-150},{-70,-118},{-62,-118}},
      color={0,0,127}));
  connect(swi.y,yFanSpe)
    annotation (Line(points={{82,-130},{120,-130}}, color={0,0,127}));

annotation (
  defaultComponentName="lesCouTowSpe",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}})),
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
variable tower speed. Reset the tower speed from minimum tower speed <code>fanSpeMin</code>
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
