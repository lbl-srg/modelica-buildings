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
    annotation (Placement(transformation(extent={{210,-30},{230,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b "Chilled water return"
    annotation (Placement(transformation(extent={{210,-70},{230,-50}})));
  BaseClasses.Connectors.BusInterface chiPlaCon "Chiller plant control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{220,100}}),                                  graphics={
              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{220,100}})));
end ChilledWaterPlant;
