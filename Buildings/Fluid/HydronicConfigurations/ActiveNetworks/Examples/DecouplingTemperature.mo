within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model DecouplingTemperature
  "Model illustrating the operation of a decoupling circuit with Delta-T control"
  extends
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.Decoupling(
      con(typCtl=Buildings.Fluid.HydronicConfigurations.Types.Control.None,
          dpBal3_nominal=0));

  parameter Boolean is_cor = false
    "Set to true to correct Delta-T set point for low load operation"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Reals.Subtract dT(
    y(final unit="K")) "Compute T1Ret-T2Ret"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-40})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTSetVal[3](final k={1,
        if typ == Types.Control.Heating then 1 else -1,1})
    "Delta-T set point values"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor dTSetAct(
    y(final unit="K"), final nin=3)
                       "Select actual set point based on operating mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={140,-30})));
  Controls.PIDWithOperatingMode ctl(
    k=0.1,
    Ti=120,
    u_s(final unit="K", displayUnit="K"),
    u_m(final unit="K", displayUnit="K"),
    final reverseActing=typ == Buildings.Fluid.HydronicConfigurations.Types.Control.Heating)
    "Controller"
    annotation (Placement(transformation(extent={{130,-70},{150,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dT2SupRet(y(final unit="K"))
    "Compute T2Sup-T2Ret" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-120})));
  Modelica.Blocks.Sources.RealExpression T2Ret(y=con.T2Ret.T)
    "Access T2Ret measurement from connection component"
    annotation (Placement(transformation(extent={{30,-56},{50,-36}})));
  Modelica.Blocks.Sources.RealExpression T2Sup(y=con.T2Sup.T)
    "Access T2Sup measurement from connection component"
    annotation (Placement(transformation(extent={{30,-124},{50,-104}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxDelT(y(final unit="K"))
    "Compute max(T2Sup-T2Ret, dTSet) for cooling mode" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-100})));
  Buildings.Controls.OBC.CDL.Reals.Min minDelT(y(final unit="K"))
    "Compute min(T2Sup-T2Ret, dTSet) for heating mode" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-140})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor dTSetCor(
    y(final unit="K"), final nin=3)
                       if is_cor
    "Delta-T set point corrected for low load operation" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={140,-120})));
  Modelica.Blocks.Routing.RealPassThrough dTSetUnc if not is_cor
    "Delta-T set point uncorrected"
    annotation (Placement(transformation(extent={{170,-40},{190,-20}})));
equation

  connect(T1ConRet.T, dT.u1) annotation (Line(points={{31,-20},{50,-20},{50,-34},
          {58,-34}}, color={0,0,127}));
  connect(dT.y, ctl.u_m) annotation (Line(points={{82,-40},{88,-40},{88,-78},{140,
          -78},{140,-72}},     color={0,0,127}));
  connect(dTSetVal.y, dTSetAct.u)
    annotation (Line(points={{122,-30},{128,-30}}, color={0,0,127}));
  connect(ctl.y, con.yVal) annotation (Line(points={{152,-60},{160,-60},{160,-8},
          {-10,-8},{-10,10},{-2,10}},       color={0,0,127}));
  connect(mode.y[1], ctl.mode) annotation (Line(points={{-118,80},{162,80},{162,
          -80},{134,-80},{134,-72}}, color={255,127,0}));
  connect(T2Ret.y, dT.u2)
    annotation (Line(points={{51,-46},{58,-46}}, color={0,0,127}));
  connect(T2Sup.y, dT2SupRet.u1)
    annotation (Line(points={{51,-114},{58,-114}}, color={0,0,127}));
  connect(T2Ret.y, dT2SupRet.u2) annotation (Line(points={{51,-46},{54,-46},{54,
          -126},{58,-126}}, color={0,0,127}));
  connect(dT2SupRet.y, maxDelT.u2) annotation (Line(points={{82,-120},{86,-120},
          {86,-106},{98,-106}}, color={0,0,127}));
  connect(dT2SupRet.y, minDelT.u1) annotation (Line(points={{82,-120},{86,-120},
          {86,-134},{98,-134}}, color={0,0,127}));
  connect(dTSetAct.y, maxDelT.u1) annotation (Line(points={{152,-30},{154,-30},{
          154,-46},{90,-46},{90,-94},{98,-94}},   color={0,0,127}));
  connect(dTSetAct.y, minDelT.u2) annotation (Line(points={{152,-30},{154,-30},{
          154,-46},{90,-46},{90,-146},{98,-146}}, color={0,0,127}));
  connect(dTSetCor.y, ctl.u_s) annotation (Line(points={{152,-120},{160,-120},{160,
          -90},{124,-90},{124,-60},{128,-60}}, color={0,0,127}));
  connect(dTSetAct.y, dTSetUnc.u)
    annotation (Line(points={{152,-30},{168,-30}}, color={0,0,127}));
  connect(dTSetUnc.y, ctl.u_s) annotation (Line(points={{191,-30},{196,-30},{196,
          -90},{124,-90},{124,-60},{128,-60}}, color={0,0,127}));
  connect(addPar.y, dTSetAct.index) annotation (Line(points={{-160,48},{-160,-12},
          {140,-12},{140,-18}}, color={255,127,0}));
  connect(addPar.y, dTSetCor.index) annotation (Line(points={{-160,48},{-160,-160},
          {140,-160},{140,-132}}, color={255,127,0}));
  connect(maxDelT.y, dTSetCor.u[2]) annotation (Line(points={{122,-100},{124,-100},
          {124,-120},{128,-120}}, color={0,0,127}));
  connect(minDelT.y, dTSetCor.u[3]) annotation (Line(points={{122,-140},{124,
          -140},{124,-119.333},{128,-119.333}},
                                          color={0,0,127}));
  connect(dT2SupRet.y, dTSetCor.u[1]) annotation (Line(points={{82,-120},{106,
          -120},{106,-120.667},{128,-120.667}},
                                          color={0,0,127}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DecouplingTemperature.mos"
    "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{200,
            180}})),
    Documentation(info="<html>
<p>
This example is similar to
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.Decoupling\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.Decoupling</a>
except that an alternative control logic is implemented,
based on the measurement of the return temperature in the consumer circuit
and in the primary branch.
</p>
<p>
<img alt=\"Decoupling circuit schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DecouplingTemperature.png\"/>
</p>
<p>
This control logic intends to keep constant the difference between those two
measurements. 
Considering that we have:
<i>T<sub>1, ret</sub> - T<sub>2, ret</sub> =
(m&#775;<sub>1</sub> - m&#775;<sub>2</sub>) / m&#775;<sub>1</sub> *
(T<sub>1, sup</sub> - T<sub>2, ret</sub>)</i>,
the control objective can be expressed based on the
set point <i>&Delta;T<sub>set</sub></i> and the consumer circuit
temperature differential <i>&Delta;T<sub>2</sub></i>
(<i>&Delta;T<sub>2</sub> = T<sub>2, sup</sub> - T<sub>2, ret</sub> =
T<sub>1, sup</sub> - T<sub>2, ret</sub></i>)
as:
<i>&Delta;T<sub>set</sub> =
(m&#775;<sub>1</sub> - m&#775;<sub>2</sub>) / m&#775;<sub>1</sub> *
&Delta;T<sub>2</sub></i>.
For consumer circuits that have a temperature differential
relatively constant (see for instance
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.ThrottleOpenLoop\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.ThrottleOpenLoop</a>),
the control logic will thus maintain a
nearly constant fraction of primary flow recirculation.
However, at very low load if <i>&Delta;T<sub>2</sub></i> value
drops (due for instance to a secondary flow recirculation
ensuring a minimum flow for the secondary pump) the
control valve will be fully open, and the primary pump speed
potentially maxed out, trying to compensate for the vanishing
<i>&Delta;T<sub>2</sub></i>.
In other words, taking the example of a heating circuit, at low
load the control logic cannot infer that the low
value of <i>T<sub>1, ret</sub> - T<sub>2, ret</sub></i> is due
to a consumer circuit return temperature that is too high
(as it tends towards the supply temperature).
It will work under the assumption that <i>T<sub>1, ret</sub></i>
is too low, and open the control valve to try and increase the
primary flow recirculation.
This flawed control is showcased in this example when the parameter
<code>is_cor</code> is set to <code>false</code> (the default), see
plots #1 and #2 between <i>14</i> and <i>16</i>&nbsp;h.
</p>
<p>
Now setting <code>is_cor</code> to <code>true</code>, a correction
is used to counteract this low load effect
by limiting the set point to the consumer circuit temperature differential
<i>&Delta;T<sub>2</sub></i>.
Note that the implementation of that correction is specific to
a change-over operation and needs to be adapted for heating-only
or cooling-only applications.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end DecouplingTemperature;
