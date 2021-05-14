within Buildings.Examples.VAVReheat.Controls;
block SupplyAirTemperature
  "Control block for tracking the supply air temperature set point"
  extends Modelica.Blocks.Icons.Block;
  parameter Boolean have_heating = true
    "Set to true for heating and cooling functions (false for cooling only)"
    annotation (Evaluate=true);
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
         Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller";
  parameter Real k(min=0) = 0.01 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small) = 120
    "Time constant of integrator block"
    annotation (Dialog(enable=
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(enable=
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "Signal enabling set point tracking"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC")
    "Supply air temperature measurement"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1") if have_heating
    "Control signal for heating coil valve" annotation (Placement(
        transformation(extent={{120,60},{160,100}}),
          iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOA(final unit="1")
    "Control signal for outdoor air damper"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(final unit="1")
    "Control signal for cooling coil valve"
    annotation (Placement(transformation(extent={{120,-100},{160,-60}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset con(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=1,
    final yMin=if have_heating then -1 else 0,
    y_reset=if have_heating then limSupHea.k else limInfOA.k,
    u_s(
    final unit="K",
    displayUnit="degC"),
    u_m(
    final unit="K",
    displayUnit="degC"))
    "Supply temperature controller"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapHea if have_heating
    "Mapping function for actuating the heating coil valve "
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapOA
    "Mapping function for actuating the outdoor air damper"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapCoo
    "Mapping function for actuating the cooling coil valve"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant limInfHea(k=-1)
    "Inferior limit of the control signal for heating coil control "
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant limSupHea(k=-0.5)
    "Superior limit of the control signal for heating coil control "
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant limInfOA(k=0)
    "Inferior limit of the control signal for outdoor air damper control "
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant limSupOA(k=0.5)
    "Superior limit of the control signal for outdoor air damper control "
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant limSupCoo(k=1)
    "Superior limit of the control signal for cooling coil control "
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero(k=0) "Zero"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "one"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiHea if have_heating
    "Switch to close heating coil valve"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiCoo
    "Switch to close cooling coil valve"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOA
    "Switch to close outdoor air damper"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant limInfCoo(
    k=limSupOA.k)
    "Inferior limit of the control signal for cooling coil control "
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
equation
  connect(TSup, con.u_s) annotation (Line(points={{-160,0},{-112,0}},
               color={0,0,127}));
  connect(TSupSet, con.u_m) annotation (Line(points={{-160,-40},{-100,-40},{-100,
          -12}},                color={0,0,127}));
  connect(con.y, mapOA.u)
    annotation (Line(points={{-89,0},{8,0}}, color={0,0,127}));
  connect(con.y, mapCoo.u)
    annotation (Line(points={{-89,0},{0,0},{0,-80},{8,-80}}, color={0,0,127}));
  connect(con.y, mapHea.u) annotation (Line(points={{-89,0},{0,0},{0,80},{8,80}},
                 color={0,0,127}));
  connect(limInfHea.y, mapHea.x1) annotation (Line(points={{-28,120},{0,120},{0,
          88},{8,88}},    color={0,0,127}));
  connect(limSupHea.y, mapHea.x2) annotation (Line(points={{-28,80},{-4,80},{-4,
          76},{8,76}},
                    color={0,0,127}));
  connect(limInfOA.y, mapOA.x1) annotation (Line(points={{-28,40},{-16,40},{-16,
          8},{8,8}}, color={0,0,127}));
  connect(limSupOA.y, mapOA.x2) annotation (Line(points={{-28,-20},{-24,-20},{
          -24,-4},{8,-4}}, color={0,0,127}));
  connect(limSupCoo.y, mapCoo.x2) annotation (Line(points={{-28,-120},{0,-120},
          {0,-84},{8,-84}}, color={0,0,127}));
  connect(one.y, mapCoo.f2) annotation (Line(points={{-78,-60},{-20,-60},{-20,
          -88},{8,-88}}, color={0,0,127}));
  connect(zero.y, mapHea.f2) annotation (Line(points={{-78,60},{-10,60},{-10,72},
          {8,72}}, color={0,0,127}));
  connect(one.y, mapOA.f2) annotation (Line(points={{-78,-60},{-20,-60},{-20,-8},
          {8,-8}}, color={0,0,127}));
  connect(zero.y, mapOA.f1) annotation (Line(points={{-78,60},{-10,60},{-10,4},{
          8,4}},  color={0,0,127}));
  connect(one.y, mapHea.f1) annotation (Line(points={{-78,-60},{-20,-60},{-20,84},
          {8,84}},   color={0,0,127}));
  connect(zero.y, mapCoo.f1) annotation (Line(points={{-78,60},{-78,60.2941},{-10,
          60.2941},{-10,-76},{8,-76}},     color={0,0,127}));
  connect(swiHea.y, yHea)
    annotation (Line(points={{92,80},{140,80}},   color={0,0,127}));
  connect(mapHea.y, swiHea.u1) annotation (Line(points={{32,80},{50,80},{50,88},
          {68,88}},       color={0,0,127}));
  connect(mapCoo.y, swiCoo.u1) annotation (Line(points={{32,-80},{50,-80},{50,
          -72},{68,-72}}, color={0,0,127}));
  connect(zero.y, swiHea.u3) annotation (Line(points={{-78,60},{40,60},{40,72},{
          68,72}},  color={0,0,127}));
  connect(zero.y, swiCoo.u3) annotation (Line(points={{-78,60},{40,60},{40,-88},
          {68,-88}}, color={0,0,127}));
  connect(swiOA.y, yOA)
    annotation (Line(points={{92,0},{140,0}}, color={0,0,127}));
  connect(mapOA.y, swiOA.u1)
    annotation (Line(points={{32,0},{50,0},{50,8},{68,8}}, color={0,0,127}));
  connect(zero.y, swiOA.u3) annotation (Line(points={{-78,60},{40,60},{40,-8},{68,
          -8}},    color={0,0,127}));
  connect(uEna, swiCoo.u2) annotation (Line(points={{-160,-100},{60,-100},{60,-80},
          {68,-80}},      color={255,0,255}));
  connect(uEna, swiOA.u2) annotation (Line(points={{-160,-100},{60,-100},{60,0},
          {68,0}}, color={255,0,255}));
  connect(uEna, swiHea.u2) annotation (Line(points={{-160,-100},{60,-100},{60,80},
          {68,80}},       color={255,0,255}));
  connect(swiCoo.y, yCoo)
    annotation (Line(points={{92,-80},{106,-80},{106,-80},{140,-80}},
                                                  color={0,0,127}));
  connect(limInfCoo.y, mapCoo.x1) annotation (Line(points={{-28,-80},{-4,-80},{
          -4,-72},{8,-72}}, color={0,0,127}));
  connect(uEna, con.trigger) annotation (Line(points={{-160,-100},{-106,-100},{-106,
          -12}}, color={255,0,255}));
  annotation (
  defaultComponentName="conTSup",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{120,140}})),
    Documentation(info="<html>
<p>
This block implements the control logic for the supply air temperature,
as described in the control sequence VAV 2A2-21232 of the
Sequences of Operation for Common HVAC Systems (ASHRAE, 2006).
</p>
<p>
The heating coil valve, outdoor air damper, and cooling coil valve are modulated
in sequence to maintain the supply air temperature set point.
A deadband between heating and economizer cooling is also modeled.
</p>
<p>
Note that the economizer lockout when the outdoor air temperature
is higher than the return air temperature is implemented in
<a href=\"modelica://Buildings.Examples.VAVReheat.Controls.Economizer\">
Buildings.Examples.VAVReheat.Controls.Economizer</a>.
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
October 27, 2020, by Antoine Gautier:<br/>
First implementation.<br/>
</li>
</ul>
</html>"));
end SupplyAirTemperature;
