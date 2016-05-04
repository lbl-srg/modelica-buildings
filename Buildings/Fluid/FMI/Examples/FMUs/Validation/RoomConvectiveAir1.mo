within Buildings.Fluid.FMI.Examples.FMUs.Validation;
block RoomConvectiveAir1 "Validation of simple thermal zone"
  extends Buildings.Fluid.FMI.RoomConvective(
    redeclare package Medium = Buildings.Media.Air, nFluPor = 1,
    theHvaAda(nFluPor=1));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  Modelica.Blocks.Sources.Constant rooAir(k=295.13)
    annotation (Placement(transformation(extent={{120,30},{100,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{84,30},{64,50}})));
  Modelica.Blocks.Sources.Constant radTem(k=295.13)
    annotation (Placement(transformation(extent={{40,90},{20,110}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRad
    "Radiative temperature"
    annotation (Placement(transformation(extent={{0,90},{-20,110}})));
  Sources.FixedBoundary bou(
    redeclare package Medium = Medium,
    T=293.15,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  Modelica.Blocks.Sources.Constant TDryBul(k=285.13)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,100})));
  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
    "Design outlet air temperature";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 1000
    "Internal heat gains of the room";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal= 0.01;
  /////////////////////////////////////////////////////////
  // HVAC models
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
  connect(radTem.y, TRad.T)
    annotation (Line(points={{19,100},{19,100},{2,100}}, color={0,0,127}));
  connect(TAir.port, theHvaAda.heaPorAir) annotation (Line(points={{64,40},{60,
          40},{60,159.333},{-63.8182,159.333}},
                                           color={191,0,0}));
  connect(TDryBul.y, TOut) annotation (Line(points={{99,100},{80,100},{80,148},{
          0,148},{0,200}},      color={0,0,127}));
  connect(theHvaAda.heaPorRad, TRad.port) annotation (Line(points={{-63.8182,
          144.667},{-60,144.667},{-60,100},{-20,100}}, color={191,0,0}));
  connect(theHvaAda.ports[1], bou.ports[1]) annotation (Line(points={{-64,
          151.333},{-52,151.333},{-52,150},{-40,150},{-40,0},{100,0}}, color={0,
          127,255}));
    annotation(Dialog(tab="Assumptions"), Evaluate=true,
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
<a href=\"modelica://Buildings.Fluid.FMI.RoomConvective\">
Buildings.Fluid.FMI.RoomConvective
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/Validation/RoomConvectiveAir1.mos"
        "Export FMU"));
end RoomConvectiveAir1;
