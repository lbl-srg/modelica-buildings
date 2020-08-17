within Buildings.Fluid.HeatPumps.BaseClasses;
block EvaporatorSetpoint "Reset of TSetCoo for heating mode"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", displayUnit="degC")
    "Set point temperature"
     annotation (Placement(transformation(extent={{-120,50},
            {-100,70}}), iconTransformation(extent={{-120,18},{-100,38}})));
  Modelica.Blocks.Interfaces.RealInput TLoaLvg(final
    unit="K",
    displayUnit="degC")
    "Load side leaving water temperature."
    annotation (Placement(
        transformation(extent={{-120,30},{-100,50}}), iconTransformation(extent={{-120,
            -10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput TSouLvgMin(final
    unit="K",
    displayUnit="degC")
    "Minimum leaving water temperature at the source side" annotation (
      Placement(transformation(extent={{-120,10},{-100,30}}),
        iconTransformation(extent={{-120,80},{-100,100}})));
 Controls.OBC.CDL.Interfaces.BooleanInput isHea
    "true if unit operates in heating mode"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput TSouLvgMax(final
    unit="K",
    displayUnit= "degC")
    "Maximum source leaving water temperature"
    annotation (Placement(
        transformation(extent={{-120,70},{-100,90}}), iconTransformation(extent={{-120,50},
            {-100,70}})));
  Modelica.Blocks.Interfaces.RealOutput TSetEvaLvg(
    final unit="K",
    displayUnit="degC")
    "Set point for evaporator leaving temperature if operated in heating mode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Line lin
     annotation (Placement(transformation(extent={{52,-10},{72,10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant x1(final k=0)
     annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Controls.OBC.CDL.Continuous.LimPID conPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=10,
    Ti=300,
    yMax=1,
    yMin=0,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    y_reset=0) "Controller to compute the new set point"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
 Controls.OBC.CDL.Continuous.Sources.Constant x2(final k=1)
     annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

equation
  connect(TSet, conPI.u_s)
    annotation (Line(points={{-110,60},{-42,60}}, color={0,0,127}));
  connect(TLoaLvg, conPI.u_m)
    annotation (Line(points={{-110,40},{-30,40},{-30,48}}, color={0,0,127}));
  connect(conPI.y, lin.u) annotation (Line(points={{-18,60},{-16,60},{-16,0},{
          50,0}}, color={0,0,127}));
  connect(x1.y, lin.x1)
    annotation (Line(points={{22,30},{40,30},{40,8},{50,8}},
                                                       color={0,0,127}));
  connect(x2.y, lin.x2)
    annotation (Line(points={{22,-30},{40,-30},{40,-4},{50,-4}},
        color={0,0,127}));
  connect(TSouLvgMax, lin.f1)
    annotation (Line(points={{-110,80},{-80,80},{-80,4},{50,4}},
                            color={0,0,127}));
  connect(TSouLvgMin, lin.f2)
    annotation (Line(points={{-110,20},{-90,20},{-90,-8},{50,-8}},
                                      color={0,0,127}));
  connect(conPI.trigger, isHea) annotation (Line(points={{-38,48},{-38,-40},{-120,
          -40}}, color={255,0,255}));
  connect(lin.y, TSetEvaLvg)
    annotation (Line(points={{74,0},{110,0}}, color={0,0,127}));
annotation (
defaultComponentName="reSet",
Documentation(info="<html>
<p>
This block is used if
<a href=\"Buildings.Fluid.HeatPumps.DOE2Reversible\">Buildings.Fluid.HeatPumps.DOE2Reversible</a>
operates in heating mode.
Because
<a href=\"Buildings.Fluid.HeatPumps.DOE2Reversible\">Buildings.Fluid.HeatPumps.DOE2Reversible</a>
uses to compute the performance the set point evaporator leaving water temperature, but in heating mode
the control input is the condenser leaving water temperature, the model computes a new set point
based on the control error between the condenser leaving water temperature and the actual condener leaving water temperature.
Using the function below, the control output is mapped to the set point temperature
</p>
<p align=\"center\">
<img  alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/DOE2HeatPumpMappingFunction.png\" border=\"1\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
February 4, 2020, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
October 27, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EvaporatorSetpoint;
