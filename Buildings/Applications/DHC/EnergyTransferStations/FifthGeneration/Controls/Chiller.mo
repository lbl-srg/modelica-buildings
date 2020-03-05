within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls;
model Chiller "Chiller controller"

  extends Modelica.Blocks.Icons.Block;

   Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetConWatLvg(final unit="K",
      displayUnit="degC") "Condenser water leaving temperature set point"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetChiWatSup(final unit="K",
      displayUnit="degC") "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TMinEvaWatLvg(final unit="K",
      displayUnit="degC")
    "Minimum value for evaporator water leaving temperature" annotation (
      Placement(transformation(extent={{-200,-100},{-160,-60}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatLvg(final unit="K",
      displayUnit="degC") "Condenser water leaving temperature" annotation (
      Placement(transformation(extent={{-200,-260},{-160,-220}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEnt(final unit="K",
      displayUnit="degC") "Condenser water entering temperature" annotation (
      Placement(transformation(extent={{-200,-300},{-160,-260}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TMinConWatEnt(final unit="K",
      displayUnit="degC")
    "Minimum value for condenser water entering temperature" annotation (
      Placement(transformation(extent={{-200,-180},{-160,-140}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaWatEnt(final unit="K",
      displayUnit="degC") "Evaporator water entering temperature" annotation (
      Placement(transformation(extent={{-200,-220},{-160,-180}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxEvaWatEnt(final unit="K",
      displayUnit="degC")
    "Maximum value for evaporator water entering temperature" annotation (
      Placement(transformation(extent={{-200,-140},{-160,-100}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
   Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqCoo
    "Building cooling request"
     annotation (Placement(transformation(
          extent={{-200,20},{-160,60}}), iconTransformation(extent={{-140,50},{
            -100,90}})));
   Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqHea
    "Building heating request"
     annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
        iconTransformation(extent={{-140,68},{-100,108}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetEvaWatLvg(final unit=
        "K", displayUnit="degC")
    "Evaporator water leaving temperature set point" annotation (Placement(
        transformation(extent={{160,-20},{200,20}}), iconTransformation(extent=
            {{100,20},{140,60}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Condenser mixing valve control signal"
     annotation (Placement(transformation(extent={{160,-340},{200,-300}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva "Evaporator
mixing valve control signal"
     annotation (Placement(transformation(extent={{160,-280},{200,-240}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
   Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput onCom
    "Plant on/off command" annotation (Placement(transformation(extent={{160,40},
            {200,80}}), iconTransformation(extent={{100,60},{140,100}})));

   Buildings.Controls.OBC.CDL.Logical.Or or2
    "Plant on/off command (cooling or heating requested)"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
   Buildings.Controls.OBC.CDL.Logical.Switch swi2
     annotation (Placement(transformation(extent={{120,-10},{140,10}})));
   Buildings.Controls.Continuous.LimPID PI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 300,
    reverseAction=false)
    "Resetting of heating set point tempearture in case reqCoo or (reqCoo and reqHea) are true."
     annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
   Buildings.Controls.OBC.CDL.Continuous.Line mapFun
    "Mapping control function to reset the TsetHea"
     annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(k=0)
    "PI minimum error"
     annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(k=1)
    "PI maximum error"
     annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
   Buildings.Controls.OBC.CDL.Logical.Switch swi4
     annotation (Placement(transformation(extent={{72,-90},{92,-70}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X3(k=10 + 273.15)
    "Minimum heating setpoint temperature"
     annotation (Placement(transformation(extent={{-10,-190},{10,-170}})));
   Buildings.Controls.OBC.CDL.Logical.Not not1
     annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
   Buildings.Controls.OBC.CDL.Logical.And cooOnl
   "Cooling only mode"
     annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
   Buildings.Controls.Continuous.LimPID valEva(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 100,
    reverseAction=false)
   "Evaporator three way valve PI control signal "
    annotation (Placement(transformation(extent={{-10,-270},{10,-250}})));
   Buildings.Controls.Continuous.LimPID valCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 100,
    reverseAction=true)
    "Condenser three way valve PI control signal "
     annotation (Placement(transformation(extent={{-10,-330},{10,-310}})));

equation
  connect(reqHea, or2.u2) annotation (Line(points={{-180,80},{-140,80},{-140,52},
          {-92,52}}, color={255,0,255}));
  connect(reqCoo, or2.u1) annotation (Line(points={{-180,40},{-100,40},{-100,60},
          {-92,60}}, color={255,0,255}));
  connect(swi2.y, TSetEvaWatLvg)
    annotation (Line(points={{142,0},{180,0}}, color={0,0,127}));
  connect(PI.u_s, TSetConWatLvg) annotation (Line(points={{-92,-80},{-100,-80},
          {-100,-40},{-180,-40}}, color={0,0,127}));
  connect(X1.y, mapFun.x1) annotation (Line(points={{12,-80},{16,-80},{16,-92},
          {28,-92}},  color={0,0,127}));
  connect(PI.y, mapFun.u)  annotation (Line(points={{-69,-80},{-64,-80},{-64,
          -100},{28,-100}},                        color={0,0,127}));
  connect(TMinEvaWatLvg, mapFun.f2) annotation (Line(points={{-180,-80},{-150,
          -80},{-150,-108},{28,-108}}, color={0,0,127}));
  connect(X2.y, mapFun.x2) annotation (Line(points={{12,-140},{16,-140},{16,
          -104},{28,-104}},
                      color={0,0,127}));
  connect(TConWatLvg, PI.u_m) annotation (Line(points={{-180,-240},{-80,-240},{
          -80,-92}}, color={0,0,127}));
  connect(TSetChiWatSup, mapFun.f1) annotation (Line(points={{-180,0},{-50,0},{
          -50,-96},{28,-96}}, color={0,0,127}));
  connect(reqHea, PI.trigger) annotation (Line(points={{-180,80},{-140,80},{
          -140,-100},{-88,-100},{-88,-92}},
                                        color={255,0,255}));
  connect(mapFun.y, swi4.u1) annotation (Line(points={{52,-100},{56,-100},{56,
          -72},{70,-72}}, color={0,0,127}));
  connect(X3.y, swi4.u3) annotation (Line(points={{12,-180},{60,-180},{60,-88},
          {70,-88}},  color={0,0,127}));
  connect(swi4.y, swi2.u3) annotation (Line(points={{94,-80},{100,-80},{100,-8},
          {118,-8}},                   color={0,0,127}));
  connect(TSetChiWatSup, swi2.u1) annotation (Line(points={{-180,0},{60,0},{60,
          8},{118,8}}, color={0,0,127}));
  connect(reqHea, not1.u) annotation (Line(points={{-180,80},{-140,80},{-140,
          -20},{-12,-20}},
                      color={255,0,255}));
  connect(reqCoo, cooOnl.u1) annotation (Line(points={{-180,40},{40,40},{40,-20},
          {48,-20}},                    color={255,0,255}));
  connect(cooOnl.y, swi2.u2) annotation (Line(points={{72,-20},{80,-20},{80,0},
          {118,0}}, color={255,0,255}));
  connect(TMaxEvaWatEnt, valEva.u_s) annotation (Line(points={{-180,-120},{-150,
          -120},{-150,-260},{-12,-260}}, color={0,0,127}));
  connect(TEvaWatEnt, valEva.u_m) annotation (Line(points={{-180,-200},{-128,
          -200},{-128,-280},{0,-280},{0,-272}}, color={0,0,127}));
  connect(valEva.y, yValEva) annotation (Line(points={{11,-260},{180,-260}}, color={0,0,127}));
  connect(TMinConWatEnt, valCon.u_s) annotation (Line(points={{-180,-160},{-140,
          -160},{-140,-320},{-12,-320}}, color={0,0,127}));
  connect(TConWatEnt, valCon.u_m) annotation (Line(points={{-180,-280},{-150,
          -280},{-150,-340},{0,-340},{0,-332}}, color={0,0,127}));
  connect(valCon.y, yValCon) annotation (Line(points={{11,-320},{180,-320}}, color={0,0,127}));
  connect(or2.y, valEva.trigger) annotation (Line(points={{-68,60},{-40,60},{
          -40,-278},{-8,-278},{-8,-272}}, color={255,0,255}));
  connect(or2.y, valCon.trigger) annotation (Line(points={{-68,60},{-40,60},{
          -40,-338},{-8,-338},{-8,-332}}, color={255,0,255}));

  connect(or2.y, onCom)
    annotation (Line(points={{-68,60},{180,60}}, color={255,0,255}));
  connect(not1.y, cooOnl.u2) annotation (Line(points={{12,-20},{20,-20},{20,-28},
          {48,-28}}, color={255,0,255}));
  connect(reqHea, swi4.u2) annotation (Line(points={{-180,80},{-140,80},{-140,
          -60},{40,-60},{40,-80},{70,-80}}, color={255,0,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
       Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-360},{160,
            100}}),
        graphics={
       Rectangle(
        extent={{224,30},{544,-230}},
        lineThickness=0.5,
        fillColor={218,244,206},
        fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
       Rectangle(
        extent={{268,106},{588,24}},
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
       Text(
        extent={{374,112},{484,88}},
        lineColor={0,0,255},
        fillColor={215,215,215},
        fillPattern=FillPattern.None,
          textString="Chiller operating mode"),
       Text(
        extent={{222,-182},{444,-190}},
        lineColor={0,0,255},
        fillColor={215,215,215},
        fillPattern=FillPattern.None,
          textString="Reset of water setpoint temperature"),
       Text(
        extent={{296,-276},{482,-284}},
        lineColor={0,0,255},
        fillColor={215,215,215},
        fillPattern=FillPattern.None,
          textString="Evaporator and Condenser three-way valves control")}),
        defaultComponentName="chiCon",
Documentation(info="<html>
<p>
The block computes the control signals for
</p>
<h4>EIR Chiller status</h4>
<p>
The chiller compressor is constant speed and switched on or off based on either <code>reqHea</code> or
<code>reqCoo</code> is true, the controller outputs the integer output
<code>ychiMod</code> =1 to switch on the chiller compressor.
</p>
<h4>Three way valve at the evaporator inlet</h4>
<p>
The three way valve at the inlet stream of the evaporator side is controlled with
a P or PI controller to track a constant, maximum water inlet temperature.
</p>
<h4>Three way valve at the condenser inlet</h4>
<p>
The three way valve at the inlet stream of the condenser side is controlled with
a P or PI controller to track a constant, minimum water inlet temperature.
</p>
<p>
The block in addition, resets <code>TSetCoo</code> based on the thermal operational 
mode i.e. cooling only, heating only or
simultaneous heating and cooling.
</p>
<h4>Reset of Chilled water setpoint temperature</h4>
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
