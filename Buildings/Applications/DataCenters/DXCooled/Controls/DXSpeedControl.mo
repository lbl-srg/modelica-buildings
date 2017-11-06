within Buildings.Applications.DataCenters.DXCooled.Controls;
model DXSpeedControl "Speed controller of DX coil"

  parameter Real k=0.5 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=240 "Time constant of Integrator block";
  parameter Real yMax=1 "Upper limit of output";
  parameter Real yMin=0 "Lower limit of output";
  parameter Boolean reverseAction=true
    "Set to true for throttling the water flow rate through a cooling coil controller";

  Buildings.Controls.Continuous.LimPID dxSpe(
    Td=1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    yMax=yMax,
    yMin=yMin,
    reverseAction=reverseAction)
    "Controller for variable speed DX coil"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode of the cooling system"
    annotation (Placement(
        transformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of Real output signal"
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
    annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=Integer(
        Types.CoolingModes.FreeCooling))
    "Outputs signal for full mechanical cooling"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal freCoo
    "Determine if free cooling is on"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch1
    "Switch to select control output"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(final k=0)
    "Constant output signal with value 1"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

equation
  connect(cooMod, freCoo.u1)
    annotation (Line(points={{-120,-70},{-22,-70}}, color={255,127,0}));
  connect(conInt.y, freCoo.u2) annotation (Line(points={{-59,-90},{-40,-90},{-40,
          -78},{-22,-78}}, color={255,127,0}));
  connect(freCoo.y, switch1.u2) annotation (Line(points={{1,-70},{20,-70},{20,0},
          {38,0}}, color={255,0,255}));
  connect(const.y, switch1.u1)
    annotation (Line(points={{21,40},{28,40},{28,8},{38,8}}, color={0,0,127}));
  connect(dxSpe.y, switch1.u3) annotation (Line(points={{-39,20},{0,20},{0,-8},{
          38,-8}}, color={0,0,127}));
  connect(switch1.y, y)
    annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));
  connect(TMixAirSet, dxSpe.u_s) annotation (Line(points={{-120,60},{-80,60},{-80,
          20},{-62,20}}, color={0,0,127}));
  connect(TMixAirMea, dxSpe.u_m)
    annotation (Line(points={{-120,0},{-50,0},{-50,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                  Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{128,114},{-128,166}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model implements a PI controller to maintain the supply air temperature at its setpoint by adjusting the compressor's speed. 
When the free cooling is activated, the DX unit is deactivated by setting the speed signal as 0. In Partial Mechanical cooling and 
Full Mechanical cooling, the PI controller works to adjust the compressor's speed. 
</p>
</html>", revisions="<html>
<ul>
<li>
November 2, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DXSpeedControl;
