within Buildings.Applications.DataCenters.DXCooled.Controls;
model AirsideEconomizer "Controller for airside economizer"

  parameter Real gai(min=Modelica.Constants.small) = 1
    "Gain of controller"
    annotation(Dialog(group="Control"));
  parameter Modelica.Units.SI.Time Ti=50 "Integrator time"
    annotation (Dialog(group="Control"));
  parameter Real minOAFra(min=0,max=1, final unit="1")
    "Minimum outdoor air fraction";

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
  Modelica.Blocks.Interfaces.IntegerInput cooMod
    "Cooling mode of the cooling system"
    annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.Continuous.LimPID con(
    reverseActing=false,
    k=gai,
    yMin=minOAFra,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=Ti) "PID controller"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(final k=0)
    "Constant output signal with value 1"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Integer(Types.CoolingModes.FullMechanical))
    "Outputs signal for full mechanical cooling"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Equal ecoOff
    "Determine if airside economizer is off"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch1
    "Switch to select control output"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(TMixAirSet, con.u_s)
    annotation (Line(points={{-120,60},{-82,60}}, color={0,0,127}));
  connect(TMixAirMea, con.u_m)
    annotation (Line(points={{-120,0},{-70,0},{-70,48}}, color={0,0,127}));
  connect(switch1.y, y)
    annotation (Line(points={{61,0},{68,0},{110,0}}, color={0,0,127}));
  connect(ecoOff.y, switch1.u2) annotation (Line(points={{-19,-60},{20,-60},{20,
          0},{38,0}},     color={255,0,255}));
  connect(const.y, switch1.u1)
    annotation (Line(points={{21,30},{28,30},{28,8},{38,8}}, color={0,0,127}));
  connect(con.y, switch1.u3)
    annotation (Line(points={{-59,60},{-20,60},{-20,-8},
          {38,-8}}, color={0,0,127}));
  connect(ecoOff.u2, conInt.y)
    annotation (Line(points={{-42,-68},{-50,-68},{-50,
          -80},{-59,-80}}, color={255,127,0}));
  connect(ecoOff.u1, cooMod)
    annotation (Line(points={{-42,-60},{-120,-60}},
           color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{128,114},{-128,166}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
This model implements an airside economizer controller to modulate the outdoor air damper
in order to maintain desired mixed air temperature.
When the airside economizer is open, which means the system is in free cooling or partial mechanical
cooling, the position of the OA damper is controlled by a PI controller to maintain a desired mixed air temperature;
otherwise, the position of the OA damper is set as closed.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirsideEconomizer;
