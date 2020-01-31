within Buildings.Fluid.HeatPumps.BaseClasses;
block ReSetTSetCoo "Reset of TSetCoo for heating mode"
  extends Modelica.Blocks.Icons.Block;

   Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", displayUnit="degC")
    "Set point temperature"
     annotation (Placement(transformation(extent={{-120,50},
            {-100,70}}), iconTransformation(extent={{-120,18},{-100,38}})));
   Modelica.Blocks.Interfaces.IntegerInput uMod
     "Control input signal, cooling mode= -1, off=0, heating mode=+1"
     annotation (Placement(transformation(extent={{-120,-60},{-100,-40}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
   Modelica.Blocks.Interfaces.RealInput TLoaLvg(final
     unit="K",
     displayUnit="degC")
     "Load side leaving water temperature."
     annotation (Placement(
        transformation(extent={{-120,30},{-100,50}}), iconTransformation(extent={{-120,
            -90},{-100,-70}})));
   Modelica.Blocks.Interfaces.RealInput TSouLvgMin(final
     unit="K",
     displayUnit="degC")
     "Minimum leaving water temperature at the source side" annotation (
      Placement(transformation(extent={{-120,10},{-100,30}}),
        iconTransformation(extent={{-120,82},{-100,102}})));
   Modelica.Blocks.Interfaces.RealInput TSouLvgMax(final
     unit="K",
     displayUnit= "degC")
     "Maximum source leaving water temperature"
     annotation (Placement(
        transformation(extent={{-120,70},{-100,90}}), iconTransformation(extent={{-120,50},
            {-100,70}})));
    Modelica.Blocks.Interfaces.RealOutput chiTSet(
    final unit="K",
      displayUnit="degC")
      "Reset of the cooling set point in heating mode"
     annotation (Placement(transformation(extent={{100,-20},{120,0}}),
                 iconTransformation(extent={{100,-10},{120,10}})));
   Buildings.Controls.OBC.CDL.Continuous.Line lin
     annotation (Placement(transformation(extent={{24,30},{44,50}})));
   Controls.OBC.CDL.Continuous.Sources.Constant x1(k=0)
     annotation (Placement(transformation(extent={{-2,60},{18,80}})));
   Modelica.Blocks.Logical.Switch switch1
     annotation (Placement(transformation(extent={{60,-20},{80,0}})));
   Controls.OBC.CDL.Continuous.LimPID conPID(
     controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
     k=0.1,
     Ti=300,
     yMax=1,
     yMin=0.1,
     reverseAction=true,
     reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
     annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant x2(k=1)
     annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(threshold=0)
     annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation

  connect(TSet, conPID.u_s)
    annotation (Line(points={{-110,60},{-42,60}}, color={0,0,127}));
  connect(TSet, switch1.u3)
    annotation (Line(points={{-110,60},{-80,60},{-80,
          -18},{58,-18}},
                     color={0,0,127}));
  connect(TLoaLvg, conPID.u_m)
    annotation (Line(points={{-110,40},{-30,40},{-30,48}}, color={0,0,127}));
  connect(conPID.y, lin.u)
    annotation (Line(points={{-18,60},{-16,60},{-16,40},
          {22,40}},color={0,0,127}));
  connect(lin.y, switch1.u1)
    annotation (Line(points={{46,40},{48,40},{48,-2},{
          58,-2}},  color={0,0,127}));
  connect(switch1.y,chiTSet)
    annotation (Line(points={{81,-10},{110,-10}}, color={0,0,127}));
  connect(x1.y, lin.x1)
    annotation (Line(points={{20,70},{20,48},{22,48}}, color={0,0,127}));
  connect(x2.y, lin.x2)
    annotation (Line(points={{2,20},{18,20},{18,36},{22,36}},
        color={0,0,127}));
  connect(TSouLvgMax, lin.f1)
    annotation (Line(points={{-110,80},{-8,80},{-8,46},
          {22,46},{22,44}}, color={0,0,127}));
  connect(TSouLvgMin, lin.f2)
    annotation (Line(points={{-110,20},{-90,20},{-90,
          0},{20,0},{20,32},{22,32}}, color={0,0,127}));
  connect(uMod, intGreEquThr.u)
    annotation (Line(points={{-110,-50},{-82,-50}}, color={255,127,0}));
  connect(intGreEquThr.y, conPID.trigger)
    annotation (Line(points={{-58,-50},{
          -38,-50},{-38,48}}, color={255,0,255}));
  connect(intGreEquThr.y, switch1.u2)
    annotation (Line(points={{-58,-50},{-38,
          -50},{-38,-10},{58,-10}}, color={255,0,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
Diagram(coordinateSystem(preserveAspectRatio=false)),
defaultComponentName="reSet",
Documentation(info="<html>
<p>
This Block is implemented to reset the DOE2 heat pump set point water temperature <code>TSet</code> if <code>uMod</code>= +1,
till the <code>TLoaLvg</code> meets the heating set point temperature <a href=\"Buildings.Fluid.HeatPumps.DOE2Reversible\">
Buildings.Fluid.HeatPumps.DOE2Reversible</a> according the calrified below control mapping function 
</p>
<p align=\"center\">
<img  alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/DOE2HeatPumpMappingFunction.png\" border=\"1\"/>
</p>
<p>
If <code>uMod</code>= -1,  the block returns the cooling setpoint <code>TSet</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 27, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReSetTSetCoo;
