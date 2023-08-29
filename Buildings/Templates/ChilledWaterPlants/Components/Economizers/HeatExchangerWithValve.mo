within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model HeatExchangerWithValve
  "Heat exchanger with bypass valve for CHW flow control"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizerHX(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve,
    hex(from_dp2=true));

  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatByp(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatByp,
    val(from_dp=true))
    "WSE CHW bypass valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatEco(
    redeclare final package Medium=MediumChiWat,
    final have_sen=true)
    "WSE CHW differential pressure"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation
  /* Control point connection - start */
  connect(bus.valChiWatEcoByp, valChiWatByp.bus);
  connect(bus.dpChiWatEco, dpChiWatEco.y);
  /* Control point connection - stop */

  connect(port_a, hex.port_a2)
    annotation (Line(points={{-100,0},{-20,0},{-20,68},{-10,68}},
                                                color={0,127,255}));
  connect(port_a, valChiWatByp.port_a) annotation (Line(points={{-100,0},{-10,0}},
                                color={0,127,255}));
  connect(valChiWatByp.port_b, port_b) annotation (Line(points={{10,0},{100,0}},
                           color={0,127,255}));
  connect(hex.port_a2, dpChiWatEco.port_a) annotation (Line(points={{-10,68},{-20,
          68},{-20,40},{-10,40}}, color={0,127,255}));
  connect(hex.port_b2, dpChiWatEco.port_b) annotation (Line(points={{10,68},{20,
          68},{20,40},{10,40}}, color={0,127,255}));
annotation (
 defaultComponentName="eco", Documentation(info="<html>
<p>
This is a model of a waterside economizer where a modulating
heat exchanger bypass valve is used to control the CHW flow rate 
through the heat exchanger.
The CW flow rate is modulated by means of a two-way valve.
As per standard practice, the model includes a differential pressure
sensor on the CHW side that measures the pressure drop 
across the heat exchanger.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
  Line(
    points={{0,30},{0,-30}},
    color={0,0,0},
          origin={430,0},
          rotation=-90),
  Bitmap(
    extent={{460,-38},{540,42}},
    fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
  Bitmap(
    extent={{140,-40},{220,40}},
    fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressure.svg"),
  Bitmap(
    extent={{190,-100},{270,-20}},
    fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureHigh.svg"),
  Bitmap(
    extent={{190,20},{270,100}},
    fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/DifferentialPressureLow.svg"),
        Rectangle(extent={{175,-40},{185,-80}}, lineColor={0,0,0}),
        Rectangle(extent={{175,80},{185,40}}, lineColor={0,0,0}),
  Bitmap(
    extent={{-100,-100},{100,100}},
    fileName=
        "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
    rotation=180,
    origin={400,0})}));
end HeatExchangerWithValve;
