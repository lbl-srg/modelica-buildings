within Districts.BuildingLoads.Examples.BaseClasses.Examples;
model BatteryControl_V "Test model for the battery control"
  import Districts;
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Power PMax=1e3 "Maximum power during discharge";

  Districts.BuildingLoads.Examples.BaseClasses.BatteryControl_V con(
      VDis=480, PMax=PMax) "Controller"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Continuous.Integrator soc(k=1/PMax/3600/4) "State of charge"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Sine     V(
    amplitude=48,
    offset=480,
    freqHz=1/4/3600) "Voltage"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation

  connect(con.P, soc.u) annotation (Line(
      points={{-19,6.66134e-16},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(soc.y, con.SOC) annotation (Line(
      points={{41,6.66134e-16},{60,6.66134e-16},{60,30},{-60,30},{-60,6},{-42,6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(V.y, con.VMea) annotation (Line(
      points={{-59,-10},{-50,-10},{-50,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    experiment(
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
      Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/BuildingLoads/Examples/BaseClasses/Examples/BatteryControl_V.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    __Dymola_experimentSetupOutput);
end BatteryControl_V;
