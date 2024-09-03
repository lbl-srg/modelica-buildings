within Buildings.Utilities.IO.BCVTB.Examples;
model TwoRooms
  "Thermal model of two rooms that will be linked to the BCVTB which models the controls"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Time tau=2*3600 "Room time constant";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nom=100 "Nominal heat flow";
  parameter Modelica.Units.SI.ThermalConductance UA=Q_flow_nom/20
    "Thermal conductance of room";
  parameter Modelica.Units.SI.Temperature TStart=283.15 "Start temperature";
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C1(C=tau*UA, T(start=
          TStart, fixed=true)) "Heat capacity of room"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UA1(G=UA)
    "Heat transmission of room"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TOut1(T=278.15)
    "Outside air temperature"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow Q_flow_1
    "Heat input into the room"
    annotation (Placement(transformation(extent={{42,20},{62,40}})));
  Modelica.Blocks.Math.Gain GaiQ_flow_nom1(k=Q_flow_nom)
    "Gain for nominal heat load"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UA2(G=UA)
    "Heat transmission of room"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C2(C=2*tau*UA, T(start=
          TStart, fixed=true)) "Heat capacity of room"
    annotation (Placement(transformation(extent={{70,-28},{90,-8}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TOut2(T=278.15)
    "Outside air temperature"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow Q_flow_2
    "Heat input into the room"
    annotation (Placement(transformation(extent={{44,-80},{64,-60}})));
  Modelica.Blocks.Math.Gain GaiQ_flow_nom2(k=Q_flow_nom)
    "Gain for nominal heat load"
    annotation (Placement(transformation(extent={{2,-80},{22,-60}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo1
    "Room temperature"
    annotation (Placement(transformation(extent={{92,60},{112,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo2
    "Room temperature"
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
  Buildings.Utilities.IO.BCVTB.BCVTB bcvtb(
    xmlFileName="socket.cfg",
    uStart={TStart - 273.15,TStart - 273.15},
    timeStep=60,
    final nDblWri=2,
    final nDblRea=2)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Routing.Multiplex2 multiplex2_1
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplex2_1
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Utilities.IO.BCVTB.To_degC to_degC1
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Buildings.Utilities.IO.BCVTB.To_degC to_degC2
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
equation
  connect(TOut1.port, UA1.port_a) annotation (Line(
      points={{20,70},{40,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(UA1.port_b, C1.port) annotation (Line(
      points={{60,70},{80,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut2.port, UA2.port_a) annotation (Line(
      points={{20,-30},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(UA2.port_b, C2.port) annotation (Line(
      points={{60,-30},{79,-30},{79,-28},{80,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Q_flow_1.port, C1.port) annotation (Line(
      points={{62,30},{80,30},{80,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Q_flow_2.port, C2.port) annotation (Line(
      points={{64,-70},{80,-70},{80,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(C1.port, TRoo1.port) annotation (Line(
      points={{80,70},{92,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(C2.port, TRoo2.port) annotation (Line(
      points={{80,-28},{80,-30},{90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GaiQ_flow_nom1.y, Q_flow_1.Q_flow) annotation (Line(
      points={{21,30},{42,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GaiQ_flow_nom2.y, Q_flow_2.Q_flow) annotation (Line(
      points={{23,-70},{44,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bcvtb.yR, deMultiplex2_1.u) annotation (Line(
      points={{-59,6.10623e-16},{-54.75,6.10623e-16},{-54.75,1.27676e-15},{
          -50.5,1.27676e-15},{-50.5,6.66134e-16},{-42,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deMultiplex2_1.y1[1], GaiQ_flow_nom1.u) annotation (Line(
      points={{-19,6},{-11.5,6},{-11.5,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deMultiplex2_1.y2[1], GaiQ_flow_nom2.u) annotation (Line(
      points={{-19,-6},{-10,-6},{-10,-70},{-6.66134e-16,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex2_1.y, bcvtb.uR) annotation (Line(
      points={{221,6.10623e-16},{230,6.10623e-16},{230,-92},{-90,-92},{-90,
          6.66134e-16},{-82,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo1.T, to_degC1.Kelvin) annotation (Line(
      points={{112,70},{138,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo2.T, to_degC2.Kelvin) annotation (Line(
      points={{110,-30},{138,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_degC2.Celsius, multiplex2_1.u2[1]) annotation (Line(
      points={{161,-30},{180,-30},{180,-6},{198,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_degC1.Celsius, multiplex2_1.u1[1]) annotation (Line(
      points={{161,70},{180,70},{180,6},{198,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{240,100}})),
    experiment(StopTime=21600),
    Documentation(info="<html>
This example illustrates the use of Modelica with the Building Controls Virtual Test Bed.<br/>
<p>
Given a control signal for two heat flow rates, Modelica simulates the thermal response
of two first order systems. The two systems may represent a first order approximation of a room.
The control signal for the heat flow rate is computed in the Building Controls Virtual Test Bed
using a discrete time implementation of a proportional controller.
Every 60 seconds, measured temperatures and control signals for the heat flow rates are
exchanged between Dymola and the Building Controls Virtual Test Bed.
</p>
<p>
This model is implemented in <code>bcvtb\\examples\\dymola-room</code>.
</html>", revisions="<html>
<ul>
<li>
May 15, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoRooms;
