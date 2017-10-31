within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers;
model Controller "Multi zone VAV AHU economizer control sequence"

  parameter Boolean use_enthalpy=false
    "Set to true if enthalpy measurement is used in addition to temperature measurement";
  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Hysteresis"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits" annotation (
      Evaluate=true, Dialog(
      tab="Advanced",
      group="Hysteresis",
      enable=use_enthalpy));
  parameter Modelica.SIunits.Time retDamFulOpeTim=180 "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations" annotation (Evaluate=true,
      Dialog(tab="Advanced", group="Delays at disable"));
  parameter Modelica.SIunits.Time disDel=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation (Evaluate=true,Dialog(tab="Advanced", group="Delays at disable"));

  parameter Real kPMinOut=1
    "Proportional gain of controller for minimum outdoor air"
    annotation (Evaluate=true,Dialog(tab="Commissioning", group="Control gains"));
  parameter Modelica.SIunits.Time TiMinOut=30
    "Time constant of controller for minimum outdoor air" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group="Control gains"));

//  parameter Real yMinDamLim=0
//    "Lower limit of damper position limits control signal output" annotation (
//      Evaluate=true, Dialog(tab="Commissioning", group="Control gains"));

  parameter Real uHeaMax=-0.25
    "Lower limit of controller input when outdoor damper opens for modulation control. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Evaluate=true,Dialog(tab="Commissioning", group="Controller"));
  parameter Real uCooMin=+0.25
    "Upper limit of controller input when return damper is closed for modulation control. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Evaluate=true,Dialog(tab="Commissioning", group="Controller"));

  parameter Real uOutDamMax(
    final min=-1,
    final max=1,
    final unit="1") = (uHeaMax + uCooMin)/2
    "Maximum loop signal for the OA damper to be fully open. Require -1 < uHeaMax < uOutDamMax <= uRetDamMin < uCooMin < 1."
    annotation (Evaluate=true, Dialog(tab="Commissioning", group="Controller"));

  parameter Real uRetDamMin(
    final min=-1,
    final max=1,
    final unit="1") = (uHeaMax + uCooMin)/2
    "Minimum loop signal for the RA damper to be fully open. Require -1 < uHeaMax < uOutDamMax <= uRetDamMin < uCooMin < 1."
    annotation (Evaluate=true, Dialog(tab="Commissioning", group="Controller"));

//  parameter Real yMaxDamLim=1
//    "Upper limit of damper position limits control signal output" annotation (
//      Evaluate=true, Dialog(tab="Commissioning", group="Control gains"));


  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Physical damper position limits"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Physical damper position limits"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper" annotation (
      Evaluate=true, Dialog(tab="Commissioning", group=
          "Physical damper position limits"));

  parameter Modelica.SIunits.Temperature TFreSet = 277.15
    "Lower limit for mixed air temperature for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Advanced", group="Freeze protection"));
  parameter Real kPFre = 1
    "Proportional gain for mixed air temperature tracking for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Advanced", group="Freeze protection"));

  parameter Modelica.SIunits.Time delta=120
    "Time horizon over which the outdoor air flow measurment is averaged";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSup(final unit="1")
    "Signal for supply air temperature control (T Sup Control Loop Signal in diagram)"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(final unit="K", final
      quantity="ThermodynamicTemperature") "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(final unit="K",
      final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(final unit="J/kg",
      final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(final unit="J/kg",
      final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(final unit="m3/s",
      final quantity="VolumeFlowRate")
    "Measured outdoor volumetric airflow rate" annotation (Placement(
        transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow(final unit=
        "m3/s", final quantity="VolumeFlowRate")
    "Minimum outdoor volumetric airflow rate setpoint" annotation (Placement(
        transformation(extent={{-180,-10},{-160,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection status" annotation (Placement(transformation(extent={{-180,
            -150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal" annotation (Placement(transformation(
          extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    "Zone state signal" annotation (Placement(transformation(extent={{-180,-130},
            {-160,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status" annotation (Placement(transformation(extent={{-180,-70},
            {-160,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position" annotation (Placement(
        transformation(extent={{160,70},{180,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position" annotation (Placement(
        transformation(extent={{160,-90},{180,-70}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable enaDis(
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final TFreSet=TFreSet,
    final kPFre=kPFre)
    "Multi zone VAV AHU economizer enable/disable sequence"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits
    damLim(
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final kPDamLim=kPMinOut,
    final TiDamLim=TiMinOut,
    final uRetDamMin=uRetDamMin)
    "Multi zone VAV AHU economizer minimum outdoor air requirement damper limit sequence"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation
    mod(
    final uRetDamMin=uRetDamMin,
    final uMin=uHeaMax,
    final uMax=uCooMin,
    final uOutDamMax=uOutDamMax)
    "Multi zone VAV AHU economizer damper modulation sequence"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  CDL.Continuous.MovingMean VOutMea_flow(final delta=delta)
    "Moving average of outdoor air flow measurement"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

equation
  connect(uSupFan, enaDis.uSupFan) annotation (Line(points={{-170,-60},{-80,-60},
          {-80,-26.4286},{-0.714286,-26.4286}},
                               color={255,0,255}));
  connect(uFreProSta, enaDis.uFreProSta) annotation (Line(points={{-170,-140},{
          -60,-140},{-60,-28.2143},{-0.714286,-28.2143}},
                                         color={255,127,0}));
  connect(hOutCut, enaDis.hOutCut) annotation (Line(points={{-170,80},{-46,80},
          {-46,-24.6429},{-0.714286,-24.6429}},
                               color={0,0,127}));
  connect(hOut, enaDis.hOut) annotation (Line(points={{-170,100},{-44,100},{-44,
          -23.2143},{-0.714286,-23.2143}},
                          color={0,0,127}));
  connect(TOutCut, enaDis.TOutCut) annotation (Line(points={{-170,120},{-42,120},
          {-42,-21.7857},{-0.714286,-21.7857}},
                               color={0,0,127}));
  connect(TOut, enaDis.TOut) annotation (Line(points={{-170,140},{-40,140},{-40,
          -20.3571},{-0.714286,-20.3571}},
                          color={0,0,127}));
  connect(VOutMinSet_flow, damLim.VOutMinSet_flow) annotation (Line(points={{-170,0},
          {-110,0},{-110,15},{-81,15}},              color={0,0,127}));
  connect(uSupFan, damLim.uSupFan) annotation (Line(points={{-170,-60},{-104,
          -60},{-104,10},{-81,10}},
                               color={255,0,255}));
  connect(uOpeMod, damLim.uOpeMod) annotation (Line(points={{-170,-100},{-102,
          -100},{-102,5},{-81,5}},    color={255,127,0}));
  connect(uFreProSta, damLim.uFreProSta) annotation (Line(points={{-170,-140},{
          -100,-140},{-100,2},{-81,2}}, color={255,127,0}));
  connect(damLim.yOutDamPosMax, enaDis.uOutDamPosMax) annotation (Line(points={{-59,17},
          {-24,17},{-24,16},{-24,-34.2857},{-0.714286,-34.2857}},
                                                          color={0,0,127}));
  connect(damLim.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points={{-59,15},
          {-26,15},{-26,12},{-26,-35.7143},{-0.714286,-35.7143}},
                                                          color={0,0,127}));
  connect(damLim.yRetDamPosMin, enaDis.uRetDamPosMin) annotation (Line(points={{-59,10},
          {-28,10},{-28,8},{-28,-40},{-0.714286,-40}},   color={0,0,127}));
  connect(damLim.yRetDamPhyPosMax, enaDis.uRetDamPhyPosMax) annotation (Line(
        points={{-59,6},{-32,6},{-32,2},{-32,-37.1429},{-0.714286,-37.1429}},
                                                             color={0,0,127}));
  connect(damLim.yRetDamPosMax, enaDis.uRetDamPosMax) annotation (Line(points={{-59,8},
          {-30,8},{-30,-38.5714},{-0.714286,-38.5714}},
                                               color={0,0,127}));
  connect(mod.yRetDamPos, yRetDamPos) annotation (Line(points={{81,12},{140,12},
          {140,80},{170,80}}, color={0,0,127}));
  connect(mod.yOutDamPos, yOutDamPos) annotation (Line(points={{81,8},{140,8},{
          140,-80},{170,-80}}, color={0,0,127}));
  connect(enaDis.yOutDamPosMax, mod.uOutDamPosMax) annotation (Line(points={{20.3571,
          -27.1429},{50,-27.1429},{50,6},{59,6}},      color={0,0,127}));
  connect(enaDis.yRetDamPosMax, mod.uRetDamPosMax) annotation (Line(points={{20.3571,
          -30},{52,-30},{52,18},{59,18}},
                                        color={0,0,127}));
  connect(damLim.yOutDamPosMin, mod.uOutDamPosMin) annotation (Line(points={{-59,15},
          {20,15},{20,2},{59,2}},                      color={0,0,127}));
  connect(enaDis.yRetDamPosMin, mod.uRetDamPosMin) annotation (Line(points={{20.3571,
          -33.5714},{54,-33.5714},{54,14},{59,14}},
                                               color={0,0,127}));
  connect(uZonSta, enaDis.uZonSta) annotation (Line(points={{-170,-120},{-58,
          -120},{-58,-30.3571},{-0.714286,-30.3571}},
                               color={255,127,0}));
  connect(uTSup, mod.uTSup) annotation (Line(points={{-170,50},{40,50},{40,10},
          {59,10}},color={0,0,127}));
  connect(enaDis.TMix, TMix) annotation (Line(points={{-0.714286,-32.1429},{
          -0.714286,-32},{-110,-32},{-110,-30},{-170,-30}},
                                                  color={0,0,127}));
  connect(VOut_flow,VOutMea_flow. u) annotation (Line(points={{-170,20},{-158,20},
          {-158,30},{-142,30}}, color={0,0,127}));
  connect(VOutMea_flow.y, damLim.VOut_flow) annotation (Line(points={{-119,30},{
          -100,30},{-100,18},{-81,18}}, color={0,0,127}));
  annotation (
    defaultComponentName="conEco",
    Icon(coordinateSystem(extent={{-160,-160},{160,160}}),
         graphics={
        Rectangle(
          extent={{-160,-160},{160,162}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-96,-40},{-18,-40},{20,62},{58,62}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-92,62},{-14,62},{24,-36},{88,-36}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{58,62},{58,-14},{58,-26},{90,-26}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-176,200},{152,162}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{
            160,160}})),
    Documentation(info="<html>
<p>
Multi zone VAV AHU economizer control sequence that calculates
outdoor and return air damper positions based on ASHRAE
Guidline 36, PART5 sections: N.2.c, N.5, N.6.c, N.7, A.17, N.12.
</p>
<p>
The sequence consists of three subsequences.
</p>
<ul>
<li>
First, the block <code>damLim</code> computes the damper position limits to satisfy
outdoor air requirements. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Limits</a>
for a description.
</li>
<li>
Second, the block <code>enaDis</code> enables or disables the economizer based on
outdoor temperature and optionally enthalpy, and based on the supply fan status,
freeze protection stage and zone state.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable</a>
for a description.
</li>
<li>
Third, the block <code>mod</code> modulates the outdoor and return damper position
to track the supply air temperature setpoint, subject to the limits of the damper positions
that were computed in the above two blocks.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation</a>
for a description.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
October 11, 2017, by Michael Wetter:<br/>
Corrected implementation to use control loop signal as input.
</li>
<li>
June 28, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
