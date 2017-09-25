within Buildings.HeatTransfer.Windows.BaseClasses.Validation;
model HeatCapacityConstantShade
  "Validation model for heat capacity with constant shade signal"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Area AGla = 2 "Glass area";

  parameter Data.Solids.Glass datGla(x=0.005)
    "Thermal properties for glass"
    annotation (Placement(transformation(extent={{60,112},{80,132}})));

  HeatCapacity heaCapGla(
    haveShade=true,
    TUns(fixed=true),
    TSha(fixed=true),
    C=AGla*datGla.x*datGla.d*datGla.c)
    "Heat Capacity of glass"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapSha1(
    C=0.5*1000,
    T(start=283.15, fixed=true))
    "Thermal capacity connected to shaded part of window"
    annotation (Placement(transformation(extent={{50,80},{70,100}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapUns1(
    C=0.5*1000,
    T(start=283.15, fixed=true))
    "Thermal capacity connected to unshaded part of window"
    annotation (Placement(transformation(extent={{50,40},{70,60}})));
  Modelica.Blocks.Sources.Constant y05(k=0.5) "Shade control signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConUns1(
    G=0.5*AGla*10)
    "Thermal conductor"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConSha1(
    G=0.5*AGla*10)
    "Thermal conductor"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  HeatCapacity heaCapGla01(
    haveShade=true,
    TUns(fixed=true),
    TSha(fixed=true),
    C=AGla*datGla.x*datGla.d*datGla.c)
                      "Heat Capacity of glass"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapSha2(
    C=0.1*1000,
    T(start=283.15, fixed=true))
    "Thermal capacity connected to shaded part of window"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapUns2(
    C=0.9*1000,
    T(start=283.15, fixed=true))
    "Thermal capacity connected to unshaded part of window"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Modelica.Blocks.Sources.Constant y1(k=0.1)  "Shade control signal"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConUns2(
    G=0.9*AGla*10)
    "Thermal conductor"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConSha2(
    G=0.1*AGla*10)
    "Thermal conductor"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Constant y2(k=0.9)  "Shade control signal"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  HeatCapacity heaCapGlaNoSha(
    TUns(fixed=true),
    haveShade=false,
    C=AGla*datGla.x*datGla.d*datGla.c) "Heat Capacity of glass"
    annotation (Placement(transformation(extent={{-10,-122},{10,-102}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConUns3(G=AGla*10)
    "Thermal conductor"
    annotation (Placement(transformation(extent={{20,-126},{40,-106}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapUns3(C=1000, T(
        start=283.15, fixed=true))
    "Thermal capacity connected to unshaded part of window"
    annotation (Placement(transformation(extent={{50,-108},{70,-88}})));
equation
  connect(y05.y, heaCapGla.ySha) annotation (Line(points={{-39,60},{-26,60},{-26,
          64},{-12,64}}, color={0,0,127}));
  connect(y05.y, heaCapGla.yCom) annotation (Line(points={{-39,60},{-26,60},{-26,
          56},{-12,56}}, color={0,0,127}));
  connect(heaCapUns1.port, theConUns1.port_b)
    annotation (Line(points={{60,40},{50,40},{40,40}}, color={191,0,0}));
  connect(theConUns1.port_a, heaCapGla.portUns) annotation (Line(points={{20,40},
          {20,40},{18,40},{16,40},{16,50},{16,56},{10,56}}, color={191,0,0}));
  connect(heaCapGla.portSha, theConSha1.port_a) annotation (Line(points={{10,64},
          {16,64},{16,80},{20,80}}, color={191,0,0}));
  connect(theConSha1.port_b, heaCapSha1.port)
    annotation (Line(points={{40,80},{50,80},{60,80}}, color={191,0,0}));
  connect(y1.y, heaCapGla01.ySha) annotation (Line(points={{-39,-10},{-40,-10},{
          -30,-10},{-30,-26},{-12,-26}}, color={0,0,127}));
  connect(heaCapUns2.port,theConUns2. port_b)
    annotation (Line(points={{60,-50},{40,-50}},       color={191,0,0}));
  connect(theConUns2.port_a, heaCapGla01.portUns) annotation (Line(points={{20,-50},
          {20,-50},{14,-50},{14,-34},{10,-34}}, color={191,0,0}));
  connect(heaCapGla01.portSha, theConSha2.port_a) annotation (Line(points={{10,-26},
          {14,-26},{14,-10},{20,-10}}, color={191,0,0}));
  connect(theConSha2.port_b,heaCapSha2. port)
    annotation (Line(points={{40,-10},{40,-10},{60,-10}},
                                                       color={191,0,0}));
  connect(y2.y, heaCapGla01.yCom) annotation (Line(points={{-39,-50},{-30,-50},{
          -30,-34},{-12,-34}}, color={0,0,127}));
  connect(theConUns3.port_b,heaCapUns3. port)
    annotation (Line(points={{40,-116},{60,-116},{60,-108}}, color={191,0,0}));
  connect(heaCapGlaNoSha.portUns, theConUns3.port_a)
    annotation (Line(points={{10,-116},{16,-116},{20,-116}}, color={191,0,0}));
  annotation (            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})),
    experiment(Tolerance=1e-6, StopTime=600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Validation/HeatCapacityConstantShade.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the heat capacitor model for the window glass,
with and without a shade. For the case with shade, different
constant shade control signals are used to test
the correct energy storage of the system.
All temperatures need to decay at the same rates because
the area of heat transfer, and the heat capacity to which the
glass is connected, are scaled proportionally to the control signal.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatCapacityConstantShade;
