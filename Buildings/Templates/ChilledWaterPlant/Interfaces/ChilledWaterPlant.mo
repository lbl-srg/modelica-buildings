within Buildings.Templates.ChilledWaterPlant.Interfaces;
partial model ChilledWaterPlant
  parameter Buildings.Types.ChilledWaterPlant typ "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_cwLoop = typ==Types.ChilledWaterPlant.WaterCooledChiller
    "Set to true for condenser water loop"
    annotation (
      Evaluate=true,
      Dialog(
        group="Configuration",
        enable=false));

  Modelica.Fluid.Interfaces.FluidPort_a port_a "Chilled water supply"
    annotation (Placement(transformation(extent={{190,0},{210,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b "Chilled water return"
    annotation (Placement(transformation(extent={{190,-80},{210,-60}})));
  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater chwCon
    "Chilled water loop control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,60})));
  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusCondenserWater cwCon if have_cwLoop
    "Condenser loop control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-200,60})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={0,100})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},
            {200,100}}),                                        graphics={
              Rectangle(
          extent={{-200,100},{200,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-100},{200,100}}), graphics={
        Rectangle(
          extent={{-200,80},{200,40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={245,239,184},
          pattern=LinePattern.None)}));
end ChilledWaterPlant;
