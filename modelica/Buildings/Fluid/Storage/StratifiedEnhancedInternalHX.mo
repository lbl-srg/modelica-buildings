within Buildings.Fluid.Storage;
model StratifiedEnhancedInternalHX
  "A model of a water storage tank with a secondary loop and intenral heat exchanger"
  extends StratifiedEnhanced;

  replaceable package Medium_2 =
      Modelica.Media.Incompressible.Examples.Glycol47
    "Medium in the heat exchanger loop";

  parameter Integer TopHXSeg
    "Tank segment the top of the heat exchanger is located in";

  parameter Integer BotHXSeg
    "Tank segment the bottom of the heat exchanger is located in";

  parameter Modelica.SIunits.HeatCapacity C "Capacitance of the heat exchanger";

  parameter Modelica.SIunits.Volume VolHX "Volume of the heat exchanger";

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Nominal UA value for the heat exchanger";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_HX
    "Nominal mass flow rate through the heat exchanger";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_tank
    "Nominal mass flow rate through the tank";

protected
  parameter Integer nSegHX = TopHXSeg - BotHXSeg + 1
    "Number of segments in the heat exchanger";

  HeatExchangers.IndirectTankHeatExchanger indTanHX(redeclare package Medium =
        Medium_2,
    nSeg=nSegHX,
    C=C,
    GlyVol=VolHX,
    UA_nominal=UA_nominal,
    m_flow_nominal_gly=m_flow_nominal_HX,
    m_flow_nominal_wat=m_flow_nominal_tank)         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,68})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium_2) annotation (Placement(transformation(extent={{-110,42},{-90,
            62}}), iconTransformation(extent={{-100,90},{-80,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Medium_2) annotation (Placement(transformation(extent={{90,78},{110,98}}),
        iconTransformation(extent={{80,90},{100,110}})));
equation

  for i in 1:nSegHX loop
    connect(indTanHX.port_b1[i], heaPorVol[i]);
  end for;
           annotation (Line(
      points={{-73.2,69},{-70,69},{-70,28},{-16,28},{-16,-2.22045e-16},{0,-2.22045e-16}},
      color={191,0,0},
      smooth=Smooth.None), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
  connect(port_a1, indTanHX.port_a) annotation (Line(
      points={{-100,52},{-87,52},{-87,59}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(indTanHX.port_b, port_b1) annotation (Line(
      points={{-87,78.8},{-87,88},{100,88}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end StratifiedEnhancedInternalHX;
