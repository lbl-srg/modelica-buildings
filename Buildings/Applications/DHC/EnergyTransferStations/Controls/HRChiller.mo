within Buildings.Applications.DHC.EnergyTransferStations.Controls;
model HRChiller "Heat recovery chiller controller"

  extends Modelica.Blocks.Icons.Block;

   Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetConLvg(final unit="K",
      displayUnit="degC") "Setpoint for condenser water leaving temperature"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCoo(final
      unit="K",
      displayUnit="degC")
    "Setpoint for cooling supply water to space loads"
     annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCooMin(final
      unit="K",
      displayUnit="degC")
    "Minimum setpoint for chilled water."
     annotation (Placement(transformation(extent={{-200,-240},{-160,-200}}),
                    iconTransformation(extent={{-140,-10},{-100,30}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TConLvg(final
     unit="K",
     displayUnit="degC")
   "Condenser leaving water temperature"
     annotation (Placement(
        transformation(extent={{-200,-200},{-160,-160}}), iconTransformation(
          extent={{-140,-90},{-100,-50}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEnt(final
      unit="K",
      displayUnit="degC")
    "Condenser entering water temperature"
     annotation (
      Placement(transformation(extent={{-202,-368},{-160,-326}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TMinConEnt(final
      unit="K",
      displayUnit="degC")
   "Minimum condenser entering water temperature"
     annotation (Placement(transformation(extent={{-200,-340},{-160,-300}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaEnt(final
      unit="K",
      displayUnit="degC")
   "Evaporator entering water temperature"
     annotation (
      Placement(transformation(extent={{-200,-314},{-160,-274}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxEvaEnt(final
      unit="K",
      displayUnit="degC")
    "Maximum evaporator entering water temperature"
     annotation (Placement(transformation(extent={{-200,-280},{-160,-240}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
   Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqCoo
    "Cooling is required Boolean signal"
     annotation (Placement(transformation(
          extent={{-200,60},{-160,100}}),iconTransformation(extent={{-140,50},{
            -100,90}})));
   Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqHea
    "Heating is required Boolean signal"
     annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetChi(final
      unit="K",
      displayUnit="degC")
    "Setpoint temperture for the chiller"
     annotation (
      Placement(transformation(extent={{160,-20},{200,20}}),iconTransformation(
          extent={{100,40},{140,80}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Control signal of the modulating three way valve to maintain the condenser 
      entering temperature above the minimum value."
     annotation (Placement(transformation(extent={{160,-340},{200,-300}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
   Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva
    "Control signal of the modulating three way valve to maintain the evaporator
      entering temperature below the maximum value."
     annotation (Placement(transformation(extent={{160,-280},{200,-240}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
   Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiMod
    "Chiller operational mode."
     annotation (Placement(transformation(extent={{160,40},{200,80}}),
         iconTransformation(extent={{100,-20},{140,20}})));

   Buildings.Controls.OBC.CDL.Logical.Or or2
     annotation (Placement(transformation(extent={{-106,44},{-86,64}})));
   Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
     annotation (Placement(transformation(extent={{100,50},{120,70}})));
   Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiON(k=true)
    "chiller turn on signal"
    annotation (Placement(transformation(extent={{-106,74},{-86,94}})));
   Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOff(k=false)
    "Chiller shut off signal =0"
     annotation (Placement(transformation(extent={{-106,18},{-86,38}})));
   Buildings.Controls.OBC.CDL.Logical.Switch swi2
     annotation (Placement(transformation(extent={{100,-10},{120,10}})));
   Buildings.Controls.OBC.CDL.Logical.And simHeaCoo
   "Simultaneous heating and cooling mode"
     annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
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
     annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
   Buildings.Controls.OBC.CDL.Continuous.Line mapFun
    "Mapping control function to reset the TsetHea"
     annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(k=0)
    "PI minimum error"
     annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(k=1)
    "PI maximum error"
     annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
   Buildings.Controls.OBC.CDL.Logical.Switch swi4
     annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
   Buildings.Controls.OBC.CDL.Logical.Or heaOnl
    "Heating only mode"
     annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X3(k=10 + 273.15)
    "Minimum heating setpoint temperature"
     annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
   Buildings.Controls.OBC.CDL.Logical.Not not1
     annotation (Placement(transformation(extent={{-108,-36},{-88,-16}})));
   Buildings.Controls.OBC.CDL.Logical.And cooOnl
   "Cooling only mode"
     annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
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
    annotation (Placement(transformation(extent={{-30,-270},{-10,-250}})));
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
     annotation (Placement(transformation(extent={{-30,-330},{-10,-310}})));

equation
  connect(reqHea,or2. u2)  annotation (Line(points={{-180,40},{-144,40},{-144,
          46},{-108,46}},                                                color={255,0,255}));
  connect(reqCoo,or2. u1) annotation (Line(points={{-180,80},{-116,80},{-116,54},
          {-108,54}},color={255,0,255}));
  connect(or2.y, logSwi.u2) annotation (Line(points={{-84,54},{-72,54},{-72,60},
          {98,60}},                                                    color={255,0,255}));
  connect(swi2.y, TSetChi) annotation (Line(points={{122,0},{180,0}},  color={0,0,127}));
  connect(reqHea, simHeaCoo.u2) annotation (Line(points={{-180,40},{-144,40},{
          -144,-88},{-122,-88}},
                               color={255,0,255}));
  connect(reqCoo, simHeaCoo.u1) annotation (Line(points={{-180,80},{-130,80},{
          -130,-80},{-122,-80}},
                           color={255,0,255}));
  connect(PI.u_s, TSetConLvg)
    annotation (Line(points={{-122,-140},{-180,-140}}, color={0,0,127}));
  connect(X1.y, mapFun.x1) annotation (Line(points={{-18,-100},{-18,-132},{-12,
          -132}},     color={0,0,127}));
  connect(PI.y, mapFun.u)  annotation (Line(points={{-99,-140},{-12,-140}},
                                                   color={0,0,127}));
  connect(TSetCooMin, mapFun.f2) annotation (Line(points={{-180,-220},{-14,-220},
          {-14,-148},{-12,-148}},
                                color={0,0,127}));
  connect(X2.y, mapFun.x2) annotation (Line(points={{-18,-180},{-18,-144},{-12,
          -144}},     color={0,0,127}));
  connect(TConLvg, PI.u_m) annotation (Line(points={{-180,-180},{-110,-180},{
          -110,-152}},
                  color={0,0,127}));
  connect(TSetCoo, mapFun.f1) annotation (Line(points={{-180,-40},{-106,-40},{
          -106,-136},{-12,-136}},            color={0,0,127}));
  connect(heaOnl.y, swi4.u2) annotation (Line(points={{-58,-80},{14,-80},{14,
          -98},{28,-98}},
                     color={255,0,255}));
  connect(simHeaCoo.y,heaOnl. u2) annotation (Line(points={{-98,-80},{-90,-80},
          {-90,-88},{-82,-88}},                                                  color={255,0,255}));
  connect(reqHea,heaOnl. u1) annotation (Line(points={{-180,40},{-144,40},{-144,
          -60},{-90,-60},{-90,-80},{-82,-80}}, color={255,0,255}));
  connect(reqHea, PI.trigger) annotation (Line(points={{-180,40},{-144,40},{
          -144,-172},{-118,-172},{-118,-152}},
                                        color={255,0,255}));
  connect(mapFun.y, swi4.u1) annotation (Line(points={{12,-140},{22,-140},{22,
          -90},{28,-90}}, color={0,0,127}));
  connect(X3.y, swi4.u3) annotation (Line(points={{12,-200},{26,-200},{26,-106},
          {28,-106}}, color={0,0,127}));
  connect(swi4.y, swi2.u3) annotation (Line(points={{52,-98},{56,-98},{56,-8},{
          98,-8}},                     color={0,0,127}));
  connect(TSetCoo, swi2.u1) annotation (Line(points={{-180,-40},{-94,-40},{-94,
          8},{98,8}},                   color={0,0,127}));
  connect(reqHea, not1.u) annotation (Line(points={{-180,40},{-144,40},{-144,
          -26},{-110,-26}},
                      color={255,0,255}));
  connect(not1.y,cooOnl. u2) annotation (Line(points={{-86,-26},{-72,-26},{-72,
          -28},{-42,-28}},color={255,0,255}));
  connect(reqCoo, cooOnl.u1) annotation (Line(points={{-180,80},{-130,80},{-130,
          -4},{-72,-4},{-72,-20},{-42,-20}},
                                        color={255,0,255}));
  connect(cooOnl.y, swi2.u2) annotation (Line(points={{-18,-20},{40,-20},{40,0},
          {98,0}},  color={255,0,255}));
  connect(TMaxEvaEnt, valEva.u_s) annotation (Line(points={{-180,-260},{-32,
          -260}},                                                                  color={0,0,127}));
  connect(TEvaEnt, valEva.u_m) annotation (Line(points={{-180,-294},{-20,-294},
          {-20,-272}},
                     color={0,0,127}));
  connect(valEva.y, yValEva) annotation (Line(points={{-9,-260},{180,-260}}, color={0,0,127}));
  connect(TMinConEnt, valCon.u_s) annotation (Line(points={{-180,-320},{-32,
          -320}},                                                                  color={0,0,127}));
  connect(TConEnt, valCon.u_m) annotation (Line(points={{-181,-347},{-20,-347},
          {-20,-332}},
                     color={0,0,127}));
  connect(valCon.y, yValCon) annotation (Line(points={{-9,-320},{180,-320}}, color={0,0,127}));
  connect(or2.y, valEva.trigger) annotation (Line(
      points={{-84,54},{-60,54},{-60,-286},{-28,-286},{-28,-272}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(or2.y, valCon.trigger) annotation (Line(
      points={{-84,54},{-60,54},{-60,-340},{-28,-340},{-28,-332}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(logSwi.y,yChiMod) annotation (Line(points={{122,60},{180,60}},color={255,0,255}));
  connect(chiON.y, logSwi.u1) annotation (Line(points={{-84,84},{-74,84},{-74,
          68},{98,68}},color={255,0,255}));
  connect(chiOff.y, logSwi.u3) annotation (Line(points={{-84,28},{-76,28},{-76,
          52},{98,52}},color={255,0,255}));

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
end HRChiller;
