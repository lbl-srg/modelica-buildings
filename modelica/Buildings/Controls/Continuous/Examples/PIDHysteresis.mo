within Buildings.Controls.Continuous.Examples;
model PIDHysteresis "Example model"
  import Buildings;

  Buildings.Controls.Continuous.PIDHysteresis con(
    pre_y_start=false,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0.3,
    Ti=600,
    Td=60)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 40) "Set point"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap(C=1000000, T(start=
         313.15, fixed=true))
    annotation (Placement(transformation(extent={{38,30},{58,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TBC
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20)
    annotation (Placement(transformation(extent={{38,60},{58,80}})));
  Modelica.Blocks.Math.Gain gain(k=2000)
    annotation (Placement(transformation(extent={{-12,20},{8,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Q_flow
    annotation (Placement(transformation(extent={{16,20},{36,40}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/86400,
    offset=273.15,
    amplitude=20,
    phase=-1.5707963267949)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation

  connect(TSet.y, con.u_s) annotation (Line(
      points={{-59,30},{-42,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBC.port, theCon.port_a) annotation (Line(
      points={{20,70},{38,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCon.port_b, cap.port) annotation (Line(
      points={{58,70},{66,70},{66,30},{48,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.y, gain.u) annotation (Line(
      points={{-19,30},{-14,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cap.port, temSen.port) annotation (Line(
      points={{48,30},{70,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSen.T, con.u_m) annotation (Line(
      points={{90,30},{94,30},{94,6},{-30,6},{-30,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, Q_flow.Q_flow) annotation (Line(
      points={{9,30},{16,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow.port, cap.port) annotation (Line(
      points={{36,30},{48,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, TBC.T) annotation (Line(
      points={{-59,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
 annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="PIDHysteresis.mos" "run"),
    experiment(StopTime=86400),
    experimentSetupOutput,
              Diagram);
end PIDHysteresis;
