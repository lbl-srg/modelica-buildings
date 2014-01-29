within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads;
package Examples
  extends Modelica.Icons.ExamplesPackage;
  model dummyTest
    Sources.dummySource dummySource(
      f=50,
      V=200,
      Phi=0)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    BaseClasses.PartialLoad
              dummyLoad1
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    Modelica.Blocks.Sources.Sine sine(
      amplitude=20,
      freqHz=0.1,
      offset=50)
      annotation (Placement(transformation(extent={{20,40},{40,60}})));
    Modelica.Blocks.Sources.Constant const(k=0)
      annotation (Placement(transformation(extent={{20,70},{40,90}})));
  equation
    connect(dummySource.terminal_n, dummyLoad1.terminal_p) annotation (Line(
        points={{-60,0},{0,0}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(sine.y, dummyLoad1.y1) annotation (Line(
        points={{41,50},{46,50},{46,6},{20,6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(const.y, dummyLoad1.y2) annotation (Line(
        points={{41,80},{50,80},{50,0},{20,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sine.y, dummyLoad1.y3) annotation (Line(
        points={{41,50},{46,50},{46,-6},{20,-6}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),      graphics));
  end dummyTest;
end Examples;
