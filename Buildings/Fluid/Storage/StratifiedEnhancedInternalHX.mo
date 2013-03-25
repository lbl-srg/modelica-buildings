within Buildings.Fluid.Storage;
model StratifiedEnhancedInternalHX
  "A model of a water storage tank with a secondary loop and intenral heat exchanger"
  extends StratifiedEnhanced;

  replaceable package Medium_2 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the heat exchanger loop";

  parameter Modelica.SIunits.Height HXTopHeight
    "Height of the top of the heat exchanger";

  parameter Modelica.SIunits.Height HXBotHeight
    "Height of the bottom of the heat exchanger";

  parameter Integer HXSegMult = 2
    "Number of heat exchanger segments in each tank segment";

  parameter Modelica.SIunits.HeatCapacity C "Capacitance of the heat exchanger";

  parameter Modelica.SIunits.Volume VolHX "Volume of the heat exchanger";

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Nominal UA value for the heat exchanger";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_HX
    "Nominal mass flow rate through the heat exchanger";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_tank
    "Nominal mass flow rate through the tank";

  parameter Modelica.SIunits.Area ASurHX
    "External surface area of the heat exchanger";

  parameter Modelica.SIunits.Diameter dHXExt
    "External diameter of the heat exchanger";

protected
  parameter Modelica.SIunits.Height SegHeight = hTan/nSeg
    "Height of each tank segment (relative to bottom of same segment)";
  parameter Integer TopHXSeg(max=nSeg) = ceil(HXTopHeight/SegHeight)
    "Segment the top of the heat exchanger is located in";            // fixme: add min(...)
  parameter Integer BotHXSeg(min=1) = floor(HXBotHeight/SegHeight)
    "Segment the bottom of the heat exchanger is located in";      // fixme: add max(1, ...)
  parameter Integer nSegHX = (TopHXSeg - BotHXSeg + 1)*HXSegMult
    "Number of segments in thDiagnosticse heat exchanger";
  parameter Integer nSegHXTan = TopHXSeg - BotHXSeg + 1
    "Number of tank segments the HX resides in";

public
  HeatExchangers.IndirectTankHeatExchanger indTanHX(
    nSeg=nSegHX,
    C=C,
    HtfVol=VolHX,
    UA_nominal=UA_nominal,
    m_flow_nominal_htf=m_flow_nominal_HX,
    ASurHX=ASurHX,
    dHXExt=dHXExt,
    redeclare package Medium = Medium_2,
    redeclare package Medium_2 = Medium)            annotation (Placement(
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

  for j in 1:nSegHXTan loop
    for i in 1:HXSegMult loop
      connect(indTanHX.port_b1[(j-1)*HXSegMult+i], heaPorVol[nSeg-j+1])
     annotation (Line(
      points={{-76.6,68.5},{-66,68.5},{-66,0},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
    end for;
  end for;
  connect(port_a1, indTanHX.port_a) annotation (Line(
      points={{-100,52},{-83.5,52},{-83.5,63.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(indTanHX.port_b, port_b1) annotation (Line(
      points={{-83.5,73.4},{-83.5,88},{100,88}},
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
            This model is an extension of <a href=\"Buildings.Fluid.Storage.StratifiedEnhanced\"> Buildings.Fluid.Storage.StratifiedEnhanced</a>.</p>
            <p>
            The changes made to the model consist of adding a heat exchanger 
            (<a href=\"Buildings.Fluid.HeatExchangers.IndirectTankHeatExchanger\"> Buildings.Fluid.HeatExchangers.IndirectTankHeatExchanger</a>) and fluid ports to connect to the heat exchanger.<br>
            The modifications allow the ability to run a fluid through the tank causing heat transfer to the stored fluid. An example of when this would be useful is modeling<br>
            a storage tank which includes a glycol loop connedted to a solar thermal collector.
            </p>
            <p>
            The heat exchanger models assumes flow through the inside of a helical coil heat exchanger, and stagnant fluid on the outside. Inputs are used to describe the <br>
            heat transfer on the inside of the heat exchanger at nominal conditions, and geometry of the outside of the heat exchanger. This information is used to compute <br>
            an hA value for each side of the coil. Convection calculations are then performed to identify heat transfer between the heat transfer fluid and the fluid in the tank.
            </p>
            </html>",
            revisions = "<html>
            <ul>
            <li>
            January 29, 2013 by Peter Grant:<br>
            First implementation.
            </li>
            </ul>
            </html>"));
end StratifiedEnhancedInternalHX;
