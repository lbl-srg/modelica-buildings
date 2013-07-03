within Buildings.Fluid.Storage;
model StratifiedEnhancedInternalHex
  "A model of a water storage tank with a secondary loop and intenral heat exchanger"
  extends StratifiedEnhanced;

  replaceable package MediumHex =
      Modelica.Media.Interfaces.PartialMedium
    "Medium in the heat exchanger loop"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.Height HexTopHeight
    "Height of the top of the heat exchanger"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.Height HexBotHeight
    "Height of the bottom of the heat exchanger"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Integer HexSegMult = 2
    "Number of heat exchanger segments in each tank segment"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.HeatCapacity CHex = 25.163
    "Capacitance of the heat exchanger"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat transfer at nominal conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Modelica.SIunits.Temperature TTan_nominal
    "Temperature of fluid inside the tank at nominal heat transfer conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Modelica.SIunits.Temperature THex_nominal
    "Temperature of fluid inside the heat exchanger at nominal heat transfer conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Real r_nominal(min=0, max=1)=0.5
    "Ratio between coil inside and outside convective heat transfer at nominal heat transfer conditions"
          annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.MassFlowRate mHex_flow_nominal
    "Nominal mass flow rate through the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Diameter dExtHex = 0.025
    "Exterior diameter of the heat exchanger pipe"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.Pressure dpHex_nominal(displayUnit="Pa") = 2500
    "Pressure drop across the heat exchanger at nominal conditions"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamicsHex=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamicsHex=energyDynamicsHex
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare package Medium =MediumHex) "Heat exchanger inlet"
   annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
                   iconTransformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
     redeclare package Medium = MediumHex) "Heat exchanger outlet"
   annotation (Placement(transformation(extent={{-110,-90},{-90,-70}}),
        iconTransformation(extent={{-110,-90},{-90,-70}})));

  BaseClasses.IndirectTankHeatExchanger indTanHex(
    final nSeg=nSegHex,
    final CHex=CHex,
    final volHexFlu=volHexFlu,
    final Q_flow_nominal=Q_flow_nominal,
    final TTan_nominal=TTan_nominal,
    final THex_nominal=THex_nominal,
    final r_nominal=r_nominal,
    final dExtHex=dExtHex,
    redeclare final package Medium = Medium,
    redeclare final package MediumHex = MediumHex,
    final dp_nominal=dpHex_nominal,
    final m_flow_nominal=mHex_flow_nominal,
    final energyDynamics=energyDynamicsHex,
    final massDynamics=massDynamicsHex,
    m_flow_small=1e-4*abs(mHex_flow_nominal),
    final computeFlowResistance=computeFlowResistance,
    from_dp=from_dp,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM) "Heat exchanger inside the tank"
                                     annotation (Placement(
        transformation(
        extent={{-10,-15},{10,15}},
        rotation=180,
        origin={-87,32})));

protected
  parameter Modelica.SIunits.Height segHeight = hTan/nSeg
    "Height of each tank segment (relative to bottom of same segment)";

  parameter Modelica.SIunits.Volume volHexFlu = 0.25 * Modelica.Constants.pi * dExtHex
    "Volume of the heat exchanger";

  parameter Integer topHexSeg = integer(ceil(HexTopHeight/segHeight))
    "Segment the top of the heat exchanger is located in"
    annotation(Evaluate=true);

  parameter Integer botHexSeg = integer(HexBotHeight/segHeight)
    "Segment the bottom of the heat exchanger is located in"
    annotation(Evaluate=true);

  parameter Integer nSegHex = (topHexSeg - botHexSeg + 1)*HexSegMult
    "Number of segments in thDiagnosticse heat exchanger";

  parameter Integer nSegHexTan = topHexSeg - botHexSeg + 1
    "Number of tank segments the Hex resides in";

public
  parameter Boolean computeFlowResistance=true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Dialog(tab="Flow resistance heat exchanger"));
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance heat exchanger"));
  parameter Boolean linearizeFlowResistance=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance heat exchanger"));
  parameter Real deltaM=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance heat exchanger"));
equation
   for j in 1:nSegHexTan loop
     for i in 1:HexSegMult loop
     connect(indTanHex.port[(j-1)*HexSegMult+i], heaPorVol[nSeg-j+1])
      annotation (Line(
       points={{-87,41.8},{-20,41.8},{-20,-2.22045e-16},{0,-2.22045e-16}},
       color={191,0,0},
       smooth=Smooth.None));
     end for;
   end for;
  connect(port_a1, indTanHex.port_a) annotation (Line(
      points={{-100,-40},{-74,-40},{-74,32},{-77,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(indTanHex.port_b, port_b1) annotation (Line(
      points={{-97,32},{-97,26},{-98,26},{-98,20},{-76,20},{-76,-80},{-100,-80}},
      color={0,127,255},
      smooth=Smooth.None));

           annotation (Line(
      points={{-73.2,69},{-70,69},{-70,28},{-16,28},{-16,-2.22045e-16},{0,-2.22045e-16}},
      color={191,0,0},
      smooth=Smooth.None), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-94,-38},{28,-42}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-50},{28,-54}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-78},{-68,-82}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,-50},{-68,-80}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,-48},{28,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Rectangle(
          extent={{-4,-42},{28,-46}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,-44},{-2,-48}},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid)}),
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            defaultComponentName = "tan",
            Documentation(info = "<html>
            This model is an extension of 
            <a href=\"Buildings.Fluid.Storage.StratifiedEnhanced\">Buildings.Fluid.Storage.StratifiedEnhanced</a>.<br/>
            <p>
            The modifications consist of adding a heat exchanger 
            (<a href=\"Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger\">
            Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger</a>) and fluid ports to connect to the heat exchanger.
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
            May 10, 2013 by Michael Wetter:<br/>
            Removed <code>m_flow_nominal_tank</code> which was not used.
            </li>
            <li>
            January 29, 2013 by Peter Grant:<br/>
            First implementation.
            </li>
            </ul>
            </html>"));
end StratifiedEnhancedInternalHex;
