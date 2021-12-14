within Buildings.Applications.DataCenters.DXCooled.Controls;
model Compressor "Controller for compressor speed"

  parameter Real k=0.5 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti=240 "Time constant of integrator block";
  parameter Real yMax=1 "Upper limit of output";
  parameter Real yMin=0 "Lower limit of output";
  parameter Boolean reverseActing=false
    "Set to true for throttling the water flow rate through a cooling coil controller";

  Buildings.Controls.Continuous.LimPID dxSpe(
    Td=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final yMax=yMax,
    final yMin=yMin,
    reverseActing=reverseActing,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=yMin) "Controller for variable speed DX coil"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode of the cooling system"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    min=0,
    max=1,
    final unit="1") "Compressor speed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TMixAirSet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC") "Mixed air setpoint temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TMixAirMea(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC") "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Negation of signal to trigger the integrator reset"
    annotation (Placement(transformation(extent={{-68,20},{-48,40}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=Integer(
        Buildings.Applications.DataCenters.Types.CoolingModes.FreeCooling))
    "Outputs signal for full mechanical cooling"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal freCoo
    "Determine if free cooling is on"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch1
    "Switch to select control output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(final k=0)
    "Constant output signal with value 1"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));


equation
  connect(cooMod, freCoo.u1) annotation (Line(points={{-120,-70},{-92,-70},{-92,
          -50},{-42,-50}}, color={255,127,0}));
  connect(conInt.y, freCoo.u2) annotation (Line(points={{-59,-70},{-52,-70},{-52,
          -58},{-42,-58}}, color={255,127,0}));
  connect(freCoo.y, switch1.u2) annotation (Line(points={{-19,-50},{40,-50},{40,
          0},{58,0}}, color={255,0,255}));
  connect(const.y, switch1.u1)
    annotation (Line(points={{41,40},{48,40},{48,8},{58,8}}, color={0,0,127}));
  connect(dxSpe.y, switch1.u3) annotation (Line(points={{-19,60},{10,60},{10,-8},
          {58,-8}},color={0,0,127}));
  connect(switch1.y, y)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(TMixAirSet, dxSpe.u_s)
    annotation (Line(points={{-120,60},{-42,60}}, color={0,0,127}));
  connect(TMixAirMea, dxSpe.u_m)
    annotation (Line(points={{-120,0},{-30,0},{-30,48}},color={0,0,127}));
  connect(not1.y, dxSpe.trigger)
    annotation (Line(points={{-47,30},{-38,30},{-38,48}}, color={255,0,255}));
  connect(freCoo.y, not1.u) annotation (Line(points={{-19,-50},{0,-50},{0,-20},
          {-80,-20},{-80,30},{-70,30}},color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{128,114},{-128,166}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model implements a PI controller to maintain the supply air temperature at its setpoint by adjusting the compressor's speed.
When the free cooling is activated, the DX unit is deactivated by setting the speed signal as 0. In Partial Mechanical cooling and
Full Mechanical cooling, the PI controller works to adjust the compressor's speed.
</p>
</html>", revisions="<html>
<ul>
<li>
November 6, 2017, by Michael Wetter:<br/>
Added reset for integrator when compressor switches on.
</li>
<li>
November 2, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Compressor;
