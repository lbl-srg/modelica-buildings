within Buildings.Controls.OBC.ASHRAE.G36.AHU.Coils;
block HeatingAndCoolingCoilValves "Generates heating and cooling control signals to maintain zone set temperature"

  parameter Real kPCoo=1 "Proportional gain for cooling coil control loop"
    annotation(Dialog(group="Cooling coil control"));
  parameter Modelica.SIunits.Time TiCoo=30 "Time constant of integrator block for cooling coil control loop"
    annotation(Dialog(group="Cooling coil control"));

  parameter Real kPHea=1 "Proportional gain for heating coil control loop"
    annotation(Dialog(group="Heating coil control"));

  parameter Modelica.SIunits.Time TiHea=30 "Time constant of integrator block for heating coil control loop"
    annotation(Dialog(group="Heating coil control"));

  Modelica.Blocks.Interfaces.RealInput TRooHeaSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Zone heating setpoint temperature"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},rotation=0, origin={-120,60}), iconTransformation(
      extent={{-10,-10},{10,10}},origin={-110,60})));
  Modelica.Blocks.Interfaces.RealInput TRooCooSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Zone cooling setpoint temperature"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},rotation=0,origin={-120,0}), iconTransformation(
      extent={{-10,-10},{10,10}},origin={-110,0})));
  Modelica.Blocks.Interfaces.RealInput TRoo(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Zone temperature measurement"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-120,-60}),
      iconTransformation(extent={{-10,-10},{10,10}}, origin={-110,-60})));

  CDL.Interfaces.RealOutput yHea(
    final min=0,
    final max=1,
    final unit="1") "Heating control signal"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
      iconTransformation(extent={{100,30},{120,50}})));
  CDL.Interfaces.RealOutput yCoo(
    final min=0,
    final max=1,
    final unit="1") "Cooling control signal"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

protected
  CDL.Continuous.LimPID conCooVal(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=kPCoo,
    final Ti=TiCoo,
    final yMax=1,
    final yMin=0) "Cooling coil valve controller"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  CDL.Continuous.LimPID conHeaVal(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=kPHea,
    final Ti=TiHea,
    final yMax=1,
    final yMin=0) "Heating coil valve controller"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Continuous.Line conCooInv(
    final limitBelow=false,
    final limitAbove=false) "Inverter of the cooling control signal"
    annotation (Placement(transformation(extent={{64,-30},{84,-10}})));
  CDL.Continuous.Sources.Constant conSigMinSig(final k=0)
    "Minimum controller output signal"
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
  CDL.Continuous.Sources.Constant conSigMaxSig(final k=1)
   "Maximum controller output signal"
    annotation (Placement(transformation(extent={{24,-50},{44,-30}})));

equation
  connect(TRoo, conHeaVal.u_m)
    annotation (Line(points={{-120,-60},{-68,-60},{-68,20},{-50,20},{-50,38}},color={0,0,127}));
  connect(TRoo, conCooVal.u_m)
    annotation (Line(points={{-120,-60},{-50,-60},{-50,-32}},color={0,0,127}));
  connect(conCooVal.u_s,TRooCooSet)
    annotation (Line(points={{-62,-20},{-62,-20},{-70,-20},{-70,0},{-120,0}},
    color={0,0,127}));
  connect(conCooVal.y, conCooInv.u)
    annotation (Line(points={{-39,-20},{-39,-20},{62,-20}},color={0,0,127}));
  connect(conSigMinSig.y, conCooInv.x1)
    annotation (Line(points={{45,0},{54,0},{54,-12},{62,-12}},color={0,0,127}));
  connect(conSigMaxSig.y, conCooInv.f1)
    annotation (Line(points={{45,-40},{52,-40},{52,-16},{62,-16}},color={0,0,127}));
  connect(conSigMaxSig.y, conCooInv.x2)
    annotation (Line(points={{45,-40},{54,-40},{54,-24},{62,-24}},color={0,0,127}));
  connect(conSigMinSig.y, conCooInv.f2)
    annotation (Line(points={{45,0},{56,0},{56,-28},{62,-28}}, color={0,0,127}));
  connect(conHeaVal.y, yHea) annotation (Line(points={{-39,50},{78,50},{110,50}}, color={0,0,127}));
  connect(conCooInv.y, yCoo) annotation (Line(points={{85,-20},{94,-20},{110,-20}}, color={0,0,127}));
  connect(TRooHeaSet, conHeaVal.u_s)
    annotation (Line(points={{-120,60},{-80,60},{-80,50},{-62,50}}, color={0,0,127}));
    annotation (Placement(transformation(extent={{-20,110},{0,130}})),
                Placement(transformation(extent={{-20,20},{0,40}})),
                Placement(transformation(extent={{60,90},{80,110}})),
                Placement(transformation(extent={{-140,130},{-120,150}})),
                Placement(transformation(extent={{-140,-30},{-120,-10}})),
                Placement(transformation(extent={{-140,160},{-120,180}})),
                Placement(transformation(extent={{-140,0},{-120,20}})),
    defaultComponentName = "coiCon",
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-124,144},{128,108}},
          lineColor={0,0,127},
          textString="%name"),
        Line(
          points={{-80,28},{-46,28},{-38,28},{-22,-26},{24,-26},{32,-26},{46,-26},{82,-26}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-80,-26},{-80,-26},{-52,-26},{-30,-26},{16,-26},{24,-26},{38,28},{82,28}},
          color={0,0,127},
          pattern=LinePattern.Dot,
          thickness=0.5)}),
    Documentation(info="<html>
<p>
Controller that modulates the position of the heating and cooling coil valves
in order to maintain the zone temperature setpoint. ASHRAE Guidline 36 (G36), PART5.B.5, refers to them
as the cooling loop and the heating loop.
</p>
<p>
Both controllers remain
enabled at all times since antiwindup is implemented within each controller, see
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.LimPID\">
Buildings.Controls.OBC.CDL.Continuous.LimPID</a>.

The cooling loop shall maintain the space temperature at the active zone cooling setpoint. The heating loop shall
maintain the space temperature at the active zone heating setpoint. The diagram below illustrates the control configuration.
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of heating and cooling loop control chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHU/Coils/HeatingAndCoolingCoilValvesControlDiagram.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
September 1, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-80},{100,80}}),
                                                          graphics={
        Rectangle(
          extent={{-94,74},{-4,-76}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-28,-64},{8,-76}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Controllers"),
        Rectangle(
          extent={{4,74},{96,-76}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{70,-62},{106,-74}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Controller
signal reverse")}));
end HeatingAndCoolingCoilValves;
