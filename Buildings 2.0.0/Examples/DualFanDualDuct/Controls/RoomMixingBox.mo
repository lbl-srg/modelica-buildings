within Buildings.Examples.DualFanDualDuct.Controls;
block RoomMixingBox "Controller for room mixing box"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.MassFlowRate m_flow_min "Minimum mass flow rate";
  Buildings.Controls.Continuous.LimPID conHea(
    yMax=1,
    xi_start=0.1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    Td=60,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "Controller for heating"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.Continuous.LimPID conCoo(
    yMax=1,
    reverseAction=true,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-20,-66},{0,-46}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC", min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput yHot "Signal for hot air damper"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput yCol "Signal for cold deck air damper"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealInput mAir_flow
    "Measured air mass flow rate into the room"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.Continuous.LimPID conFloRat(
    yMax=1,
    xi_start=0.1,
    Td=60,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=120) "Controller for mass flow rate"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Modelica.Blocks.Sources.Constant mAirSet(k=m_flow_min)
    "Set point for minimum air flow rate"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Utilities.Math.SmoothMax smoothMaxHea(deltaX=0.01)
    "Adds control signal for minimum flow rate of zone"
    annotation (Placement(transformation(extent={{72,30},{92,50}})));
  Modelica.Blocks.Interfaces.RealInput TRooSetHea(unit="K")
    "Room temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TRooSetCoo(unit="K")
    "Room temperature setpoint for cooling"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Sources.RealExpression gaiCoo(y=
        Buildings.Utilities.Math.Functions.smoothLimit(
        (TRoo - TRooSetHea)/(TRooSetCoo - TRooSetHea),
        0,
        1,
        0.01)) "Gain for adding minimum flow rate to cooling signal"
    annotation (Placement(transformation(extent={{2,-34},{30,-14}})));
  Modelica.Blocks.Sources.RealExpression gaiHea(y=1 - gaiCoo.y)
    "Gain for adding minimum flow rate to cooling signal"
    annotation (Placement(transformation(extent={{2,-18},{30,2}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Utilities.Math.SmoothMax smoothMaxCoo(deltaX=0.01)
    "Adds control signal for minimum flow rate of zone"
    annotation (Placement(transformation(extent={{72,-60},{92,-40}})));
equation
  connect(mAir_flow, conFloRat.u_m) annotation (Line(
      points={{-120,-60},{-90,-60},{-90,-20},{-20,-20},{-20,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y, smoothMaxHea.u1)
                                   annotation (Line(
      points={{1,60},{20,60},{20,46},{70,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.u_s, TRooSetHea) annotation (Line(
      points={{-22,60},{-62,60},{-62,40},{-120,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_s, TRooSetCoo) annotation (Line(
      points={{-22,-56},{-72,-56},{-72,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo, conCoo.u_m) annotation (Line(
      points={{-120,80},{-80,80},{-80,-80},{-10,-80},{-10,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo, conHea.u_m) annotation (Line(
      points={{-120,80},{-80,80},{-80,44},{-10,44},{-10,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFloRat.y, product.u1) annotation (Line(
      points={{-9,10},{0,10},{0,26},{38,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, smoothMaxHea.u2) annotation (Line(
      points={{61,20},{66,20},{66,34},{70,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.u2, gaiHea.y) annotation (Line(
      points={{38,14},{34,14},{34,-8},{31.4,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gaiCoo.y, product1.u1) annotation (Line(
      points={{31.4,-24},{38,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFloRat.y, product1.u2) annotation (Line(
      points={{-9,10},{-4,10},{-4,-36},{38,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothMaxHea.y, yHot) annotation (Line(
      points={{93,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, smoothMaxCoo.u1) annotation (Line(
      points={{61,-30},{66,-30},{66,-44},{70,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.y, smoothMaxCoo.u2) annotation (Line(
      points={{1,-56},{70,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(smoothMaxCoo.y, yCol) annotation (Line(
      points={{93,-50},{110,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAirSet.y, conFloRat.u_s) annotation (Line(
      points={{-39,10},{-32,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(graphics={
        Text(
          extent={{-86,92},{-38,68}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-90,-44},{-42,-68}},
          lineColor={0,0,127},
          textString="m_flow"),
        Text(
          extent={{42,52},{90,28}},
          lineColor={0,0,127},
          textString="yHea"),
        Text(
          extent={{46,-36},{94,-60}},
          lineColor={0,0,127},
          textString="yCoo"),
        Text(
          extent={{-84,52},{-36,28}},
          lineColor={0,0,127},
          textString="TSetH"),
        Text(
          extent={{-84,10},{-36,-14}},
          lineColor={0,0,127},
          textString="TSetC")}),
    Documentation(info="<html>
This controller outputs the control signal for the air damper for the hot deck and the cold deck.
The control signal for the hot deck is the larger of the two signals needed to track the room heating
temperature setpoint, and the minimum air flow rate.
</html>"));
end RoomMixingBox;
