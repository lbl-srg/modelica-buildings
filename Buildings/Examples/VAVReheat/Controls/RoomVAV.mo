within Buildings.Examples.VAVReheat.Controls;
block RoomVAV "Controller for room VAV box"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput yVal "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conHea(
    yMax=1,
    xi_start=0.1,
    Td=60,
    yMin=0,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
            "Controller for heating"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.Continuous.LimPID conCoo(
    yMax=1,
    Td=60,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0.1,
    reverseAction=true)
    "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
protected
  parameter Real kDamHea = 0.5
    "Gain for VAV damper controller in heating mode";

equation
  connect(conHea.u_m, TRoo) annotation (Line(
      points={{-10,48},{-10,36},{-80,36},{-80,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_m, TRoo) annotation (Line(
      points={{-10,-62},{-10,-90},{-80,-90},{-80,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y,yVal)  annotation (Line(
      points={{1,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.u_s, TRooHeaSet) annotation (Line(points={{-22,60},{-80,60},{
          -80,80},{-120,80}},
                          color={0,0,127}));
  connect(TRooCooSet, conCoo.u_s) annotation (Line(points={{-120,40},{-50,40},{
          -50,-50},{-22,-50}},
                           color={0,0,127}));
  connect(conCoo.y, yDam)
    annotation (Line(points={{1,-50},{110,-50}}, color={0,0,127}));
  annotation ( Icon(graphics={
        Text(
          extent={{-92,-16},{-44,-40}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-92,-72},{-44,-96}},
          lineColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{44,-34},{92,-58}},
          lineColor={0,0,127},
          textString="yHea"),
        Text(
          extent={{42,64},{90,40}},
          lineColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-90,100},{-42,76}},
          lineColor={0,0,127},
          textString="TRooHeaSet"),
        Text(
          extent={{-90,42},{-42,18}},
          lineColor={0,0,127},
          textString="TRooCooSet")}),
                                Documentation(info="<html>
<p>
Controller for terminal box of VAV system with reheat.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2017, by Michael Wetter:<br/>
Removed blocks with blocks from CDL package.
</li>
</ul>
</html>"));
end RoomVAV;
