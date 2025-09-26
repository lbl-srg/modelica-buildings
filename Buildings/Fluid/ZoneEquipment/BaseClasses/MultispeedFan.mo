within Buildings.Fluid.ZoneEquipment.BaseClasses;
block MultispeedFan
  "Controller for multi-speed fan"

  parameter Boolean has_hea
    "The zonal HVAC system has a heating coil";

  parameter Boolean has_coo
    "The zonal HVAC system has a cooling coil";

  parameter Integer nSpe(
    final min=2)
    "Number of fan speeds"
    annotation(Dialog(group="System parameters"));

  parameter Real fanSpe[nSpe](
    final min=fill(0, nSpe),
    final max=fill(1, nSpe),
    final unit=fill("1", nSpe),
    displayUnit=fill("1", nSpe))
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

  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.2
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput heaCooOpe
    "Heating/cooling operation is enabled"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
      iconTransformation(extent={{-160,80},{-120,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput fanOpeMod
    "Fan operating mode signal"
    annotation (Placement(transformation(extent={{-180,-200},{-140,-160}}),
      iconTransformation(extent={{-160,-120},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "Availability signal"
    annotation (Placement(transformation(extent={{-180,-160},{-140,-120}}),
      iconTransformation(extent={{-160,-80},{-120,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-160,40},{-120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if has_coo
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-160,0},{-120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if has_hea
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-160,-40},{-120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-140},{180,-100}}),
      iconTransformation(extent={{120,-40},{160,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{120,0},{160,40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And andAva
    "Enable the fan only when the system is available"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Ensure minimum fan speed signal is passed"
    annotation (Placement(transformation(extent={{110,-90},{130,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on fan"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));

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

  Buildings.Controls.OBC.CDL.Continuous.Subtract subCoo if has_coo
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subHea if has_hea
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDCoo(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "PI controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDHea(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false)
    "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Add addFanSpe
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCooOcc
    "Enable fan in heating mode and cooling mode or when zone is occupied"
    annotation (Placement(transformation(extent={{50,-170},{70,-150}})));

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

equation
  connect(TZon, subCoo.u1) annotation (Line(points={{-160,40},{-130,40},{-130,16},
          {-122,16}}, color={0,0,127}));

  connect(TCooSet, subCoo.u2) annotation (Line(points={{-160,0},{-124,0},{-124,4},
          {-122,4}},  color={0,0,127}));

  connect(TZon, subHea.u2) annotation (Line(points={{-160,40},{-130,40},{-130,-36},
          {-122,-36}}, color={0,0,127}));

  connect(THeaSet, subHea.u1) annotation (Line(points={{-160,-40},{-124,-40},{-124,
          -24},{-122,-24}}, color={0,0,127}));

  connect(subCoo.y, conPIDCoo.u_m) annotation (Line(points={{-98,10},{-90,10},{-90,
          -80},{-70,-80},{-70,-72}}, color={0,0,127}));

  connect(subHea.y, conPIDHea.u_m) annotation (Line(points={{-98,-30},{-86,-30},
          {-86,-120},{-70,-120},{-70,-112}}, color={0,0,127}));

  connect(con.y, conPIDCoo.u_s) annotation (Line(points={{-98,-80},{-94,-80},{-94,
          -60},{-82,-60}}, color={0,0,127}));

  connect(con.y, conPIDHea.u_s) annotation (Line(points={{-98,-80},{-94,-80},{-94,
          -100},{-82,-100}}, color={0,0,127}));

  connect(conPIDCoo.y, addFanSpe.u1) annotation (Line(points={{-58,-60},{-54,-60},
          {-54,-74},{-52,-74}}, color={0,0,127}));

  connect(conPIDHea.y, addFanSpe.u2) annotation (Line(points={{-58,-100},{-54,-100},
          {-54,-86},{-52,-86}}, color={0,0,127}));

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
  connect(timFan.passed, orHeaCooOcc.u2) annotation (Line(points={{42,-168},{48,
          -168}},                     color={255,0,255}));
  connect(mul.y, reaScaRep.u)
    annotation (Line(points={{22,-30},{28,-30}}, color={0,0,127}));
  connect(addFanSpe.y, mul.u2) annotation (Line(points={{-28,-80},{-6,-80},{-6,-36},
          {-2,-36}}, color={0,0,127}));
  connect(booToReaFan.y, mul.u1) annotation (Line(points={{92,10},{100,10},{100,
          -10},{-6,-10},{-6,-24},{-2,-24}}, color={0,0,127}));
  connect(truFalHol.y, yFan) annotation (Line(points={{132,-120},{160,-120}},
                             color={255,0,255}));
  connect(truFalHol.y, booToReaFan.u) annotation (Line(points={{132,-120},{136,-120},
          {136,30},{60,30},{60,10},{68,10}}, color={255,0,255}));
  connect(yFanSpe, max.y)
    annotation (Line(points={{160,-80},{132,-80}}, color={0,0,127}));
  connect(extIndSig.y, max.u2) annotation (Line(points={{92,-60},{100,-60},{100,
          -86},{108,-86}}, color={0,0,127}));
  connect(fanSpeVal[1].y, max.u1) annotation (Line(points={{42,-60},{54,-60},{54,
          -74},{108,-74}}, color={0,0,127}));
  connect(fanOpeMod, orHeaCooOcc.u1) annotation (Line(points={{-160,-180},{44,-180},
          {44,-160},{48,-160}}, color={255,0,255}));
  connect(truFalHol.u, andAva.y)
    annotation (Line(points={{108,-120},{102,-120}}, color={255,0,255}));
  connect(orHeaCooOcc.y, andAva.u2) annotation (Line(points={{72,-160},{76,-160},
          {76,-128},{78,-128}}, color={255,0,255}));
  connect(uAva, andAva.u1) annotation (Line(points={{-160,-140},{-40,-140},{-40,
          -120},{78,-120}}, color={255,0,255}));
  connect(heaCooOpe, timFan.u) annotation (Line(points={{-160,80},{-20,80},{-20,
          -160},{18,-160}}, color={255,0,255}));
  annotation (defaultComponentName="conMulSpeFan",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}}),
        graphics={Rectangle(
          extent={{-120,120},{120,-120}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,140},{140,180}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-112,72},{-70,48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-112,36},{-44,0}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-112,-2},{-44,-38}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-108,-46},{-66,-72}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAva"),
        Text(
          extent={{48,46},{114,-2}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yFanSpe"),
        Text(
          extent={{70,-8},{114,-32}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yFan"),
        Text(
          extent={{-110,-84},{-28,-118}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="fanOpeMod"),
        Text(
          extent={{-114,118},{-32,84}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="heaCooOpe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-200},{140,100}})),
    Documentation(info="<html>
      <p>
      This is a control module for the multispeed fan designed as an 
      analogue to the control logic in EnergyPlus. The components are operated 
      as follows:
      <ul>
      <li>
      The fan is enabled (<code>yFan=true</code>) when the cooling/heating mode signal
      <code>heaCooOpe</code> is held <code>true</code> for a minimum time duration
      <code>tFanEnaDel</code>, or if the fan operating mode signal <code>fanOpeMod</code>
      is <code>true</code>.
      </li>
      <li>
      Once enabled, the fan is held enabled for minimum time duration <code>tFanEna</code>.
      </li>
      <li>
      The fan speed <code>yFanSpe</code> is determined by the difference between the
      measured zone temperature <code>TZon</code> and the setpoints <code>THeaSet</code>
      and <code>TCooSet</code>. The two PI controllers <code>conPIDCoo</code> and 
      <code>conPIDHea</code> try to regulate this difference to <code>zero</code>.
      The output from these two signals is compared against the list of available 
      normalized fan speeds <code>fanSpe</code>. The fan speed just lower than the
      generated PID output is output through <code>yFanSpe</code>.
      </li>
      <li>
      The fan is not enabled if the availability signal <code>uAva</code> is set 
      to <code>false</code>.
      </li>
      </ul>
      </p>
      <p align=\"center\">
      <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/Baseclasses/multispeedFan.png\"/>
      </p>
      </html>
      ", revisions="<html>
      <ul>
      <li>
      June 21, 2023 by Karthik Devaprasad, Junke Wang:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end MultispeedFan;
