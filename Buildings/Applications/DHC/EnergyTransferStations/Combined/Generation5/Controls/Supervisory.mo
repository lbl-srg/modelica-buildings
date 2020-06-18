within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Supervisory "Energy transfer station supervisory controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nSouAmb
    "Number of ambient sources to control"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.TemperatureDifference dTHys = 2
    "Temperature hysteresis (absolute value)";
  parameter Modelica.SIunits.TemperatureDifference dTDea = 0
    "Temperature dead band (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType[nSouAmb]=
    fill(Buildings.Controls.OBC.CDL.Types.SimpleController.PI, nSouAmb)
    "Type of controller";
  parameter Real kHot[nSouAmb](each min=0)=fill(0.1, nSouAmb)
    "Gain of controller on hot side";
  parameter Real kCol[nSouAmb](each min=0)=fill(0.2, nSouAmb)
    "Gain of controller on cold side";
  parameter Modelica.SIunits.Time Ti[nSouAmb](
    each min=Buildings.Controls.OBC.CDL.Constants.small)=fill(300, nSouAmb)
    "Time constant of integrator block (hot and cold side)"
    annotation (Dialog(enable=Modelica.Math.BooleanVectors.anyTrue({
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType[i] == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
      for i in 1:nSouAmb})));
  parameter Modelica.SIunits.Temperature THeaWatSupSetMin(
    displayUnit="degC")
    "Minimum value of heating water supply temperature set-point";
  parameter Modelica.SIunits.Temperature TChiWatSupSetMax(
    displayUnit="degC")
    "Maximum value of chilled water supply temperature set-point";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal" annotation (Placement(transformation(extent={{-160,90},
            {-120,130}}), iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal" annotation (Placement(transformation(extent={{-160,70},
            {-120,110}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupPreSet(final unit="K",
      displayUnit="degC") "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatTop(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatBot(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
       iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatTop(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatBot(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupPreSet(
    final unit="K", displayUnit="degC") "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point after reset" annotation (
      Placement(transformation(extent={{120,-70},{160,-30}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point after reset" annotation (
      Placement(transformation(extent={{120,-100},{160,-60}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoEva(
    final unit="1")
    "Evaporator to ambient loop isolation valve control signal" annotation (
      Placement(transformation(extent={{120,-40},{160,0}}), iconTransformation(
          extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoCon(
    final unit="1") "Condenser to ambient loop isolation valve control signal"
    annotation (
      Placement(transformation(extent={{120,-10},{160,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](
    each final unit="1") "Control output for ambient sources" annotation (
      Placement(transformation(extent={{120,20},{160,60}}), iconTransformation(
          extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHea
    "Enabled signal for heating system" annotation (Placement(transformation(
          extent={{120,80},{160,120}}), iconTransformation(extent={{100,70},{140,
            110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "Enabled signal for cooling system" annotation (Placement(transformation(
          extent={{120,50},{160,90}}), iconTransformation(extent={{100,40},{140,
            80}})));

  HotSide conHotSid(
    final nSouAmb=nSouAmb,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=kHot,
    final Ti=Ti)
    "Hot side controller"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  ColdSide conColSid(
    final nSouAmb=nSouAmb,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final controllerType=controllerType,
    final k=kCol,
    final Ti=Ti)
    "Cold side controller"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1[nSouAmb]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Reset reset(
    final THeaWatSupSetMin=THeaWatSupSetMin,
    final TChiWatSupSetMax=TChiWatSupSetMax)
    "Supply temperature reset"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
equation
  connect(THeaWatTop, conHotSid.TTop) annotation (Line(points={{-140,20},{-32,
          20},{-32,46},{-12,46}}, color={0,0,127}));
  connect(THeaWatBot, conHotSid.TBot) annotation (Line(points={{-140,0},{-28,0},
          {-28,42},{-12,42}},     color={0,0,127}));
  connect(TChiWatBot, conColSid.TBot) annotation (Line(points={{-140,-80},{-20,
          -80},{-20,-58},{-12,-58}}, color={0,0,127}));
  connect(conHotSid.y, max1.u1)
    annotation (Line(points={{12,49},{20,49},{20,6},{28,6}}, color={0,0,127}));
  connect(conColSid.y, max1.u2) annotation (Line(points={{12,-51},{20,-51},{20,-6},
          {28,-6}}, color={0,0,127}));
  connect(uHea, conHotSid.uHeaCoo) annotation (Line(points={{-140,110},{-16,110},
          {-16,58},{-12,58}}, color={255,0,255}));
  connect(uCoo, conColSid.uHeaCoo) annotation (Line(points={{-140,90},{-20,90},{
          -20,-42},{-12,-42}}, color={255,0,255}));
  connect(TChiWatTop, conColSid.TTop) annotation (Line(points={{-140,-60},{-24,
          -60},{-24,-54},{-12,-54}}, color={0,0,127}));
  connect(uHea, reset.uHea) annotation (Line(points={{-140,110},{-112,110},{-112,
          -92},{-82,-92}}, color={255,0,255}));
  connect(uCoo, reset.uCoo) annotation (Line(points={{-140,90},{-100,90},{-100,-97},
          {-82,-97}}, color={255,0,255}));
  connect(THeaWatSupPreSet, reset.THeaWatSupPreSet) annotation (Line(points={{-140,40},
          {-106,40},{-106,-103},{-82,-103}},     color={0,0,127}));
  connect(TChiWatSupPreSet, reset.TChiWatSupPreSet) annotation (Line(points={{-140,
          -40},{-112,-40},{-112,-108},{-82,-108}}, color={0,0,127}));
  connect(reset.TChiWatSupSet, TChiWatSupSet) annotation (Line(points={{-58,-105},
          {112,-105},{112,-80},{140,-80}}, color={0,0,127}));
  connect(reset.THeaWatSupSet, THeaWatSupSet) annotation (Line(points={{-58,-95},
          {106,-95},{106,-50},{140,-50}}, color={0,0,127}));
  connect(conColSid.yIsoAmb, yIsoEva) annotation (Line(points={{12,-57},{100,-57},
          {100,-20},{140,-20}}, color={0,0,127}));
  connect(max1.y, yAmb) annotation (Line(points={{52,0},{100,0},{100,40},{140,40}},
        color={0,0,127}));
  connect(conColSid.yHeaCoo, yCoo) annotation (Line(points={{12,-45},{80,-45},{80,
          70},{140,70}}, color={255,0,255}));
  connect(conHotSid.yHeaCoo, yHea) annotation (Line(points={{12,55},{60,55},{60,
          100},{140,100}}, color={255,0,255}));
  connect(conHotSid.yIsoAmb, yIsoCon) annotation (Line(points={{12,43},{60,43},{
          60,10},{140,10}}, color={0,0,127}));
  connect(conColSid.yHeaCoo, conHotSid.uCooHea) annotation (Line(points={{12,-45},
          {14,-45},{14,20},{-16,20},{-16,54},{-12,54}}, color={255,0,255}));
  connect(conHotSid.yHeaCoo, conColSid.uCooHea) annotation (Line(points={{12,55},
          {20,55},{20,80},{-24,80},{-24,-46},{-12,-46}}, color={255,0,255}));
  connect(reset.THeaWatSupSet, conHotSid.TSet) annotation (Line(points={{-58,
          -95},{-40,-95},{-40,50},{-12,50}}, color={0,0,127}));
  connect(reset.TChiWatSupSet, conColSid.TSet) annotation (Line(points={{-58,
          -105},{-32,-105},{-32,-50},{-12,-50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
        defaultComponentName="conSup",
        Documentation(info="<html>
<p>
The block implements the control sequence for the ETS chilled water and 
heating water circuits.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 10, 2019, by Hagar Elarga:<br/>
Added the documentation. 
</li>
<li>
November 25, 2019, by Hagar Elarga:<br/>
Removed the tank minimum charging flow signal because the primary pumps are constant speed.
</li>
</ul>
</html>"));
end Supervisory;
