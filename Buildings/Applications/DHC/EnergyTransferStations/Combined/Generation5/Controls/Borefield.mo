within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Borefield "Controller for borefield system"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Temperature TBorWatEntMax(displayUnit="degC")
    "Maximum value of borefield water entering temperature";
  parameter Real spePumBorMin(final unit="1") = 0.1
    "Borefield pump minimum speed";
  Buildings.Controls.OBC.CDL.Continuous.LimPID conMix(
    final yMin=0,
    final yMax=1,
    reset=Buildings.Types.Reset.Parameter,
    final reverseActing=true,
    y_reset=0,
    k=0.1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti(displayUnit="s") = 120)
    "Mixing valve controller"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTBorWatEnt(
    y(final  unit="K", displayUnit="degC"), final k=TBorWatEntMax)
    "Maximum value of borefield water entering temperature"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold opeVal(threshold=0.9)
    "True if at least one isolation valve is open"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax1(nin=2)
    "Maximum opening"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold enaSup(
    threshold=Modelica.Constants.eps) "Borefield enabled from supervisory"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch runBor
    "Enable borefield system pump"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
    "Zero representing off command"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Maximum between control signal and minimum speed"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe(
    final k=spePumBorMin)     "Minimum pump speed"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Logical.And enaBor "Borefield enabled signal"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (fractional)" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal from supervisory" annotation (Placement(transformation(
          extent={{-140,40},{-100,80}}), iconTransformation(extent={{-140,40},{-100,
            80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum(final unit="kg/s")
    "Control signal for borefield pump"                            annotation (
      Placement(transformation(extent={{100,40},{140,80}}), iconTransformation(
          extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValMix(final unit="1")
    "Control signal for borefield mixing valve"           annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent={{100,-80},
            {140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBorWatEnt(
    final unit="K", displayUnit="degC")
    "Borefield water entering temperature" annotation (Placement(transformation(
          extent={{-140,-100},{-100,-60}}), iconTransformation(extent={{-140,-80},
            {-100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch actVal
    "Enable mixing valve control"
    annotation (Placement(transformation(extent={{70,-50},{90,-70}})));
equation

  connect(multiMax1.y, opeVal.u)
    annotation (Line(points={{-68,-40},{-52,-40}}, color={0,0,127}));
  connect(yValIso, multiMax1.u)
    annotation (Line(points={{-120,-40},{-92,-40}}, color={0,0,127}));
  connect(off.y,runBor. u3) annotation (Line(points={{12,20},{60,20},{60,52},{
          68,52}},         color={0,0,127}));
  connect(u, enaSup.u) annotation (Line(points={{-120,60},{-90,60},{-90,0},{-52,
          0}},  color={0,0,127}));
  connect(enaSup.y, enaBor.u1) annotation (Line(points={{-28,0},{-20,0},{-20,
          -20},{-12,-20}},
                   color={255,0,255}));
  connect(opeVal.y, enaBor.u2) annotation (Line(points={{-28,-40},{-20,-40},{
          -20,-28},{-12,-28}},
                        color={255,0,255}));
  connect(enaBor.y, conMix.trigger) annotation (Line(points={{12,-20},{40,-20},
          {40,-76},{14,-76},{14,-72}},
                              color={255,0,255}));
  connect(maxTBorWatEnt.y, conMix.u_s)
    annotation (Line(points={{2,-60},{8,-60}},   color={0,0,127}));
  connect(max1.y, runBor.u1) annotation (Line(points={{12,60},{20,60},{20,68},{
          68,68}}, color={0,0,127}));
  connect(runBor.y, yPum)
    annotation (Line(points={{92,60},{120,60}}, color={0,0,127}));
  connect(TBorWatEnt, conMix.u_m)
    annotation (Line(points={{-120,-80},{20,-80},{20,-72}}, color={0,0,127}));
  connect(enaBor.y, runBor.u2) annotation (Line(points={{12,-20},{40,-20},{40,
          60},{68,60}}, color={255,0,255}));
  connect(minSpe.y, max1.u2) annotation (Line(points={{-28,40},{-20,40},{-20,54},
          {-12,54}}, color={0,0,127}));
  connect(u, max1.u1) annotation (Line(points={{-120,60},{-30,60},{-30,66},{-12,
          66}}, color={0,0,127}));
  connect(conMix.y, actVal.u1) annotation (Line(points={{32,-60},{50,-60},{50,
          -68},{68,-68}}, color={0,0,127}));
  connect(actVal.y, yValMix)
    annotation (Line(points={{92,-60},{120,-60}}, color={0,0,127}));
  connect(off.y, actVal.u3) annotation (Line(points={{12,20},{60,20},{60,-52},{
          68,-52}}, color={0,0,127}));
  connect(enaBor.y, actVal.u2) annotation (Line(points={{12,-20},{54,-20},{54,
          -60},{68,-60}}, color={255,0,255}));
annotation (Diagram(
              coordinateSystem(preserveAspectRatio=false,
              extent={{-100,-100},{100,100}})),
              defaultComponentName="con",
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This blocks implement the control logic for the borefield system.
The main control signal <code>u</code> is yielded by the hot side
and cold side controllers, see
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>.
</p>
<p>
The system is enabled when
</p>
<ul>
<li>
the main control signal is greater than zero,
</li>
<li>
the return position of one ambient loop isolation valve is greater than 90%.
</li>
</ul>
<p>
When the system is enabled,
</p>
<ul>
<li>
the pump speed is modulated by the input signal, constrained by the minimum
pump speed,
</li>
<li>
the mixing valve opening is modulated based on a PI loop controlling
the maximum inlet temperature.
</li>
</ul>
</html>"));
end Borefield;
