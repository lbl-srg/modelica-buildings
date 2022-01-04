within Buildings.Templates.ChilledWaterPlant.Interfaces;
partial model PartialChilledWaterPlant
  parameter Buildings.Templates.Types.ChilledWaterPlant typ "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  replaceable package Medium = Buildings.Media.Water;

  inner parameter String id
    "System name"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  inner parameter Integer nChi "Number of chillers";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium) "Chilled water supply"
    annotation (Placement(transformation(extent={{190,0},{210,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium) "Chilled water return"
    annotation (Placement(transformation(extent={{190,-80},{210,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={0,100})));

protected
  parameter Boolean isAirCoo=
    typ == Buildings.Templates.Types.ChilledWaterPlant.AirCooledParallel or
    typ == Buildings.Templates.Types.ChilledWaterPlant.AirCooledSeries
    "= true, chillers in group are air cooled, 
    = false, chillers in group are water cooled";

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
end PartialChilledWaterPlant;
