within Buildings.Air.Systems.SingleZone.VAV.BaseClasses;
model ControllerChillerDXHeatingEconomizer
  "Controller for single zone VAV system"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Temperature TSupChi_nominal
    "Design value for chiller leaving water temperature";
  parameter Real minAirFlo(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum airflow fraction of system"
    annotation(Dialog(group="Setpoints"));
  parameter Modelica.Units.SI.DimensionlessRatio minOAFra
    "Minimum outdoor air fraction of system"
    annotation (Dialog(group="Setpoints"));
  parameter Modelica.Units.SI.Temperature TSetSupAir
    "Cooling supply air temperature setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Heating coil control"));
  parameter Real kHea(
    final unit="1/K")=0.1
    "Gain for heating coil control signal"
    annotation(Dialog(group="Heating coil control"));
  parameter Real TiHea(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for heating coil control signal"
    annotation(Dialog(group="Heating coil control",
    enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdHea(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for heating coil control signal"
    annotation (Dialog(group="Heating coil control",
      enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Cooling coil control"));
  parameter Real kCoo(
    final unit="1/K")=0.1
    "Gain for cooling coil control signal"
    annotation(Dialog(group="Cooling coil control"));
  parameter Real TiCoo(
    final unit="s")=900
    "Time constant of integrator block for cooling coil control signal"
    annotation(Dialog(group="Cooling coil control",
    enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCoo(
    final unit="s")=0.1
    "Time constant of derivative block for cooling coil control signal"
    annotation (Dialog(group="Cooling coil control",
    enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFan=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Fan control"));
  parameter Real kFan(final unit="1/K")=0.1
    "Gain for fan signal"
    annotation(Dialog(group="Fan control"));
  parameter Real TiFan(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for fan signal"
    annotation(Dialog(group="Fan control",
    enable=controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdFan(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for fan signal"
    annotation (Dialog(group="Fan control",
    enable=controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeEco=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Economizer control"));
  parameter Real kEco(final unit="1/K")=0.1
    "Gain for economizer control signal"
    annotation(Dialog(group="Economizer control"));
  parameter Real TiEco=300
    "Time constant of integrator block for economizer control signal"
    annotation(Dialog(group="Economizer control",
    enable=controllerTypeEco == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeEco == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdEco(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for economizer control signal"
    annotation (Dialog(group="Economizer control",
      enable=controllerTypeEco == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeEco == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetRooCoo(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetRooHea(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature measurement"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-120,-80}),
        iconTransformation(extent={{-20,-20},{20,20}},origin={-120,-60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature after the cooling coil"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured outside air temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1") "Control signal for heating coil"
    annotation (Placement(transformation(extent={{100,44},{120,64}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final unit="1") "Control signal for fan"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutAirFra(
    final unit="1")
    "Control signal for outside air fraction"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoiVal(
    final unit="1")
    "Control signal for cooling coil valve"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetSupChi(
    final unit="K",
    displayUnit="degC")
    "Set point for chiller leaving water temperature"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput chiOn
    "On signal for chiller"
    annotation (Placement(transformation(extent={{100,-64},{120,-44}}),
        iconTransformation(extent={{100,-70},{140,-30}})));

  BaseClasses.ControllerHeatingFan conSup(
    final controllerTypeHea=controllerTypeHea,
    final kHea=kHea,
    final TiHea=TiHea,
    final TdHea=TdHea,
    final controllerTypeFan=controllerTypeFan,
    final kFan=kFan,
    final TiFan=TiFan,
    final TdFan=TdFan,
    final minAirFlo = minAirFlo)
    "Heating coil and fan controller"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  BaseClasses.ControllerEconomizer conEco(
    final controllerTypeEco=controllerTypeEco,
    final kEco=kEco,
    final TiEco=TiEco,
    final TdEco=TdEco)
    "Economizer control"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.Continuous.LimPID conCooVal(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final yMax=1,
    final yMin=0,
    final reverseActing=false)
    "Cooling coil valve controller"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch the outdoor air fraction to 0 when in unoccupied mode"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    "Zero outside air fraction"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFan "Switch fan on"
    annotation (Placement(transformation(extent={{70,120},{90,140}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr orFan(nin=3)
    "Switch fan on if heating, cooling, or occupied"
    annotation (Placement(transformation(extent={{40,94},{60,114}})));
  Modelica.Blocks.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater chiOnTRoo(h=1)
    "Chiller on signal based on room temperature"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Controls.OBC.CDL.Continuous.Greater heaOnTRoo(h=0.5)
    "Heatin on signal based on room temperature"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
protected
  Modelica.Blocks.Sources.Constant TSetSupChiConst(
    final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Modelica.Blocks.Sources.Constant conMinOAFra(
    final k=minOAFra)
    "Minimum outside air fraction"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant TSetSupAirConst(
    final k=TSetSupAir)
    "Set point for supply air temperature"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

equation
  connect(TSetSupAirConst.y,conCooVal. u_s)    annotation (Line(points={{-19,-50},
          {-10,-50},{-10,-20},{-2,-20}}, color={0,0,127}));
  connect(conSup.TRoo, TRoo) annotation (Line(points={{-61,84},{-74,84},{-74,
          -80},{-120,-80}}, color={0,0,127}));
  connect(conEco.TRet, TRoo) annotation (Line(points={{39,72},{-22,72},{-22,20},
          {-86,20},{-86,-80},{-120,-80}}, color={0,0,127}));
  connect(conSup.yHea, yHea) annotation (Line(points={{-39,86},{88,86},{88,54},{
          110,54}}, color={0,0,127}));
  connect(conEco.yOutAirFra, yOutAirFra) annotation (Line(points={{61,70},{80,70},
          {80,20},{110,20}}, color={0,0,127}));
  connect(conCooVal.y, yCooCoiVal) annotation (Line(points={{21,-20},{40,-20},{40,-20},{110,-20}},
          color={0,0,127}));
  connect(TSetSupChiConst.y, TSetSupChi) annotation (Line(points={{81,-90},{110,
          -90}}, color={0,0,127}));
  connect(conCooVal.u_m, TSup) annotation (Line(points={{10,-32},{10,-110},{-120,-110}},
          color={0,0,127}));
  connect(conMinOAFra.y, swi.u1) annotation (Line(points={{-39,50},{-30,50},{-30,
          38},{-2,38}}, color={0,0,127}));
  connect(uOcc, swi.u2) annotation (Line(points={{-120,0},{-14,0},{-14,30},{-2,30}},
          color={255,0,255}));
  connect(swi.y, conEco.minOAFra) annotation (Line(points={{22,30},{30,30},{30,
          68},{39,68}}, color={0,0,127}));
  connect(con.y, swi.u3) annotation (Line(points={{-38,-20},{-30,-20},{-30,-10},
          {-6,-10},{-6,22},{-2,22}}, color={0,0,127}));
  connect(con.y, swiFan.u3) annotation (Line(points={{-38,-20},{-30,-20},{-30,
          -10},{-6,-10},{-6,122},{68,122}}, color={0,0,127}));
  connect(conSup.yFan, swiFan.u1) annotation (Line(points={{-39,94},{18,94},{18,
          138},{68,138}}, color={0,0,127}));
  connect(swiFan.y, yFan) annotation (Line(points={{92,130},{96,130},{96,90},{
          110,90}}, color={0,0,127}));
  connect(swiFan.u2, orFan.y)   annotation (Line(points={{68,130},{64,130},{64,104},{62,104}},
          color={255,0,255}));
  connect(conEco.TMixSet, conCooVal.u_s) annotation (Line(points={{39,78},{-10,
          78},{-10,-20},{-2,-20}}, color={0,0,127}));
  connect(and1.y, chiOn) annotation (Line(points={{91,-30},{96,-30},{96,-54},{110,
          -54}},     color={255,0,255}));
  connect(conEco.yCoiSta, and1.u1) annotation (Line(points={{61,62},{64,62},{64,
          -30},{68,-30}}, color={255,0,255}));
  connect(uOcc, orFan.u[1]) annotation (Line(points={{-120,0},{-14,0},{-14,
          101.667},{38,101.667}},
                        color={255,0,255}));
  connect(TMix, conEco.TMix) annotation (Line(points={{-120,30},{-26,30},{-26,75},
          {39,75}}, color={0,0,127}));
  connect(TOut, conEco.TOut) annotation (Line(points={{-120,-40},{-66,-40},{-66,
          16},{-18,16},{-18,65},{39,65}}, color={0,0,127}));
  connect(TRoo, chiOnTRoo.u1) annotation (Line(points={{-120,-80},{-74,-80},{-74,
          -70},{18,-70}}, color={0,0,127}));
  connect(TSetRooCoo, chiOnTRoo.u2) annotation (Line(points={{-120,60},{-80,60},
          {-80,-78},{18,-78}}, color={0,0,127}));
  connect(TSetRooCoo, conSup.TSetRooCoo) annotation (Line(points={{-120,60},{-80,
          60},{-80,90},{-61,90}}, color={0,0,127}));
  connect(TSetRooHea, conSup.TSetRooHea) annotation (Line(points={{-120,120},{-80,
          120},{-80,96},{-61,96}}, color={0,0,127}));
  connect(chiOnTRoo.y, and1.u2) annotation (Line(points={{42,-70},{50,-70},{50,-38},
          {68,-38}}, color={255,0,255}));
  connect(chiOnTRoo.y, conEco.cooSta) annotation (Line(points={{42,-70},{50,-70},
          {50,40},{34,40},{34,62},{39,62}}, color={255,0,255}));

  connect(chiOnTRoo.y, orFan.u[2]) annotation (Line(points={{42,-70},{50,-70},{
          50,40},{34,40},{34,104},{38,104}},         color={255,0,255}));
  connect(heaOnTRoo.y, orFan.u[3]) annotation (Line(points={{-18,130},{34,130},
          {34,106.333},{38,106.333}}, color={255,0,255}));
  connect(heaOnTRoo.u2, TRoo) annotation (Line(points={{-42,122},{-86,122},{-86,
          -80},{-120,-80}}, color={0,0,127}));
  connect(heaOnTRoo.u1, TSetRooHea) annotation (Line(points={{-42,130},{-80,130},
          {-80,120},{-120,120}}, color={0,0,127}));
  annotation (
  defaultComponentName="conChiDXHeaEco",
  Icon(graphics={Line(points={{-100,-100},{0,2},{-100,100}}, color=
              {0,0,0})}), Documentation(info="<html>
<p>
This is a controller for the single-zone VAV system with an economizer, a 
heating coil and a cooling coil.
</p>
</html>", revisions="<html>
<ul>
<li>
March 28, 2024, by David Blum:<br/>
Adjust hysteresis based on heating to avoid chatter.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3735\">issue 3735</a>.
</li>
<li>
November 20, 2020, by David Blum:<br/>
Turn fan on when setup cooling required.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2265\">issue 2265</a>.
</li>
<li>
July 21, 2020, by Kun Zhang:<br/>
Exposed PID control parameters to allow users to tune for their specific systems.
</li>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-120},{100,140}})));
end ControllerChillerDXHeatingEconomizer;
