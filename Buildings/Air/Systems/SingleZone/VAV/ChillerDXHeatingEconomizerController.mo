within Buildings.Air.Systems.SingleZone.VAV;
model ChillerDXHeatingEconomizerController
  "Controller for single zone VAV system"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Temperature TSupChi_nominal
    "Design value for chiller leaving water temperature";
  parameter Real minAirFlo(
    min=0,
    max=1,
    unit="1") = 0.2
    "Minimum airflow rate of system"
    annotation(Dialog(group="Air design"));

  parameter Modelica.SIunits.DimensionlessRatio minOAFra "Minimum outdoor air fraction of system"
    annotation(Dialog(group="Air design"));

  parameter Modelica.SIunits.Temperature TSetSupAir "Cooling supply air temperature setpoint"
    annotation(Dialog(group="Air design"));

  parameter Real kHea(min=Modelica.Constants.small) = 2
    "Gain of heating controller"
    annotation(Dialog(group="Control gain"));

  parameter Real kCoo(min=Modelica.Constants.small)=1
    "Gain of controller for cooling valve"
    annotation(Dialog(group="Control gain"));

  parameter Real kFan(min=Modelica.Constants.small) = 0.5
    "Gain of controller for fan"
    annotation(Dialog(group="Control gain"));

  parameter Real kEco(min=Modelica.Constants.small) = 4
    "Gain of controller for economizer"
    annotation(Dialog(group="Control gain"));

  Modelica.Blocks.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC") "Zone temperature measurement"
  annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,-60})));

  Modelica.Blocks.Interfaces.RealInput TSetRooCoo(
    final unit="K",
    displayUnit="degC")
    "Zone cooling setpoint temperature" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,60})));
  Modelica.Blocks.Interfaces.RealInput TSetRooHea(
    final unit="K",
    displayUnit="degC")
    "Zone heating setpoint temperature" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,100})));

  Modelica.Blocks.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC")
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));

  Modelica.Blocks.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC")
    "Measured supply air temperature after the cooling coil"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC")
    "Measured outside air temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));

  Modelica.Blocks.Interfaces.RealOutput yHea(final unit="1") "Control signal for heating coil"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Modelica.Blocks.Interfaces.RealOutput yFan(final unit="1") "Control signal for fan"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));

  Modelica.Blocks.Interfaces.RealOutput yOutAirFra(final unit="1")
    "Control signal for outside air fraction"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Modelica.Blocks.Interfaces.RealOutput yCooCoiVal(final unit="1")
    "Control signal for cooling coil valve"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput TSetSupChi(
    final unit="K",
    displayUnit="degC")
    "Set point for chiller leaving water temperature"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.BooleanOutput chiOn "On signal for chiller"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  BaseClasses.ControllerHeatingFan conSup(
    minAirFlo = minAirFlo,
    kHea = kHea,
    kFan = kFan) "Heating coil, cooling coil and fan controller"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  BaseClasses.ControllerEconomizer conEco(
    final kEco = kEco)
    "Economizer control"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Controls.OBC.CDL.Continuous.Hysteresis                   hysChiPla(
    uLow=-1,
    uHigh=0)
    "Hysteresis with delay to switch on cooling"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Modelica.Blocks.Math.Feedback errTRooCoo
    "Control error on room temperature for cooling"
    annotation (Placement(transformation(extent={{-42,-70},{-22,-50}})));
  Controls.Continuous.LimPID conCooVal(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    final yMax=1,
    final yMin=0,
    final k=kCoo,
    final reverseAction=true)
    "Cooling coil valve controller"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

protected
  Modelica.Blocks.Sources.Constant TSetSupChiConst(
    final k=TSupChi_nominal)
    "Set point for chiller temperature"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

  Modelica.Blocks.Sources.Constant conMinOAFra(
    final k=minOAFra)
    "Minimum outside air fraction"
    annotation (Placement(transformation(extent={{-70,38},{-50,58}})));

  Modelica.Blocks.Sources.Constant TSetSupAirConst(
    final k=TSetSupAir)
    "Set point for supply air temperature"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

equation
  connect(conMinOAFra.y,conEco. minOAFra) annotation (Line(points={{-49,48},{
          -26,48},{-1,48}},                 color={0,0,127}));
  connect(TSetSupAirConst.y, conEco.TMixSet) annotation (Line(points={{-39,-20},
          {-20,-20},{-20,58},{-1,58}}, color={0,0,127}));
  connect(errTRooCoo.y, hysChiPla.u) annotation (Line(points={{-23,-60},{0,-60},
          {0,-40},{38,-40}},                           color={0,0,127}));
  connect(TSetRooCoo, errTRooCoo.u2) annotation (Line(points={{-120,60},{-80,60},
          {-80,-80},{-32,-80},{-32,-68}}, color={0,0,127}));
  connect(errTRooCoo.u1, TRoo) annotation (Line(points={{-40,-60},{-74,-60},{
          -120,-60}}, color={0,0,127}));
  connect(TSetSupAirConst.y,conCooVal. u_s)
    annotation (Line(points={{-39,-20},{-2,-20}},        color={0,0,127}));
  connect(conSup.TSetRooHea, TSetRooHea) annotation (Line(points={{-41,86},{-88,
          86},{-88,100},{-120,100}},
                                   color={0,0,127}));
  connect(conSup.TSetRooCoo, TSetRooCoo) annotation (Line(points={{-41,80},{-80,
          80},{-80,60},{-120,60}}, color={0,0,127}));
  connect(conSup.TRoo, TRoo) annotation (Line(points={{-41,74},{-74,74},{-74,
          -60},{-120,-60}},
                       color={0,0,127}));
  connect(conSup.yHea, conEco.yHea) annotation (Line(points={{-19,76},{-10,76},
          {-10,42},{-1,42}},color={0,0,127}));
  connect(conEco.TMix, TMix) annotation (Line(points={{-1,55},{-40,55},{-40,20},
          {-120,20}}, color={0,0,127}));
  connect(conEco.TRet, TRoo) annotation (Line(points={{-1,52},{-34,52},{-34,12},
          {-88,12},{-88,-60},{-120,-60}},     color={0,0,127}));
  connect(conEco.TOut, TOut) annotation (Line(points={{-1,45},{-30,45},{-30,8},
          {-94,8},{-94,-20},{-120,-20}},   color={0,0,127}));
  connect(conSup.yHea, yHea) annotation (Line(points={{-19,76},{40,76},{40,60},
          {80,60},{110,60}},
                    color={0,0,127}));
  connect(conSup.yFan, yFan) annotation (Line(points={{-19,84},{40,84},{40,90},
          {40,90},{40,90},{110,90},{110,90}},
                    color={0,0,127}));
  connect(conEco.yOutAirFra, yOutAirFra) annotation (Line(points={{21,50},{80,50},
          {80,30},{110,30}}, color={0,0,127}));
  connect(conCooVal.y, yCooCoiVal)
    annotation (Line(points={{21,-20},{76,-20},{76,0},{110,0}},
                                              color={0,0,127}));
  connect(TSetSupChiConst.y, TSetSupChi)
    annotation (Line(points={{61,-80},{110,-80}}, color={0,0,127}));
  connect(conCooVal.u_m, TSup)
    annotation (Line(points={{10,-32},{10,-90},{-120,-90}}, color={0,0,127}));
  connect(hysChiPla.y, chiOn) annotation (Line(points={{61,-40},{80,-40},{110,
          -40}},           color={255,0,255}));
  annotation (Icon(graphics={Line(points={{-100,-100},{0,2},{-100,100}}, color=
              {0,0,0})}), Documentation(info="<html>
<p>
This is the controller for the VAV system with economizer, heating coil and cooling coil.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerDXHeatingEconomizerController;
