within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences;
block FreProTMix "Optional freeze protection block based on mixed air temperature."

  parameter Boolean use_enthalpy = true
    "Set to true to evaluate outdoor air enthalpy in addition to temperature"
    annotation(Dialog(group="Conditional"));
  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));
  parameter Modelica.SIunits.Time retDamFulOpeTim=180
    "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Delays at disable"));
  parameter Modelica.SIunits.Time disDel=15
    "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Delays at disable"));

  parameter Modelica.SIunits.Temperature TFreSet = 277.15
    "Lower limit for mixed air temperature for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Advanced", group="Freeze protection"));
  parameter Real kPFre = 1
    "Proportional gain for mixed air temperature tracking for freeze protection"
     annotation(Evaluate=true, Dialog(tab="Advanced", group="Freeze protection"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-120,
            -30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final unit="1",
    final min=0,
    final max=1) "Maximum outdoor air damper position which prevents freezing" annotation (
      Placement(transformation(extent={{100,-30},{120,-10}}), iconTransformation(extent={{100,50},{
            120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final unit="1",
    final min=0,
    final max=1) "Minimum return air damper position during freeze protection" annotation (
      Placement(transformation(extent={{100,10},{120,30}}), iconTransformation(extent={{100,-70},{
            120,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter yFreOut(final p=1, final k=
       -1) "Control signal for outdoor damper due to freeze protection"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conFreTMix(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=kPFre,
    final yMax=1,
    final yMin=0)
    "Controller for mixed air to track freeze protection set point"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

protected
  final parameter Modelica.SIunits.TemperatureDifference TOutHigLimCutHig = 0
    "Hysteresis high limit cutoff";
  final parameter Real TOutHigLimCutLow = TOutHigLimCutHig - delTOutHis
    "Hysteresis low limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutHigLimCutHig = 0
    "Hysteresis block high limit cutoff";
  final parameter Real hOutHigLimCutLow = hOutHigLimCutHig - delEntHis
    "Hysteresis block low limit cutoff";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setPoiFre(
    final k=TFreSet)
    "Set point for freeze protection"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter offSig(
    final k=1,
    final p=-1/kPFre)
    "Offset of TMix to account for P-band. This ensures that the damper is fully closed at TFreSet"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
equation

  connect(conFreTMix.y,yFreOut. u) annotation (Line(points={{11,10},{20,10},{20,-20},{38,-20}},
                                    color={0,0,127}));
  connect(conFreTMix.u_s, setPoiFre.y)
    annotation (Line(points={{-12,10},{-29,10}},     color={0,0,127}));
  connect(TMix, offSig.u) annotation (Line(points={{-120,0},{-80,0},{-80,-30},{-52,-30}},
                        color={0,0,127}));
  connect(offSig.y, conFreTMix.u_m) annotation (Line(points={{-29,-30},{0,-30},{0,-2}},
                       color={0,0,127}));
  connect(yFreOut.y, yOutDamPos) annotation (Line(points={{61,-20},{110,-20}}, color={0,0,127}));
  connect(conFreTMix.y, yRetDamPos)
    annotation (Line(points={{11,10},{90,10},{90,20},{110,20}}, color={0,0,127}));
  annotation (
    defaultComponentName = "enaDis",
    Icon(coordinateSystem(extent={{-100,-60},{100,60}}),
         graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-174,332},{154,294}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,60}},
        initialScale=0.05)),
Documentation(info="<html>
<p>
This is a multi zone VAV AHU economizer enable/disable sequence
based on ASHRAE G36 PART5.N.7 and PART5.A.17. Additional
conditions included in the sequence are: freeze protection (freeze protection
stage 0-3, see PART5.N.12), supply fan status (on or off, see PART5.N.5),
and zone state (cooling, heating, or deadband, as illustrated in the
modulation control chart, PART5.N.2.c).
</p>
<p>
The economizer is disabled whenever the outdoor air conditions
exceed the economizer high limit setpoint.
This sequence allows for all device types listed in
ASHRAE 90.1-2013 and Title 24-2013.
</p>
<p>
In addition, the economizer gets disabled without a delay whenever any of the
following is <code>true</code>:
</p>
<ul>
<li>
The supply fan is off (<code>uSupFan = false</code>),
</li>
<li>
the zone state <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.ZoneStates</a> is <code>heating</code>, or
</li>
<li>
the freeze protection stage
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages</a>
is not <code>stage0</code>.
</li>
</ul>
<p>
The following state machine chart illustrates the transitions between enabling and disabling:
</p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconEnableDisableStateMachineChartMultiZone.png\"/>
</p>
<p>
After the disable signal is activated, the following procedure is applied, per PART5.N.7.d, in order to
prevent pressure fluctuations in the HVAC system:
</p>
<ul>
<li>
The return damper gets fully opened (<code>yRetDamPosMax = uRetDamPhyPosMax</code> and
<code>yRetDamPosMin = uRetDamPhyPosMax</code>) for <code>retDamFulOpeTim</code>
time period, after which the return damper gets released to its minimum outdoor airflow control position
(<code>yRetDamPosMax = uRetDamPosMax</code> and <code>yRetDamPosMin = uRetDamPosMax</code>).
</li>
<li>
The outdoor air damper is closed to its minimum outoor airflow control limit (<code>yOutDamPosMax = uOutDamPosMin</code>)
after a <code>disDel</code> time delay.
</li>
</ul>
<p>
This sequence also has an overwrite of the damper positions to track
a minimum mixed air temperature of <code>TFreSet</code>, which is
by default set to <i>4</i>&deg;C (<i>39.2</i> F).
This is implemented using a proportional controller with a default deadband of
<i>1</i> K, which can be adjusted using the parameter <code>kPFrePro</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2017, by Michael Wetter:<br/>
Added freeze protection that tracks mixed air temperature.
</li>
<li>
August 3, 2017, by Michael Wetter:<br/>
Removed unrequired input into block <code>and2</code> as this input
was always <code>true</code> if <code>and2.u2 = true</code>.
</li>
<li>
June 27, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreProTMix;
