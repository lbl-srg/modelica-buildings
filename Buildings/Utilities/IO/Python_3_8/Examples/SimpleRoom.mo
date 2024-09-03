within Buildings.Utilities.IO.Python_3_8.Examples;
model SimpleRoom
  "Simple room model implemented in Python that outputs the temperature and the energy"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Python_3_8.Real_Real pyt(
    moduleName="SimpleRoom",
    functionName="doStep",
    nDblRea=2,
    nDblWri=4,
    samplePeriod=60,
    passPythonObject=true) "Python interface"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Constant T0(k=293.15) "Initial temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Routing.Multiplex4 mul "Multiplex"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Controls.OBC.CDL.Conversions.BooleanToReal onOff(realTrue=1.2)
    "On off control"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.Sine TAmb(
    amplitude=5,
    offset=283.15,
    y(unit="K", displayUnit="degC"),
    f=1/86400,
    phase=-1.5707963267949) "Ambient temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Inputs different"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis onOffCon(
    final uLow=-1,
    final uHigh=1)
    "On/off control"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
equation
  connect(mul.u1[1], T0.y) annotation (Line(points={{-22,19},{-40,19},{-40,80},{
          -59,80}}, color={0,0,127}));
  connect(modTim.y, mul.u4[1]) annotation (Line(points={{-59,0},{-50,0},{-50,1},
          {-22,1}}, color={0,0,127}));
  connect(mul.y, pyt.uR)
    annotation (Line(points={{1,10},{18,10}},    color={0,0,127}));
  connect(onOff.y, mul.u3[1]) annotation (Line(points={{82,50},{90,50},{90,-10},
          {-40,-10},{-40,7},{-22,7}}, color={0,0,127}));
  connect(TAmb.y, mul.u2[1]) annotation (Line(points={{-59,40},{-46,40},{-46,13},
          {-22,13}}, color={0,0,127}));
  connect(onOffCon.y, onOff.u)
    annotation (Line(points={{42,50},{58,50}}, color={255,0,255}));
  connect(pyt.yR[1], sub1.u2) annotation (Line(points={{41,9.75},{50,9.75},{50,30},
          {-34,30},{-34,44},{-22,44}}, color={0,0,127}));
  connect(T0.y, sub1.u1) annotation (Line(points={{-59,80},{-40,80},{-40,56},{-22,
          56}}, color={0,0,127}));
  connect(sub1.y, onOffCon.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  annotation (
experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Python_3_8/Examples/SimpleRoom.mos"
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
December 11, 2023, by Jianjun Hu:<br/>
Reimplemented on-off control to avoid using the obsolete <code>OnOffController</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">#3595</a>.
</li>
<li>
August 27, 2021, by Michael Wetter:<br/>
Updated to Python 3.8.
</li>
<li>
April 10, 2020, by Jianjun Hu and Michael Wetter:<br/>
Updated to Python 3.6.
</li>
<li>
January 31, 2018, by Michael Wetter and Thierry Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimpleRoom;
