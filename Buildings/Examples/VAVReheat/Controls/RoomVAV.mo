within Buildings.Examples.VAVReheat.Controls;
block RoomVAV "Controller for room VAV box"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput yVal "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conHea(
    yMax=1,
    xi_start=0.1,
    Td=60,
    yMin=0,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
            "Controller for heating"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.Continuous.LimPID conCoo(
    yMax=1,
    Td=60,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0.1,
    reverseAction=true)
    "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
protected
  parameter Real kDamHea = 0.5
    "Gain for VAV damper controller in heating mode";

equation
  connect(conHea.u_m, TRoo) annotation (Line(
      points={{-10,38},{-10,20},{-80,20},{-80,-60},{-120,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_m, TRoo) annotation (Line(
      points={{-10,-42},{-10,-60},{-120,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y,yVal)  annotation (Line(
      points={{1,50},{40,50},{40,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.u_s, TRooHeaSet) annotation (Line(points={{-22,50},{-72,50},{
          -72,60},{-120,60}},
                          color={0,0,127}));
  connect(TRooCooSet, conCoo.u_s) annotation (Line(points={{-120,0},{-50,0},{
          -50,-30},{-22,-30}},
                           color={0,0,127}));
  connect(conCoo.y, yDam) annotation (Line(points={{1,-30},{40,-30},{40,-40},{
          110,-40}}, color={0,0,127}));
  annotation ( Icon(graphics={
        Text(
          extent={{-92,-46},{-44,-70}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{44,-34},{92,-58}},
          lineColor={0,0,127},
          textString="yHea"),
        Text(
          extent={{42,64},{90,40}},
          lineColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-90,74},{-42,50}},
          lineColor={0,0,127},
          textString="TRooHeaSet"),
        Text(
          extent={{-90,12},{-42,-12}},
          lineColor={0,0,127},
          textString="TRooCooSet")}),
                                Documentation(info="<html>
<p>
Controller for terminal box of VAV system with reheat.
</p>
</html>", revisions="<html>
<ul>
<li>Februray 22, 2019, by Kun Zhang:<br>Changed the damper position from 1 to 0.1 for heating mode.</li>
<li>September 20, 2017, by Michael Wetter:<br>Removed blocks with blocks from CDL package. </li>
</ul>
</html>"));
end RoomVAV;
