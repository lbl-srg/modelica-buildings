within Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.BaseClasses;
model AirsideEconomizerController "Airside economizer controller"

  parameter Real gai(min=Modelica.Constants.small) = 1
    "Proportional gain of controller"
    annotation(Dialog(group="Control"));
  parameter Modelica.SIunits.Time Ti
    "Integrator time"
    annotation(Dialog(group="Control"));
  parameter Real minOAFra(min=0,max=1, final unit="1")
    "Minimum outdoor air fraction";
  Buildings.Controls.Continuous.LimPID con(
    Td=1,
    reverseAction=true,
    k=gai,
    yMin=minOAFra,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=Ti) "PID controller"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Interfaces.RealInput MATSet(
    final unit="K", displayUnit="degC")
    "Mixed air setpoint temperature"
    annotation (Placement(transformation(rotation=0,
      extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput MAT(
    final unit="K", displayUnit="degC")
    "Measured mixed air temperature"
    annotation (Placement(transformation(rotation=0, extent={{-140,20},
      {-100,60}})));
  Modelica.Blocks.Interfaces.RealInput cooMod(
    final unit="1")
    "Cooling mode of the cooling system"
    annotation (Placement(
        transformation(rotation=0, extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Math.RealToBoolean ASEOff(final threshold=1.5)
    "Determine if airside economizer is off"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Logical.Not not1 "Inverse signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Logical.Switch switch1 "Switch to select control output"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant const(final k=0)
    "Constant output signal with value 1"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(MATSet, con.u_s)
    annotation (Line(points={{-120,80},{-82,80}}, color={0,0,127}));
  connect(MAT, con.u_m)
    annotation (Line(points={{-120,40},{-70,40},{-70,68}}, color={0,0,127}));
  connect(ASEOff.y, not1.u)
    annotation (Line(points={{-59,0},{-50.5,0},{-42,0}}, color={255,0,255}));
  connect(cooMod, ASEOff.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(con.y, switch1.u1)
    annotation (Line(points={{-59,80},{0,80},{0,8},{38,8}}, color={0,0,127}));
  connect(not1.y, switch1.u2)
    annotation (Line(points={{-19,0},{38,0}}, color={255,0,255}));
  connect(const.y, switch1.u3)
  annotation (Line(points={{-59,-50},{0,-50},{0,-8},
          {38,-8}}, color={0,0,127}));
  connect(switch1.y, y)
    annotation (Line(points={{61,0},{68,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{128,114},{-128,166}},
          lineColor={0,0,255},
          textString="%name")}),
      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model implements an airside economizer controller to modulate the outdoor air damper 
in order to maintain desired mixed air temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirsideEconomizerController;
