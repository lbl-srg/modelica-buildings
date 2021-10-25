within Buildings.Examples.VAVReheat.BaseClasses;
model ASHRAE2006
  "Variable air volume flow system with terminal reheat and ASHRAE 2006 control sequence serving five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC(amb(nPorts=3));

  parameter Real ratVMinCor_flow(final unit="1")=
    max(1.5*VCorOA_flow_nominal, 0.15*mCor_flow_nominal/1.2) /
    (mCor_flow_nominal/1.2)
    "Minimum discharge air flow rate ratio";
  parameter Real ratVMinSou_flow(final unit="1")=
    max(1.5*VSouOA_flow_nominal, 0.15*mSou_flow_nominal/1.2) /
    (mSou_flow_nominal/1.2)
    "Minimum discharge air flow rate ratio";
  parameter Real ratVMinEas_flow(final unit="1")=
    max(1.5*VEasOA_flow_nominal, 0.15*mEas_flow_nominal/1.2) /
    (mEas_flow_nominal/1.2)
    "Minimum discharge air flow rate ratio";
  parameter Real ratVMinNor_flow(final unit="1")=
    max(1.5*VNorOA_flow_nominal, 0.15*mNor_flow_nominal/1.2) /
    (mNor_flow_nominal/1.2)
    "Minimum discharge air flow rate ratio";
  parameter Real ratVMinWes_flow(final unit="1")=
    max(1.5*VWesOA_flow_nominal, 0.15*mWes_flow_nominal/1.2) /
    (mWes_flow_nominal/1.2)
    "Minimum discharge air flow rate ratio";

  Controls.FanVFD conFanSup(xSet_nominal(displayUnit="Pa") = 410, r_N_min=
        yFanMin)
    "Controller for fan"
    annotation (Placement(transformation(extent={{240,-10},{260,10}})));
  Controls.ModeSelector modeSelector
    annotation (Placement(transformation(extent={{-200,-320},{-180,-300}})));
  Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-250,-352},{-230,-332}}),
        iconTransformation(extent={{-162,-100},{-142,-80}})));

  Controls.Economizer conEco(
    have_reset=true,
    have_frePro=true,
    VOut_flow_min=Vot_flow_nominal)
           "Controller for economizer"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Controls.RoomTemperatureSetpoint TSetRoo(
    final THeaOn=THeaOn,
    final THeaOff=THeaOff,
    final TCooOn=TCooOn,
    final TCooOff=TCooOff)
    annotation (Placement(transformation(extent={{-300,-358},{-280,-338}})));
  Controls.DuctStaticPressureSetpoint pSetDuc(
    nin=5,
    pMin=50) "Duct static pressure setpoint"
    annotation (Placement(transformation(extent={{160,-16},{180,4}})));
  Controls.RoomVAV conVAVCor(ratVFloMin=ratVMinCor_flow, ratVFloHea=ratVFloHea)
    "Controller for terminal unit corridor"
    annotation (Placement(transformation(extent={{456,-124},{476,-104}})));
  Controls.RoomVAV conVAVSou(ratVFloMin=ratVMinSou_flow, ratVFloHea=ratVFloHea)
                             "Controller for terminal unit south"
    annotation (Placement(transformation(extent={{638,-124},{658,-104}})));
  Controls.RoomVAV conVAVEas(ratVFloMin=ratVMinEas_flow, ratVFloHea=ratVFloHea)
                             "Controller for terminal unit east"
    annotation (Placement(transformation(extent={{822,-124},{842,-104}})));
  Controls.RoomVAV conVAVNor(ratVFloMin=ratVMinNor_flow, ratVFloHea=ratVFloHea)
                             "Controller for terminal unit north"
    annotation (Placement(transformation(extent={{996,-124},{1016,-104}})));
  Controls.RoomVAV conVAVWes(ratVFloMin=ratVMinWes_flow, ratVFloHea=ratVFloHea)
                             "Controller for terminal unit west"
    annotation (Placement(transformation(extent={{1186,-124},{1206,-104}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));
  Controls.SupplyAirTemperature conTSup
    "Supply air temperature and economizer controller"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  Controls.SupplyAirTemperatureSetpoint TSupSet
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExh(
    from_dp=false,
    riseTime=15,
    dpFixed_nominal=5,
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dpDamper_nominal=5)  "Exhaust air damper"
    annotation (Placement(transformation(extent={{-30,-20},{-50,0}})));
  Controls.SystemHysteresis sysHysHea
    "Hysteresis and delay to switch heating on and off"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  Controls.SystemHysteresis sysHysCoo
    "Hysteresis and delay to switch cooling on and off"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFreStaPum
    "Switch for freeze stat of pump"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFreStaVal
    "Switch for freeze stat of valve"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFreHeaCoi(final k=1)
    "Flow rate signal for heating coil when freeze stat is on"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin TRooMin(
    final nin=numZon,
    u(each final unit="K",
      each displayUnit="degC"),
    y(final unit="K",
      displayUnit="degC"))
    "Minimum room temperature"
    annotation (Placement(transformation(extent={{-340,260},{-320,280}})));
  Utilities.Math.Average TRooAve(
    final nin=numZon,
    u(each final unit="K",
      each displayUnit="degC"),
    y(final unit="K",
      displayUnit="degC")) "Average room temperature"
    annotation (Placement(transformation(extent={{-340,230},{-320,250}})));
  Controls.FreezeStat freSta "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(controlBus, modeSelector.cb) annotation (Line(
      points={{-240,-342},{-152,-342},{-152,-303.182},{-196.818,-303.182}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TRooAve.y, controlBus.TRooAve) annotation (Line(
      points={{-319,240},{-240,240},{-240,-342}},
      color={0,0,127}),          Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TRet.T, conEco.TRet) annotation (Line(
      points={{100,151},{100,174},{-94,174},{-94,153.333},{-81.3333,153.333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSetRoo.controlBus, controlBus) annotation (Line(
      points={{-288,-342},{-240,-342}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(dpDisSupFan.p_rel, conFanSup.u_m) annotation (Line(
      points={{311,4.44089e-16},{304,4.44089e-16},{304,-16},{250,-16},{250,-12}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(pSetDuc.y, conFanSup.u) annotation (Line(
      points={{181,-6},{210,-6},{210,0},{238,0}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(conEco.VOut_flow, VOut1.V_flow) annotation (Line(
      points={{-81.3333,142.667},{-90,142.667},{-90,80},{-80,80},{-80,-29}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(conVAVCor.TRoo, TRooAir.y5[1]) annotation (Line(
      points={{455,-121},{452,-121},{452,-120},{440,-120},{440,240},{520,240},{520,
          282},{501,282}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVSou.TRoo, TRooAir.y1[1]) annotation (Line(
      points={{637,-121},{628,-121},{628,298},{501,298}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], conVAVEas.TRoo) annotation (Line(
      points={{501,294},{808,294},{808,-121},{821,-121}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], conVAVNor.TRoo) annotation (Line(
      points={{501,290},{978,290},{978,-121},{995,-121}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], conVAVWes.TRoo) annotation (Line(
      points={{501,286},{1160,286},{1160,-121},{1185,-121}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVCor.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{454,
          -107},{436,-107},{436,-342},{-240,-342}},  color={0,0,127}));
  connect(conVAVCor.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{454,
          -114},{436,-114},{436,-342},{-240,-342}},  color={0,0,127}));
  connect(conVAVSou.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{636,
          -107},{620,-107},{620,-342},{-240,-342}},  color={0,0,127}));
  connect(conVAVSou.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{636,
          -114},{620,-114},{620,-342},{-240,-342}},  color={0,0,127}));
  connect(conVAVEas.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{820,
          -107},{794,-107},{794,-342},{-240,-342}},  color={0,0,127}));
  connect(conVAVEas.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{820,
          -114},{794,-114},{794,-342},{-240,-342}},  color={0,0,127}));
  connect(conVAVNor.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{994,
          -107},{970,-107},{970,-342},{-240,-342}},     color={0,0,127}));
  connect(conVAVNor.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{994,
          -114},{970,-114},{970,-342},{-240,-342}},     color={0,0,127}));
  connect(conVAVWes.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{1184,
          -107},{1142,-107},{1142,-342},{-240,-342}},   color={0,0,127}));
  connect(conVAVWes.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{1184,
          -114},{1142,-114},{1142,-342},{-240,-342}},   color={0,0,127}));

  connect(occSch.tNexOcc, controlBus.dTNexOcc) annotation (Line(
      points={{-299,-204},{-240,-204},{-240,-342}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(occSch.occupied, controlBus.occupied) annotation (Line(
      points={{-299,-216},{-240,-216},{-240,-342}},
      color={255,0,255},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut.y, controlBus.TOut) annotation (Line(points={{-279,180},{-240,180},
          {-240,-342}},                            color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conEco.controlBus, controlBus) annotation (Line(
      points={{-70.6667,141.467},{-70.6667,120},{-240,120},{-240,-342}},
      color={255,204,51},
      thickness=0.5));
  connect(modeSelector.yFan, conFanSup.uFan) annotation (Line(points={{-179.091,
          -305.455},{260,-305.455},{260,-30},{226,-30},{226,6},{238,6}},
                                                                 color={255,0,
          255}));
  connect(conFanSup.y, fanSup.y) annotation (Line(points={{261,0},{280,0},{280,
          -20},{310,-20},{310,-28}}, color={0,0,127}));
  connect(or2.u2, modeSelector.yFan) annotation (Line(points={{-102,-248},{-120,
          -248},{-120,-305.455},{-179.091,-305.455}},
                                     color={255,0,255}));
  connect(cor.y_actual, pSetDuc.u[1]) annotation (Line(points={{612,42},{620,42},
          {620,74},{140,74},{140,-7.6},{158,-7.6}}, color={0,0,127}));
  connect(sou.y_actual, pSetDuc.u[2]) annotation (Line(points={{792,40},{800,40},
          {800,74},{140,74},{140,-6.8},{158,-6.8}}, color={0,0,127}));
  connect(eas.y_actual, pSetDuc.u[3]) annotation (Line(points={{972,40},{980,40},
          {980,74},{140,74},{140,-6},{158,-6}}, color={0,0,127}));
  connect(nor.y_actual, pSetDuc.u[4]) annotation (Line(points={{1132,40},{1140,40},
          {1140,74},{140,74},{140,-5.2},{158,-5.2}},     color={0,0,127}));
  connect(wes.y_actual, pSetDuc.u[5]) annotation (Line(points={{1332,40},{1338,40},
          {1338,74},{140,74},{140,-4.4},{158,-4.4}},     color={0,0,127}));
  connect(TSup.T, conTSup.TSup) annotation (Line(
      points={{340,-29},{352,-29},{352,-188},{-80,-188},{-80,-214},{-62,-214}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conTSup.yOA, conEco.uOATSup) annotation (Line(
      points={{-38,-220},{-28,-220},{-28,-180},{-152,-180},{-152,158.667},{
          -81.3333,158.667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(or2.y, conTSup.uEna) annotation (Line(points={{-78,-240},{-70,-240},{
          -70,-226},{-62,-226}},
                               color={255,0,255}));
  connect(modeSelector.yEco, conEco.uEna) annotation (Line(points={{-179.091,
          -314.545},{-160,-314.545},{-160,100},{-73.3333,100},{-73.3333,137.333}},
        color={255,0,255}));
  connect(TMix.T, conEco.TMix) annotation (Line(points={{40,-29},{40,166},{-90,
          166},{-90,148},{-81.3333,148}}, color={0,0,127}));
  connect(controlBus, TSupSet.controlBus) annotation (Line(
      points={{-240,-342},{-240,-228},{-190,-228}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSupSet.TSet, conTSup.TSupSet)
    annotation (Line(points={{-178,-220},{-62,-220}},color={0,0,127}));
  connect(damRet.y, conEco.yRet) annotation (Line(points={{-12,-10},{-18,-10},{
          -18,146.667},{-58.6667,146.667}},
                                        color={0,0,127}));
  connect(damExh.y, conEco.yOA) annotation (Line(points={{-40,2},{-40,152},{
          -58.6667,152}},
                 color={0,0,127}));
  connect(damOut.y, conEco.yOA) annotation (Line(points={{-40,-28},{-40,-20},{
          -22,-20},{-22,152},{-58.6667,152}},
                                          color={0,0,127}));
  connect(damExh.port_a, TRet.port_b) annotation (Line(points={{-30,-10},{-26,-10},
          {-26,140},{90,140}}, color={0,127,255}));
  connect(cor.yHea, conVAVCor.yVal) annotation (Line(points={{566,48},{504,48},
          {504,-119},{477,-119}}, color={0,0,127}));
  connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,58},{500,58},
          {500,-109.2},{477,-109.2}},
                                  color={0,0,127}));
  connect(sou.yHea, conVAVSou.yVal) annotation (Line(points={{746,46},{686,46},
          {686,-119},{659,-119}}, color={0,0,127}));
  connect(sou.yVAV, conVAVSou.yDam) annotation (Line(points={{746,56},{680,56},
          {680,-109.2},{659,-109.2}},
                                  color={0,0,127}));
  connect(eas.yHea, conVAVEas.yVal) annotation (Line(points={{926,46},{866,46},
          {866,-119},{843,-119}}, color={0,0,127}));
  connect(eas.yVAV, conVAVEas.yDam) annotation (Line(points={{926,56},{860,56},
          {860,-109.2},{843,-109.2}},
                                  color={0,0,127}));
  connect(nor.yHea, conVAVNor.yVal) annotation (Line(points={{1086,46},{1044,46},
          {1044,-119},{1017,-119}}, color={0,0,127}));
  connect(nor.yVAV, conVAVNor.yDam) annotation (Line(points={{1086,56},{1040,56},
          {1040,-109.2},{1017,-109.2}},
                                    color={0,0,127}));
  connect(wes.yHea, conVAVWes.yVal) annotation (Line(points={{1286,46},{1228,46},
          {1228,-119},{1207,-119}}, color={0,0,127}));
  connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,56},{1220,56},
          {1220,-109.2},{1207,-109.2}},
                                    color={0,0,127}));
  connect(freSta.y, or2.u1) annotation (Line(points={{-38,-80},{-20,-80},{-20,-100},
          {-108,-100},{-108,-240},{-102,-240}},
                                   color={255,0,255}));
  connect(conTSup.yHea, sysHysHea.u) annotation (Line(points={{-38,-214},{-32,
          -214},{-32,-140},{-12,-140}},
                                color={0,0,127}));
  connect(conTSup.yCoo, sysHysCoo.u)
    annotation (Line(points={{-38,-226},{-38,-240},{38,-240}},
                                                           color={0,0,127}));
  connect(sysHysCoo.y, valCooCoi.y) annotation (Line(points={{62,-240},{160,-240},
          {160,-210},{208,-210}},       color={0,0,127}));
  connect(sysHysCoo.yPum, pumCooCoi.y) annotation (Line(points={{62,-247},{200,
          -247},{200,-120},{192,-120}}, color={0,0,127}));
  connect(sysHysCoo.sysOn, modeSelector.yFan) annotation (Line(points={{38,-234},
          {20,-234},{20,-305.455},{-179.091,-305.455}}, color={255,0,255}));
  connect(sysHysHea.sysOn, modeSelector.yFan) annotation (Line(points={{-12,
          -134},{-18,-134},{-18,-306},{-98,-306},{-98,-305.455},{-179.091,
          -305.455}}, color={255,0,255}));
  connect(yFreHeaCoi.y, swiFreStaPum.u1) annotation (Line(points={{-118,-120},{
          -80,-120},{-80,-112},{38,-112}}, color={0,0,127}));
  connect(yFreHeaCoi.y, swiFreStaVal.u1) annotation (Line(points={{-118,-120},{
          28,-120},{28,-152},{38,-152}}, color={0,0,127}));
  connect(freSta.y, swiFreStaPum.u2) annotation (Line(points={{-38,-80},{34,-80},
          {34,-120},{38,-120}},      color={255,0,255}));
  connect(freSta.y, swiFreStaVal.u2) annotation (Line(points={{-38,-80},{34,-80},
          {34,-160},{38,-160}},      color={255,0,255}));
  connect(sysHysHea.y, swiFreStaVal.u3) annotation (Line(points={{12,-140},{24,
          -140},{24,-168},{38,-168}}, color={0,0,127}));
  connect(sysHysHea.yPum, swiFreStaPum.u3) annotation (Line(points={{12,-147},{
          20,-147},{20,-128},{38,-128}}, color={0,0,127}));
  connect(swiFreStaPum.y, pumHeaCoi.y) annotation (Line(points={{62,-120},{108,
          -120},{108,-140},{150,-140},{150,-120},{140,-120}}, color={0,0,127}));
  connect(swiFreStaVal.y, valHeaCoi.y) annotation (Line(points={{62,-160},{66,-160},
          {66,-210},{116,-210}},      color={0,0,127}));
  connect(TRooMin.y, controlBus.TRooMin) annotation (Line(points={{-318,270},{-240,
          270},{-240,-342}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TRooMin.u, TRoo) annotation (Line(points={{-342,270},{-360,270},{-360,
          320},{-400,320}}, color={0,0,127}));
  connect(TRooAve.u, TRoo) annotation (Line(points={{-342,240},{-360,240},{-360,
          320},{-400,320}}, color={0,0,127}));
  connect(freSta.u, TMix.T) annotation (Line(points={{-62,-80},{-72,-80},{-72,-60},
          {26,-60},{26,-20},{40,-20},{40,-29}}, color={0,0,127}));
  connect(damExh.port_b, amb.ports[3]) annotation (Line(points={{-50,-10},{-100,
          -10},{-100,-45},{-114,-45}}, color={0,127,255}));
  annotation (
  defaultComponentName="hvac",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-400},{1420,
            660}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC\">
Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</a>
for a description of the HVAC system,
and see the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Floor\">
Buildings.Examples.VAVReheat.BaseClasses.Floor</a>
for a description of the building envelope.
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is modulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate.
The duct static pressure set point is adjusted so that at least one
VAV damper is 90% open.
The heating coil valve, outside air damper, and cooling coil valve are
modulated in sequence to maintain the supply air temperature set point.
The economizer control provides the following functions:
freeze protection, minimum outside air requirement, and supply air cooling,
see
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.Economizer\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.Economizer</a>.
The controller of the terminal units tracks the room air temperature set point
based on a \"dual maximum with constant volume heating\" logic, see
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV</a>.
</p>
<p>
There is also a finite state machine that transitions the mode of operation
of the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Guideline36\">
Buildings.Examples.VAVReheat.BaseClasses.Guideline36</a>.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
August 24, 2021, by Michael Wetter:<br/>
Changed model to include the hydraulic configurations of the cooling coil,
heating coil and VAV terminal box.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
<li>
May 6, 2021, by David Blum:<br/>
Change to <code>from_dp=false</code> for exhaust air damper.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2485\">issue #2485</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 15, 2021, by David Blum:<br/>
Update documentation graphic to include relief damper.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2399\">#2399</a>.
</li>
<li>
October 27, 2020, by Antoine Gautier:<br/>
Refactored the supply air temperature control sequence.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Changed design and control parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>.
</li>
<li>
April 20, 2020, by Jianjun Hu:<br/>
Exported actual VAV damper position as the measured input data for
defining duct static pressure setpoint.<br/>
This is
for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{240,172},{220,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{240,172},{220,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,100},{-158,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,96},{-2,82}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,-12},{-158,-52}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-78,60},{-118,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,96},{-12,62}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,86},{-22,72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,100},{56,60}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{104,100},{118,60}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-138,100},{-124,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-138,-12},{-124,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,20},{7,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={-98,23},
          rotation=90),
        Line(points={{106,60},{106,-6}}, color={0,0,255}),
        Line(points={{116,60},{116,-6}}, color={0,0,255}),
        Line(points={{106,34},{116,34}},   color={0,0,255}),
        Polygon(
          points={{-5,-4},{3,-4},{-1,4},{-5,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={107,16}),
        Ellipse(
          extent={{100,54},{112,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{106,54},{100,48},{112,48},{106,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{3,4},{-1,-4},{-5,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={107,24}),
        Line(points={{44,60},{44,-6}},   color={0,0,255}),
        Line(points={{54,60},{54,-6}},   color={0,0,255}),
        Line(points={{44,34},{54,34}},     color={0,0,255}),
        Polygon(
          points={{-5,-4},{3,-4},{-1,4},{-5,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={45,16}),
        Ellipse(
          extent={{38,54},{50,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,54},{38,48},{50,48},{44,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{3,4},{-1,-4},{-5,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={45,24}),
        Rectangle(
          extent={{320,172},{300,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{280,172},{260,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,172},{380,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{360,172},{340,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{240,20},{220,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{280,20},{260,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{320,20},{300,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{360,20},{340,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,20},{380,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{380,136},{400,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={390,153},
          rotation=90),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={350,153},
          rotation=90),
        Rectangle(
          extent={{340,136},{360,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{300,136},{320,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={310,153},
          rotation=90),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={270,153},
          rotation=90),
        Rectangle(
          extent={{260,136},{280,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{220,136},{240,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={230,153},
          rotation=90)}));
end ASHRAE2006;
