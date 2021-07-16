within Buildings.Examples.VAVReheat;
model ASHRAE2006
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop(
   redeclare replaceable Buildings.Examples.VAVReheat.BaseClasses.Floor flo(
      final lat=lat,
      final sampleModel=sampleModel),
    amb(nPorts=3));

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
    annotation (Placement(transformation(extent={{-250,-352},{-230,-332}})));

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
    annotation (Placement(transformation(extent={{-10,-250},{10,-230}})));
  Controls.SupplyAirTemperature conTSup
    "Supply air temperature and economizer controller"
    annotation (Placement(transformation(extent={{30,-230},{50,-210}})));
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
equation
  connect(controlBus, modeSelector.cb) annotation (Line(
      points={{-240,-342},{-152,-342},{-152,-303.182},{-196.818,-303.182}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(min.y, controlBus.TRooMin) annotation (Line(
      points={{1221,450},{1400,450},{1400,-342},{-240,-342}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(ave.y, controlBus.TRooAve) annotation (Line(
      points={{1221,420},{1400,420},{1400,-342},{-240,-342}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash), Text(
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
      points={{455,-121},{452,-121},{452,-120},{448,-120},{448,275},{480,275}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVSou.TRoo, TRooAir.y1[1]) annotation (Line(
      points={{637,-121},{628,-121},{628,275},{496,275}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], conVAVEas.TRoo) annotation (Line(
      points={{492,275},{808,275},{808,-121},{821,-121}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], conVAVNor.TRoo) annotation (Line(
      points={{488,275},{978,275},{978,-121},{995,-121}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], conVAVWes.TRoo) annotation (Line(
      points={{484,275},{1160,275},{1160,-121},{1185,-121}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,54},{556,54},
          {556,-109.2},{477,-109.2}},
                                 color={0,0,127}));
  connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{659,-109.2},{738,
          -109.2},{738,52},{746,52}},
                                    color={0,0,127}));
  connect(conVAVEas.yDam, eas.yVAV) annotation (Line(points={{843,-109.2},{914,
          -109.2},{914,52},{926,52}},
                                    color={0,0,127}));
  connect(conVAVNor.yDam, nor.yVAV) annotation (Line(points={{1017,-109.2},{
          1072.5,-109.2},{1072.5,52},{1086,52}},
                                               color={0,0,127}));
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

  connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,52},{1274,52},
          {1274,-109.2},{1207,-109.2}},
                                    color={0,0,127}));
  connect(occSch.tNexOcc, controlBus.dTNexOcc) annotation (Line(
      points={{-297,-204},{-240,-204},{-240,-342}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(occSch.occupied, controlBus.occupied) annotation (Line(
      points={{-297,-216},{-240,-216},{-240,-342}},
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
  connect(modeSelector.yFan, conFanSup.uFan) annotation (Line(points={{-179.091,-305.455},{260,-305.455},{260,-30},{226,
          -30},{226,6},{238,6}},                                 color={255,0,
          255}));
  connect(conFanSup.y, fanSup.y) annotation (Line(points={{261,0},{280,0},{280,
          -20},{310,-20},{310,-28}}, color={0,0,127}));
  connect(or2.u2, modeSelector.yFan) annotation (Line(points={{-12,-248},{-30,-248},{-30,-305.455},{-179.091,-305.455}},
                                     color={255,0,255}));
  connect(cor.y_actual, pSetDuc.u[1]) annotation (Line(points={{612,42},{620,42},
          {620,74},{140,74},{140,-7.6},{158,-7.6}}, color={0,0,127}));
  connect(sou.y_actual, pSetDuc.u[2]) annotation (Line(points={{792,40},{800,40},
          {800,74},{140,74},{140,-6.8},{158,-6.8}}, color={0,0,127}));
  connect(eas.y_actual, pSetDuc.u[3]) annotation (Line(points={{972,40},{980,40},
          {980,74},{140,74},{140,-6},{158,-6}}, color={0,0,127}));
  connect(nor.y_actual, pSetDuc.u[4]) annotation (Line(points={{1132,40},{1140,
          40},{1140,74},{140,74},{140,-5.2},{158,-5.2}}, color={0,0,127}));
  connect(wes.y_actual, pSetDuc.u[5]) annotation (Line(points={{1332,40},{1338,
          40},{1338,74},{140,74},{140,-4.4},{158,-4.4}}, color={0,0,127}));
  connect(TSup.T, conTSup.TSup) annotation (Line(
      points={{340,-29},{340,-20},{360,-20},{360,-280},{16,-280},{16,-214},{28,
          -214}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conTSup.yHea, gaiHeaCoi.u) annotation (Line(
      points={{52,-214},{68,-214},{68,-184},{124,-184}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conTSup.yCoo, gaiCooCoi.u) annotation (Line(
      points={{52,-226},{60,-226},{60,-186},{222,-186}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conTSup.yOA, conEco.uOATSup) annotation (Line(
      points={{52,-220},{60,-220},{60,170},{-86,170},{-86,158.667},{-81.3333,158.667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(or2.y, conTSup.uEna) annotation (Line(points={{12,-240},{20,-240},{20,
          -226},{28,-226}},    color={255,0,255}));
  connect(modeSelector.yEco, conEco.uEna) annotation (Line(points={{-179.091,-314.545},{-160,-314.545},{-160,100},{
          -73.3333,100},{-73.3333,137.333}},
        color={255,0,255}));
  connect(TMix.T, conEco.TMix) annotation (Line(points={{40,-29},{40,166},{-90,166},{-90,148},{-81.3333,148}},
                                          color={0,0,127}));
  connect(controlBus, TSupSet.controlBus) annotation (Line(
      points={{-240,-342},{-240,-228},{-190,-228}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSupSet.TSet, conTSup.TSupSet)
    annotation (Line(points={{-178,-220},{28,-220}}, color={0,0,127}));
  connect(conVAVCor.yVal, gaiHeaCoiCor.u) annotation (Line(points={{477,-119},{
          477,46},{492,46}},              color={0,0,127}));
  connect(conVAVSou.yVal, gaiHeaCoiSou.u) annotation (Line(points={{659,-119},{
          659,-106},{660,-106},{660,44},{678,44}},
                                            color={0,0,127}));
  connect(conVAVEas.yVal, gaiHeaCoiEas.u) annotation (Line(points={{843,-119},{
          843,-36},{844,-36},{844,44},{850,44}},
                                            color={0,0,127}));
  connect(conVAVNor.yVal, gaiHeaCoiNor.u) annotation (Line(points={{1017,-119},
          {1017,-37.5},{1016,-37.5},{1016,44}}, color={0,0,127}));
  connect(conVAVWes.yVal, gaiHeaCoiWes.u) annotation (Line(points={{1207,-119},
          {1207,-37.5},{1206,-37.5},{1206,44}}, color={0,0,127}));
  connect(damRet.y, conEco.yRet) annotation (Line(points={{-12,-10},{-18,-10},{-18,146.667},{-58.6667,146.667}},
                                        color={0,0,127}));
  connect(damExh.y, conEco.yOA) annotation (Line(points={{-40,2},{-40,152},{-58.6667,152}},
                 color={0,0,127}));
  connect(damOut.y, conEco.yOA) annotation (Line(points={{-40,-28},{-40,-20},{-22,-20},{-22,152},{-58.6667,152}},
                                          color={0,0,127}));
  connect(damExh.port_a, TRet.port_b) annotation (Line(points={{-30,-10},{-26,-10},
          {-26,140},{90,140}}, color={0,127,255}));
  connect(damExh.port_b, amb.ports[3]) annotation (Line(points={{-50,-10},{-100,
          -10},{-100,-45},{-114,-45}}, color={0,127,255}));
  connect(freSta.y, or2.u1) annotation (Line(points={{-38,-90},{-30,-90},{-30,
          -240},{-12,-240}}, color={255,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-400},{1440,
            660}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop\">
Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</a>
for a description of the HVAC system and the building envelope.
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
<a href=\"modelica://Buildings.Examples.VAVReheat.Controls.Economizer\">
Buildings.Examples.VAVReheat.Controls.Economizer</a>.
The controller of the terminal units tracks the room air temperature set point
based on a \"dual maximum with constant volume heating\" logic, see
<a href=\"modelica://Buildings.Examples.VAVReheat.Controls.RoomVAV\">
Buildings.Examples.VAVReheat.Controls.RoomVAV</a>.
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
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>.
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
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</code> rather than through the
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
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/ASHRAE2006.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ASHRAE2006;
