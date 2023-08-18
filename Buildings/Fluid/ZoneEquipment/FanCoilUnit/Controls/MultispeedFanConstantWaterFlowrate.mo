within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls;
block MultispeedFanConstantWaterFlowrate
  "Controller for fan coil system with constant water flow rates and variable speed fan"
  parameter Integer nSpe(
    final min=2) = 2
    "Number of fan speeds"
    annotation(Dialog(group="System parameters"));

  parameter Real fanSpe[nSpe](
    final unit="1",
    displayUnit="1") = {0,1}
    "Fan speed values"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tSpe = 180
    "Minimum amount of time for which calculated speed exceeds preset value for speed to be changed"
    annotation(Dialog(group="System parameters"));

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of cooling loop controller"
    annotation (Dialog(group="Fan control parameters - Cooling mode"));

  parameter Real kCoo(
    final unit="1",
    displayUnit="1")=1
    "Gain of cooling loop controller"
    annotation(Dialog(group="Fan control parameters - Cooling mode"));

  parameter Modelica.Units.SI.Time TiCoo=0.5
    "Time constant of cooling loop integrator block"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.Time TdCoo=0.1
    "Time constant of cooling loop derivative block"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of heating loop controller"
    annotation (Dialog(group="Fan control parameters - Heating mode"));

  parameter Real kHea(
    final unit="1",
    displayUnit="1")=1
    "Gain of heating loop controller"
    annotation(Dialog(group="Fan control parameters - Heating mode"));

  parameter Modelica.Units.SI.Time TiHea=0.5
    "Time constant of heating loop integrator block"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.Time TdHea=0.1
    "Time constant of heating loop derivative block"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum running time of the fan"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tValEna = 600
    "Minimum duration for which heating/cooling valve action is enabled"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tValDis = 300
    "Minimum duration for which heating/cooling valve action is disabled"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.2
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  parameter Real dFanSpe(
    final unit="1",
    displayUnit="1") = 0.05
    "Fan speed difference used for cycling fan speed"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Occupancy signal"
    annotation (Placement(transformation(extent={{-180,-160},{-140,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-140},{180,-100}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final unit="1",
    displayUnit="1")
    "Cooling signal"
    annotation (Placement(transformation(extent={{140,60},{180,100}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1",
    displayUnit="1")
    "Heating signal"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
      iconTransformation(extent={{100,0},{140,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Ensure minimum fan speed signal is passed"
    annotation (Placement(transformation(extent={{110,-90},{130,-70}})));

  Buildings.Controls.OBC.CDL.Logical.And andCoo
    "Enable cooling coil valve only when fan is proven on"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Logical.And andHea
    "Enable heating coil valve only when fan is proven on"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on fan"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater gre[nSpe]
    "Check if calculated fan speed signal "
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fanSpeVal[nSpe](
    final k=fanSpe)
    "Fan speed values"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nSpe)
    "Replicate fan speed signal for staging"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSpe]
    "Find integer index based on calculated fan speed"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nSpe)
    "Find fan speed stage"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSpe)
    "Find fan speed value based on calculated stage"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[nSpe](
    final t=fill(tSpe, nSpe))
    "Ensure fan speed signal exceeds preset for a minimum time duration"
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));

  Buildings.Controls.OBC.CDL.Integers.AddParameter addPar(
    final p=1)
    "Add 1 to calculated stage to switch to next speed signal"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCoo(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable cooling when zone temperature is higher than cooling setpoint"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subCoo
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaCoo
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subHea
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysHea(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable heating when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHea
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCoo
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{-4,-170},{16,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDCoo(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "PI controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{-66,-70},{-46,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDHea(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false)
    "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{-66,-110},{-46,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Add addFanSpe
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{-36,-90},{-16,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCooOcc
    "Enable fan in heating mode and cooling mode or when zone is occupied"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Pass non-zero signal only when fan is enabled"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFan
    "Convert Boolean to Real"
    annotation (Placement(transformation(extent={{70,0},{90,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=tFanEna,
    final falseHoldDuration=0)
    "Keep fan enabled for minimum duration"
    annotation (Placement(transformation(extent={{110,-130},{130,-110}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHolCoo(
    final trueHoldDuration=tValEna,
    final falseHoldDuration=tValDis)
    "Ensure cooling is enabled and disabled for minimum time duration"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHolHea(
    final trueHoldDuration=tValEna,
    final falseHoldDuration=tValDis)
    "Ensure heating is enabled and disabled for minimum time duration"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

equation
  connect(TZon, subCoo.u1) annotation (Line(points={{-160,40},{-130,40},{-130,46},
          {-102,46}}, color={0,0,127}));

  connect(TCooSet, subCoo.u2) annotation (Line(points={{-160,0},{-120,0},{-120,34},
          {-102,34}}, color={0,0,127}));

  connect(subCoo.y, hysCoo.u)
    annotation (Line(points={{-78,40},{-42,40}}, color={0,0,127}));

  connect(booToReaCoo.y, yCoo)
    annotation (Line(points={{122,80},{160,80}}, color={0,0,127}));

  connect(subHea.y, hysHea.u) annotation (Line(points={{-78,-30},{-74,-30},{-74,
          10},{-42,10}}, color={0,0,127}));

  connect(TZon, subHea.u2) annotation (Line(points={{-160,40},{-130,40},{-130,-36},
          {-102,-36}}, color={0,0,127}));

  connect(THeaSet, subHea.u1) annotation (Line(points={{-160,-40},{-110,-40},{-110,
          -24},{-102,-24}}, color={0,0,127}));

  connect(booToReaHea.y, yHea)
    annotation (Line(points={{122,50},{160,50}}, color={0,0,127}));

  connect(hysCoo.y, orHeaCoo.u1) annotation (Line(points={{-18,40},{-10,40},{-10,
          -160},{-6,-160}}, color={255,0,255}));

  connect(hysHea.y, orHeaCoo.u2) annotation (Line(points={{-18,10},{-14,10},{-14,
          -168},{-6,-168}}, color={255,0,255}));

  connect(subCoo.y, conPIDCoo.u_m) annotation (Line(points={{-78,40},{-72,40},{-72,
          -82},{-56,-82},{-56,-72}}, color={0,0,127}));

  connect(subHea.y, conPIDHea.u_m) annotation (Line(points={{-78,-30},{-74,-30},
          {-74,-120},{-56,-120},{-56,-112}}, color={0,0,127}));

  connect(con.y, conPIDCoo.u_s) annotation (Line(points={{-78,-80},{-76,-80},{-76,
          -60},{-68,-60}}, color={0,0,127}));

  connect(con.y, conPIDHea.u_s) annotation (Line(points={{-78,-80},{-76,-80},{-76,
          -100},{-68,-100}}, color={0,0,127}));

  connect(conPIDCoo.y, addFanSpe.u1) annotation (Line(points={{-44,-60},{-40,-60},
          {-40,-74},{-38,-74}}, color={0,0,127}));

  connect(conPIDHea.y, addFanSpe.u2) annotation (Line(points={{-44,-100},{-40,-100},
          {-40,-86},{-38,-86}}, color={0,0,127}));

  connect(gre.u1, reaScaRep.y)
    annotation (Line(points={{58,-30},{52,-30}}, color={0,0,127}));
  connect(fanSpeVal.y, gre.u2) annotation (Line(points={{42,-60},{54,-60},{54,-38},
          {58,-38}}, color={0,0,127}));
  connect(booToInt.y, mulSumInt.u[1:nSpe]) annotation (Line(points={{22,-90},{28,
          -90}},                                          color={255,127,0}));
  connect(fanSpeVal.y, extIndSig.u) annotation (Line(points={{42,-60},{68,-60}},
                             color={0,0,127}));
  connect(gre.y, tim.u)
    annotation (Line(points={{82,-30},{88,-30}}, color={255,0,255}));
  connect(tim.passed, booToInt.u) annotation (Line(points={{112,-38},{120,-38},{
          120,-44},{-4,-44},{-4,-90},{-2,-90}}, color={255,0,255}));
  connect(mulSumInt.y, addPar.u)
    annotation (Line(points={{52,-90},{58,-90}}, color={255,127,0}));
  connect(addPar.y, extIndSig.index) annotation (Line(points={{82,-90},{90,-90},
          {90,-76},{80,-76},{80,-72}},     color={255,127,0}));
  connect(orHeaCoo.y, timFan.u) annotation (Line(points={{18,-160},{38,-160}},
                            color={255,0,255}));
  connect(timFan.passed, orHeaCooOcc.u2) annotation (Line(points={{62,-168},{72,
          -168},{72,-128},{78,-128}}, color={255,0,255}));
  connect(mul.y, reaScaRep.u)
    annotation (Line(points={{22,-30},{28,-30}}, color={0,0,127}));
  connect(addFanSpe.y, mul.u2) annotation (Line(points={{-14,-80},{-6,-80},{-6,-36},
          {-2,-36}}, color={0,0,127}));
  connect(booToReaFan.y, mul.u1) annotation (Line(points={{92,10},{100,10},{100,
          -10},{-6,-10},{-6,-24},{-2,-24}}, color={0,0,127}));
  connect(orHeaCooOcc.y, truFalHol.u)
    annotation (Line(points={{102,-120},{108,-120}}, color={255,0,255}));
  connect(truFalHol.y, yFan) annotation (Line(points={{132,-120},{160,-120}},
                             color={255,0,255}));
  connect(truFalHol.y, booToReaFan.u) annotation (Line(points={{132,-120},{136,-120},
          {136,30},{60,30},{60,10},{68,10}}, color={255,0,255}));
  connect(uFan, andCoo.u1)
    annotation (Line(points={{-160,80},{18,80}}, color={255,0,255}));
  connect(uFan, andHea.u1) annotation (Line(points={{-160,80},{10,80},{10,50},{18,
          50}}, color={255,0,255}));
  connect(hysCoo.y, andCoo.u2) annotation (Line(points={{-18,40},{0,40},{0,72},{
          18,72}}, color={255,0,255}));
  connect(hysHea.y, andHea.u2) annotation (Line(points={{-18,10},{10,10},{10,42},
          {18,42}}, color={255,0,255}));
  connect(uOcc, orHeaCooOcc.u1) annotation (Line(points={{-160,-140},{30,-140},{
          30,-120},{78,-120}}, color={255,0,255}));
  connect(yFanSpe, max.y)
    annotation (Line(points={{160,-80},{132,-80}}, color={0,0,127}));
  connect(extIndSig.y, max.u2) annotation (Line(points={{92,-60},{100,-60},{100,
          -86},{108,-86}}, color={0,0,127}));
  connect(fanSpeVal[1].y, max.u1) annotation (Line(points={{42,-60},{54,-60},{54,
          -74},{108,-74}}, color={0,0,127}));
  connect(andCoo.y, truFalHolCoo.u)
    annotation (Line(points={{42,80},{58,80}}, color={255,0,255}));
  connect(truFalHolCoo.y, booToReaCoo.u)
    annotation (Line(points={{82,80},{98,80}}, color={255,0,255}));
  connect(andHea.y, truFalHolHea.u)
    annotation (Line(points={{42,50},{58,50}}, color={255,0,255}));
  connect(truFalHolHea.y, booToReaHea.u)
    annotation (Line(points={{82,50},{98,50}}, color={255,0,255}));
  annotation (defaultComponentName="conMulSpeFanConWat",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                      graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{100,140}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-200},{140,100}})),
    Documentation(info="<html>
      <p>
      This is a control module for the fan coil unit (FCU) system model designed as an 
      analogue to the <code>MultiSpeedFan</code> capacity control method 
      in EnergyPlus. The control logic is as described in the following section 
      and can also be seen in the logic chart.
      <br>
      <ul>
      <li>
      When the zone temperature <code>TZon</code> is above the cooling setpoint
      temperature <code>TCooSet</code>, the FCU enters cooling mode operation.
      The fan is enabled (<code>yFan = True</code>). The cooling loop signal 
      <code>conPIDCoo.y</code> is then compared with the speed limits defined in <code>fanSpe</code> 
      to determine the fan speed <code>yFanSpe</code>. The cooling coil valve signal 
      <code>yCoo</code> is set to fully open.
      </li>
      <li>
      When <code>TZon</code> is below the heating setpoint temperature <code>THeaSet</code>, 
      the FCU enters heating mode operation. The fan is enabled (<code>yFan = True</code>). 
      The heating loop signal <code>conPIDHea.y</code> is then compared with <code>fanSpe</code> 
      to determine <code>yFanSpe</code>. The heating coil valve signal <code>yHea</code> 
      is set to fully open.
      </li>
      <li>
      When the zone temperature <code>TZon</code> is between <code>THeaSet</code>
      and <code>TCooSet</code>, the FCU enters deadband mode. If the zone is occupied 
      as per the occupancy schedule (<code>conVarWatConFan.timTabOccSch.y = 1</code>),
      the fan is enabled (<code>yFan = True</code>) and is run at the minimum speed
      (<code>yFanSpe = minFanSpe</code>). <code>yHea</code> and <code>yCoo</code> are set 
      to <code>zero</code>.
      </li>
      </ul>
      <p align=\"center\">
      <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/FanCoilUnit/Controls/constantFlowrateMultispeedFan.png\"/>
      </p>
      </html>
      ", revisions="<html>
      <ul>
      <li>
      August 03, 2022 by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end MultispeedFanConstantWaterFlowrate;
