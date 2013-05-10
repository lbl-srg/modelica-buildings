within Buildings.Fluid.Storage;
model StratifiedEnhancedInternalHX
  "A model of a water storage tank with a secondary loop and intenral heat exchanger"
  extends StratifiedEnhanced;

  replaceable package Medium_2 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the heat exchanger loop";

  parameter Modelica.SIunits.Height HXTopHeight
    "Height of the top of the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Height HXBotHeight
    "Height of the bottom of the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Integer HXSegMult = 2
    "Number of heat exchanger segments in each tank segment"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.HeatCapacity C = 25.163
    "Capacitance of the heat exchanger";

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Nominal UA value for the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_HX
    "Nominal mass flow rate through the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Area ASurHX = 1.5
    "External surface area of the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Diameter dHXExt = 0.025
    "External diameter of the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Pressure dp_nominal = 2500
    "Pressure drop across the heat exchanger at nominal conditions"
    annotation(Dialog(group="Heat exchanger"));

protected
  parameter Modelica.SIunits.Height segHeight = hTan/nSeg
    "Height of each tank segment (relative to bottom of same segment)";

  parameter Modelica.SIunits.Volume volHX = 0.25 * Modelica.Constants.pi * dHXExt
    "Volume of the heat exchanger";

  parameter Integer topHXSeg = integer(ceil(HXTopHeight/segHeight))
    "Segment the top of the heat exchanger is located in"
    annotation(Evaluate=true);

  parameter Integer botHXSeg = integer(HXBotHeight/segHeight)
    "Segment the bottom of the heat exchanger is located in"
    annotation(Evaluate=true);

  parameter Integer nSegHX = (topHXSeg - botHXSeg + 1)*HXSegMult
    "Number of segments in thDiagnosticse heat exchanger";

  parameter Integer nSegHXTan = topHXSeg - botHXSeg + 1
    "Number of tank segments the HX resides in";

public
  BaseClasses.IndirectTankHeatExchanger indTanHX(
    nSeg=nSegHX,
    C=C,
    htfVol=volHX,
    UA_nominal=UA_nominal,
    m_flow_nominal_htf=m_flow_nominal_HX,
    ASurHX=ASurHX,
    dHXExt=dHXExt,
    redeclare package Medium = Medium,
    redeclare package Medium_2 = Medium_2,
    dp_nominal=dp_nominal,
    m_flow_nominal=m_flow_nominal_HX,
    energyDynamics=energyDynamics) "Heat exchanger inside the tank"
                                     annotation (Placement(
        transformation(
        extent={{-10,-15},{10,15}},
        rotation=90,
        origin={-85,68})));
public
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium_2) annotation (Placement(transformation(extent={{-110,42},{-90,
            62}}), iconTransformation(extent={{-100,90},{-80,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Medium_2) annotation (Placement(transformation(extent={{90,78},{110,98}}),
        iconTransformation(extent={{80,90},{100,110}})));
equation

   for j in 1:nSegHXTan loop
     for i in 1:HXSegMult loop
     connect(indTanHX.port[(j-1)*HXSegMult+i], heaPorVol[nSeg-j+1])
      annotation (Line(
       points={{-75.2,68},{-66,68},{-66,0},{0,0}},
       color={191,0,0},
       smooth=Smooth.None));
     end for;
   end for;
  connect(port_a1, indTanHX.port_a) annotation (Line(
      points={{-100,52},{-85,52},{-85,58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(indTanHX.port_b, port_b1) annotation (Line(
      points={{-85,78},{-85,88},{100,88}},
      color={0,127,255},
      smooth=Smooth.None));

           annotation (Line(
      points={{-73.2,69},{-70,69},{-70,28},{-16,28},{-16,-2.22045e-16},{0,-2.22045e-16}},
      color={191,0,0},
      smooth=Smooth.None), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            defaultComponentName = "tan",
            Documentation(info = "<html>
            This model is an extension of 
            <a href=\"Buildings.Fluid.Storage.StratifiedEnhanced\">Buildings.Fluid.Storage.StratifiedEnhanced</a>.</p>
            <p>
            The modifications consist of adding a heat exchanger 
            (<a href=\"Buildings.Fluid.HeatExchangers.IndirectTankHeatExchanger\">
            Buildings.Fluid.HeatExchangers.IndirectTankHeatExchanger</a>) and fluid ports to connect to the heat exchanger.
            The modifications allow to run a fluid through the tank causing heat transfer to the stored fluid. 
            A typical example is a storage tank in a solar hot water system.
            </p>
            <p>
            The heat exchanger model assumes flow through the inside of a helical coil heat exchanger, 
            and stagnant fluid on the outside. Parameters are used to describe the 
            heat transfer on the inside of the heat exchanger at nominal conditions, and 
            geometry of the outside of the heat exchanger. This information is used to compute 
            an <i>hA</i>-value for each side of the coil. Convection calculations are then performed to identify heat transfer 
            between the heat transfer fluid and the fluid in the tank.
            </p>
            <p>
            Default values describing the heat exchanger are taken from the documentation for a Vitocell 100-B, 300 L tank.
            </p>
            </html>",
            revisions = "<html>
            <ul>
            <li>
            May 10, 2013 by Michael Wetter:<br>
            Removed <code>m_flow_nominal_tank</code> which was not used.
            </li>
            <li>
            January 29, 2013 by Peter Grant:<br>
            First implementation.
            </li>
            </ul>
            </html>"));
end StratifiedEnhancedInternalHX;
