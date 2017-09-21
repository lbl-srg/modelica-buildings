within Buildings.Examples.VAVReheat.Controls;
block RoomVAV "Controller for room VAV box"
  extends Modelica.Blocks.Icons.Block;

  parameter Real kPDamHea = 0.5
    "Proportional gain for VAV damper in heating mode";
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
  Buildings.Controls.OBC.CDL.Continuous.LimPID conCoo(
    yMax=1,
    Td=60,
    k=0.1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
            "Controller for cooling (acts on damper)"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  ControlBus controlBus "Control bus"
    annotation (Placement(transformation(extent={{-80,64},{-60,84}})));
  Modelica.Blocks.Interfaces.RealInput TRoo(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput yHea "Signal for heating coil valve"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealInput TSup(displayUnit="degC")
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Max maxDam
    "Limitation of damper signal"
    annotation (Placement(transformation(extent={{12,-14},{32,6}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-60,-76},{-40,-56}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Addition of cooling and heating signal (one of which being zero due to dual setpoint)"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero(k=0.1)
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Min minDam
    "Limitation of damper signal"
    annotation (Placement(transformation(extent={{72,-60},{92,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final k={1,kPDamHea,-kPDamHea},
    nin=3) annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
equation
  connect(controlBus.TRooSetHea, conHea.u_s) annotation (Line(
      points={{-70,74},{-70,60},{-22,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus.TRooSetCoo, conCoo.u_s) annotation (Line(
      points={{-70,74},{-70,-50},{-22,-50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(conHea.u_m, TRoo) annotation (Line(
      points={{-10,48},{-10,40},{-120,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.u_m, TRoo) annotation (Line(
      points={{-10,-62},{-10,-80},{-80,-80},{-80,40},{-120,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conCoo.y, add.u2) annotation (Line(
      points={{1,-50},{8,-50},{8,-36},{38,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHea.y, yHea) annotation (Line(
      points={{1,60},{80,60},{80,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zero.y, maxDam.u1)
    annotation (Line(points={{1,20},{6,20},{6,2},{10,2}}, color={0,0,127}));
  connect(maxDam.y, add.u1) annotation (Line(points={{33,-4},{34,-4},{34,-24},{
          38,-24}}, color={0,0,127}));
  connect(add.y, minDam.u1) annotation (Line(points={{61,-30},{64,-30},{64,-44},
          {70,-44}}, color={0,0,127}));
  connect(one.y, minDam.u2) annotation (Line(points={{-39,-66},{64,-66},{64,-66},
          {64,-56},{70,-56}}, color={0,0,127}));
  connect(minDam.y, yDam)
    annotation (Line(points={{93,-50},{110,-50},{110,-50}}, color={0,0,127}));
  connect(one.y, mulSum.u[1]) annotation (Line(points={{-39,-66},{-30,-66},{-30,
          -5.33333},{-22,-5.33333}}, color={0,0,127}));
  connect(TSup, mulSum.u[2]) annotation (Line(points={{-120,-40},{-40,-40},{-40,
          -10},{-22,-10}}, color={0,0,127}));
  connect(TRoo, mulSum.u[3]) annotation (Line(points={{-120,40},{-80,40},{-80,
          -14},{-80,-14},{-80,-14.6667},{-22,-14.6667}},
                                                    color={0,0,127}));
  connect(maxDam.u2, mulSum.y)
    annotation (Line(points={{10,-10},{1.7,-10}}, color={0,0,127}));
  annotation ( Icon(graphics={
        Text(
          extent={{-92,48},{-44,24}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{-92,-30},{-44,-54}},
          lineColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{42,52},{90,28}},
          lineColor={0,0,127},
          textString="yHea"),
        Text(
          extent={{46,-36},{94,-60}},
          lineColor={0,0,127},
          textString="yCoo")}), Documentation(info="<html>
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
