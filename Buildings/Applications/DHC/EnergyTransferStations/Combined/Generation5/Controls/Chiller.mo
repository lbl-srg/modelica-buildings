within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Chiller "Chiller controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_resUp = true
    "Allow resetting up chilled water supply temperature in heating only"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Temperature TChiWatSupSetMin(
    displayUnit="degC")
    "Minimum value of chilled water supply temperature set-point";
  parameter Modelica.SIunits.Temperature TChiWatSupSetMax(
    displayUnit="degC")
    "Maximum value of chilled water supply temperature set-point"
    annotation(Dialog(enable=have_resUp));
  parameter Modelica.SIunits.Temperature TConWatEntMin(
    displayUnit="degC")
    "Minimum value of condenser water entering temperature";
  parameter Modelica.SIunits.Temperature TEvaWatEntMax(
    displayUnit="degC")
    "Maximum value of evaporator water entering temperature";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupPreSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point (may be reset down)"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSup(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEnt(
    final unit="K", displayUnit="degC")
    "Condenser water entering temperature"
    annotation (Placement(transformation(extent={{-200,-320},{-160,-280}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaWatEnt(
    final unit="K", displayUnit="degC")
    "Evaporator water entering temperature"
    annotation (Placement(transformation(extent={{-200,-260},{-160,-220}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal" annotation (Placement(transformation(extent={
            {-200,20},{-160,60}}), iconTransformation(extent={{-140,40},{-100,
            80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal" annotation (Placement(transformation(extent={
            {-200,60},{-160,100}}), iconTransformation(extent={{-140,60},{-100,
            100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Condenser mixing valve control signal"
    annotation (Placement(transformation(extent={{160,-300},{200,-260}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva
    "Evaporator mixing valve control signal"
    annotation (Placement(transformation(extent={{160,-240},{200,-200}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi
    "Chiller enabled signal"
    annotation (Placement(transformation(extent={{160,40},
    {200,80}}), iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCoo
    "Heating or cooling mode enabled"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Pass through maximum set-point value if cooling only, otherwise reset"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.Continuous.LimPID conTChiWatSet(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 60,
    reverseAction=false)
    "Controller resetting chilled water supply temperature"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun
    "Mapping function resetting heating water supply temperature"
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1(k=0)
    "PI minimum output"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2(k=1)
    "PI maximum output"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHea "Heating mode disabled"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.And cooOnl "Cooling only mode"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.Continuous.LimPID conValEva(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final yMax=1,
    final yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 60,
    final reverseAction=false)
    "Evaporator three-way valve control"
    annotation (Placement(transformation(extent={{50,-230},{70,-210}})));
  Buildings.Controls.Continuous.LimPID conValCon(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final yMax=1,
    final yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 60,
    final reverseAction=true)
    "Condenser three-way valve control"
    annotation (Placement(transformation(extent={{50,-290},{70,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTChiWatSup(
    y(final unit="K", displayUnit="degC"),
    final k=TChiWatSupSetMin)
    "Minimum value of chilled water supply temperature"
    annotation (Placement(transformation(extent={{-10,-190},{10,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTEvaWatEnt(
    y(final unit="K", displayUnit="degC"),
    final k=TEvaWatEntMax)
    "Maximum value of evaporator water entering temperature"
  annotation (Placement(transformation(extent={{-10,-230},{10,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTConWatEnt(
    y(final unit="K", displayUnit="degC"),
    final k=TConWatEntMin)
    "Minimum value of condenser water entering temperature"
    annotation (Placement(transformation(extent={{-10,-290},{10,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCoo "Cooling mode disabled"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaResUp(nu=3)
    "Heating only mode and allow resetting up CHWST "
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Pass through maximum set-point value if cooling only, otherwise reset"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTChiWatSupSet(k=
        TChiWatSupSetMax)
    "Maximum chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant havResUp(k=have_resUp)
    "True if allow resetting up CHWST"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
equation
  connect(swi2.y,TChiWatSupSet)
    annotation (Line(points={{142,-40},{180,-40}},
                                               color={0,0,127}));
  connect(x1.y, mapFun.x1) annotation (Line(points={{12,-100},{16,-100},{16,-112},
          {48,-112}},
              color={0,0,127}));
  connect(conTChiWatSet.y, mapFun.u)
    annotation (Line(points={{-49,-120},{48,-120}}, color={0,0,127}));
  connect(x2.y, mapFun.x2) annotation (Line(points={{12,-140},{16,-140},{16,-124},
          {48,-124}}, color={0,0,127}));
  connect(uHea, conTChiWatSet.trigger) annotation (Line(points={{-180,80},{-140,
          80},{-140,-140},{-68,-140},{-68,-132}}, color={255,0,255}));
  connect(TChiWatSupPreSet, swi2.u1) annotation (Line(points={{-180,-40},{60,-40},
          {60,-32},{118,-32}},
                       color={0,0,127}));
  connect(uHea, notHea.u)
    annotation (Line(points={{-180,80},{-102,80}}, color={255,0,255}));
  connect(cooOnl.y, swi2.u2) annotation (Line(points={{12,80},{80,80},{80,-40},{
          118,-40}},
                   color={255,0,255}));
  connect(TEvaWatEnt, conValEva.u_m) annotation (Line(points={{-180,-240},{60,-240},
          {60,-232}}, color={0,0,127}));
  connect(conValEva.y,yValEva)
    annotation (Line(points={{71,-220},{180,-220}}, color={0,0,127}));
  connect(TConWatEnt, conValCon.u_m) annotation (Line(points={{-180,-300},{60,-300},
          {60,-292}}, color={0,0,127}));
  connect(conValCon.y,yValCon)
    annotation (Line(points={{71,-280},{180,-280}}, color={0,0,127}));
  connect(heaOrCoo.y, conValEva.trigger) annotation (Line(points={{-78,0},{-40,0},
          {-40,-236},{52,-236},{52,-232}}, color={255,0,255}));
  connect(heaOrCoo.y, conValCon.trigger) annotation (Line(points={{-78,0},{-40,0},
          {-40,-296},{52,-296},{52,-292}}, color={255,0,255}));
  connect(heaOrCoo.y, yChi) annotation (Line(points={{-78,0},{140,0},{140,60},{180,
          60}}, color={255,0,255}));
  connect(uHea,heaOrCoo. u1) annotation (Line(points={{-180,80},{-140,80},{-140,
          0},{-102,0}}, color={255,0,255}));
  connect(uCoo,heaOrCoo. u2) annotation (Line(points={{-180,40},{-140,40},{-140,
          -8},{-102,-8}}, color={255,0,255}));
  connect(mapFun.y, swi2.u3) annotation (Line(points={{72,-120},{100,-120},{100,
          -48},{118,-48}},
                         color={0,0,127}));
  connect(minTChiWatSup.y, mapFun.f2) annotation (Line(points={{12,-180},{40,-180},
          {40,-128},{48,-128}}, color={0,0,127}));
  connect(THeaWatSup, conTChiWatSet.u_m) annotation (Line(points={{-180,-160},{-60,
          -160},{-60,-132}}, color={0,0,127}));
  connect(THeaWatSupSet, conTChiWatSet.u_s)
    annotation (Line(points={{-180,-120},{-72,-120}}, color={0,0,127}));
  connect(maxTEvaWatEnt.y, conValEva.u_s)
    annotation (Line(points={{12,-220},{48,-220}}, color={0,0,127}));
  connect(minTConWatEnt.y, conValCon.u_s)
    annotation (Line(points={{12,-280},{48,-280}}, color={0,0,127}));
  connect(uCoo, notCoo.u)
    annotation (Line(points={{-180,40},{-102,40}}, color={255,0,255}));
  connect(notHea.y, cooOnl.u1)
    annotation (Line(points={{-78,80},{-12,80}}, color={255,0,255}));
  connect(uCoo, cooOnl.u2) annotation (Line(points={{-180,40},{-120,40},{-120,64},
          {-60,64},{-60,72},{-12,72}}, color={255,0,255}));
  connect(TChiWatSupPreSet, swi1.u3) annotation (Line(points={{-180,-40},{-80,-40},
          {-80,-88},{-72,-88}},  color={0,0,127}));
  connect(maxTChiWatSupSet.y, swi1.u1) annotation (Line(points={{-98,-80},{-88,-80},
          {-88,-72},{-72,-72}}, color={0,0,127}));
  connect(swi1.y, mapFun.f1) annotation (Line(points={{-48,-80},{-20,-80},{-20,-116},
          {48,-116}}, color={0,0,127}));
  connect(notCoo.y, enaResUp.u[1]) annotation (Line(points={{-78,40},{-12,40},{
          -12,44.6667}},
                     color={255,0,255}));
  connect(havResUp.y, enaResUp.u[2]) annotation (Line(points={{-28,20},{-20,20},
          {-20,40},{-12,40}}, color={255,0,255}));
  connect(uHea, enaResUp.u[3]) annotation (Line(points={{-180,80},{-140,80},{
          -140,60},{-20,60},{-20,40},{-12,40},{-12,35.3333}},
                                                         color={255,0,255}));
  connect(enaResUp.y, swi1.u2) annotation (Line(points={{12,40},{20,40},{20,-60},
          {-76,-60},{-76,-80},{-72,-80}}, color={255,0,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-160,-320},{160,100}})),
  defaultComponentName="con",
Documentation(info="<html>
<p>
The block computes the control signals for
</p>
<h4>EIR Chiller status</h4>
<p>
The chiller compressor is constant speed and switched on or off based on either <code>reqHea</code> or
<code>reqCoo</code> is true, the controller outputs the integer output
<code>ychiMod</code> to switch on the chiller compressor.
</p>
<h4>Mixing valve at the evaporator inlet</h4>
<p>
The three-way valve on the evaporator side is controlled with
a P or PI controller to track a constant, maximum water inlet temperature.
</p>
<h4>Mixing valve at the condenser inlet</h4>
<p>
The three-way valve at the condenser inlet is controlled with
a P or PI controller to track a constant, minimum water inlet temperature.
</p>
<p>
The block in addition, resets <code>TSetCoo</code> based on the thermal operational 
mode i.e. cooling only, heating only or
simultaneous heating and cooling.
</p>
<h4>Reset of chilled water supply temperature</h4>
<p>
As shown in the control scheme below and during
</p>
<ol>
  <li>
  simultaneous heating and cooling and heating only operational modes, the control 
  sequence resets the cooling setpoint <code>TReSetCoo</code> till the leaving heating
  water temperature from the condenser side meets the heating setpoint <code>TSetHea</code>
  <p align=\"center\">
  <img alt=\"Image PI controller to reset the TSetCoo\"
  src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/chillerControlDiagram.png\"/>
  </p align=\"center\">
  <p>
  The required decrement in <code>TSetCoo</code> is estimated by a reverse acting PI
  loop , with a reference set point of <code>TSetHea</code>
   and measured temperature value of <code>TConLvg</code>. Hence, when the condenser
   leaving water temperature is lower than <code>TSetHea</code>,
  TSetCoo is decreased. The control mapping function is shown in
  </p>
  <p align=\"center\">
  <img alt=\"Image Control Mapping function of resetting TsetCoo\"
  src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/chillerMappingFunction.png\"/>
  </p align=\"center\">
  </li>
  <li>
  cooling only operational mode, the leaving water form the chiller evaporator side
  tracks the cooling setpoint <code>TSetCoo</code>
   and the leaving water from the condenser floats depending on the entering water 
   temperature and flow rate.
  </li>
</ol>
</html>", revisions="<html>
<ul>
<li>
November 25, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end Chiller;
