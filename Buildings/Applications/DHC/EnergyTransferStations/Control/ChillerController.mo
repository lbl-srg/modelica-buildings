within Buildings.Applications.DHC.EnergyTransferStations.Control;
model ChillerController
  "The control block of the EIR chiller with constant speed compressor."

     extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqCoo
    "Cooling is required Boolean signal" annotation (Placement(transformation(
          extent={{-128,62},{-100,90}}), iconTransformation(extent={{-128,40},{
            -100,68}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqHea
    "Heating is required Boolean signal"
    annotation (Placement(transformation(extent={{-128,32},{-100,60}}),
        iconTransformation(extent={{-128,76},{-100,104}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHea(final unit="K",
      displayUnit="degC") "Setpoint for heating supply water to space loads"
                                                       annotation (Placement(transformation(extent={{-128,
            -160},{-100,-132}}),
                     iconTransformation(extent={{-120,0},{-100,20}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-46,44},{-26,64}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch
                                            logSwi
    annotation (Placement(transformation(extent={{2,44},{22,64}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiON(k=true)
    "chiller turn on signal"
    annotation (Placement(transformation(extent={{-46,74},{-26,94}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOff(k=false)
    "Chiller shut off signal =0"
    annotation (Placement(transformation(extent={{-46,18},{-26,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ychiMod
    "Chiller operational mode." annotation (Placement(transformation(extent={{
            102,44},{122,64}}), iconTransformation(extent={{100,-2},{128,26}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetChi(final unit="K",
      displayUnit="degC") "Setpoint temperture for the chiller"
                                                               annotation (
      Placement(transformation(extent={{100,-18},{120,2}}), iconTransformation(
          extent={{100,32},{128,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{70,-18},{90,2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConLvg(final
     unit="K", displayUnit="degC")
   "Condenser leaving water temperature"  annotation (Placement(
        transformation(extent={{-128,-204},{-100,-176}}), iconTransformation(
          extent={{-120,-94},{-100,-74}})));
  Modelica.Blocks.Logical.And simHeaCoo
   "Simultaneous heating and cooling mode"
    annotation (Placement(transformation(extent={{-60,-88},{-40,-68}})));
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
    annotation (Placement(transformation(extent={{-58,-172},{-38,-152}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun
    "Mapping control function to reset the TsetHea"
    annotation (Placement(transformation(extent={{2,-148},{22,-128}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(k=0)
    "PI minimum error"
    annotation (Placement(transformation(extent={{-34,-118},{-14,-98}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(k=1)
    "PI maximum error"
    annotation (Placement(transformation(extent={{-28,-202},{-8,-182}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCooMin(final
      unit="K",
      displayUnit="degC") "Minimum setpoint for chilled water." annotation (
      Placement(transformation(extent={{-128,-228},{-100,-200}}),
        iconTransformation(extent={{-120,-22},{-100,-2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCoo(final
      unit="K",
      displayUnit="degC")
   "Setpoint for cooling supply water to space loads"
    annotation (Placement(transformation(extent={{-128,-14},{-100,14}}),
        iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    annotation (Placement(transformation(extent={{40,-102},{60,-82}})));
  Modelica.Blocks.Logical.Or heaOnl "Heating only mode"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X3(k=10 + 273.15)
    "Minimum heating setpoint temperature"
    annotation (Placement(transformation(extent={{-2,-216},{18,-196}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-48,-36},{-28,-16}})));
  Modelica.Blocks.Logical.And cooOnl "Cooling only mode"
    annotation (Placement(transformation(extent={{-2,-28},{18,-8}})));
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
    annotation (Placement(transformation(extent={{32,-270},{52,-250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaEnt(final
      unit="K",
      displayUnit="degC")
   "Evaporator entering water temperature" annotation (
      Placement(transformation(extent={{-128,-302},{-100,-274}}),
        iconTransformation(extent={{-120,-76},{-100,-56}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxEvaEnt(final
      unit="K",
      displayUnit="degC") "Maximum evaporator entering water temperature"
    annotation (Placement(transformation(extent={{-128,-274},{-100,-246}}),
        iconTransformation(extent={{-120,-56},{-100,-36}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva
    "Control signal of the modulating three way valve to maintain the evaporator entering temperature below the maximum value."
    annotation (Placement(transformation(extent={{100,-270},{120,-250}}),
        iconTransformation(extent={{100,-78},{128,-50}})));
  Buildings.Controls.Continuous.LimPID valCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 100,
    reverseAction=true) "Condenser three way valve PI control signal "
    annotation (Placement(transformation(extent={{30,-322},{50,-302}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConEnt(final
      unit="K",
      displayUnit="degC")
    "Condenser entering water temperature" annotation (
      Placement(transformation(extent={{-126,-354},{-98,-326}}),
        iconTransformation(extent={{-120,-108},{-100,-88}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMinConEnt(final
      unit="K",
      displayUnit="degC")
   "Minimum condenser entering water temperature"
    annotation (Placement(transformation(extent={{-126,-326},{-98,-298}}),
        iconTransformation(extent={{-120,-38},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Control signal of the modulating three way valve to maintain the condenser entering temperature above the minimum value."
    annotation (Placement(transformation(extent={{102,-322},{122,-302}}),
        iconTransformation(extent={{100,-54},{128,-26}})));
equation

  connect(reqHea, or1.u2)
    annotation (Line(points={{-114,46},{-48,46}}, color={255,0,255}));
  connect(reqCoo, or1.u1) annotation (Line(points={{-114,76},{-56,76},{-56,54},
          {-48,54}}, color={255,0,255}));
  connect(or1.y, logSwi.u2)
    annotation (Line(points={{-25,54},{0,54}}, color={255,0,255}));
  connect(swi2.y, TSetChi)
    annotation (Line(points={{92,-8},{110,-8}}, color={0,0,127}));
  connect(reqHea, simHeaCoo.u2) annotation (Line(points={{-114,46},{-84,46},{
          -84,-86},{-62,-86}}, color={255,0,255}));
  connect(reqCoo, simHeaCoo.u1) annotation (Line(points={{-114,76},{-70,76},{-70,
          -78},{-62,-78}}, color={255,0,255}));
  connect(PI.u_s,TSetHea)
    annotation (Line(points={{-60,-162},{-78,-162},{-78,-146},{-114,-146}},
                                                    color={0,0,127}));
  connect(X1.y, mapFun.x1) annotation (Line(points={{-12,-108},{-12,-130},{0,
          -130}},     color={0,0,127}));
  connect(PI.y, mapFun.u)
    annotation (Line(points={{-37,-162},{-12,-162},{-12,-138},{0,-138}},
                                                   color={0,0,127}));
  connect(TSetCooMin, mapFun.f2) annotation (Line(points={{-114,-214},{-4,-214},
          {-4,-146},{0,-146}},  color={0,0,127}));
  connect(X2.y, mapFun.x2) annotation (Line(points={{-6,-192},{-6,-142},{0,-142}},
                      color={0,0,127}));
  connect(TConLvg, PI.u_m) annotation (Line(points={{-114,-190},{-48,-190},{-48,
          -174}}, color={0,0,127}));
  connect(TSetCoo, mapFun.f1) annotation (Line(points={{-114,1.77636e-15},{-96,
          1.77636e-15},{-96,-134},{0,-134}}, color={0,0,127}));
  connect(heaOnl.y, swi4.u2) annotation (Line(points={{1,-70},{24,-70},{24,-92},
          {38,-92}}, color={255,0,255}));
  connect(simHeaCoo.y,heaOnl. u2)
    annotation (Line(points={{-39,-78},{-22,-78}}, color={255,0,255}));
  connect(reqHea,heaOnl. u1) annotation (Line(points={{-114,46},{-84,46},{-84,
          -60},{-30,-60},{-30,-70},{-22,-70}}, color={255,0,255}));
  connect(reqHea, PI.trigger) annotation (Line(points={{-114,46},{-84,46},{-84,
          -184},{-56,-184},{-56,-174}}, color={255,0,255}));
  connect(mapFun.y, swi4.u1) annotation (Line(points={{24,-138},{32,-138},{32,
          -84},{38,-84}}, color={0,0,127}));
  connect(X3.y, swi4.u3) annotation (Line(points={{20,-206},{36,-206},{36,-100},
          {38,-100}}, color={0,0,127}));
  connect(swi4.y, swi2.u3) annotation (Line(points={{62,-92},{66,-92},{66,-16},
          {68,-16}},                   color={0,0,127}));
  connect(TSetCoo, swi2.u1) annotation (Line(points={{-114,1.77636e-15},{-34,
          1.77636e-15},{-34,0},{68,0}}, color={0,0,127}));
  connect(reqHea, not1.u) annotation (Line(points={{-114,46},{-84,46},{-84,-26},
          {-50,-26}}, color={255,0,255}));
  connect(not1.y,cooOnl. u2) annotation (Line(points={{-26,-26},{-4,-26}},
                          color={255,0,255}));
  connect(reqCoo, cooOnl.u1) annotation (Line(points={{-114,76},{-70,76},{-70,-4},
          {-12,-4},{-12,-18},{-4,-18}}, color={255,0,255}));
  connect(cooOnl.y, swi2.u2) annotation (Line(points={{19,-18},{36,-18},{36,-8},
          {68,-8}}, color={255,0,255}));
  connect(TMaxEvaEnt, valEva.u_s)
    annotation (Line(points={{-114,-260},{30,-260}}, color={0,0,127}));
  connect(TEvaEnt, valEva.u_m) annotation (Line(points={{-114,-288},{42,-288},{
          42,-272}}, color={0,0,127}));
  connect(valEva.y, yValEva)
    annotation (Line(points={{53,-260},{110,-260}}, color={0,0,127}));
  connect(TMinConEnt, valCon.u_s)
    annotation (Line(points={{-112,-312},{28,-312}}, color={0,0,127}));
  connect(TConEnt, valCon.u_m) annotation (Line(points={{-112,-340},{40,-340},{
          40,-324}}, color={0,0,127}));
  connect(valCon.y, yValCon)
    annotation (Line(points={{51,-312},{112,-312}}, color={0,0,127}));
  connect(or1.y, valEva.trigger) annotation (Line(
      points={{-25,54},{-10,54},{-10,26},{26,26},{26,-280},{34,-280},{34,-272}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(or1.y, valCon.trigger) annotation (Line(
      points={{-25,54},{-10,54},{-10,26},{26,26},{26,-336},{32,-336},{32,-324}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(logSwi.y, ychiMod)
    annotation (Line(points={{24,54},{112,54}}, color={255,0,255}));
  connect(chiON.y, logSwi.u1) annotation (Line(points={{-24,84},{-14,84},{-14,
          62},{0,62}}, color={255,0,255}));
  connect(chiOff.y, logSwi.u3) annotation (Line(points={{-24,28},{-16,28},{-16,
          46},{0,46}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-360},{100,
            100}}),
        graphics={
        Rectangle(
          extent={{-100,8},{100,-234}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={218,244,206},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,102},{100,20}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-14,106},{96,82}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="Chiller operational mode"),
        Text(
          extent={{-110,-224},{34,-232}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="Reset of water setpoint temperature"),
        Text(
          extent={{-86,-352},{100,-360}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="Evaporator and Condenser three way valves control")}),
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
The block in addition, resets <code>TSetCoo</code> based on the thermal operational mode i.e. cooling only, heating only or
simultaneous heating and cooling.
</p>
<h4>Reset of Chilled water setpoint temperature</h4>
<p>
As shown in the control scheme below and during
</p>
<ol>
  <li>
  simultaneous heating and cooling and heating only operational modes, the control sequence resets the cooling setpoint <code>TReSetCoo</code> till the leaving heating water temperature
  from the condenser side meets the heating setpoint <code>TSetHea</code>
  <p align=\"center\">
  <img alt=\"Image PI controller to reset the TSetCoo\"
  src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/chillerControlDiagram.png\"/>
  </p align=\"center\">
  <p>
  The required decrement in <code>TSetCoo</code> is estimated by a reverse acting PI loop , with a reference set point of <code>TSetHea</code>
  and measured temperature value of <code>TConLvg</code>. Hence, when the condenser leaving water temperature is lower than <code>TSetHea</code>,
  TSetCoo is decreased. The control mapping function is shown in
  </p>
  <p align=\"center\">
  <img alt=\"Image Control Mapping function of resetting TsetCoo\"
  src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/chillerMappingFunction.png\"/>
  </p align=\"center\">
  </li>
  <li>
  cooling only operational mode, the leaving water form the chiller evaporator side tracks the cooling setpoint <code>TSetCoo</code>
  and the leaving water from the condenser floats depending on the entering water temperature and flow rate.
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
end ChillerController;
