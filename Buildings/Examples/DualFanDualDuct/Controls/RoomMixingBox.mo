within Buildings.Examples.DualFanDualDuct.Controls;
block RoomMixingBox "Controller for room mixing box"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.MassFlowRate m_flow_min "Minimum mass flow rate";
  Buildings.Controls.OBC.CDL.Reals.PID conHea(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Td=60,
    k=0.1,
    Ti=120) "Controller for heating"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.PID conCoo(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseActing=false,
    Td=60,
    k=0.1,
    Ti=120) "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC", min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput yHot "Signal for hot air damper"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput yCol "Signal for cold deck air damper"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealInput mAir_flow
    "Measured air mass flow rate into the room"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput yFan
    "Fan operation, true if fan is running"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.PID conFloRat(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Td=60,
    k=0.1,
    Ti=120,
    r=m_flow_min)   "Controller for mass flow rate"
    annotation (Placement(transformation(extent={{-42,30},{-22,50}})));
  Modelica.Blocks.Sources.Constant mAirSet(k=m_flow_min)
    "Set point for minimum air flow rate"
    annotation (Placement(transformation(extent={{-72,30},{-52,50}})));
  Buildings.Controls.OBC.CDL.Reals.Max max
    "Adds control signal for minimum flow rate of zone"
    annotation (Placement(transformation(extent={{38,38},{58,58}})));
  Modelica.Blocks.Interfaces.RealInput TRooSetHea(unit="K")
    "Room temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TRooSetCoo(unit="K")
    "Room temperature setpoint for cooling"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Sources.RealExpression gaiHea(y=1 - gaiCoo.y)
    "Gain for adding minimum flow rate to cooling signal"
    annotation (Placement(transformation(extent={{-40,-2},{-12,18}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{8,12},{28,32}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{8,-44},{28,-24}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxCoo
    "Adds control signal for minimum flow rate of zone"
    annotation (Placement(transformation(extent={{40,-26},{60,-6}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTSet
    "Difference in set point"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTRooHea
    "Difference in room air temperature compared to heating setpoint"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Limiter gaiCoo(uMax=1, uMin=0)
    "Gain of cooling"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Divide gaiCooUnl
    "Gain of cooling, unlimited"
    annotation (Placement(transformation(extent={{-28,-80},{-8,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiHot "Switch for heating"
    annotation (Placement(transformation(extent={{74,30},{94,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiCoo "Switch for cooling"
    annotation (Placement(transformation(extent={{72,-60},{92,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(k=0) "Zero signal"
    annotation (Placement(transformation(extent={{34,-68},{54,-48}})));
equation
  connect(mAir_flow, conFloRat.u_m) annotation (Line(
      points={{-120,-40},{-90,-40},{-90,20},{-32,20},{-32,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y, max.u1) annotation (Line(
      points={{-38,80},{20,80},{20,54},{36,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.u_s, TRooSetHea) annotation (Line(
      points={{-62,80},{-76,80},{-76,40},{-120,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_s, TRooSetCoo) annotation (Line(
      points={{-62,-10},{-90,-10},{-90,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo, conCoo.u_m) annotation (Line(
      points={{-120,80},{-82,80},{-82,-28},{-50,-28},{-50,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo, conHea.u_m) annotation (Line(
      points={{-120,80},{-82,80},{-82,62},{-50,62},{-50,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFloRat.y, product.u1) annotation (Line(
      points={{-20,40},{-6,40},{-6,28},{6,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, max.u2) annotation (Line(
      points={{29,22},{32,22},{32,42},{36,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.u2, gaiHea.y) annotation (Line(
      points={{6,16},{-2,16},{-2,8},{-10.6,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAirSet.y, conFloRat.u_s) annotation (Line(
      points={{-51,40},{-44,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dTSet.u1, TRooSetCoo) annotation (Line(points={{-62,-74},{-68,-74},{
          -68,0},{-120,0}},
                        color={0,0,127}));
  connect(dTSet.u2, TRooSetHea) annotation (Line(points={{-62,-86},{-76,-86},{
          -76,40},{-120,40}},
                          color={0,0,127}));
  connect(dTRooHea.u1, TRoo) annotation (Line(points={{-62,-44},{-82,-44},{-82,
          80},{-120,80}},
                      color={0,0,127}));
  connect(dTRooHea.u2, TRooSetHea) annotation (Line(points={{-62,-56},{-76,-56},
          {-76,40},{-120,40}}, color={0,0,127}));
  connect(gaiCooUnl.u1, dTRooHea.y) annotation (Line(points={{-30,-64},{-36,-64},
          {-36,-50},{-38,-50}}, color={0,0,127}));
  connect(dTSet.y, gaiCooUnl.u2) annotation (Line(points={{-38,-80},{-34,-80},{-34,
          -76},{-30,-76}}, color={0,0,127}));
  connect(gaiCooUnl.y, gaiCoo.u)
    annotation (Line(points={{-6,-70},{-2,-70}}, color={0,0,127}));
  connect(gaiCoo.y, product1.u2) annotation (Line(points={{22,-70},{28,-70},{28,
          -50},{-8,-50},{-8,-40},{6,-40}},
                          color={0,0,127}));
  connect(conFloRat.y, product1.u1) annotation (Line(points={{-20,40},{-6,40},{-6,
          -28},{6,-28}},  color={0,0,127}));
  connect(conCoo.y, maxCoo.u1) annotation (Line(points={{-38,-10},{38,-10}},
                     color={0,0,127}));
  connect(maxCoo.u2, product1.y)
    annotation (Line(points={{38,-22},{32,-22},{32,-34},{29,-34}},
                                                 color={0,0,127}));
  connect(swiHot.y, yHot)
    annotation (Line(points={{96,40},{110,40}}, color={0,0,127}));
  connect(swiHot.u1, max.y)
    annotation (Line(points={{72,48},{60,48}}, color={0,0,127}));
  connect(yCol, swiCoo.y)
    annotation (Line(points={{110,-50},{94,-50}}, color={0,0,127}));
  connect(swiCoo.u1, maxCoo.y) annotation (Line(points={{70,-42},{66,-42},{66,-16},
          {62,-16}},      color={0,0,127}));
  connect(swiCoo.u2, yFan) annotation (Line(points={{70,-50},{62,-50},{62,-96},
          {-80,-96},{-80,-80},{-120,-80}}, color={255,0,255}));
  connect(zer.y, swiCoo.u3)
    annotation (Line(points={{56,-58},{70,-58}}, color={0,0,127}));
  connect(zer.y, swiHot.u3) annotation (Line(points={{56,-58},{64,-58},{64,32},{
          72,32}},  color={0,0,127}));
  connect(yFan, swiHot.u2) annotation (Line(points={{-120,-80},{-80,-80},{-80,
          -96},{62,-96},{62,40},{72,40}}, color={255,0,255}));
  annotation ( Icon(graphics={
        Text(
          extent={{-86,92},{-38,68}},
          textColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-88,-28},{-40,-52}},
          textColor={0,0,127},
          textString="m_flow"),
        Text(
          extent={{42,52},{90,28}},
          textColor={0,0,127},
          textString="yHea"),
        Text(
          extent={{46,-36},{94,-60}},
          textColor={0,0,127},
          textString="yCoo"),
        Text(
          extent={{-84,52},{-36,28}},
          textColor={0,0,127},
          textString="TSetH"),
        Text(
          extent={{-84,10},{-36,-14}},
          textColor={0,0,127},
          textString="TSetC"),
        Text(
          extent={{-86,-64},{-38,-88}},
          textColor={0,0,127},
          textString="yFan")}),
    Documentation(info="<html>
This controller outputs the control signal for the air damper for the hot deck and the cold deck.
The control signal for the hot deck is the larger of the two signals needed to track the room heating
temperature setpoint, and the minimum air flow rate.
</html>", revisions="<html>
<ul>
<li>
October 15, 2020, by Michael Wetter:<br/>
Moved normalization of control error to PID controller.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2182\">#2182</a>.
</li>
</ul>
</html>"));
end RoomMixingBox;
