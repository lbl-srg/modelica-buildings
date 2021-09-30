within Buildings.Templates.Interfaces;
partial model ChilledWaterPlant
  replaceable package MediumCHW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Chilled water medium";

  replaceable package MediumCW=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Condenser water medium";

  parameter Types.ChilledWaterPlant typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a "Chilled water supply"
    annotation (Placement(transformation(extent={{190,-20},{210,0}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b "Chilled water return"
    annotation (Placement(transformation(extent={{190,-80},{210,-60}})));
  BaseClasses.Connectors.BusChilledWater
                                      chwCon "Chilled water loop control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,40})));
  BaseClasses.Connectors.BusCondenserWater
                                      cwCon "Condenser loop control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-200,40})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},
            {200,100}}),                                        graphics={
              Rectangle(
          extent={{-200,100},{200,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-100},{200,100}})));
end ChilledWaterPlant;
