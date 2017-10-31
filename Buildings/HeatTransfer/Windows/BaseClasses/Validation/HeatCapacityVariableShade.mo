within Buildings.HeatTransfer.Windows.BaseClasses.Validation;
model HeatCapacityVariableShade
  "Validation model for heat capacity with variable shade signal"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Area AGla = 2 "Glass area";

  parameter Buildings.HeatTransfer.Data.Solids.Glass datGla(x=0.005)
    "Thermal properties for glass"
    annotation (Placement(transformation(extent={{60,46},{80,66}})));

  HeatCapacity heaCapGla(
    haveShade=true,
    TUns(fixed=true),
    TSha(fixed=true),
    C=AGla*datGla.x*datGla.d*datGla.c)
    "Heat Capacity of glass"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapSha(
    C=1000,
    T(start=293.15, fixed=true))
    "Thermal capacity connected to shaded part of window"
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));
  Modelica.Blocks.Sources.Ramp yRamp(
    height=0.5,
    offset=0.25,
    duration=300,
    startTime=150) "Shade control signal"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConSha
    "Thermal conductor"
    annotation (Placement(transformation(extent={{22,-30},{42,-10}})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConUns
    "Thermal conductor"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Modelica.Blocks.Sources.RealExpression yCom(y=1 - yRamp.y)
    "Complementary control signal"
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  Modelica.Blocks.Math.Gain hASha(k=AGla*10)
    "hA value of shaded part of window"
    annotation (Placement(transformation(extent={{-8,40},{12,60}})));
  Modelica.Blocks.Math.Gain hAUns(k=AGla*10)
    "hA value of unshaded part of window"
    annotation (Placement(transformation(extent={{-8,10},{12,30}})));
equation
  connect(yRamp.y, heaCapGla.ySha) annotation (Line(points={{-59,-10},{-26,-10},
          {-26,-36},{-12,-36}}, color={0,0,127}));
  connect(heaCapGla.portSha, theConSha.solid) annotation (Line(points={{10,-36},
          {16,-36},{16,-20},{22,-20}}, color={191,0,0}));
  connect(theConSha.fluid, heaCapSha.port)
    annotation (Line(points={{42,-20},{52,-20},{60,-20}}, color={191,0,0}));
  connect(theConUns.fluid, heaCapSha.port)
    annotation (Line(points={{40,-60},{60,-60},{60,-20}}, color={191,0,0}));
  connect(heaCapGla.portUns, theConUns.solid) annotation (Line(points={{10,-44},
          {16,-44},{16,-60},{20,-60}}, color={191,0,0}));
  connect(yCom.y, heaCapGla.yCom)
    annotation (Line(points={{-59,-44},{-59,-44},{-12,-44}}, color={0,0,127}));
  connect(yRamp.y, hASha.u) annotation (Line(points={{-59,-10},{-26,-10},{-26,50},
          {-10,50}}, color={0,0,127}));
  connect(hASha.y, theConSha.Gc)
    annotation (Line(points={{13,50},{32,50},{32,-10}}, color={0,0,127}));
  connect(hAUns.y, theConUns.Gc) annotation (Line(points={{13,20},{18,20},{18,-40},
          {30,-40},{30,-50}}, color={0,0,127}));
  connect(yCom.y, hAUns.u) annotation (Line(points={{-59,-44},{-44,-44},{-20,-44},
          {-20,20},{-10,20}}, color={0,0,127}));
  annotation (    experiment(Tolerance=1e-6, StopTime=600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Validation/HeatCapacityVariableShade.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the heat capacitor model for the window glass,
with varying control signal and heat conduction to a thermal capacity
that is a surrogate for the room model.
As the thermal capacity is at the same temperature, no heat is exchanged.
</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatCapacityVariableShade;
