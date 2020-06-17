within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Borefield "Controller for borefield loop"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Temperature TBorWatEntMax(
    displayUnit="degC")
    "Maximum value of borefield water entering temperature";
  parameter Modelica.SIunits.TemperatureDifference dTBorFieSet(min=0)
    "Set-point for temperature difference accross borefield (absolute value)";
  parameter Modelica.Blocks.Types.SimpleController
    controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k = 0.1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.SIunits.Time Ti = 3600
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PI
        or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PD
          or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real spePumBorMin(final unit="1") = 0.1
    "Borefield pump minimum speed";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBorWatEnt(final unit="K",
      displayUnit="degc") "Borefield water entering temperature " annotation (
      Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBorWatLvg(final unit="K",
      displayUnit="degc") "Borefield water leaving temperature" annotation (
      Placement(transformation(extent={{-260,-140},{-220,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (fractional)" annotation (Placement(
        transformation(extent={{-260,40},{-220,80}}), iconTransformation(extent=
           {{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMixBor(final unit="1")
    "Control signal for borefield three-way mixing valve" annotation (Placement(
        transformation(extent={{220,-20},{260,20}}), iconTransformation(extent={{100,40},
            {140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumBor(final unit="1")
    "Control signal for borefield pump"
    annotation (Placement(transformation(extent={{220,-100},{260,-60}}),
      iconTransformation(extent={{100,-82},{142,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,140},{-220,180}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT(k2=-1) "Compute deltaT"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs "Absolute value"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant delTBorWatSet(k=dTGeo)
    "Borefield water temperature difference set-point"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.Continuous.LimPID conPumBor(
    final Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    final reverseActing=false,
    y_reset=0,
    final k=1,
    yMin=0,
    final controllerType=controllerType,
    Ti(displayUnit="s") = 3600) "Borefield pump controller"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaRej
    "Full heat or cold rejection mode enabled signal"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch runBor
    "Switch that enable the borefield system pump"
    annotation (Placement(transformation(extent={{190,-90},{210,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conMix(
    final Td=Td,
    final yMin=0,
    final yMax=1,
    reset=Buildings.Types.Reset.Parameter,
    final reverseActing=true,
    y_reset=0,
    final k=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti(displayUnit="min")=3600)
    "Mixing valve controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTBorWatEnt(
    y(final unit="K", displayUnit="degC"),
    final k=TBorWatEntMax)
    "Maximum value of borefield water entering temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal fulSpe "Full speed"
    annotation (Placement(transformation(extent={{70,130},{90,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe(
    final k=spePumBorMin) "Minimum pump speed"
    annotation (Placement(transformation(extent={{70,-170},{90,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(
    final k=0) "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(nin=3)
    "Maximize pump control signal"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold enaBorFie(threshold=
       0.9)
    "Borefield enabled signal, true if at least one isolation valve is open"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax1(nin=2)
                                                                 "Max"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
equation
  connect(delT.y, abs.u)
    annotation (Line(points={{-38,-120},{-12,-120}}, color={0,0,127}));
  connect(delTBorWatSet.y, conPumBor.u_s)
    annotation (Line(points={{12,-80},{68,-80}}, color={0,0,127}));
  connect(abs.y, conPumBor.u_m)
    annotation (Line(points={{12,-120},{80,-120},{80,-92}}, color={0,0,127}));
  connect(enaRej.u1, uHeaRej) annotation (Line(points={{-12,140},{-20,140},{-20,
          160},{-240,160}},
                       color={255,0,255}));
  connect(enaRej.u2, uColRej) annotation (Line(points={{-12,132},{-20,132},{-20,
          120},{-240,120}},
                      color={255,0,255}));
  connect(runBor.y,yPumBor) annotation (Line(points={{212,-80},{240,-80}},
                                                 color={0,0,127}));
  connect(conMix.y, yMixBor)
    annotation (Line(points={{12,0},{240,0}}, color={0,0,127}));
  connect(TBorWatEnt, conMix.u_m)
    annotation (Line(points={{-240,-40},{0,-40},{0,-12}}, color={0,0,127}));
  connect(TBorWatLvg,delT. u2) annotation (Line(points={{-240,-120},{-80,-120},{
          -80,-126},{-62,-126}},
                             color={0,0,127}));
  connect(TBorWatEnt,delT. u1) annotation (Line(points={{-240,-40},{-80,-40},{-80,
          -114},{-62,-114}}, color={0,0,127}));

  connect(maxTBorWatEnt.y, conMix.u_s)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(enaRej.y, fulSpe.u)
    annotation (Line(points={{12,140},{68,140}},
                                               color={255,0,255}));
  connect(off.y, runBor.u3) annotation (Line(points={{162,-120},{180,-120},{180,
          -88},{188,-88}}, color={0,0,127}));
  connect(fulSpe.y, multiMax.u[1]) annotation (Line(points={{92,140},{120,140},
          {120,-78.6667},{138,-78.6667}},
                                     color={0,0,127}));
  connect(conPumBor.y, multiMax.u[2])
    annotation (Line(points={{91,-80},{138,-80}},  color={0,0,127}));
  connect(minSpe.y, multiMax.u[3]) annotation (Line(points={{92,-160},{120,-160},
          {120,-81.3333},{138,-81.3333}}, color={0,0,127}));
  connect(multiMax.y, runBor.u1) annotation (Line(points={{162,-80},{170,-80},{170,
          -72},{188,-72}}, color={0,0,127}));
  connect(yValIso, multiMax1.u[1:2])
    annotation (Line(points={{-240,60},{-202,60},{-202,59}}, color={0,0,127}));
  connect(multiMax1.y, enaBorFie.u)
    annotation (Line(points={{-178,60},{-162,60}}, color={0,0,127}));
  connect(enaBorFie.y, conMix.trigger) annotation (Line(points={{-138,60},{-20,
          60},{-20,-20},{-6,-20},{-6,-12}}, color={255,0,255}));
  connect(enaBorFie.y, conPumBor.trigger) annotation (Line(points={{-138,60},{
          60,60},{60,-100},{72,-100},{72,-92}}, color={255,0,255}));
  connect(enaBorFie.y, runBor.u2) annotation (Line(points={{-138,60},{180,60},{
          180,-80},{188,-80}}, color={255,0,255}));
annotation (Diagram(
              coordinateSystem(preserveAspectRatio=false,
              extent={{-220,-200},{220,200}})),
              defaultComponentName="con",
Documentation(info="<html>
<p>
This block computes the energy rejection index <code>yModInd</code>  i.e. heating or cooling energy is rejected and the control signals for
the following equipment.
</p>
<h4>Borefield pump</h4>
<p>
The borefield pump <code>pumBor</code> is a variable speed pump.
The flow rate is modulated
using a reverse acting PI loop with a reference <code>dTBor</code> and the absolute
measured temperature difference between <code>TBorEnt</code> and <code>TDisHexEnt</code>.
The controller in addition switches between modulating the <code>pumBor</code> flow rate or
run on maximum flow rate <code>rejFulLoa</code> is true.
</p>
<h4>Mixing valve</h4>
<p>
The controller of the three-way valve tracks a constant, minimum borefield water inlet temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
November 2, 2019, by Hagar Elarga:<br/>
Added the three-way valve controller and the documentation.
</li>
<li>
March 21, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Borefield;
