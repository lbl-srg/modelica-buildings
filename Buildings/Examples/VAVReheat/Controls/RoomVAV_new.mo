within Buildings.Examples.VAVReheat.Controls;
block RoomVAV_new "Controller for room VAV box"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooCooSet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput yVal "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}}),
        iconTransformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,38},{120,58}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conHea(
    yMax=1,
    xi_start=0.1,
    Td=60,
    yMin=0,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
            "Controller for heating"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.Continuous.LimPID conCoo(
    yMax=1,
    Td=60,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=true)
    "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMax(k=VCooMax_flow)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFlo(k=VMin_flow)
    "VAV box minimum flow"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(k=0)
    "Constant 0" annotation (Placement(transformation(extent={{0,30},{20,50}})));
protected
  parameter Real kDamHea = 0.5
    "Gain for VAV damper controller in heating mode";

equation
  connect(TRooCooSet, conCoo.u_s)
    annotation (Line(points={{-120,0},{-62,0}}, color={0,0,127}));
  connect(TRoo, conHea.u_m) annotation (Line(points={{-120,-70},{-80,-70},{-80,
          -90},{-50,-90},{-50,-82}}, color={0,0,127}));
  connect(TRooHeaSet, conHea.u_s) annotation (Line(points={{-120,60},{-70,60},{
          -70,-70},{-62,-70}}, color={0,0,127}));
  connect(conHea.y, yVal)
    annotation (Line(points={{-38,-70},{110,-70}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{22,40},{30,40},{30,8},{38,8}}, color={0,0,127}));
  connect(minFlo.y, lin.f1) annotation (Line(points={{-18,40},{-10,40},{-10,4},
          {38,4}}, color={0,0,127}));
  connect(cooMax.y, lin.f2) annotation (Line(points={{22,-40},{28,-40},{28,-8},
          {38,-8}}, color={0,0,127}));
  connect(conOne.y, lin.x2) annotation (Line(points={{-18,-40},{-10,-40},{-10,
          -4},{38,-4}}, color={0,0,127}));
  connect(conCoo.y, lin.u)
    annotation (Line(points={{-39,0},{38,0}}, color={0,0,127}));
  connect(lin.y, yDam) annotation (Line(points={{62,0},{84,0},{84,40},{110,40}},
        color={0,0,127}));
  connect(TRoo, conCoo.u_m) annotation (Line(points={{-120,-70},{-80,-70},{-80,
          -20},{-50,-20},{-50,-12}}, color={0,0,127}));
  annotation ( Icon(coordinateSystem(extent={{-100,-100},{100,120}}),
                    graphics={
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
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end RoomVAV_new;
