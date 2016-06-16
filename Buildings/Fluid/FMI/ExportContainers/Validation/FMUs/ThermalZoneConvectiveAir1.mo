within Buildings.Fluid.FMI.ExportContainers.Validation.FMUs;
block ThermalZoneConvectiveAir1 "Validation of simple thermal zone"
  extends Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective(
    theZonAda(nFluPor=1),
    redeclare package Medium = Buildings.Media.Air, nFluPor = 1);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Blocks.Sources.Constant rooAir(k=295.13)
    annotation (Placement(transformation(extent={{120,30},{100,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{84,30},{64,50}})));
  Sources.FixedBoundary bou(
    redeclare package Medium = Medium,
    T=293.15,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  Modelica.Blocks.Sources.Constant TDryBul(k=285.13)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,100})));

  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-20,-20},
            {20,20}},
        rotation=90,
        origin={0,200}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,200})));

equation
  connect(rooAir.y, TAir.T)
    annotation (Line(points={{99,40},{99,40},{86,40}},       color={0,0,127}));
  connect(TAir.port,theZonAda.heaPorAir)  annotation (Line(points={{64,40},{60,40},
          {60,144},{-60,144}},             color={191,0,0}));
  connect(TDryBul.y, TOut) annotation (Line(points={{99,100},{80,100},{80,148},{
          0,148},{0,200}},      color={0,0,127}));
  connect(theZonAda.ports[1], bou.ports[1]) annotation (Line(points={{-60,152},{
          -52,152},{-52,150},{-40,150},{-40,0},{100,0}},               color={0,
          127,255}));
    annotation (
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={
        Text(
          extent={{-26,176},{24,156}},
          lineColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}})),
    Documentation(info="<html>
<p>
This example validates that 
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective
</a> 
exports correctly as an FMU.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/ThermalZoneConvectiveAir1.mos"
        "Export FMU"));
end ThermalZoneConvectiveAir1;
