within ;
model PlotDemo "Model to demonstrate plotting of results"
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap(C=1, T(fixed=true,
        start=291.15)) "Heat capacity"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature sensor"
    annotation (Placement(transformation(extent={{56,-10},{76,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{14,-10},{34,10}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Td=1,
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=0.01) annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Blocks.Sources.Constant const(k=293.15)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Math.Gain gain(k=50)
    annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor con(G=10)
    "Thermal conductor"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TFix(T=291.15)
    "Temperature boundary condition"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  annotation (uses(Modelica(version="3.1")), Diagram(graphics));
equation
  connect(preHea.port, heaFloSen.port_a) annotation (Line(
      points={{6,6.10623e-16},{10,-3.36456e-22},{10,6.10623e-16},{14,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFloSen.port_b, cap.port) annotation (Line(
      points={{34,6.10623e-16},{40,6.10623e-16},{40,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cap.port, temSen.port) annotation (Line(
      points={{40,40},{40,6.10623e-16},{56,6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSen.T, PID.u_m) annotation (Line(
      points={{76,6.10623e-16},{80,6.10623e-16},{80,0},{90,0},{90,-34},{-60,-34},
          {-60,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, PID.u_s) annotation (Line(
      points={{-79,6.10623e-16},{-76.5,6.10623e-16},{-76.5,6.66134e-16},{-72,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, preHea.Q_flow) annotation (Line(
      points={{-21,6.10623e-16},{-18.5,6.10623e-16},{-18.5,6.66134e-16},{-14,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, gain.u) annotation (Line(
      points={{-49,6.10623e-16},{-47.5,6.10623e-16},{-47.5,6.66134e-16},{-44,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.port_b, cap.port) annotation (Line(
      points={{10,40},{40,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TFix.port, con.port_a) annotation (Line(
      points={{-20,40},{-10,40}},
      color={191,0,0},
      smooth=Smooth.None));
end PlotDemo;
