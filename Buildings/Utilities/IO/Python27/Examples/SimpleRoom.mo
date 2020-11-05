within Buildings.Utilities.IO.Python27.Examples;
model SimpleRoom
  "Simple room model implemented in Python that outputs the temperature and the energy"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Real_Real pyt(
    moduleName="SimpleRoom",
    functionName="doStep",
    nDblRea=2,
    nDblWri=4,
    samplePeriod=60,
    passPythonObject=true)
                     "Python interface"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Blocks.Sources.Constant T0(k=293.15) "Initial temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Routing.Multiplex4 mul "Multiplex"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Controls.OBC.CDL.Logical.OnOffController onOffCon(
    bandwidth=2,
    u(unit="K", displayUnit="degC"))
    "On/off controller"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Controls.OBC.CDL.Conversions.BooleanToReal onOff(realTrue=1.2)
    "On off control"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Modelica.Blocks.Sources.Sine TAmb(
    amplitude=5,
    offset=283.15,
    y(unit="K", displayUnit="degC"),
    freqHz=1/86400,
    phase=-1.5707963267949) "Ambient temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(mul.u1[1], T0.y) annotation (Line(points={{-42,19},{-46,19},{-46,80},{
          -59,80}}, color={0,0,127}));
  connect(clock.y, mul.u4[1]) annotation (Line(points={{-59,0},{-50,0},{-50,1},{
          -42,1}},     color={0,0,127}));
  connect(mul.y, pyt.uR)
    annotation (Line(points={{-19,10},{-12,10}}, color={0,0,127}));
  connect(pyt.yR[1], onOffCon.u) annotation (Line(points={{11,9.5},{18,9.5},{18,
          14},{28,14}}, color={0,0,127}));
  connect(onOffCon.reference, T0.y) annotation (Line(points={{28,26},{0,26},{0,80},
          {-59,80}}, color={0,0,127}));
  connect(onOffCon.y, onOff.u)
    annotation (Line(points={{51,20},{58,20}}, color={255,0,255}));
  connect(onOff.y, mul.u3[1]) annotation (Line(points={{81,20},{90,20},{90,-10},
          {-48,-10},{-48,7},{-42,7}}, color={0,0,127}));
  connect(TAmb.y, mul.u2[1]) annotation (Line(points={{-59,40},{-52,40},{-52,13},
          {-42,13}}, color={0,0,127}));
  annotation (
experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Python27/Examples/SimpleRoom.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the implementation of a simple room model
that is implemented in the Python module <code>Resources/Python-Sources/SimpleRoom.py</code>.
The Python model computes a first-order response to the room model.
It returns the current room air temperature and the energy consumed during the simulation.
The Python module also passes an object from one call to the next. This object
contains the past room temperature, energy and time when the function was called,
stored as a Python dictionary.
This illustrates how Python data structures can be passed between function calls,
thereby enabling for example to call some (memory-intensive) machine learning program,
implemented in Python, from a Modelica block that may then pass the output of this program
to a controller.
</p>
<p>
Note that this example is for demonstration only. An implementation in Modelica
would be much simpler and computationally more efficient.
</p>
</html>", revisions="<html>
<ul>
<li>
January 31, 2018, by Michael Wetter and Thierry Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimpleRoom;
