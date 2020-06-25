within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Borefield "Controller for borefield loop"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature TBorWatEntMax(displayUnit="degC")
    "Maximum value of borefield water entering temperature";
  parameter Real spePumBorMin(final unit="1") = 0.1
    "Borefield pump minimum speed";
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiBor(
    final k=m_flow_nominal)
    "Scale control signal with nominal mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,80})));
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
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTBorWatEnt(
    y(final  unit="K", displayUnit="degC"), final k=TBorWatEntMax)
    "Maximum value of borefield water entering temperature"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold opeVal(threshold=0.9)
    "True if at least one isolation valve is open"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax1(nin=2)
    "Maximum opening"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold enaSup(
    threshold=Modelica.Constants.eps) "Borefield enabled from supervisory"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch runBor
    "Enable borefield system pump"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
    "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(nin=2)
    "Maximize pump control signal"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe(
    final k=spePumBorMin)     "Minimum pump speed"
    annotation (Placement(transformation(extent={{-72,30},{-52,50}})));
  Buildings.Controls.OBC.CDL.Logical.And enaBor "Borefield enabled signal"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (fractional)" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal from supervisory" annotation (Placement(transformation(
          extent={{-140,40},{-100,80}}), iconTransformation(extent={{-140,40},{-100,
            80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum(final unit="kg/s")
    "Control signal for borefield pump (mass flow rate set-point)" annotation (
      Placement(transformation(extent={{100,40},{140,80}}), iconTransformation(
          extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValMix(final unit="1")
    "Control signal for borefield three-way mixing valve" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent={{100,-80},
            {140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBorWatEnt(
    final unit="K", displayUnit="degC")
    "Borefield water entering temperature" annotation (Placement(transformation(
          extent={{-140,-100},{-100,-60}}), iconTransformation(extent={{-140,-80},
            {-100,-40}})));
equation

  connect(multiMax1.y, opeVal.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={0,0,127}));
  connect(yValIso, multiMax1.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={0,0,127}));
  connect(off.y,runBor. u3) annotation (Line(points={{22,30},{28,30},{28,52},{
          48,52}},         color={0,0,127}));
  connect(u, enaSup.u) annotation (Line(points={{-120,60},{-80,60},{-80,20},{-42,
          20}}, color={0,0,127}));
  connect(enaSup.y, enaBor.u1) annotation (Line(points={{-18,20},{-10,20},{-10,-20},
          {-2,-20}},
                   color={255,0,255}));
  connect(opeVal.y, enaBor.u2) annotation (Line(points={{-18,-40},{-10,-40},{-10,
          -28},{-2,-28}},
                        color={255,0,255}));
  connect(enaBor.y, conMix.trigger) annotation (Line(points={{22,-20},{40,-20},{
          40,-76},{54,-76},{54,-72}},
                              color={255,0,255}));
  connect(maxTBorWatEnt.y, conMix.u_s)
    annotation (Line(points={{22,-60},{48,-60}}, color={0,0,127}));
  connect(u, gaiBor.u) annotation (Line(points={{-120,60},{-80,60},{-80,80},{-72,
          80}}, color={0,0,127}));
  connect(gaiBor.y, multiMax.u[1]) annotation (Line(points={{-48,80},{-40,80},{-40,
          61},{-2,61}}, color={0,0,127}));
  connect(minSpe.y, multiMax.u[2]) annotation (Line(points={{-50,40},{-40,40},{-40,
          59},{-2,59}}, color={0,0,127}));
  connect(multiMax.y, runBor.u1) annotation (Line(points={{22,60},{28,60},{28,
          68},{48,68}},
                    color={0,0,127}));
  connect(conMix.y, yValMix) annotation (Line(points={{72,-60},{90,-60},{90,-60},
          {120,-60}}, color={0,0,127}));
  connect(runBor.y, yPum)
    annotation (Line(points={{72,60},{120,60}}, color={0,0,127}));
  connect(TBorWatEnt, conMix.u_m)
    annotation (Line(points={{-120,-80},{60,-80},{60,-72}}, color={0,0,127}));
  connect(enaBor.y, runBor.u2) annotation (Line(points={{22,-20},{40,-20},{40,
          60},{48,60}}, color={255,0,255}));
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
</html>"));
end Borefield;
