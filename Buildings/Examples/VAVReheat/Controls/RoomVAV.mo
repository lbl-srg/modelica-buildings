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

  Modelica.Blocks.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealOutput yVal "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,38},{120,58}})));

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
    reverseAction=true)
    "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
protected
  parameter Real kDamHea = 0.5
    "Gain for VAV damper controller in heating mode";

  Buildings.Controls.OBC.CDL.Continuous.Max maxDam
    "Limitation of damper signal"
    annotation (Placement(transformation(extent={{12,-14},{32,6}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-74,-76},{-54,-56}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Addition of cooling and heating signal (one of which being zero due to dual setpoint)"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero(k=0.1)
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Min minDam
    "Limitation of damper signal"
    annotation (Placement(transformation(extent={{70,-26},{90,-6}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final k={1,kDamHea,-kDamHea},
    nin=3) annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

equation
  connect(conHea.u_m, TRoo) annotation (Line(
      points={{-10,48},{-10,36},{-80,36},{-80,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_m, TRoo) annotation (Line(
      points={{-10,-62},{-10,-90},{-80,-90},{-80,-40},{-120,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.y, add.u2) annotation (Line(
      points={{1,-50},{20,-50},{20,-16},{38,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y,yVal)  annotation (Line(
      points={{1,60},{34,60},{34,-50},{110,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zero.y, maxDam.u1)
    annotation (Line(points={{1,20},{6,20},{6,2},{10,2}}, color={0,0,127}));
  connect(maxDam.y, add.u1) annotation (Line(points={{33,-4},{38,-4}},
                    color={0,0,127}));
  connect(add.y, minDam.u1) annotation (Line(points={{61,-10},{68,-10}},
                     color={0,0,127}));
  connect(one.y, minDam.u2) annotation (Line(points={{-53,-66},{64,-66},{64,-22},
          {68,-22}},          color={0,0,127}));
  connect(minDam.y, yDam)
    annotation (Line(points={{91,-16},{96,-16},{96,48},{108,48},{108,48},{110,
          48},{110,48}},                                    color={0,0,127}));
  connect(one.y, mulSum.u[1]) annotation (Line(points={{-53,-66},{-30,-66},{-30,
          -5.33333},{-22,-5.33333}}, color={0,0,127}));
  connect(TDis, mulSum.u[2]) annotation (Line(points={{-120,-80},{-40,-80},{-40,
          -10},{-22,-10}}, color={0,0,127}));
  connect(TRoo, mulSum.u[3]) annotation (Line(points={{-120,-40},{-80,-40},{-80,
          -14.6667},{-22,-14.6667}},                color={0,0,127}));
  connect(maxDam.u2, mulSum.y)
    annotation (Line(points={{10,-10},{1.7,-10}}, color={0,0,127}));
  connect(conHea.u_s, TRooHeaSet) annotation (Line(points={{-22,60},{-80,60},{
          -80,80},{-120,80}},
                          color={0,0,127}));
  connect(TRooCooSet, conCoo.u_s) annotation (Line(points={{-120,40},{-50,40},{
          -50,-50},{-22,-50}},
                           color={0,0,127}));
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
